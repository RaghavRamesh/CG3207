----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	ControlUnit
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: Control Unit for the basic MIPS processor
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: The interface (entity) as well as implementation (architecture) can be modified
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity ControlUnit is
    Port ( 	opcode 		: in   STD_LOGIC_VECTOR (5 downto 0);
				ALUOp 		: out  STD_LOGIC_VECTOR (1 downto 0);
				Branch 		: out  STD_LOGIC;		
				Jump	 		: out  STD_LOGIC;	
				MemRead 		: out  STD_LOGIC;	
				MemtoReg 	: out  STD_LOGIC;	
				InstrtoReg	: out  STD_LOGIC;
				MemWrite		: out  STD_LOGIC;	
				ALUSrc 		: out  STD_LOGIC;	
				SignExtend 	: out  STD_LOGIC;
				RegWrite		: out  STD_LOGIC;	
				RegDst		: out  STD_LOGIC);
end ControlUnit;


architecture arch_ControlUnit of ControlUnit is  
begin   

ALUOp      <= "00" when opcode = "100011" or opcode = "101011" 
						 else "10" when opcode = "000000"
						 else "11" when opcode = "001101"
						 else "11" when opcode = "001111";
			
Branch 	  <= '1' when opcode = "000100"
						else '0';
	  
Jump 		  <= '1' when opcode = "000010"
						else '0' ;
	  
MemRead 	  <= '0' when opcode = "000010"
						else '0' when opcode = "101011" 
						else '1' when opcode = "100011" 
						else '0' when opcode = "000100" 
						else '0' when opcode = "000000"
						else '0' when opcode = "001101"
						else '0' when opcode = "001111";
			
MemtoReg   <= '0' when opcode = "000010" 
						else '1' when opcode = "100011" or  opcode = "101011"
						else '0' when opcode = "000100"
						else '0' when opcode = "000000"
						else '0' when opcode = "001101"
						else '0' when opcode = "001111";
			
InstrtoReg <= '0' when opcode = "000010" 
						else '0' when opcode = "000000"
						else '0' when opcode = "000100"
						else '0' when opcode = "100011" or  opcode = "101011"
						else '0' when opcode = "001101"
						else '1' when opcode = "001111";
			
MemWrite   <= '0' when opcode = "000010" 
						else '1' when opcode = "101011" 
						else '0' when opcode = "100011"
						else '0' when opcode = "000000" 
						else '0' when opcode = "000100"
						else '0' when opcode = "001101"
						else '0' when opcode = "001111";
			
ALUSrc 	  <= '0' when opcode = "000010" 
						else '0' when opcode = "000000"
						else '1' when opcode = "100011" or  opcode = "101011" or opcode = "001101"
						else '0' when opcode = "000100"
						else '0' when opcode = "001111";
			
SignExtend <= '0' when opcode = "000010" 
						else '1' when opcode = "000000" 
						else '1' when opcode = "000100"
						else '0' when opcode = "001101"
						else '0' when opcode = "001111"
						else '0';
			
RegWrite   <= '0' when opcode = "000010"
						else '0' when opcode = "101011" 
						else '1' when opcode = "100011"
						else '1' when opcode = "000000" 
						else '0' when opcode = "000100"
						else '1' when opcode = "001101"
						else '1' when opcode = "001111";
			
RegDst     <= '0' when opcode = "000010" 
						else '0' when opcode = "100011" or opcode = "101011" or opcode = "001101"
						else '1' when opcode = "000000"
						else '0' when opcode = "001111";
end arch_ControlUnit;

