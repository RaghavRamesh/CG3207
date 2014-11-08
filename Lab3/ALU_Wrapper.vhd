----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:41:23 10/31/2014 
-- Design Name: 
-- Module Name:    ALU_Wrapper - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_Wrapper is
    Port ( CLK : in  STD_LOGIC;
			  ALU_WrapperControl : in  STD_LOGIC_VECTOR (8 downto 0);
           ALU_InA : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_InB : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_OutA : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_OutB : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_busy : out  STD_LOGIC;
           ALU_overflow : out  STD_LOGIC;
           ALU_unknown : out  STD_LOGIC;
           ALU_zero : out  STD_LOGIC;
           RESET : in  STD_LOGIC);
end ALU_Wrapper;

architecture archALUWrapper of ALU_Wrapper is


----------------------------------------------------------------
-- ALU
----------------------------------------------------------------
component ALU is
Port (Clk			: in	STD_LOGIC;
		Control		: in	STD_LOGIC_VECTOR (5 downto 0);
		Operand1		: in	STD_LOGIC_VECTOR (31 downto 0);
		Operand2		: in	STD_LOGIC_VECTOR (31 downto 0);
		Result1		: out	STD_LOGIC_VECTOR (31 downto 0);
		Result2		: out	STD_LOGIC_VECTOR (31 downto 0);
		Status		: out	STD_LOGIC_VECTOR (2 downto 0)); -- busy (multicycle only), overflow (add and sub), zero (sub));		
end component;

	signal	ALU_status		:  STD_LOGIC_VECTOR(2 downto 0);		
	signal	ALU_Control		:  STD_LOGIC_VECTOR(5 downto 0);			

begin

----------------------------------------------------------------
-- ALU port map
----------------------------------------------------------------
ALU1 				: ALU port map
						(
						CLK => CLK,
						Control => ALU_Control,
						Operand1 => ALU_InA, 
						Operand2 => ALU_InB, 
						Result1 => ALU_OutA, 
						Result2 => ALU_OutB,  
						Status => ALU_status
						);
						
						

ALU_Control <= "100000" when RESET = '1' -- reset
		else "000010" when ALU_WrapperControl(8 downto 6) = "000" or (ALU_WrapperControl(8 downto 6) ="010"and ALU_WrapperControl(5 downto 0) = "100000") -- add
      else "000110" when ALU_WrapperControl(8 downto 6) = "001" or (ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "100010") -- sub
		else "000000" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "100100" -- and
		else "000001" when ALU_WrapperControl(8 downto 6) = "011" or (ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "100101") -- lui/ori or or
		else "000111" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "101010" -- slt
		else "001110" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "101011" -- sltu
		else "001100" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "100111" -- nor
		else "000100" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "100110" --xor
		else "000101" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000000" --sll
		else "001101" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000010" --srl
		else "001001" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000011" --sra
		else "000101" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000100" --sllv
		else "001101" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000110" --srlv
		else "001001" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000111" --srav
		else "010000" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "011000" -- mult
		else "010001" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "011001" -- multu
		else "010010" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "011010" -- div
		else "010011" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "011011" -- divu
		else "000111" when ALU_WrapperControl(8 downto 6) = "100" -- slt
		else "000000";
ALU_zero <=ALU_status(0);
ALU_overflow <=ALU_status(1);
ALU_busy <=ALU_status(2);

ALU_unknown <= '0' when ALU_WrapperControl(8 downto 6) = "010" and (ALU_WrapperControl(5 downto 0) = "100000" 
									or ALU_WrapperControl(5 downto 0) = "100010" or ALU_WrapperControl(5 downto 0) = "100100" or ALU_WrapperControl(5 downto 0) = "100101"
									or ALU_WrapperControl(5 downto 0) = "101010" or  ALU_WrapperControl(5 downto 0) = "101011" 
									or ALU_WrapperControl(5 downto 0) = "100111" or ALU_WrapperControl(5 downto 0) = "000000" 
									or ALU_WrapperControl(5 downto 0) = "000010" or ALU_WrapperControl(5 downto 0) = "000011" 
									or ALU_WrapperControl(5 downto 0) = "000100" or ALU_WrapperControl(5 downto 0) = "000110" 
									or ALU_WrapperControl(5 downto 0) = "000111" or ALU_WrapperControl(5 downto 0) = "011000" 
									or ALU_WrapperControl(5 downto 0) = "011001" or ALU_WrapperControl(5 downto 0) = "011010" 
									or ALU_WrapperControl(5 downto 0) = "011011" or ALU_WrapperControl(5 downto 0) = "100110")
					else '1' when ALU_WrapperControl(8 downto 6) = "010"
					else '0';
					-- Check for unknown RType Instruction since not all other instructions come to the alu
		
end archALUWrapper;
