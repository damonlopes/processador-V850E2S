LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_ula IS
	PORT (
		sel_mux_ula : IN std_logic; -- Porta seletora da mux
		data0_mux_ula : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 0 da mux = registrador
		data1_mux_ula : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 1 da mux = constante

		out_mux_ula : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- Saída da mux
	);
END ENTITY;

ARCHITECTURE a_mux_ula OF mux_ula IS
BEGIN
	out_mux_ula <= data0_mux_ula WHEN sel_mux_ula = '0' ELSE -- Quando o seletor = 0, Saída = Registrador
		data1_mux_ula WHEN sel_mux_ula = '1' ELSE -- Quando o seletor = 1, Saída = Constante
		"0000000000000000";
END ARCHITECTURE;