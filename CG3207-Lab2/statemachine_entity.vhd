library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity statemachine_entity is
	Port (
		clk : in STD_LOGIC;
		reset_sm : in  STD_LOGIC;
		op_sm : in  STD_LOGIC_VECTOR (1 downto 0);
		high_sm: in STD_LOGIC;
		leds_sm: out STD_LOGIC_VECTOR (3 downto 0)
	);
end statemachine_entity;

architecture Behavioral of statemachine_entity is

component rom_entity is
	Port( 
		addr_r : in  STD_LOGIC_VECTOR (3 downto 0);
		data_r : out  STD_LOGIC_VECTOR (7 downto 0)
	);
end component;

component comparator_entity is
	Port ( 
		data_c : in  STD_LOGIC_VECTOR (7 downto 0);
		result_c : out  STD_LOGIC_VECTOR (1 downto 0)
	);
end component;

component alu_entity is
	Port ( 
		data_alu : in  STD_LOGIC_VECTOR (7 downto 0);
		control_alu : in  STD_LOGIC_VECTOR (1 downto 0);
		op_alu : in STD_LOGIC_VECTOR (1 downto 0);
		result_alu : out  STD_LOGIC_VECTOR (7 downto 0)
	);
end component;

component multiplexer_entity is
	Port ( 
		result_m : in  STD_LOGIC_VECTOR (7 downto 0);
		high_m : in STD_LOGIC;
		leds_m : out  STD_LOGIC_VECTOR (3 downto 0)
	);
end component;

signal sm_rom : std_logic_vector (3 downto 0);
signal sm_alu : std_logic_vector (1 downto 0);
signal comp_sm : std_logic_vector (1 downto 0);
signal rom_alu : std_logic_vector (7 downto 0);
signal rom_comp : std_logic_vector (7 downto 0);
signal alu_multi : std_logic_vector (7 downto 0);

signal count_copy : std_logic_vector (3 downto 0);

signal debounce_counter : std_logic_vector (23 downto 0) := (others => '1');
begin 

R: rom_entity port map (count_copy, rom_comp);
C: comparator_entity port map (rom_comp, comp_sm);
A: alu_entity port map (rom_comp, comp_sm, sm_alu, alu_multi);
M: multiplexer_entity port map (alu_multi, high_sm, leds_sm);


process (clk, reset_sm, op_sm)
variable counter : std_logic_vector (3 downto 0) := "0000";
variable prev_op : std_logic_vector (1 downto 0) := "00";
variable curr_op : std_logic_vector (1 downto 0) := "00";

begin
	--op_copy <= op_sm
	if reset_sm = '1' then
		count_copy <= "0000";
		counter := "0000";
		sm_alu <= "00";
	elsif clk'event and clk = '1' then
		if op_sm /= prev_op then
			if debounce_counter = "111111111111111111111111" then
				curr_op := op_sm;
				debounce_counter <= debounce_counter - 1; 
			elsif debounce_counter = "000000000000000000000000" then
				debounce_counter <= debounce_counter - 1;
				if curr_op = op_sm then
					if op_sm = "01" then
						counter := counter + 1;
						sm_alu <= "01";
					elsif op_sm = "10" then
						counter := counter + 1;
						sm_alu <= "10";	
					elsif op_sm = "00" or op_sm = "11" then
						counter := counter;
					end if;					
				end if;
				prev_op := op_sm;
				debounce_counter <= (others => '1');	
			else
				debounce_counter <= debounce_counter - 1;
			end if;	
		end if;
	end if;
	count_copy <= counter;
end process;

end Behavioral;

