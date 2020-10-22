LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_pc IS
	PORT (
		sel_mux_pc : IN std_logic; -- Porta seletora da mux_pc
		data0_mux_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 0 da mux_pc (PC + 1)
		data1_mux_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 1 da mux_pc (JUMP)

		out_mux_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da mux_pc
	);
END ENTITY;

ARCHITECTURE a_mux_pc OF mux_pc IS
BEGIN
	out_mux_pc <= data0_mux_pc WHEN sel_mux_pc = '0' ELSE -- Quando o seletor = 0, Saída = PC + 1
		data1_mux_pc WHEN sel_mux_pc = '1' ELSE -- Quando o seletor = 1, Saída = JUMP
		"0000000";
END ARCHITECTURE;