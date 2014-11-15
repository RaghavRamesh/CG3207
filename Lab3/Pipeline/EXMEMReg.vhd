----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:04:42 11/08/2014 
-- Design Name: 
-- Module Name:    EXMEMReg - Behavioral 
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

entity EXMemReg is

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
			  
end ExMemReg;

architecture Behavioral of ExMemReg is

begin

process(CLK, FlushE)

	begin
	
	if FlushE='1' then 
	
		RegWriteM  			<= '0';	 
		MemtoRegM 			<= '0';
		MemWriteM 			<= '0';
		BranchM 				<= '0';
		ALU_ZeroM 			<= '0';
		ALU_OutAM 			<= (others => '0');
		WriteDataM			<= (others => '0');
   	WriteAddrRegM 		<= (others => '0');
		PCBranchM			<= (others => '0');
		PCSrcM				<= '0';
	
	elsif (CLK'event and CLK='1') then 
	
		RegWriteM  			<= RegWriteE;	 
		MemtoRegM 			<= MemtoRegE;			
		MemWriteM 			<= MemWriteE;		
		BranchM 				<= BranchE;		
		
		ALU_ZeroM 			<= ALU_ZeroE;
		ALU_OutAM 			<= ALU_OutAE;
		WriteDataM			<= WriteDataE;
   	WriteAddrRegM 		<= WriteAddrRegE;
		
		PCBranchM			<= PCBranchE;
		
		PCSrcM				<= BranchE and ALU_ZeroE;
		
	end if;
	
end process;

end Behavioral;

