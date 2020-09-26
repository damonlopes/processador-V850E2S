library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador_tb is
end;

architecture a_registrador_tb of registrador_tb is
	component registrador
		port(	clk		:in std_logic; -- Porta de clock
				rst		:in std_logic; -- Porta do reset
				wr_en	:in std_logic; -- Porta do enable para escrever no registrador
				data_in	:in unsigned(15 downto 0); -- Informação na entrada do registrador
				
				data_out:out unsigned(15 downto 0) -- Informação na saída do registrador
		);
	end component;
	
	signal clk, rst, wr_en: std_logic;
	signal data_in, data_out: unsigned(15 downto 0);
	
begin
	
	uut: registrador port map(	clk => clk, -- Conectando as portas do registrador
								rst => rst,
								wr_en => wr_en,
								data_in => data_in,
								data_out => data_out
							);
	-- Início do tb do registrador
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
	-- Rotina de teste do registrador
	begin
		wait for 100 ns; -- Espera a inicialização
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		data_in <= "1111111111111111"; -- DATA da entrada = 0xFFFF#
		wait for 100 ns;
		
		data_in <= "1001100110010100"; -- DATA da entrada = 0x9994#
		wr_en <= '1'; -- Enable ativado, escreve na memória
		wait for 100 ns;
		
		data_in <= "0000110001101011"; -- DATA na entrada = 0x0C6B#
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		wait for 100 ns;
		
		wr_en <= '1'; -- Enable ativado, escreve na memória
		wait for 100 ns;
		
		data_in <= "1010101011000011"; -- DATA na entrada = 0xAAC3#
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		wait for 1000 ns;
		
		wr_en <= '1'; -- Enable ativado, escreve na memória
		wait for 100 ns;
		
		data_in <= "1000000000000001"; -- DATA na entrada = 0x8001#
		wr_en <= '0'; -- Enable desativado, não escreve na memória
		wait for 100 ns;
		
		wait;
		
	end process;
end architecture;
	
	