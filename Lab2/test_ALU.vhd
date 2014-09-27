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

		-- test DIVU
		Control <= "010010";
		Operand1 <= "10111010111011110100110010101001";
		Operand2 <= "00000000001111111110000000000001";
      wait for Clk_period*32;
		

		-- test DIVU
		--Control <= "010011";
		--Operand1 <= "10111111111111111111111111111110";
		--Operand2 <= "11111111111111111111111111111111";
      --wait for Clk_period*32;
		
		
		-- test DIVU - 1
		--Control <= "010011";
		--Operand1 <= "00000000000000000000000000000101";
		--Operand2 <= "00000000000000000000000000000111";
      --wait for Clk_period*32;
      
		---- test MULT
		--Control <= "010000";
		--Operand1 <= "00000000000000000000000000010110";
		--Operand2 <= "00000000000000000000000000000111";
     -- wait for Clk_period*33;
		
		
		-- test MULT - 1
		--Control <= "010000";
		--Operand1 <= "11111111111111111110000000010110";
		--Operand2 <= "00000000000000000000000000000111";
      --wait for Clk_period*33;
      
		-- test MULTU
		--Control <= "010001";
		--Operand1 <= "11111111111110000000000000010110";
		--Operand2 <= "00000000000000000000000000000111";
      --wait for Clk_period*32;
      
		-- test SRL
		--Control <= "001101";
		--Operand1 <= "11101101010111100000000000111011";
		--Operand2 <= "00000000000000000000000000000111";
      --wait for Clk_period*5;
		
		-- test SLL
		--Control <= "000101";
		--Operand1 <= "00000000000001111111111111110111";
		--Operand2 <= "00000000000000000000000000001111";
      --wait for Clk_period*5;
		
		-- test SRA
		--Control <= "001001";
		--Operand1 <= "11111111111100000000000000010110";
		--Operand2 <= "00000000000000000000000000000111";
      --wait for Clk_period*5;
      
		-- test SRA - 1
		--Control <= "001001";
		--Operand1 <= "00001111111100000000000000010110";
		--Operand2 <= "00000000000000000000000000000111";
      --wait for Clk_period*5;
      
		-- test SLT
		--Control <= "000111";
		--Operand1 <= "11111111111111100000000000010110";
		--Operand2 <= "00000000000000000000000000000111";
      --wait for Clk_period*1;
		
		
		-- test SLT - 1
		--Control <= "000111";
		--Operand1 <= "00000000000000000000000000010110";
		--Operand2 <= "00000000000000000000000000000111";
      --wait for Clk_period*1;
		
		-- test SLTU
		--Control <= "001110";
		--Operand1 <= "00000000000000000000000000010110";
		--Operand2 <= "00000000000000000000000000000111";
      --wait for Clk_period*1;
		
		
		-- test SUB
		--Control <= "000110";
		--Operand1 <= "00000000000000000000000000010110";
		--Operand2 <= "00000000000000000000000000000111";
      --wait for Clk_period*1;
		
		wait;
   end process;

END;

