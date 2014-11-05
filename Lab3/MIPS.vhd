----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	MIPS
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: MIPS processor
--
-- Dependencies: PC, ALU, ControlUnit, RegFile
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: DO NOT modify the interface (entity). Implementation (architecture) can be modified.
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity MIPS is -- DO NOT modify the interface (entity)
    Port ( 	
			Addr_Instr 		: out STD_LOGIC_VECTOR (31 downto 0);
			Instr 			: in STD_LOGIC_VECTOR (31 downto 0);
			Addr_Data		: out STD_LOGIC_VECTOR (31 downto 0);
			Data_In			: in STD_LOGIC_VECTOR (31 downto 0);
			Data_Out			: out  STD_LOGIC_VECTOR (31 downto 0);
			MemRead 			: out STD_LOGIC; 
			MemWrite 		: out STD_LOGIC; 
			RESET				: in STD_LOGIC;
			CLK				: in STD_LOGIC
			);
end MIPS;


architecture arch_MIPS of MIPS is

----------------------------------------------------------------
-- Program Counter
----------------------------------------------------------------
component PC is
	Port(	
			PC_in 	: in STD_LOGIC_VECTOR (31 downto 0);
			PC_out 	: out STD_LOGIC_VECTOR (31 downto 0);
			RESET		: in STD_LOGIC;
			CLK		: in STD_LOGIC);
end component;

----------------------------------------------------------------
-- ALU
----------------------------------------------------------------
component ALU_Wrapper is
    Port ( 	 
			CLK 				: in  STD_LOGIC;
			ALU_WrapperControl : in  STD_LOGIC_VECTOR (8 downto 0);
			ALU_InA 		: in  STD_LOGIC_VECTOR (31 downto 0);				
			ALU_InB 		: in  STD_LOGIC_VECTOR (31 downto 0);
			ALU_OutA 		: out STD_LOGIC_VECTOR (31 downto 0);
			ALU_OutB 		: out STD_LOGIC_VECTOR (31 downto 0);
			ALU_busy		: out STD_LOGIC;
			ALU_overflow		: out STD_LOGIC;
			ALU_zero		: out STD_LOGIC);
end component;

----------------------------------------------------------------
-- Control Unit
----------------------------------------------------------------
component ControlUnit is
    Port ( 	
			opcode 		: in   STD_LOGIC_VECTOR (5 downto 0);
			ALUOp 		: out  STD_LOGIC_VECTOR (2 downto 0);
			Branch 		: out  STD_LOGIC;
			Jump	 		: out  STD_LOGIC;				
			MemRead 		: out  STD_LOGIC;	
			MemtoReg 	: out  STD_LOGIC;	
			InstrtoReg	: out  STD_LOGIC; -- true for LUI. When true, Instr(15 downto 0)&x"0000" is written to rt
			MemWrite		: out  STD_LOGIC;	
			ALUSrc 		: out  STD_LOGIC;	
			SignExtend 	: out  STD_LOGIC; -- false for ORI 
			RegWrite		: out  STD_LOGIC;	
			RegDst		: out  STD_LOGIC);
end component;

----------------------------------------------------------------
-- Register File
----------------------------------------------------------------
component RegFile is
    Port ( 	
			ReadAddr1_Reg 	: in  STD_LOGIC_VECTOR (4 downto 0);
			ReadAddr2_Reg 	: in  STD_LOGIC_VECTOR (4 downto 0);
			ReadData1_Reg 	: out STD_LOGIC_VECTOR (31 downto 0);
			ReadData2_Reg 	: out STD_LOGIC_VECTOR (31 downto 0);				
			WriteAddr_Reg	: in  STD_LOGIC_VECTOR (4 downto 0); 
			WriteData_Reg 	: in STD_LOGIC_VECTOR (31 downto 0);
			RegWrite 		: in STD_LOGIC; 
			CLK 				: in  STD_LOGIC);
end component;

----------------------------------------------------------------
-- HILO Registers
----------------------------------------------------------------
component HILO is
    Port ( 	ReadData_High 	: out STD_LOGIC_VECTOR (31 downto 0);
				ReadData_Lo 	: out STD_LOGIC_VECTOR (31 downto 0);				
				WriteData_High	: in  STD_LOGIC_VECTOR (31 downto 0); 
				WriteData_Lo 	: in STD_LOGIC_VECTOR (31 downto 0);
				HILOWrite 		: in STD_LOGIC; 
				CLK 				: in  STD_LOGIC);
end component;


----------------------------------------------------------------
-- PC Signals
----------------------------------------------------------------
	signal	PC_in 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	PC_out 		:  STD_LOGIC_VECTOR (31 downto 0) := x"00000000";

