LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_pc_tb IS
END ENTITY;

ARCHITECTURE a_mux_pc_tb OF mux_pc_tb IS
	COMPONENT mux_pc
		PORT (
			sel_mux_pc : IN std_logic; -- Porta seletora da mux_pc
			data0_mux_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 0 da mux_pc (PC + 1)
			data1_mux_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 1 da mux_pc (JUMP)

			out_mux_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da mux_pc
		);
	END COMPONENT;

	SIGNAL sel_mux_pc : std_logic;
	SIGNAL data0_mux_pc, data1_mux_pc, out_mux_pc : unsigned(6 DOWNTO 0) := "0000000";

BEGIN
	uut : mux_pc PORT MAP(
		data0_mux_pc => data0_mux_pc, -- Conectando as portas da mux_pc
		data1_mux_pc => data1_mux_pc,
		sel_mux_pc => sel_mux_pc,
		out_mux_pc => out_mux_pc
	);
	-- Início do tb da mux_pc
	PROCESS
		-- Rotina de teste
	BEGIN
		data0_mux_pc <= "0000011"; -- Informação na porta 0
		data1_mux_pc <= "0111100"; -- Informação na porta 1
		sel_mux_pc <= '0'; -- Saída = Entrada 0 (PC + 1)
		WAIT FOR 50 ns;

		sel_mux_pc <= '1'; -- Saída = Entrada 1 (JUMP)
		WAIT FOR 50 ns;

		WAIT;
	END PROCESS;
END ARCHITECTURE;