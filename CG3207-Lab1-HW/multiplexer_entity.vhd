library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer_entity is
	Port ( 
		result_m : in  STD_LOGIC_VECTOR (7 downto 0);
		high_m : in STD_LOGIC;
		leds_m : out  STD_LOGIC_VECTOR (3 downto 0)
	);
end multiplexer_entity;

architecture Behavioral of multiplexer_entity is

begin
	with high_m select
		leds_m <= result_m (7 downto 4) when '1',
					 result_m (3 downto 0) when others;
	
end Behavioral;

