----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:02:17 11/08/2014 
-- Design Name: 
-- Module Name:    Exception - Behavioral 
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

entity Exception is
    Port ( ReadData_Cause : out  STD_LOGIC_VECTOR (31 downto 0);
           ReadData_EPC : out  STD_LOGIC_VECTOR (31 downto 0);
           WriteData_Cause : in  STD_LOGIC_VECTOR (31 downto 0);
           WriteData_EPC : in  STD_LOGIC_VECTOR (31 downto 0);
           ExceptionReg_Write : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
end Exception;


architecture arch_Exception of Exception is

	signal   CAUSE :  STD_LOGIC_VECTOR (31 downto 0);
	signal   EPC :  STD_LOGIC_VECTOR (31 downto 0);
begin
process(CLK)
begin
	if (CLK'event and CLK='1') then
		if (ExceptionReg_Write = '1') then
			CAUSE <= WriteData_Cause;
			EPC <= WriteData_EPC;
		end if;
	end if;
end process;

ReadData_Cause <= CAUSE;
ReadData_EPC <= EPC;

end arch_Exception;

