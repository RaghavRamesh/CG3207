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
 
process (clock) 
variable currDirection : std_logic := '0';
variable prevDir : std_logic := '1';

begin	
	if clock'event and clock = '1' then	
		if enable='0' then
			-- decide counting direction
			if currDirection = '0' then
				count <= count + 1;
			elsif currDirection = '1' then
				count <= count - 1;
			end if;
			
			-- reset to '00..00' if counting up and '11..11' if counting down
			if rst = '1' then
				if currDirection = '0' then
					count <= (others => '0');
				elsif currDirection = '1' then
					count <= (others => '1');
				end if;
			end if;
			
			-- change direction if the previous value of the dir pin was the opposite 
			if dir = '1' and prevDir = not dir then
				currDirection := not currDirection;
			end if;
			
			-- store the current value of the dir pin
			prevDir := dir;
      end if;	
   end if;
end process;
 
leds <= count(29 downto 26);
						
end Behavioral;
