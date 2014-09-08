LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY multiplexer_testbench IS
END multiplexer_testbench;
 
ARCHITECTURE behavior OF multiplexer_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT multiplexer_entity
    PORT(
         result_m : IN  std_logic_vector(7 downto 0);
         high_m : IN  std_logic;
         leds_m : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal result_m : std_logic_vector(7 downto 0) := (others => '0');
   signal high_m : std_logic := '0';

 	--Outputs
   signal leds_m : std_logic_vector(3 downto 0);
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: multiplexer_entity PORT MAP (
          result_m => result_m,
          high_m => high_m,
          leds_m => leds_m
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		
		result_m <= X"10";
		high_m <= '0';
		wait for 100 ns;
		
		result_m <= X"10";
		high_m <= '1';
		wait for 100 ns;
		
		result_m <= X"01";
		high_m <= '0';
		wait for 100 ns;
		
		result_m <= X"01";
		high_m <= '1';
		wait for 100 ns;
		
		result_m <= "10100101";
		high_m <= '1';
      wait;
   end process;

END;
