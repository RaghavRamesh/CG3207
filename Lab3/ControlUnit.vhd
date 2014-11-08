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
				ALUOp 		: out  STD_LOGIC_VECTOR (2 downto 0);
				Branch 		: out  STD_LOGIC;	
				BGEZLINK		: in 	 STD_LOGIC;		
				CHECK_ERET	: in 	 STD_LOGIC;		
				CHECK_MFC	: in 	 STD_LOGIC;				
				Jump	 		: out  STD_LOGIC;	
				MemRead 		: out  STD_LOGIC;	
				MemtoReg 	: out  STD_LOGIC;	
				InstrtoReg	: out STD_LOGIC;
				MemWrite		: out  STD_LOGIC;	
				ALUSrc 		: out  STD_LOGIC;	
				SignExtend 	: out  STD_LOGIC;
				RegWrite		: out  STD_LOGIC;	
				RegDst		: out  STD_LOGIC;	
				CU_Unknown	: out  STD_LOGIC);
end ControlUnit;


architecture arch_ControlUnit of ControlUnit is  
begin   
										--LW/SW/ADDI/ADDIU/MF(T)C0(ERET)/RTYPE/ ORI
CU_Unknown <= '0' when opcode = "100011" or opcode = "101011" or opcode = "001000" or opcode = "001001" or opcode = "010000" or opcode = "000000" or opcode = "001101" 
										--LUI/BEQ/SLTI/BGEZ(AL)/J/JAL
						or opcode = "001111" or opcode = "000100" or opcode = "001010" or opcode = "000001" or opcode = "000010" or opcode = "000011"
					else '1';

ALUOp <= "000" when opcode = "100011" or opcode = "101011" or opcode = "001000" or opcode = "001001" or opcode = "010000" -- MFC0/MTC0
			else "010" when opcode = "000000"
			else "011" when opcode = "001101" or opcode = "001111" -- lui
			else "001" when opcode = "000100"
			else "100" when opcode = "001010" or opcode = "000001"--slti / bgez / bgezal
			else "000"; 
			
Branch <= '1' when opcode = "000100" or opcode = "000001"
	  else '0';
	  
Jump <= '1' when opcode = "000010" or opcode = "000011"
	  else '1' when opcode = "010000" and CHECK_ERET = '1'
	  else '0' ;
	  
MemRead <= '1' when opcode = "100011" --lw
			   else '0'; 		
				
MemtoReg <= '1' when opcode = "100011" --lw
			else '0';
			
InstrtoReg <= '1' when opcode = "001111" --lui
			else '0';
			
MemWrite <= '1' when opcode = "101011" --sw
			else '0';
			
ALUSrc <= '1' when opcode = "100011" --lw
			else '1' when opcode = "101011" --sw
			else '1' when opcode = "001101" --ori
			else '1' when opcode = "001000"	--addi		
			else '1' when opcode = "001001"  --addiu
			else '1' when opcode = "001010"  --slti
			else '0';
			
SignExtend <= '1' when opcode = "000100" --beq
			else '1' when opcode = "001000" --addi
			else '1' when opcode = "100011" --lw
			else '1'	when opcode = "101011" --sw
			else '1' when opcode = "001010"  --slti
			else '0';
			
RegWrite <= '1' when opcode = "100011" --lw
			else '1' when opcode = "000000"  --rtype
			else '1' when opcode = "001000"	--addi
			else '1' when opcode = "001001"  --addiu
			else '1' when opcode = "001101"  --ori
			else '1' when opcode = "001111"  --lui			
			else '1' when opcode = "001010"  --slti
			else '1' when opcode = "000001" and BGEZLINK = '1'-- bgezal
			else '1' when opcode = "000011" -- jal
			else '1' when opcode = "010000" and CHECK_MFC = '1' --mfc0
			else '0'; 
			
RegDst <= '1' when opcode = "000000" or opcode = "010000" --rtype/mfc0
			else '0';
end arch_ControlUnit;

