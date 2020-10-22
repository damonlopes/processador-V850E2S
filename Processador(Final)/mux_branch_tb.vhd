LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_branch_tb IS
END ENTITY;

ARCHITECTURE a_mux_branch_tb OF mux_branch_tb IS
	COMPONENT mux_branch
		PORT (
			flag_branch : IN std_logic; -- Flag de operação BRANCH
        	flag_comp : IN std_logic; -- Flag de resultado da comparação feita na ULA
			data0_mux_branch : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 0 da mux_branch (PC + 1)
			data1_mux_branch : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 1 da mux_branch (BRANCH)

			out_mux_branch : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da mux_branch
		);
	END COMPONENT;

	SIGNAL flag_branch, flag_comp : std_logic;
	SIGNAL data0_mux_branch, data1_mux_branch, out_mux_branch : unsigned(6 DOWNTO 0) := "0000000";

BEGIN
	uut : mux_branch PORT MAP(
		data0_mux_branch => data0_mux_branch, -- Conectando as portas da mux_branch
		data1_mux_branch => data1_mux_branch,
		flag_branch => flag_branch,
		flag_comp => flag_comp,
		out_mux_branch => out_mux_branch
	);
	-- Início do tb da mux_branch
	PROCESS
		-- Rotina de teste
	BEGIN
		data0_mux_branch <= "0000011"; -- Informação na porta 0
		data1_mux_branch <= "0111100"; -- Informação na porta 1
		flag_branch <= '1'; -- Operação de branch
        flag_comp <= '1'; -- Condição válida
		WAIT FOR 50 ns;

		flag_branch <= '1'; -- Operação de branch
        flag_comp <= '0'; -- Condição inválida
		WAIT FOR 50 ns;

        flag_branch <= '0'; -- Não é operação de branch
        flag_comp <= '1'; -- Não importa
		WAIT FOR 50 ns;

		flag_branch <= '0'; -- Não é operação de branch
        flag_comp <= '0'; -- Não importa
		WAIT FOR 50 ns;

		WAIT;
	END PROCESS;
END ARCHITECTURE;
