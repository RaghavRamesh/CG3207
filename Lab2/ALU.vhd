----------------------------------------------------------------------------------
-- Company: NUS
-- Engineer: Rajesh Panicker
-- 
-- Create Date:   10:39:18 13/09/2014
-- Design Name: 	ALU
-- Target Devices: Nexys 4 (Artix 7 100T)
-- Tool versions: ISE 14.7
-- Description: ALU template for MIPS processor
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------


------------------------------------------------------------------
-- ALU Entity
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
generic (width 	: integer := 32);
Port (Clk			: in	STD_LOGIC;
		Control		: in	STD_LOGIC_VECTOR (5 downto 0);
		Operand1		: in	STD_LOGIC_VECTOR (width-1 downto 0);
		Operand2		: in	STD_LOGIC_VECTOR (width-1 downto 0);
		Result1		: out	STD_LOGIC_VECTOR (width-1 downto 0);
		Result2		: out	STD_LOGIC_VECTOR (width-1 downto 0);
		Status		: out	STD_LOGIC_VECTOR (2 downto 0); -- busy (multicycle only), overflow (add and sub), zero (sub)
		Debug			: out	STD_LOGIC_VECTOR (width-1 downto 0));		
end alu;


------------------------------------------------------------------
-- ALU Architecture
------------------------------------------------------------------

architecture Behavioral of alu is

type states is (COMBINATIONAL, MULTI_CYCLE);
signal state, n_state 	: states := COMBINATIONAL;


----------------------------------------------------------------------------
-- Adder instantiation
----------------------------------------------------------------------------
component adder is
generic (width : integer);
port (A 		: in 	std_logic_vector(width-1 downto 0);
		B 		: in 	std_logic_vector(width-1 downto 0);
		C_in 	: in 	std_logic;
		S 		: out std_logic_vector(width-1 downto 0);
		C_out	: out std_logic);
end component adder;

----------------------------------------------------------------------------
-- Adder instantiation
----------------------------------------------------------------------------
component shifter is
generic (width : integer; shift_width : integer);
port (I 					: in 	std_logic_vector(width-1 downto 0);
		shift_direction: in 	std_logic;
		enabled: in 	std_logic;
		arith: in 	std_logic;
		O			 		: out std_logic_vector(width-1 downto 0));
end component shifter;

----------------------------------------------------------------------------
-- Adder signals
----------------------------------------------------------------------------
signal B 		: std_logic_vector(width-1 downto 0) := (others => '0'); 
signal C_in 	: std_logic := '0';
signal S 		: std_logic_vector(width-1 downto 0) := (others => '0'); 
signal C_out	: std_logic := '0'; --not used


----------------------------------------------------------------------------
-- Shifter signals
----------------------------------------------------------------------------
signal I 		: std_logic_vector(width-1 downto 0) := (others => '0');
signal shift_direction 	: std_logic := '0'; 
signal arith 	: std_logic := '0'; 
signal O16 	: std_logic_vector(width-1 downto 0) := (others => '0'); 
signal e16 	: std_logic := '0';
signal O8 	: std_logic_vector(width-1 downto 0) := (others => '0'); 
signal e8 	: std_logic := '0';
signal O4 	: std_logic_vector(width-1 downto 0) := (others => '0'); 
signal e4 	: std_logic := '0';
signal O2 	: std_logic_vector(width-1 downto 0) := (others => '0'); 
signal e2 	: std_logic := '0';
signal O1	: std_logic_vector(width-1 downto 0) := (others => '0'); 
signal e1 	: std_logic := '0';

----------------------------------------------------------------------------
-- Signals for MULTI_CYCLE_PROCESS
----------------------------------------------------------------------------
signal Result1_multi		: STD_LOGIC_VECTOR (width-1 downto 0) := (others => '0'); 
signal Result2_multi		: STD_LOGIC_VECTOR (width-1 downto 0) := (others => '0');
signal Debug_multi		: STD_LOGIC_VECTOR (width-1 downto 0) := (others => '0'); 
signal done		 			: STD_LOGIC := '0';

begin

-- <port maps>
adder32 : adder generic map (width =>  width) port map (  A=>Operand1, B=>B, C_in=>C_in, S=>S, C_out=>C_out );
shifter16 : shifter generic map (width =>  width, shift_width => 16) port map (  I=> I, shift_direction=>shift_direction, arith=>arith, enabled => e16, O=>O16 );
shifter8 : shifter generic map (width =>  width, shift_width => 8) port map (  I=> I, shift_direction=>shift_direction, arith=>arith, enabled => e8, O=>O8 );
shifter4 : shifter generic map (width =>  width, shift_width => 4) port map (  I=> I, shift_direction=>shift_direction, arith=>arith, enabled => e4, O=>O4 );
shifter2 : shifter generic map (width =>  width, shift_width => 2) port map (  I=> I, shift_direction=>shift_direction, arith=>arith, enabled => e2, O=>O2 );
shifter1 : shifter generic map (width =>  width, shift_width => 1) port map (  I=>I, shift_direction=>shift_direction, arith=>arith, enabled => e1, O=>O1 );
-- </port maps>


