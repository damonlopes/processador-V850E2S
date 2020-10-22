LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_ram_tb IS
END ENTITY;

ARCHITECTURE a_mux_ram_tb OF mux_ram_tb IS
	COMPONENT mux_ram
		PORT (
			sel_mux_ram : IN std_logic; -- Porta seletora da mux
			data0_mux_ram : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 0 da mux = ULA
			data1_mux_ram : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 1 da mux = RAM

			out_mux_ram : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- Saída da mux
		);
	END COMPONENT;

	SIGNAL sel_mux_ram : std_logic;
	SIGNAL data0_mux_ram, data1_mux_ram, out_mux_ram : unsigned(15 DOWNTO 0) := "0000000000000000";

BEGIN
	uut : mux_ram PORT MAP(
		data0_mux_ram => data0_mux_ram, -- Conectando as portas da mux
		data1_mux_ram => data1_mux_ram,
		sel_mux_ram => sel_mux_ram,
		out_mux_ram => out_mux_ram
	);
	-- Início do tb da mux
	PROCESS
		-- Rotina de teste
	BEGIN
		data0_mux_ram <= "0110011011000011"; -- Informação na porta 0
		data1_mux_ram <= "1001100100111100"; -- Informação na porta 1
		sel_mux_ram <= '0'; -- Saída = Entrada 0 (ULA)
		WAIT FOR 50 ns;

		sel_mux_ram <= '1'; -- Saída = Entrada 1 (RAM)
		WAIT FOR 50 ns;

		WAIT;
	END PROCESS;
END ARCHITECTURE;