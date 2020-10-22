LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_ram IS
	PORT (
		sel_mux_ram : IN std_logic; -- Porta seletora da mux
		data0_mux_ram : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 0 da mux = ULA
		data1_mux_ram : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 1 da mux = RAM

		out_mux_ram : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- Saída da mux
	);
END ENTITY;

ARCHITECTURE a_mux_ram OF mux_ram IS
BEGIN
	out_mux_ram <= data0_mux_ram WHEN sel_mux_ram = '0' ELSE -- Quando o seletor = 0, Saída = ULA
		data1_mux_ram WHEN sel_mux_ram = '1' ELSE -- Quando o seletor = 1, Saída = RAM
		"0000000000000000";
END ARCHITECTURE;