----------------------------------------------------------------
-- ALU Signals
----------------------------------------------------------------
	signal	ALU_InA 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_WrapperControl 		:  STD_LOGIC_VECTOR (8 downto 0);
	signal	ALU_InB 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_OutA 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_OutB 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_Control	:  STD_LOGIC_VECTOR (4 downto 0);
	signal	ALU_zero		:  STD_LOGIC;			
	signal	ALU_overflow		:  STD_LOGIC;	
	signal	ALU_busy		:  STD_LOGIC;	

----------------------------------------------------------------
-- Control Unit Signals
----------------------------------------------------------------				
 	signal	opcode 		:  STD_LOGIC_VECTOR (5 downto 0);
	signal	ALUOp 		:  STD_LOGIC_VECTOR (2 downto 0);
	signal	Branch 		:  STD_LOGIC;
	signal	Jump	 		:  STD_LOGIC;	
	signal	MemtoReg 	:  STD_LOGIC;
	signal 	InstrtoReg	: 	STD_LOGIC;		
	signal	ALUSrc 		:  STD_LOGIC;	
	signal	SignExtend 	: 	STD_LOGIC;
	signal	RegWrite		: 	STD_LOGIC;	
	signal	RegDst		:  STD_LOGIC;

----------------------------------------------------------------
-- Register File Signals
----------------------------------------------------------------
 	signal	ReadAddr1_Reg 	:  STD_LOGIC_VECTOR (4 downto 0);
	signal	ReadAddr2_Reg 	:  STD_LOGIC_VECTOR (4 downto 0);
	signal	ReadData1_Reg 	:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ReadData2_Reg 	:  STD_LOGIC_VECTOR (31 downto 0);
	signal	WriteAddr_Reg	:  STD_LOGIC_VECTOR (4 downto 0); 
	signal	WriteData_Reg 	:  STD_LOGIC_VECTOR (31 downto 0);
	
	
----------------------------------------------------------------
-- HILO Register Signals
----------------------------------------------------------------
 	signal	ReadData_High 	:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ReadData_Lo 	:  STD_LOGIC_VECTOR (31 downto 0);				
	signal	WriteData_High	:  STD_LOGIC_VECTOR (31 downto 0); 
	signal	WriteData_Lo 	:  STD_LOGIC_VECTOR (31 downto 0);
	signal	HILOWrite 		:  STD_LOGIC; 

----------------------------------------------------------------
-- Other Signals
----------------------------------------------------------------


	--<any other signals used goes here>


	signal	PC_plus4 	:  STD_LOGIC_VECTOR (31 downto 0);
----------------------------------------------------------------	
----------------------------------------------------------------
-- <MIPS architecture>
----------------------------------------------------------------
----------------------------------------------------------------
begin

----------------------------------------------------------------
-- PC port map
----------------------------------------------------------------
PC1				: PC port map
						(
						PC_in 	=> PC_in, 
						PC_out 	=> PC_out, 
						RESET 	=> RESET,
						CLK 		=> CLK
						);
						
----------------------------------------------------------------
-- ALU port map
----------------------------------------------------------------
ALU_Wrapper1 		: ALU_Wrapper port map
						(
						CLK => CLK,
						ALU_WrapperControl=>ALU_WrapperControl, 
						ALU_InA 		=> ALU_InA, 
						ALU_InB 		=> ALU_InB, 
						ALU_OutA 		=> ALU_OutA,
						ALU_OutB 		=> ALU_OutB, 
						ALU_busy  	=> ALU_busy,
						ALU_overflow  	=> ALU_overflow,
						ALU_zero  	=> ALU_zero
						);
						
----------------------------------------------------------------
-- PC port map
----------------------------------------------------------------
ControlUnit1 	: ControlUnit port map
						(
						opcode 		=> opcode, 
						ALUOp 		=> ALUOp, 
						Branch 		=> Branch, 
						Jump 			=> Jump, 
						MemRead 		=> MemRead, 
						MemtoReg 	=> MemtoReg, 
						InstrtoReg 	=> InstrtoReg, 
						MemWrite 	=> MemWrite, 
						ALUSrc 		=> ALUSrc, 
						SignExtend 	=> SignExtend, 
						RegWrite 	=> RegWrite, 
						RegDst 		=> RegDst
						);
						
----------------------------------------------------------------
-- Register file port map
----------------------------------------------------------------
RegFile1			: RegFile port map
						(
						ReadAddr1_Reg 	=>  ReadAddr1_Reg,
						ReadAddr2_Reg 	=>  ReadAddr2_Reg,
						ReadData1_Reg 	=>  ReadData1_Reg,
						ReadData2_Reg 	=>  ReadData2_Reg,
						WriteAddr_Reg 	=>  WriteAddr_Reg,
						WriteData_Reg 	=>  WriteData_Reg,
						RegWrite 		=> RegWrite,
						CLK 				=> CLK				
						);
						
						
						
