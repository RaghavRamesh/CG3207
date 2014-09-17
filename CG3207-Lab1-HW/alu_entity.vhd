library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu_entity is
	Port ( 
		data_alu : in  STD_LOGIC_VECTOR (7 downto 0);
		control_alu : in  STD_LOGIC_VECTOR (1 downto 0);
		op_alu: in STD_LOGIC_VECTOR (1 downto 0);
		result_alu : out  STD_LOGIC_VECTOR (7 downto 0)
	);
end alu_entity;

architecture Behavioral of alu_entity is

begin
result_alu <= data_alu + X"20" when (control_alu = "01" and op_alu = "01") else
				  data_alu - X"20" when (control_alu = "10" and op_alu = "10") else
				  data_alu;
				
end Behavioral;

