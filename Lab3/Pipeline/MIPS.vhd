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
component ALU is
    Port ( 	
			ALU_InA 		: in  STD_LOGIC_VECTOR (31 downto 0);				
			ALU_InB 		: in  STD_LOGIC_VECTOR (31 downto 0);
			ALU_Out 		: out STD_LOGIC_VECTOR (31 downto 0);
			ALU_Control	: in  STD_LOGIC_VECTOR (7 downto 0);
			ALU_zero		: out STD_LOGIC);
end component;

----------------------------------------------------------------
-- Control Unit
----------------------------------------------------------------
component ControlUnit is
    Port ( 	
			opcode 		: in   STD_LOGIC_VECTOR (5 downto 0);
			ALUOpD 		: out  STD_LOGIC_VECTOR (2 downto 0);
			BranchD 		: out  STD_LOGIC;
--			Jump	 		: out  STD_LOGIC;				
--			MemRead 		: out  STD_LOGIC;	
			MemtoRegD 	: out  STD_LOGIC;	
--			InstrtoReg	: out  STD_LOGIC; -- true for LUI. When true, Instr(15 downto 0)&x"0000" is written to rt
			MemWriteD	: out  STD_LOGIC;	
			ALUSrcD		: out  STD_LOGIC;
--			SignExtend 	: out  STD_LOGIC; -- false for ORI 
			RegWriteD		: out  STD_LOGIC;	
			RegDstD		: out  STD_LOGIC);
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

