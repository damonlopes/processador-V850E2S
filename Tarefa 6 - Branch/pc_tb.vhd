LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; -- CHECAR COMENTARIOS

ENTITY pc_tb IS
END;

ARCHITECTURE a_pc_tb OF pc_tb IS
	COMPONENT pc
		PORT (
			clk : IN std_logic; -- Porta do clock do PC
			rst : IN std_logic; -- Porta do reset do PC
			wr_en_pc : IN std_logic; -- Porta do enable para escrever no PC
			data_in_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- DATA do próximo endereço do PC

			data_out_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- DATA do endereço atual do PC
		);
	END COMPONENT;

	SIGNAL clk, rst, wr_en_pc : std_logic;
	SIGNAL data_in_pc, data_out_pc : unsigned(6 DOWNTO 0) := "0000000";

BEGIN

	uut : pc PORT MAP(
		clk => clk, -- Conectando as portas do PC
		rst => rst,
		wr_en_pc => wr_en_pc,
		data_in_pc => data_in_pc,
		data_out_pc => data_out_pc
	);
	-- Início do tb do pc
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
		-- Rotina de teste do pc
	BEGIN
		WAIT FOR 100 ns; -- Espera a inicialização
		wr_en_pc <= '0'; -- Enable desativado, não escreve na memória
		data_in_pc <= "1111111"; -- Endereço = 0x7F
		WAIT FOR 100 ns;

		data_in_pc <= "0010100"; -- Endereço = 0x14
		wr_en_pc <= '1'; -- Enable ativado, escreve na memória
		WAIT FOR 100 ns;

		data_in_pc <= "1101011"; -- Endereço = 0x6B
		wr_en_pc <= '0'; -- Enable desativado, não escreve na memória
		WAIT FOR 100 ns;

		wr_en_pc <= '1'; -- Enable ativado, escreve na memória
		WAIT FOR 100 ns;

		data_in_pc <= "1000011"; -- Endereço = 0x43
		wr_en_pc <= '0'; -- Enable desativado, não escreve na memória
		WAIT FOR 1000 ns;

		wr_en_pc <= '1'; -- Enable ativado, escreve na memória
		WAIT FOR 100 ns;

		data_in_pc <= "0000001"; -- Endereço = 0x01
		wr_en_pc <= '0'; -- Enable desativado, não escreve na memória
		WAIT FOR 100 ns;

		WAIT;

	END PROCESS;
END ARCHITECTURE;