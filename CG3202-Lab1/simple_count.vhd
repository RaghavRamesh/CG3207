library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity simple_count is
    Port ( clock : in  STD_LOGIC;
           enable : in  STD_LOGIC;
			  rst: in STD_LOGIC;
			  dir: in STD_LOGIC;
           leds : out  STD_LOGIC_VECTOR (3 downto 0));
end simple_count;

architecture Behavioral of simple_count is

signal count: std_logic_vector (29 downto 0) := (others=>'0');

begin
 
process (clock, rst) 
variable direction: std_logic := '0';

begin	
	if rst = '1' then
		count <= (others => '0');
   elsif clock'event and clock = '1' then
      if enable='0' then	
			if direction = '0' then
				count <= count + 1;
			elsif direction = '1' then
				count <= count - 1;
			end if;
			if dir = '1' then
				direction := not direction;
			end if;
      end if;	
   end if;
end process;
 
leds <= count(29 downto 26);
						
end Behavioral;