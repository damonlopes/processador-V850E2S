LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adder_x_pc IS
	PORT (
		in_a_adder_x_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada A da adder_x_pc
        in_b_adder_x_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada B da adder_x_pc

		out_adder_x_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da adder_x_pc
	);
END ENTITY;

ARCHITECTURE a_adder_x_pc OF adder_x_pc IS
BEGIN
	out_adder_x_pc <= in_a_adder_x_pc + in_b_adder_x_pc; -- somador de imm7 para o próximo endereço
END ARCHITECTURE;
