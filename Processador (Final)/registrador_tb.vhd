LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY registrador_tb IS
END;

ARCHITECTURE a_registrador_tb OF registrador_tb IS
	COMPONENT registrador
		PORT (
			clk : IN std_logic; -- Porta do clock do registrador
			rst : IN std_logic; -- Porta do reset do registrador
			wr_en : IN std_logic; -- Porta do enable para escrever no registrador
			data_in : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- DATA da entrada do registrador

			data_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- DATA da saída do registrador
		);
	END COMPONENT;

	SIGNAL clk, rst, wr_en : std_logic;
	SIGNAL data_in, data_out : unsigned(15 DOWNTO 0);

BEGIN

	uut : registrador PORT MAP(
		clk => clk, -- Conectando as portas do registrador
		rst => rst,
		wr_en => wr_en,
		data_in => data_in,
		data_out => data_out
	);
	-- Início do tb do registrador
	PROCESS
		-- Rotina do clock
	BEGIN
		clk <= '0';
		WAIT FOR 50 ns;

		clk <= '1';
		WAIT FOR 50 ns;

	END PROCESS;

	PROCESS
		-- Rotina de inicialização
	BEGIN
		rst <= '1';
		WAIT FOR 100 ns;

		rst <= '0';

		WAIT;
	END PROCESS;

	PROCESS
		-- Rotina de teste do registrador
	BEGIN
		WAIT FOR 100 ns; -- Espera a inicialização
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		data_in <= "1111111111111111"; -- DATA da entrada = 0xFFFF
		WAIT FOR 100 ns;

		data_in <= "1001100110010100"; -- DATA da entrada = 0x9994
		wr_en <= '1'; -- Enable ativado, escreve na memória
		WAIT FOR 100 ns;

		data_in <= "0000110001101011"; -- DATA na entrada = 0x0C6B
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		WAIT FOR 100 ns;

		wr_en <= '1'; -- Enable ativado, escreve na memória
		WAIT FOR 100 ns;

		data_in <= "1010101011000011"; -- DATA na entrada = 0xAAC3
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		WAIT FOR 1000 ns;

		wr_en <= '1'; -- Enable ativado, escreve na memória
		WAIT FOR 100 ns;

		data_in <= "1000000000000001"; -- DATA na entrada = 0x8001
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		WAIT FOR 100 ns;

		WAIT;

	END PROCESS;
END ARCHITECTURE;