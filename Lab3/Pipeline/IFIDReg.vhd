----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:23:05 11/08/2014 
-- Design Name: 
-- Module Name:    IFIDReg - Behavioral 
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

entity IFIDReg is
    Port ( CLK 				: in  STD_LOGIC;
			  StallIFID			: in  STD_LOGIC;
			  PC_F 				: in  STD_LOGIC_VECTOR (31 downto 0);
           InstrF 			: in  STD_LOGIC_VECTOR (31 downto 0);
           PC_D 				: out  STD_LOGIC_VECTOR (31 downto 0);
           InstrD 			: out  STD_LOGIC_VECTOR (31 downto 0));
end IFIDReg;

architecture Behavioral of IFIDReg is

begin
process(CLK, StallIFID)
begin

if (CLK'event and CLK='1' and StallIFID='0') then
	PC_D <= PC_F;
	InstrD <= InstrF;
end if;

end process;

end Behavioral;

