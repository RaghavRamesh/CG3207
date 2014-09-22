--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:29:44 09/21/2014
-- Design Name:   
-- Module Name:   C:/Users/Akshay Viswanathan/VHDL/Lab2/test_ALU.vhd
-- Project Name:  Lab2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu
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
 
ENTITY test_ALU IS
END test_ALU;
 
ARCHITECTURE behavior OF test_ALU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu
    PORT(
         Clk : IN  std_logic;
         Control : IN  std_logic_vector(5 downto 0);
         Operand1 : IN  std_logic_vector(31 downto 0);
         Operand2 : IN  std_logic_vector(31 downto 0);
         Result1 : OUT  std_logic_vector(31 downto 0);
         Result2 : OUT  std_logic_vector(31 downto 0);
         Status : OUT  std_logic_vector(2 downto 0);
         Debug : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal Clk : std_logic := '0';
   signal Control : std_logic_vector(5 downto 0) := (others => '0');
   signal Operand1 : std_logic_vector(31 downto 0) := (others => '0');
   signal Operand2 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Result1 : std_logic_vector(31 downto 0);
   signal Result2 : std_logic_vector(31 downto 0);
   signal Status : std_logic_vector(2 downto 0);
   signal Debug : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant Clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu PORT MAP (
          Clk => Clk,
          Control => Control,
          Operand1 => Operand1,
          Operand2 => Operand2,
          Result1 => Result1,
          Result2 => Result2,
          Status => Status,
          Debug => Debug 
        );

   -- Clock process definitions
   Clk_process :process
   begin
		Clk <= '0';
		wait for Clk_period/2;
		Clk <= '1';
		wait for Clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here 
		Control <= "000101";
		Operand1 <= "11111010101111100000011111101011";
		Operand2 <= "00000000000000000000000000010100";
		
      wait for Clk_period*9;
		Control <= "001101";
		Operand1 <= "11111010101111100000011111101011";
		Operand2 <= "00000000000000000000000000010100";
      
		wait for Clk_period*9;
		Control <= "001001";
		Operand1 <= "11111010101111100000011111101011";
		Operand2 <= "00000000000000000000000000010100";
      
		wait for Clk_period*9;
      Control <= "001001";
		Operand1 <= "01111010101111100000011111101011";
		Operand2 <= "00000000000000000000000000010100";
      
		wait for Clk_period*9;
		
		Control <= "001110";
		Operand1 <= "11111010101111100000011111101011";
		Operand2 <= "00000000000000000000000000010100";
		wait for Clk_period*2;
		
		Control <= "000111";
		Operand1 <= "00000000000000000000000000000101";
		Operand2 <= "00000000000000000000000000000010";
		wait for Clk_period*2;
		
		Control <= "000111";
		Operand1 <= "00000000000000000000000000000010";
		Operand2 <= "00000000000000000000000000000101";
		wait for Clk_period*2;
		
		Control <= "000111";
		Operand1 <= "11111111111111111111111111111101";
		Operand2 <= "00000000000000000000000000000100";
		wait for Clk_period*2;
		
		Control <= "000111";
		Operand1 <= "00000000000000000000000000000100";
		Operand2 <= "11111111111111111111111111111101";
		wait for Clk_period*2;
		
		Control <= "000111";
		Operand1 <= "11111111111111111111111111111101";
		Operand2 <= "11111111111111111111111111111011";
		wait for Clk_period*2;
		
		Control <= "000111";
		Operand1 <= "11111111111111111111111111111011";
		Operand2 <= "11111111111111111111111111111101";
		wait;
   end process;

END;

