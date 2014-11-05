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
           ALU_zero : out  STD_LOGIC);
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
	signal	ALU_Control		:  STD_LOGIC_VECTOR(5 downto 0) ;			

begin

----------------------------------------------------------------
-- ALU port map
----------------------------------------------------------------
ALU1 				: ALU port map
						(
						CLK => CLK,
						Control => ALU_Control,
						Operand1 		=> ALU_InA, 
						Operand2 		=> ALU_InB, 
						Result1 		=> ALU_OutA, 
						Result2 		=> ALU_OutB,  
						Status  	=> ALU_status
						);
						
						

ALU_Control <= "000010" when ALU_WrapperControl(8 downto 6) = "000" or (ALU_WrapperControl(7 downto 6) ="10"and ALU_WrapperControl(5 downto 0) = "100000") -- add
      else "000110" when ALU_WrapperControl(8 downto 6) = "001" or (ALU_WrapperControl(7 downto 6) = "10" and ALU_WrapperControl(5 downto 0) = "100010") -- sub
		else "000000" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "100100" -- and
		else "000001" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "100101" -- or
		else "000111" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "101010" -- slt
		else "001110" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "101011" -- sltu
		else "001100" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "100111" -- nor
		else "100101" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000000" --sll
		else "101101" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000010" --srl
		else "101001" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000011" --sra
		else "100101" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000100" --sllv
		else "101101" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000100" --srlv
		else "101001" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "000100" --srav
		else "110000" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "011000" -- mult
		else "110001" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "011001" -- multu
		else "110010" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "011010" -- div
		else "110011" when ALU_WrapperControl(8 downto 6) = "010" and ALU_WrapperControl(5 downto 0) = "011011" -- divu
		else "000001" when ALU_WrapperControl(8 downto 6) = "011" -- lui/ori;
		else "000111" when ALU_WrapperControl(8 downto 6) = "100" -- slt
		else "000000";
ALU_zero <=ALU_status(0);
ALU_overflow <=ALU_status(1);
ALU_busy <=ALU_status(2);
end archALUWrapper;

