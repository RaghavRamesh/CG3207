----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:56:32 11/08/2014 
-- Design Name: 
-- Module Name:    MemWBReg - Behavioral 
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

entity MemWBReg is

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

end MemWBReg;

architecture Behavioral of MemWBReg is

begin

process (CLK)

begin

	if (CLK'event and CLK='1') then 

		RegWriteW <= RegWriteM;
		MemtoRegW <= MemtoRegM;
		ALU_OutAW <= ALU_OutAM;
		ReadDataW <= ReadDataM;
		WriteAddrRegW <= WriteAddrRegM;

	end if;

end process;

end Behavioral;

