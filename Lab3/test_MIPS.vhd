--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:41:06 10/26/2014
-- Design Name:   
-- Module Name:   C:/Users/raghav/Lab3/test_MIPS.vhd
-- Project Name:  Lab3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MIPS
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
 
ENTITY test_MIPS IS
END test_MIPS;
 
ARCHITECTURE behavior OF test_MIPS IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MIPS
    PORT(
         Addr_Instr : OUT  std_logic_vector(31 downto 0);
         Instr : IN  std_logic_vector(31 downto 0);
         Addr_Data : OUT  std_logic_vector(31 downto 0);
         Data_In : IN  std_logic_vector(31 downto 0);
         Data_Out : OUT  std_logic_vector(31 downto 0);
         MemRead : OUT  std_logic;
         MemWrite : OUT  std_logic;
         RESET : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Instr : std_logic_vector(31 downto 0) := (others => '0');
   signal Data_In : std_logic_vector(31 downto 0) := (others => '0');
   signal RESET : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal Addr_Instr : std_logic_vector(31 downto 0);
   signal Addr_Data : std_logic_vector(31 downto 0);
   signal Data_Out : std_logic_vector(31 downto 0);
   signal MemRead : std_logic;
   signal MemWrite : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MIPS PORT MAP (
          Addr_Instr => Addr_Instr,
          Instr => Instr,
          Addr_Data => Addr_Data,
          Data_In => Data_In,
          Data_Out => Data_Out,
          MemRead => MemRead,
          MemWrite => MemWrite,
          RESET => RESET,
          CLK => CLK
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
      wait for CLK_period;

      -- insert stimulus here
	
		Instr <= x"01490018";
		wait for CLK_PERIOD * 33;
		
		Instr <= x"00005012";
		
		wait;
   end process;

END;
