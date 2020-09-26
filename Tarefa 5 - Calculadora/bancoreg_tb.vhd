LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY bancoreg_tb IS
END ENTITY;

ARCHITECTURE a_bancoreg_tb OF bancoreg_tb IS
	COMPONENT bancoreg
		PORT (
			clk : IN std_logic; -- Porta do clock do banco
			rst : IN std_logic; -- Porta do reset do banco
			write_en : IN std_logic; -- Porta do enable para escrever no banco de registradores
			sel_reg0 : IN unsigned(2 DOWNTO 0) := "000"; -- Seletor para leitura do primeiro registrador (conectado a mux)
			sel_reg1 : IN unsigned(2 DOWNTO 0) := "000"; -- Seletor para leitura do segundo registrador (conectado direto na ULA)
			sel_wr_reg : IN unsigned(2 DOWNTO 0) := "000"; -- Seletor para escolher em qual registrador vai gravar a DATA (destino)
			datawr_reg : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- DATA para gravar no registrador

			data_reg0 : OUT unsigned(15 DOWNTO 0) := "0000000000000000"; -- DATA do primeiro registrador
			data_reg1 : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- DATA do segundo registrador
		);
	END COMPONENT;

	SIGNAL clk, rst, write_en : std_logic;
	SIGNAL sel_wr_reg, sel_reg0, sel_reg1 : unsigned(2 DOWNTO 0) := "000";
	SIGNAL datawr_reg, data_reg0, data_reg1 : unsigned(15 DOWNTO 0) := "0000000000000000";

BEGIN

	uut : bancoreg PORT MAP(
		sel_reg0 => sel_reg0, -- Conectando as portas do banco
		sel_reg1 => sel_reg1,
		datawr_reg => datawr_reg,
		sel_wr_reg => sel_wr_reg,
		write_en => write_en,
		clk => clk,
		rst => rst,
		data_reg0 => data_reg0,
		data_reg1 => data_reg1
	);
	-- Início do tb do banco
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
		-- Rotina de teste no banco
	BEGIN
		write_en <= '0'; -- Desativando o enable
		sel_reg0 <= "000"; -- Lendo o registrador 0 na primeira saída
		sel_reg1 <= "010"; -- Lendo o registrador 2 na segunda saída
		sel_wr_reg <= "001"; -- Selecionando o registrador 1 para escrita
		datawr_reg <= "0101010110101010"; -- DATA para escrever no registrador = 0x55AA
		WAIT FOR 100 ns; -- Espera a rotina de inicialização

		write_en <= '1'; -- Ativa o enable, permitindo a escrita no registrador selecionado (registrador 1)
		datawr_reg <= "1010101001010101"; -- DATA para escrever no registrador = 0xAA55
		WAIT FOR 100 ns;

		write_en <= '0'; -- Desativando o enable
		sel_reg1 <= "001"; -- Lendo o registrador 1 na segunda saída
		sel_wr_reg <= "000"; -- Selecionando o registrador 0 para escrita
		datawr_reg <= "1111111111111111"; -- DATA para escrever no registrador = 0xFFFF
		WAIT FOR 100 ns;

		write_en <= '1'; -- Ativa o enable, mas não escreve no registrador selecionado (registrador 0)
		WAIT FOR 100 ns;

		sel_wr_reg <= "100"; -- Selecionando o registrador 4 para escrita
		datawr_reg <= "0000000000000011"; -- DATA para escrever no registrador = 0x0003
		WAIT FOR 100 ns;

		write_en <= '0'; -- Desativando o enable
		sel_reg0 <= "001"; -- Lendo o registrador 1 na primeira saída
		sel_reg1 <= "100"; -- Lendo o registrador 4 na segunda saída
		datawr_reg <= "0000000000000000"; -- DATA para escrever no registrador = 0x0000
		WAIT FOR 100 ns;

		WAIT;
	END PROCESS;

END ARCHITECTURE;