----------------------------------------------------------------------------
-- COMBINATIONAL PROCESS
----------------------------------------------------------------------------
COMBINATIONAL_PROCESS : process (
											Control, Operand1, Operand2, state, -- external inputs
											S, -- ouput from the adder (or other components)
											Result1_multi, Result2_multi, Debug_multi, done -- from multi-cycle process(es)
											)
begin

-- <default outputs>
Status(2 downto 0) <= "000"; -- both statuses '0' by default 
Result1 <= (others=>'0');
Result2 <= (others=>'0');
Debug <= (others=>'0');

n_state <= state;

B <= Operand2;
C_in <= '0';
-- </default outputs>

--reset
if Control(5) = '1' then
	n_state <= COMBINATIONAL;
else

case state is
	when COMBINATIONAL =>
		case Control(4 downto 0) is
		--and
		when "00000" => 
			Result1 <= Operand1 and Operand2;
		--or
		when "00001" =>
			Result1 <= Operand1 or Operand2;
		--nor
		when "01100" => 
			Result1 <= Operand1 nor Operand2;
		--add
		when "00010" =>
			Result1 <= S;
			-- overflow
			Status(1) <= ( Operand1(width-1) xnor  Operand2(width-1) )  and ( Operand2(width-1) xor S(width-1) );
		-- sub
		when "00110" =>
			B <= not(Operand2);
			C_in <= '1';
			Result1 <= S;
			-- overflow
			-- Status(1) <= <for you to implement>
			--zero
			if S = x"00000000" then 
				Status(0) <= '1'; 
			else
				Status(0) <= '0';
			end if;
		-- multi-cycle operations
		when "10000" | "11110" | "01101" |"00101" | "01001" => 
			n_state <= MULTI_CYCLE;
			Status(2) <= '1';
		-- default cases (already covered)
		when others=> null;
		end case;
	when MULTI_CYCLE => 
		if done = '1' then
			Result1 <= Result1_multi;
			Result2 <= Result2_multi;
			Debug <= Debug_multi;
			n_state <= COMBINATIONAL;
			Status(2) <= '0';
		else
			Status(2) <= '1';
			n_state <= MULTI_CYCLE;
		end if;
	end case;
end if;	
end process;


----------------------------------------------------------------------------
-- STATE UPDATE PROCESS
----------------------------------------------------------------------------

