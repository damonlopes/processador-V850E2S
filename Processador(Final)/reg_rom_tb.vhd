LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY reg_rom_tb IS
END;

ARCHITECTURE a_reg_rom_tb OF reg_rom_tb IS
	COMPONENT reg_rom
		PORT (
			clk : IN std_logic; -- Porta do clock do REG_ROM
			rst : IN std_logic; -- Porta do reset do REG_ROM
			wr_en_regrom : IN std_logic; -- Porta do enable para escrever no REG_ROM
			data_in_regrom : IN unsigned(16 DOWNTO 0) := "00000000000000000"; -- DATA da entrada do REG_ROM = Próxima instrução

			data_out_regrom : OUT unsigned(16 DOWNTO 0) := "00000000000000000" -- DATA da saída do REG_ROM = Instrução atual
		);
	END COMPONENT;

	SIGNAL clk, rst, wr_en_regrom : std_logic;
	SIGNAL data_in_regrom, data_out_regrom : unsigned(16 DOWNTO 0);

BEGIN

	uut : reg_rom PORT MAP(
		clk => clk, -- Conectando as portas do REG_ROM
		rst => rst,
		wr_en_regrom => wr_en_regrom,
		data_in_regrom => data_in_regrom,
		data_out_regrom => data_out_regrom
	);
	-- Início do tb do REG_ROM
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
		-- Rotina de teste do REG_ROM
	BEGIN
		WAIT FOR 100 ns; -- Espera a inicialização
		wr_en_regrom <= '0'; -- Enable desativado, não escreve na memória
		data_in_regrom <= "11111111111111111"; -- Próxima instrução = 0x1FFFF
		WAIT FOR 100 ns;

		data_in_regrom <= "01001100110010100"; -- Próxima instrução = 0x09994
		wr_en_regrom <= '1'; -- Enable ativado, escreve na memória
		WAIT FOR 100 ns;

		data_in_regrom <= "00000110001101011"; -- Próxima instrução = 0x00C6B
		wr_en_regrom <= '0'; -- Enable desativado, não escreve na memória
		WAIT FOR 100 ns;

		wr_en_regrom <= '1'; -- Enable ativado, escreve na memória
		WAIT FOR 100 ns;

		data_in_regrom <= "01010101011000011"; -- Próxima instrução = 0x0AAC3
		wr_en_regrom <= '0'; -- Enable desativado, não escreve na memória
		WAIT FOR 1000 ns;

		wr_en_regrom <= '1'; -- Enable ativado, escreve na memória
		WAIT FOR 100 ns;

		data_in_regrom <= "01000000000000001"; -- Próxima instrução = 0x08001
		wr_en_regrom <= '0'; -- Enable desativado, não escreve na memória
		WAIT FOR 100 ns;

		WAIT;

	END PROCESS;
END ARCHITECTURE;