----------------------------------------------------------------
-- HILO registers port map
----------------------------------------------------------------
HILO1			: HILO port map
						(
						ReadData_High 	=> ReadData_High,
						ReadData_Lo => ReadData_Lo,
						WriteData_High => WriteData_High,
						WriteData_Lo => WriteData_Lo,
						HILOWrite => HILOWrite,
						CLK => CLK
						);

----------------------------------------------------------------
-- Processor logic
----------------------------------------------------------------
--<Rest of the logic goes here>

-- Init PC to the last value of PC
--PC_in <= PC_Out;				
opcode <= Instr(31 downto 26);
ReadAddr1_Reg <= Instr(25 downto 21);
ReadAddr2_Reg <= Instr(20 downto 16);


ALU_InA <= ReadData1_Reg when InstrtoReg = '0'
			  else Instr(15 downto 0)&x"0000" when InstrtoReg = '1';
			  
ALU_InB <= 
			"000000000000000000000000000" & Instr(10 downto 6) when Instr(31 downto 26) = "000000" and (Instr(5 downto 0) = "000000" or Instr(5 downto 0) = "000010" or Instr(5 downto 0) = "000011") -- sll/srl/sra
			else x"00000000" when InstrtoReg = '1' or Instr(31 downto 26) = "000001" -- lui/bgez/bgezal
			else ReadData2_Reg when ALUSrc = '0' -- all other r types
			else "0000000000000000" & Instr(15 downto 0) when (ALUSrc = '1' and Instr(15) = '0' and SignExtend = '1') -- lw/sw
			else "1111111111111111" & Instr(15 downto 0) when (ALUSrc = '1' and Instr(15) = '1' and SignExtend = '1') -- lw/sw
			else "0000000000000000" & Instr(15 downto 0) when (ALUSrc = '1' and SignExtend = '0'); -- ori
ALU_WrapperControl <= ALUOp & Instr(5 downto 0);

Addr_Data <= ALU_OutA;

WriteAddr_Reg <= Instr(15 downto 11) when RegDst = '1'
				else "11111" when (Instr(15 downto 11) = "10001" and Instr(31 downto 26) = "000001") or Instr(31 downto 26) = "000011" 
				else Instr(20 downto 16);
				
WriteData_Reg <= ReadData_High when Instr(31 downto 26) = "000000" and Instr(5 downto 0) = "010000" -- MFHI
					  else ReadData_Lo when Instr(31 downto 26) = "000000" and  Instr(5 downto 0) = "010010" -- MFLO
					  else PC_plus4  when (Instr(15 downto 11) = "10001" and Instr(31 downto 26) = "000001") or Instr(31 downto 26) = "000011" or (opcode = "000000" and Instr(5 downto 0) = "001001") -- jalr 
					  else ALU_OutA when MemtoReg = '0'
					  else Data_In when MemtoReg = '1';


Data_Out <= ReadData2_Reg;

PC_plus4 <= PC_out + 4;

HILOWrite <= '1' when opcode = "000000" and (Instr(5 downto 0) = "011000" or Instr(5 downto 0) = "011001" or Instr(5 downto 0) = "011010" or Instr(5 downto 0) = "011011")
				else '0';
				
WriteData_High <= ALU_OutA;
WriteData_Lo <= ALU_OutB;

PC_in <= PC_in when ALU_busy = '1'
			else ReadData1_Reg when opcode = "000000" and (Instr(5 downto 0) = "001000" or Instr(5 downto 0) = "001001") --jr/jral
			else PC_plus4(31 downto 28) & Instr(25 downto 0) & "00" when Jump = '1' and opcode = "000010" --j
			else ("00000000000000" & Instr(15 downto 0) & "00") + PC_plus4 when (Branch = '1' and Instr(15) = '0' and ((opcode = "000100" and ALU_zero = '1') or (opcode = "000001" and ALU_OutA(0) = '0'))) --beq / BGEZ
			else ("11111111111111" & Instr(15 downto 0) & "00") + PC_plus4 when (Branch = '1' and Instr(15) = '1' and ((opcode = "000100" and ALU_zero = '1') or (opcode = "000001" and ALU_OutA(0) = '0'))) --beq / BGEZ
			else PC_plus4;
Addr_Instr <= PC_out;	


end arch_MIPS;

----------------------------------------------------------------	
----------------------------------------------------------------
-- </MIPS architecture>
----------------------------------------------------------------
----------------------------------------------------------------	
