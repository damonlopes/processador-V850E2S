LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_ula_tb IS
END ENTITY;

ARCHITECTURE a_mux_ula_tb OF mux_ula_tb IS
	COMPONENT mux_ula
		PORT (
			sel_mux_ula : IN std_logic; -- Porta seletora da mux
			data0_mux_ula : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 0 da mux = registrador
			data1_mux_ula : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 1 da mux = constante

			out_mux_ula : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- Saída da mux
		);
	END COMPONENT;

	SIGNAL sel_mux_ula : std_logic;
	SIGNAL data0_mux_ula, data1_mux_ula, out_mux_ula : unsigned(15 DOWNTO 0) := "0000000000000000";

BEGIN
	uut : mux_ula PORT MAP(
		data0_mux_ula => data0_mux_ula, -- Conectando as portas da mux
		data1_mux_ula => data1_mux_ula,
		sel_mux_ula => sel_mux_ula,
		out_mux_ula => out_mux_ula
	);
	-- Início do tb da mux
	PROCESS
		-- Rotina de teste
	BEGIN
		data0_mux_ula <= "0110011011000011"; -- Informação na porta 0
		data1_mux_ula <= "1001100100111100"; -- Informação na porta 1
		sel_mux_ula <= '0'; -- Saída = Entrada 0 (Registrador)
		WAIT FOR 50 ns;

		sel_mux_ula <= '1'; -- Saída = Entrada 1 (Constante)
		WAIT FOR 50 ns;

		WAIT;
	END PROCESS;
END ARCHITECTURE;