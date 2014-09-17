LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY comparator_testbench IS
END comparator_testbench;
 
ARCHITECTURE behavior OF comparator_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT comparator_entity
    PORT(
         data_c : IN  std_logic_vector(7 downto 0);
         result_c : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal data_c : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal result_c : std_logic_vector(1 downto 0);
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: comparator_entity PORT MAP (
          data_c => data_c,
          result_c => result_c
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		-- boundary cases
		data_c <= X"4A";
		wait for 100 ns;
		
		data_c <= X"5A";
		wait for 100 ns;
		
		data_c <= X"61";
		wait for 100 ns;
		
		data_c <= X"7A";
		wait for 100 ns;
		
		-- within the ranges
		data_c <= X"52";
		wait for 100 ns;
		
		data_c <= X"67";
      wait for 100 ns;
		
		data_c <= X"5B";
		wait;
		
   end process;

END;
