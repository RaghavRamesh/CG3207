--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:07:48 09/19/2014
-- Design Name:   
-- Module Name:   C:/Users/Akshay Viswanathan/VHDL/Lab2/test_shifter.vhd
-- Project Name:  Lab2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shifter
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_shifter IS
END test_shifter;
 
ARCHITECTURE behavior OF test_shifter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT shifter
    PORT(
         I : IN  std_logic_vector(31 downto 0);
         shift_direction : IN  std_logic;
			enabled : IN std_logic;
         O : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I : std_logic_vector(31 downto 0) := (others => '0');
   signal shift_direction : std_logic := '0';
   signal enabled : std_logic := '0';

 	--Outputs
   signal O : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
--   constant <clock>_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shifter PORT MAP (
          I => I,
          shift_direction => shift_direction,
			 enabled => enabled,
          O => O
        );

   -- Clock process definitions
   --<clock>_process :process
   --begin
	--	<clock> <= '0';
	--	wait for <clock>_period/2;
	--	<clock> <= '1';
	--	wait for <clock>_period/2;
   --end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.

     -- wait for <clock>_period*10;

      -- insert stimulus here 
      wait for 100 ns;	
		I <= "11111111111111111111111111111111";
		shift_direction <= '1';
		enabled <= '1';
		
		wait for 100 ns;
		I <= "11111111111111111111111111110000";
		shift_direction <= '1';
		enabled <= '1';
		
		
      wait for 100 ns;	
		I <= "11111111111111111111111111111111";
		shift_direction <= '0';
		enabled <= '1';
		
		wait for 100 ns;
		I <= "11111111111111111111111111110000";
		shift_direction <= '0';
		enabled <= '1';
      wait;
   end process;

END;