component IFIDReg is 
    Port ( 
			CLK 				: in  STD_LOGIC;
			StallIFID		: in 	STD_LOGIC;
			PC_F 				: in  STD_LOGIC_VECTOR (31 downto 0);
         InstrF 			: in  STD_LOGIC_VECTOR (31 downto 0);
         PC_D 				: out  STD_LOGIC_VECTOR (31 downto 0);
         InstrD 			: out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component IDEXReg is 

Port (
		CLK 					: in STD_LOGIC;
		StallIDEX			: in STD_LOGIC;
		RegWriteD			: in  STD_LOGIC;	
		MemtoRegD 			: in  STD_LOGIC;	
		MemWriteD			: in  STD_LOGIC;	
		BranchD 				: in  STD_LOGIC;			
		ALUOpD 				: in  STD_LOGIC_VECTOR (2 downto 0);
		ALUSrcD 				: in  STD_LOGIC;	
		RegDstD				: in  STD_LOGIC;
		ReadData1_RegD 	: in STD_LOGIC_VECTOR (31 downto 0);
		ReadData2_RegD 	: in STD_LOGIC_VECTOR (31 downto 0);		
		PC_D					: in STD_LOGIC_VECTOR (31 downto 0);
		RtD					: in STD_LOGIC_VECTOR (4 downto 0);
		RdD					: in STD_LOGIC_VECTOR (4 downto 0);
		ImmediateD			: in STD_LOGIC_VECTOR (31 downto 0);
		InstrD 				: in  STD_LOGIC_VECTOR (31 downto 0);

		
		RegWriteE			: out  STD_LOGIC;	
		MemtoRegE 			: out  STD_LOGIC;	
		MemWriteE			: out  STD_LOGIC;	
		BranchE 				: out  STD_LOGIC;			
		ALUOpE 				: out  STD_LOGIC_VECTOR (2 downto 0);
		ALUSrcE 				: out  STD_LOGIC;	
		RegDstE				: out  STD_LOGIC;
		ReadData1_RegE 	: out STD_LOGIC_VECTOR (31 downto 0);
		ReadData2_RegE 	: out STD_LOGIC_VECTOR (31 downto 0);				
		PC_E					: out STD_LOGIC_VECTOR (31 downto 0);
		RtE					: out STD_LOGIC_VECTOR (4 downto 0);
		RdE					: out STD_LOGIC_VECTOR (4 downto 0);
		ImmediateE			: out STD_LOGIC_VECTOR (31 downto 0);
		InstrE 				: out  STD_LOGIC_VECTOR (31 downto 0)
		);

end component;

component EXMEMReg is

Port ( 	CLK 				: in  STD_LOGIC;
			FlushE			: in 	STD_LOGIC;
			RegWriteE		: in  STD_LOGIC;	
			MemtoRegE		: in  STD_LOGIC;	
			MemWriteE		: in  STD_LOGIC;
			BranchE			: in STD_LOGIC;
			ALU_ZeroE    	: in STD_LOGIC;							-- Branch Selector
			ALU_OutAE		: in STD_LOGIC_VECTOR(31 downto 0); -- ALU Result
			WriteDataE		: in STD_LOGIC_VECTOR(31 downto 0);
			WriteAddrRegE	: in STD_LOGIC_VECTOR(4 downto 0);	-- Register Destination 
			PCBranchE		: in STD_LOGIC_VECTOR(31 downto 0);
			
			RegWriteM		: out  STD_LOGIC;	
			MemtoRegM		: out  STD_LOGIC;	
			MemWriteM		: out  STD_LOGIC;
			BranchM			: out STD_LOGIC;
			ALU_ZeroM    	: out STD_LOGIC;
			ALU_OutAM		: out STD_LOGIC_VECTOR(31 downto 0);
			WriteDataM		: out STD_LOGIC_VECTOR(31 downto 0);
			WriteAddrRegM	: out STD_LOGIC_VECTOR(4 downto 0);	-- Register Destination 
			PCBranchM		: out STD_LOGIC_VECTOR(31 downto 0);
			PCSrcM			: out STD_LOGIC
);	
			  
end component;

component MemWBReg is 

Port (
		CLK 				: in STD_LOGIC;
		RegWriteM		: in STD_LOGIC;
		MemtoRegM		: in STD_LOGIC;
		ALU_OutAM		: in STD_LOGIC_VECTOR(31 downto 0);
		ReadDataM	: in STD_LOGIC_VECTOR(31 downto 0);
		WriteAddrRegM	: in STD_LOGIC_VECTOR(4 downto 0);
		
		RegWriteW		: out STD_LOGIC;
		MemtoRegW		: out STD_LOGIC;
		ALU_OutAW		: out STD_LOGIC_VECTOR(31 downto 0);
		ReadDataW		: out STD_LOGIC_VECTOR(31 downto 0);
		WriteAddrRegW	: out STD_LOGIC_VECTOR(4 downto 0)
);

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
	signal	ALU_InB 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_Out 		:  STD_LOGIC_VECTOR (31 downto 0);
	signal	ALU_Control	:  STD_LOGIC_VECTOR (7 downto 0);
	signal	ALU_zero		:  STD_LOGIC;			

----------------------------------------------------------------
-- Control Unit Signals
----------------------------------------------------------------				
 	signal	opcode 		:  STD_LOGIC_VECTOR (5 downto 0);
	signal	ALUOp 		:  STD_LOGIC_VECTOR (1 downto 0);
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
-- Other Signals
----------------------------------------------------------------
	--<any other signals used goes here>

	signal	PC_plus4 	:  STD_LOGIC_VECTOR (31 downto 0);
	
	-- Fetch Stage Signals
	
	signal	PC_F 				: STD_LOGIC_VECTOR(31 downto 0);
	signal	InstrF 			: STD_LOGIC_VECTOR(31 downto 0);

	-- Decode Stage Signals 
	
	signal 	PC_D 				: STD_LOGIC_VECTOR(31 downto 0);
	signal 	InstrD 			: STD_LOGIC_VECTOR(31 downto 0);
	signal	RegWriteD		: STD_LOGIC;	
	signal	MemtoRegD 		: STD_LOGIC;	
	signal	MemWriteD		: STD_LOGIC;
	signal	BranchD 			: STD_LOGIC;			
	signal	ALUOpD 			: STD_LOGIC_VECTOR (2 downto 0);
	signal	ALUSrcD 			: STD_LOGIC;	
	signal	RegDstD			: STD_LOGIC;
	signal	ReadData1_RegD : STD_LOGIC_VECTOR (31 downto 0);
	signal	ReadData2_RegD : STD_LOGIC_VECTOR (31 downto 0);
	signal 	RtD				: STD_LOGIC_VECTOR (4 downto 0);
	signal 	RdD				: STD_LOGIC_VECTOR (4 downto 0);
	signal 	ImmediateD		: STD_LOGIC_VECTOR (31 downto 0);
	
	
	-- Execute Stage Signals 
	
	signal	RegWriteE		: STD_LOGIC;	
	signal	MemtoRegE 		: STD_LOGIC;	
	signal	MemWriteE		: STD_LOGIC;
	signal	BranchE 			: STD_LOGIC;			
	signal	ALUOpE			: STD_LOGIC_VECTOR (2 downto 0);
	signal	ALUSrcE 			: STD_LOGIC;	
	signal	RegDstE			: STD_LOGIC;
	signal	ReadData1_RegE : STD_LOGIC_VECTOR (31 downto 0);
	signal	ReadData2_RegE : STD_LOGIC_VECTOR (31 downto 0);
	signal   PC_E				: STD_LOGIC_VECTOR (31 downto 0);
	signal 	RtE				: STD_LOGIC_VECTOR (4 downto 0);
	signal 	RdE				: STD_LOGIC_VECTOR (4 downto 0);
	signal 	ImmediateE		: STD_LOGIC_VECTOR (31 downto 0);
	signal 	InstrE 			: STD_LOGIC_VECTOR(31 downto 0);
	signal 	ALU_ZeroE    	: STD_LOGIC;
	signal 	ALU_OutAE		: STD_LOGIC_VECTOR(31 downto 0);
	signal 	WriteDataE		: STD_LOGIC_VECTOR(31 downto 0);
	signal 	WriteAddrRegE	: STD_LOGIC_VECTOR(4 downto 0);	-- Register Destination 
	signal 	PCBranchE		: STD_LOGIC_VECTOR(31 downto 0);
		
	-- Memory Stage Signals 
	
	signal 	RegWriteM		: STD_LOGIC;	
	signal 	MemtoRegM		: STD_LOGIC;	
	signal 	MemWriteM		: STD_LOGIC;
	signal 	BranchM			: STD_LOGIC;
	signal 	ALU_ZeroM    	: STD_LOGIC;
	signal 	ALU_OutAM		: STD_LOGIC_VECTOR(31 downto 0);
	signal 	WriteDataM		: STD_LOGIC_VECTOR(31 downto 0);
	signal 	WriteAddrRegM	: STD_LOGIC_VECTOR(4 downto 0);	-- Register Destination 
	signal 	PCBranchM		: STD_LOGIC_VECTOR(31 downto 0);
	signal 	PCSrcM			: STD_LOGIC;
	signal 	ReadDataM		: STD_LOGIC_VECTOR(31 downto 0);
	
	-- Write Back Stage Signals
	
	signal	RegWriteW		: STD_LOGIC;
	signal 	MemtoRegW		: STD_LOGIC;
	signal	ALU_OutAW		: STD_LOGIC_VECTOR(31 downto 0);
	signal 	ReadDataW		: STD_LOGIC_VECTOR(31 downto 0);
	signal 	WriteAddrRegW	: STD_LOGIC_VECTOR(4 downto 0);
	
	-- Stall/Clear Signals
	
	signal StallIFID			: STD_LOGIC;
	signal StallIDEX			: STD_LOGIC;
	signal CLREXMem			: STD_LOGIC;
	signal FlushE				: STD_LOGIC;
	
	signal LWStall				: STD_LOGIC;
	
		
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
ALU1 				: ALU port map
						(
						ALU_InA 		=> ALU_InA, 
						ALU_InB 		=> ALU_InB, 
						ALU_Out 		=> ALU_Out, 
						ALU_Control => ALU_Control, 
						ALU_zero  	=> ALU_zero
						);
						
----------------------------------------------------------------
-- PC port map
----------------------------------------------------------------
ControlUnit1 	: ControlUnit port map
						(
						opcode 		=> opcode, 
						ALUOpD 		=> ALUOpD, 
						BranchD 		=> BranchD, 
--						Jump 			=> Jump, 
--						MemRead 		=> MemRead, 
						MemtoRegD 	=> MemtoRegD, 
--						InstrtoReg 	=> InstrtoReg, 
						MemWriteD		=> MemWriteD, 
						ALUSrcD 		=> ALUSrcD, 
--						SignExtend 	=> SignExtend, 
						RegWriteD 	=> RegWriteD, 
						RegDstD		=> RegDstD
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
						
IFIDReg1			: IFIDReg port map
						(
						CLK 					=> CLK,
						StallIFID			=> StallIFID,
						PC_F 					=> PC_F,
						InstrF 				=> InstrF,
						PC_D 					=> PC_D,
						InstrD 				=>InstrD
						);
						
IDEXReg1			: IDEXReg port map
						(
						CLK 					=> CLK,
						StallIDEX			=> StallIDEX,
						RegWriteD 			=> RegWriteD,
						MemtoRegD  			=> MemtoRegD, 
						MemWriteD 			=> MemWriteD, 
						BranchD  			=> BranchD,  
						ALUOpD  				=> ALUOpD,
						ALUSrcD  			=> ALUSrcD, 
						RegDstD  			=> RegDstD,
						ReadData1_RegD 	=> ReadData1_RegD,
						ReadData2_RegD 	=> ReadData2_RegD,
						PC_D					=> PC_D,
						RtD					=> RtD,
						RdD					=> RdD,
						ImmediateD			=> ImmediateD,
						InstrD				=> InstrD,
						
						RegWriteE 			=> RegWriteE,
						MemtoRegE  			=> MemtoRegE, 
						MemWriteE 			=> MemWriteE, 
						BranchE  			=> BranchE,  
						ALUOpE  				=> ALUOpE,
						ALUSrcE  			=> ALUSrcE, 
						RegDstE  			=> RegDstE,
						ReadData1_RegE 	=> ReadData1_RegE,
						ReadData2_RegE 	=> ReadData2_RegE,
						PC_E					=> PC_E,
						RtE					=> RtE,
						RdE					=> RdE,
						ImmediateE			=> ImmediateE,
						InstrE				=> InstrE
						);
						
EXMemReg1		: ExMemReg port map
						(
						CLK 				=> CLK,
						FlushE			=> FlushE,
						RegWriteE 		=> RegWriteE,
						MemtoRegE 		=> MemtoRegE,
						MemWriteE 		=> MemWriteE,
						BranchE 			=> BranchE,
						
						ALU_ZeroE    	=> ALU_ZeroE,							-- Branch Selector
						ALU_OutAE		=> ALU_OutAE,							 -- ALU Result
						WriteDataE		=> WriteDataE,
						WriteAddrRegE	=> WriteAddrRegE,	-- Register Destination 
						PCBranchE		=> PCBranchE,

						RegWriteM 		=> RegWriteM,
						MemtoRegM 		=> MemtoRegM,
						MemWriteM 		=> MemWriteM,
						BranchM 			=> BranchM,
						
						ALU_ZeroM    	=> ALU_ZeroM,							-- Branch Selector
						ALU_OutAM		=> ALU_OutAM,							 -- ALU Result
						WriteDataM		=> WriteDataM,
						WriteAddrRegM	=> WriteAddrRegM,	-- Register Destination 
						PCBranchM		=> PCBranchM,
			
						PCSrcM			=> PCSrcM
						);

MemWBReg1		: MemWBReg port map
						(
						CLK 				=> CLK,
						RegWriteM		=> RegWriteM,
						MemtoRegM		=> MemtoRegM,
						ALU_OutAM		=> ALU_OutAM,
						ReadDataM		=> ReadDataM,
						WriteAddrRegM	=> WriteAddrRegM,
						
						RegWriteW		=> RegWriteW,
						MemtoRegW		=> MemtoRegW,
						ALU_OutAW		=> ALU_OutAW,
						ReadDataW		=> ReadDataW,
						WriteAddrRegW	=> WriteAddrRegW
						);
----------------------------------------------------------------
-- Processor logic
----------------------------------------------------------------
--<Rest of the logic goes here>


-- Fetch Stage

	PC_F <= PC_out + 4;
	InstrF <= Instr;

-- Decode Stage
	
	opcode 	<= InstrD(31 downto 26);
		
	ReadAddr1_Reg <= InstrD(25 downto 21);
	ReadAddr2_Reg <= InstrD(20 downto 16);
	
	ReadData1_RegD <=	ReadData1_Reg;
	ReadData2_RegD <=	ReadData2_Reg;
	
	RtD <= InstrD(20 downto 16);
	RdD <= InstrD(15 downto 11);
	
	LWStall <= '1' when (ReadAddr1_Reg = RtE)  
				else '1' when (RtD = RtE)
				else '1' when MemtoRegE = '1'
				else '0';
				
	StallIFID <= '1' when LWStall = '1';
	StallIDEX <= '1' when LWStall = '1';
	FlushE <= '1' when LWStall = '1';
	
	ImmediateD 	<= ("0000000000000000" & InstrD(15 downto 0)) when InstrD(15) = '0'
					else ("1111111111111111" & InstrD(15 downto 0)) when InstrD(15) = '1';
	
-- Execute Stage

	ALU_InA 	<= ReadData1_RegE;
	ALU_InB 	<= ReadData2_RegE when ALUSrcE = '0'
				else ImmediateE;
	
	ALU_Control <= ALUOp & InstrE(5 downto 0);

	ALU_OutAE <= ALU_Out;
	
	ALU_ZeroE <= ALU_zero;
	
	WriteDataE		<= ReadData2_RegE;
	
	WriteAddrRegE 	<= RtE when RegDst = '0' 
						else RdE;
						
	PCBranchE <= (ImmediateE(29 downto 0) & "00") + PC_E;
		
-- Memory Stage

	MemWrite <= MemWriteM;
	Addr_Data <= ALU_OutAM;	-- Write Address 
	Data_Out <= WriteDataM;
	ReadDataM <= Data_In; 
	
-- Writeback Stage

	WriteData_Reg <= ALU_OutAW when MemtoRegW = '1'
						else	ReadDataW;
	
	PC_plus4 <= PC_out + 4;
						
	PC_in <= PCBranchM when PCSrcM = '1'
				else PC_plus4;
				

--PC_in <= PC_plus4(31 downto 28) & Instr(25 downto 0) & "00" when Jump = '1' 
--			else ("00000000000000" & Instr(15 downto 0) & "00") + PC_plus4 when (Branch = '1' and ALU_zero = '1' and Instr(15) = '0')
--			else ("11111111111111" & Instr(15 downto 0) & "00") + PC_plus4 when (Branch = '1' and ALU_zero = '1' and Instr(15) = '1')
--			else PC_plus4;
--			

Addr_Instr <= PC_out;	


end arch_MIPS;

----------------------------------------------------------------	
----------------------------------------------------------------
-- </MIPS architecture>
----------------------------------------------------------------
----------------------------------------------------------------	