STATE_UPDATE_PROCESS : process (Clk) -- state updating
begin  
   if (Clk'event and Clk = '1') then
		state <= n_state;
   end if;
end process;

----------------------------------------------------------------------------
-- MULTI CYCLE PROCESS
----------------------------------------------------------------------------

MULTI_CYCLE_PROCESS : process (Clk) -- multi-cycle operations done here
-- assume that Operand1 and Operand 2 do not change while multi-cycle operations are being performed
variable count : std_logic_vector(7 downto 0) := (others => '0');
variable temp_sum : std_logic_vector(2*width-1 downto 0) := (others => '0');
variable temp_shift : std_logic_vector(width-1 downto 0) := (others => '0');
begin  
   if (Clk'event and Clk = '1') then 
	done <= '0';
		if n_state = MULTI_CYCLE then
			case Control(4 downto 0) is
			when "10000" =>  -- takes 17 cycles to execute, returns Operand1<<16
				if state = COMBINATIONAL then  -- n_state = MULTI_CYCLE and state = COMBINATIONAL implies we are just transitioning into MULTI_CYCLE
					temp_sum := (others => '0');
					count := (others => '0');					
				end if;		
				count := count+1;	
				temp_sum := temp_sum + Operand1;
				if count=x"10" then	
					Result1_multi <= temp_sum(width-1 downto 0);
					Result2_multi <= temp_sum(2*width-1 downto width);
					Debug_multi <= Operand1(width/2-1 downto 0) & Operand2(width/2-1 downto 0); -- just a random output
					done <= '1';	
				end if;
			when "11110" => -- takes 2 cycles to execute, just returns the operands
				if state = COMBINATIONAL then
					Result1_multi <= Operand1;
					Result2_multi <= Operand2;
					Debug_multi <= Operand1(width-1 downto width/2) & Operand2(width-1 downto width/2);
					done <= '1';
				end if;	
			when "00101" =>  -- takes 5 cycles to execute, Operand1 << Operand22
				if state = COMBINATIONAL then  -- n_state = MULTI_CYCLE and state = COMBINATIONAL implies we are just transitioning into MULTI_CYCLE
					count := (others => '0');	
					temp_shift := Operand1;
				end if;		
				Debug <= temp_shift;
				shift_direction <= '0';
				arith <= '0';
				e1 <= '0';
				e2 <= '0';
				e4 <= '0';
				e8 <= '0';
				e16 <= '0';
				I <= temp_shift;
				if count = "000" then
					e1 <= Operand2(conv_integer(count));
				elsif count = "001" then
					temp_shift := O1;
					e2 <= Operand2(conv_integer(count));
				elsif count = "010" then
					temp_shift := O2;
					e4 <= Operand2(conv_integer(count));
				elsif count = "011" then
					temp_shift := O4;
					e8 <= Operand2(conv_integer(count));
				elsif count = "100" then
					temp_shift := O8;
					e16 <= Operand2(conv_integer(count));
				elsif count = "101" then
					temp_shift := O16;
					done <= '1';
					Result1_multi <= temp_shift;
				end if;
				count := count + 1;
			when "01101" =>  -- takes 5 cycles to execute, Operand1 >> Operand22
				if state = COMBINATIONAL then  -- n_state = MULTI_CYCLE and state = COMBINATIONAL implies we are just transitioning into MULTI_CYCLE
					count := (others => '0');	
					temp_shift := Operand1;
				end if;		
				Debug <= temp_shift;
				shift_direction <= '1';
				arith <= '0';
				e1 <= '0';
				e2 <= '0';
				e4 <= '0';
				e8 <= '0';
				e16 <= '0';
				I <= temp_shift;
				if count = "000" then
					e1 <= Operand2(conv_integer(count));
				elsif count = "001" then
					temp_shift := O1;
					e2 <= Operand2(conv_integer(count));
				elsif count = "010" then
					temp_shift := O2;
					e4 <= Operand2(conv_integer(count));
				elsif count = "011" then
					temp_shift := O4;
					e8 <= Operand2(conv_integer(count));
				elsif count = "100" then
					temp_shift := O8;
					e16 <= Operand2(conv_integer(count));
				elsif count = "101" then
					temp_shift := O16;
					done <= '1';
					Result1_multi <= temp_shift;
				end if;
				count := count + 1;
			when "01001" =>  -- takes 5 cycles to execute, Operand1 >> Operand2 (arithmatic shift)
				if state = COMBINATIONAL then  -- n_state = MULTI_CYCLE and state = COMBINATIONAL implies we are just transitioning into MULTI_CYCLE
					count := (others => '0');	
					temp_shift := Operand1;
				end if;		
				Debug <= temp_shift;
				arith <= '1';
				e1 <= '0';
				e2 <= '0';
				e4 <= '0';
				e8 <= '0';
				e16 <= '0';
				I <= temp_shift;
				if count = "000" then
					e1 <= Operand2(conv_integer(count));
				elsif count = "001" then
					temp_shift := O1;
					e2 <= Operand2(conv_integer(count));
				elsif count = "010" then
					temp_shift := O2;
					e4 <= Operand2(conv_integer(count));
				elsif count = "011" then
					temp_shift := O4;
					e8 <= Operand2(conv_integer(count));
				elsif count = "100" then
					temp_shift := O8;
					e16 <= Operand2(conv_integer(count));
				elsif count = "101" then
					temp_shift := O16;
					done <= '1';
					Result1_multi <= temp_shift;
				end if;
				count := count + 1;
			when others=> null;
			end case;
		end if;
	end if;
end process;


end Behavioral;

------------------------------------------------------------------
-- Adder Entity
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder is
generic (width : integer := 32);
port (A 		: in std_logic_vector(width-1 downto 0);
		B 		: in std_logic_vector(width-1 downto 0);
		C_in 	: in std_logic;
		S 		: out std_logic_vector(width-1 downto 0);
		C_out	: out std_logic);
end adder;

------------------------------------------------------------------
-- Adder Architecture
------------------------------------------------------------------

architecture adder_arch of adder is
signal S_wider : std_logic_vector(width downto 0);
begin
	S_wider <= ('0'& A) + ('0'& B) + C_in;
	S <= S_wider(width-1 downto 0);
	C_out <= S_wider(width);
end adder_arch;


------------------------------------------------------------------
-- Shifter Entity
------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity shifter is
generic (width : integer :=32; shift_width : integer := 1);
port (I				: in std_logic_vector(width-1 downto 0);
		shift_direction: in std_logic;
		arith: in std_logic;
		enabled: in std_logic;
		O 			: out std_logic_vector(width-1 downto 0));
end shifter;


------------------------------------------------------------------
-- Shifter Architecture
------------------------------------------------------------------

architecture shifter_arch of shifter is
signal zero_sig : std_logic_vector(shift_width - 1 downto 0) := (others => '0');
signal one_sig : std_logic_vector(shift_width - 1 downto 0) := (others => '1');
begin
		O <= zero_sig & I(width - 1 downto shift_width) when (shift_direction = '1' and enabled = '1' and arith = '0')
									or (enabled = '1' and arith = '1' and I(width - 1) = '0')
		else
		     one_sig & I(width - 1 downto shift_width) when (enabled = '1' and arith = '1' and I(width - 1) = '1')
		else
		     I(width - 1 - shift_width downto 0) & zero_sig when shift_direction = '0' and enabled = '1'
		else
		     I;
end shifter_arch;
