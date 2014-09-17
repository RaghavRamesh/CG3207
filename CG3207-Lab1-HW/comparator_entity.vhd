library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_entity is
	Port ( 
		data_c : in  STD_LOGIC_VECTOR (7 downto 0);
		result_c : out  STD_LOGIC_VECTOR (1 downto 0)
	);
end comparator_entity;

architecture Behavioral of comparator_entity is

begin
result_c <= "01" when (data_c >= X"41") and (data_c <= X"5A") else
				"10" when (data_c >= X"61") and (data_c <= X"7A") else
				"00";
	
end Behavioral;

