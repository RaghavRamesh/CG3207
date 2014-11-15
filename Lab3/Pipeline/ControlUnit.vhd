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
    Port ( 	opcode 		: in  STD_LOGIC_VECTOR (5 downto 0);
				RegWriteD	: out  STD_LOGIC;
				MemtoRegD 	: out  STD_LOGIC;	
				MemWriteD	: out  STD_LOGIC;	
				BranchD 		: out  STD_LOGIC;		
				ALUOpD 		: out  STD_LOGIC_VECTOR (2 downto 0);
				ALUSrcD 		: out  STD_LOGIC;	
				RegDstD		: out  STD_LOGIC);

--				Jump	 		: out  STD_LOGIC;	
--				MemRead 		: out  STD_LOGIC;	
--				InstrtoReg	: out  STD_LOGIC;
--				SignExtend 	: out  STD_LOGIC;
end ControlUnit;


architecture arch_ControlUnit of ControlUnit is  
begin   

ALUOpD <= "000" when opcode = "100011" or opcode = "101011" 	-- LW/SW
			else "010" when opcode = "000000"							-- R-Type
			else "011" when opcode = "001101"							-- Ori
			else "001" when opcode = "000100"							-- Beq
			else "011" when opcode = "001111";						-- Lui
			
BranchD <= '1' when opcode = "000100"
	  else '0';
	  
--Jump <= '1' when opcode = "000010"
--	  else '0' ;
	  
--MemRead <= '0' when opcode = "000010"
--			else '0' when opcode = "101011" 
--			else '1' when opcode = "100011" 
--			else '0' when opcode = "000100" 
--			else '0' when opcode = "000000"
--			else '0' when opcode = "001101"
--			else '0' when opcode = "001111";
			
MemtoRegD <= '0' when opcode = "000010" 
			else '1' when opcode = "100011" or  opcode = "101011"
			else '0' when opcode = "000100"
			else '0' when opcode = "000000"
			else '0' when opcode = "001101"
			else '0' when opcode = "001111";
			
--InstrtoReg <= '0' when opcode = "000010" 
--			else '0' when opcode = "000000"
--			else '0' when opcode = "000100"
--			else '0' when opcode = "100011" or  opcode = "101011"
--			else '0' when opcode = "001101"
--			else '1' when opcode = "001111";
			
MemWriteD <= '0' when opcode = "000010" 
			else '1' when opcode = "101011" 
			else '0' when opcode = "100011"
			else '0' when opcode = "000000" 
			else '0' when opcode = "000100"
			else '0' when opcode = "001101"
			else '0' when opcode = "001111";
			
ALUSrcD <= '0' when opcode = "000010" 
			else '0' when opcode = "000000"
			else '1' when opcode = "100011" or  opcode = "101011" or opcode = "001101"
			else '0' when opcode = "000100"
			else '0' when opcode = "001111";
			
--SignExtend <= '0' when opcode = "000010" 
--			else '0' when opcode = "000000" 
--			else '1' when opcode = "000100"
--			else '0' when opcode = "001101"
--			else '1' when opcode = "100011" or  opcode = "101011"
--			else '0' when opcode = "001111"
--			else '0';
			
RegWriteD <= '0' when opcode = "000010"
			else '0' when opcode = "101011" 
			else '1' when opcode = "100011"
			else '1' when opcode = "000000" 
			else '0' when opcode = "000100"
			else '1' when opcode = "001101"
			else '1' when opcode = "001111";
			
RegDstD <= '0' when opcode = "000010" 
			else '0' when opcode = "100011" or opcode = "101011" or opcode = "001101"
			else '1' when opcode = "000000"
			else '0' when opcode = "001111";
			
end arch_ControlUnit;

