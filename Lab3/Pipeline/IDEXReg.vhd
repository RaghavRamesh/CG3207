----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:36:43 11/08/2014 
-- Design Name: 
-- Module Name:    IDEXReg - Behavioral 
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

entity IDEXReg is
	
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
			
end IDEXReg;

architecture Behavioral of IDEXReg is

begin

process (CLK, StallIDEX)

	begin

		if (CLK'event and CLK='1' and StallIDEX='0') then

				RegWriteE 		<= RegWriteD;
				MemtoRegE 		<= MemtoRegD;
				MemWriteE		<= MemWriteD;
				BranchE 			<= BranchD;
				ALUOpE 			<= ALUOpD;
				ALUSrcE 			<= ALUSrcD;
				RegDstE			<= RegDstD;
				ReadData1_RegE <= ReadData1_RegD;
				ReadData2_RegE <= ReadData2_RegD;
				PC_E				<= PC_D;
				RtE				<= RtD;
				RdE				<= RdD;
				ImmediateE		<= ImmediateD;
				InstrE 			<= InstrD;	

		end if;

	end process;

end Behavioral;