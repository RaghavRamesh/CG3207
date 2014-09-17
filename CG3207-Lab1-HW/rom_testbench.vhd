LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY rom_testbench IS
END rom_testbench;
 
ARCHITECTURE behavior OF rom_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT rom_entity
    PORT(
         addr_r : IN  std_logic_vector(3 downto 0);
         data_r : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal addr_r : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal data_r : std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: rom_entity PORT MAP (
          addr_r => addr_r,
          data_r => data_r
        ); 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		addr_r <= "0001";
		
		wait for 100 ns;
		addr_r <= "0010";
	
		wait for 100 ns;
		addr_r <= "0011";
      
		wait for 100 ns;
		addr_r <= "0100";
		
		wait for 100 ns;
		addr_r <= "0101";
		
      wait;
   end process;

END;
