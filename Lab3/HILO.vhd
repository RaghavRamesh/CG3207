----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   21:06:18 14/10/2014
-- Design Name: 	RegFile
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: Register File for the MIPS processor
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

entity HILO is
    Port ( 	ReadData_High 	: out STD_LOGIC_VECTOR (31 downto 0);
				ReadData_Lo 	: out STD_LOGIC_VECTOR (31 downto 0);				
				WriteData_High	: in  STD_LOGIC_VECTOR (31 downto 0); 
				WriteData_Lo 	: in STD_LOGIC_VECTOR (31 downto 0);
				HILOWrite 		: in STD_LOGIC; 
				CLK 				: in  STD_LOGIC);
end HILO;


architecture arch_HILO of HILO is

	signal   LO :  STD_LOGIC_VECTOR (31 downto 0);
	signal   HI :  STD_LOGIC_VECTOR (31 downto 0);
begin
process(CLK)
begin
	if (CLK'event and CLK='1') then
		if (HILOWrite = '1') then
			HI <= WriteData_High;
			LO <= WriteData_Lo;
		end if;
	end if;
end process;

ReadData_High <= HI;
ReadData_Lo <= LO;

end arch_HILO;


