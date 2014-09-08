--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:26:45 09/04/2014
-- Design Name:   
-- Module Name:   C:/Users/raghav/Lab1HW/lab1hwv3/statemachine_testbench.vhd
-- Project Name:  lab1hwv3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: statemachine_entity
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
 
ENTITY statemachine_testbench IS
END statemachine_testbench;
 
ARCHITECTURE behavior OF statemachine_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT statemachine_entity
    PORT(
         clk : IN  std_logic;
         reset_sm : IN  std_logic;
         op_sm : IN  std_logic_vector(1 downto 0);
         high_sm : IN  std_logic;
         leds_sm : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset_sm : std_logic := '0';
   signal op_sm : std_logic_vector(1 downto 0) := (others => '0');
   signal high_sm : std_logic := '0';

 	--Outputs
   signal leds_sm : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: statemachine_entity PORT MAP (
          clk => clk,
          reset_sm => reset_sm,
          op_sm => op_sm,
          high_sm => high_sm,
          leds_sm => leds_sm
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      
		wait for 25 ns;	
		high_sm <= '0';
		
		op_sm <= "01";
		
		wait for 100 ns;
		
		high_sm <= '1';
		
		op_sm <= "00";
		high_sm <= '1';
		wait for 100 ns;
		
		op_sm <= "01";
		
		wait for 100 ns;
		
		op_sm <= "10";
		wait for 100 ns;
		
		op_sm <= "11";
		wait for 100 ns;
		
		reset_sm <= '0';

      wait;
   end process;

END;
