library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end;

architecture a_pc_tb of pc_tb is
	component pc
		port(	clk		:in std_logic; -- Porta de clock
				rst		:in std_logic; -- Porta do reset
				wr_en	:in std_logic; -- Porta do enable para escrever no pc
				data_in	:in unsigned(6 downto 0); -- Informação na entrada do pc

				data_out:out unsigned(6 downto 0) -- Informação na saída do pc
		);
	end component;

	signal clk, rst, wr_en: std_logic;
	signal data_in, data_out: unsigned(6 downto 0);

begin

	uut: pc port map(	clk => clk, -- Conectando as portas do pc
								rst => rst,
								wr_en => wr_en,
								data_in => data_in,
								data_out => data_out
							);
	-- Início do tb do pc
	process
	-- Rotina do clock
	begin
		clk <= '0';
		wait for 50 ns;

		clk <= '1';
		wait for 50 ns;

	end process;

	process
	-- Rotina de inicialização
	begin
		rst <= '1';
		wait for 100 ns;

		rst <= '0';

		wait;
	end process;

	process
	-- Rotina de teste do pc
	begin
		wait for 100 ns; -- Espera a inicialização
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		data_in <= "1111111"; -- DATA da entrada = 0xFFFF#
		wait for 100 ns;

		data_in <= "0010100"; -- DATA da entrada = 0x9994#
		wr_en <= '1'; -- Enable ativado, escreve na memória
		wait for 100 ns;

		data_in <= "1101011"; -- DATA na entrada = 0x0C6B#
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		wait for 100 ns;

		wr_en <= '1'; -- Enable ativado, escreve na memória
		wait for 100 ns;

		data_in <= "1000011"; -- DATA na entrada = 0xAAC3#
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		wait for 1000 ns;

		wr_en <= '1'; -- Enable ativado, escreve na memória
		wait for 100 ns;

		data_in <= "0000001"; -- DATA na entrada = 0x8001#
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		wait for 100 ns;

		wait;

	end process;
end architecture;

