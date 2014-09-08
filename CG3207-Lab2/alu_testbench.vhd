LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY alu_testbench IS
END alu_testbench;
 
ARCHITECTURE behavior OF alu_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu_entity
    PORT(
         data_alu : IN  std_logic_vector(7 downto 0);
         control_alu : IN  std_logic_vector(1 downto 0);
         result_alu : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal data_alu : std_logic_vector(7 downto 0) := (others => '0');
   signal control_alu : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal result_alu : std_logic_vector(7 downto 0);
   
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu_entity PORT MAP (
          data_alu => data_alu,
          control_alu => control_alu,
          result_alu => result_alu
        );

  
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      -- wait for 100 ns;	

      -- insert stimulus here 
		
		-- boundary cases
		data_alu <= X"4A";
		control_alu <= "01";
		wait for 100 ns;
		
		data_alu <= X"5A";
		control_alu <= "01";
		wait for 100 ns;
		
		data_alu <= X"61";
		control_alu <= "10";
		wait for 100 ns;
		
		data_alu <= X"7A";
		control_alu <= "10";
		wait for 100 ns;
		
		-- within the ranges
		data_alu <= X"52";
		control_alu <= "10";
		wait for 100 ns;
		
		data_alu <= X"67";
		control_alu <= "01";
      wait for 100 ns;
		
		data_alu <= X"5B";
		control_alu <= "00";
	
      wait;
   end process;

END;
