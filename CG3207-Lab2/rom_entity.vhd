library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity rom_entity is
	Port( 
		addr_r : in  STD_LOGIC_VECTOR (3 downto 0);
		data_r : out  STD_LOGIC_VECTOR (7 downto 0)
	);
end rom_entity;

architecture Behavioral of rom_entity is
    type rom_type is array (15 downto 0) of std_logic_vector (7 downto 0);                 
    signal ROM : rom_type:= (X"2A", X"3B", X"4C", X"7E", 
									  X"86", X"3A", X"2F", X"AD", 
									  X"61", X"69", X"73", X"78", 
									  X"41", X"45", X"59", X"55");                        

signal value: std_logic_vector (7 downto 0) := X"00";

begin

data_r <= ROM(conv_integer(addr_r));
			 
end Behavioral;