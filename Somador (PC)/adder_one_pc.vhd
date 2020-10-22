LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adder_one_pc IS
	PORT (
		in_adder_one_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada da adder_one_pc

		out_adder_one_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da adder_one_pc
	);
END ENTITY;

ARCHITECTURE a_adder_one_pc OF adder_one_pc IS
BEGIN
	out_adder_one_pc <= in_adder_one_pc + 1; -- somador de +1 para o próximo endereço
END ARCHITECTURE;