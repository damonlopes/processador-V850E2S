library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoreg_tb is
end entity;

architecture a_bancoreg_tb of bancoreg_tb is
	component bancoreg
		port(	clk:		in std_logic; -- Porta do clock do banco
				rst: 		in std_logic; -- Porta do reset do banco
				write_en:	in std_logic; -- Porta do enable para escrever no banco de registradores
				sel_reg0:	in unsigned(2 downto 0):= "000"; -- Seletor para leitura do primeiro registrador
				sel_reg1:	in unsigned(2 downto 0):= "000"; -- Seletor para leitura do segundo registrador
				sel_wr_reg:	in unsigned(2 downto 0):= "000"; -- Seletor para escolher em qual registrador vai gravar a DATA
				datawr_reg:	in unsigned(15 downto 0):= "0000000000000000"; -- DATA para gravar no registrador
								
				data_reg0:	out unsigned(15 downto 0):= "0000000000000000"; -- DATA do primeiro registrador
				data_reg1:	out unsigned(15 downto 0):= "0000000000000000" -- DATA do segundo registrador
		);
	end component;
	
	signal datawr_reg, data_reg0, data_reg1: unsigned(15 downto 0):= "0000000000000000";
	signal sel_wr_reg, sel_reg0, sel_reg1: unsigned(2 downto 0):= "000";
	signal write_en, clk, rst: std_logic;
	
begin

	uut: bancoreg 	port map(	sel_reg0 => sel_reg0, -- Conectando as portas do banco
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
	-- Rotina de teste no banco
	begin
		write_en <= '0'; -- Desativando o enable
		sel_reg0 <= "000"; -- Lendo o registrador 0 na primeira saída
		sel_reg1 <= "010"; -- Lendo o registrador 2 na segunda saída
		sel_wr_reg <= "001"; -- Selecionando o registrador 1 para escrita
		datawr_reg <= "0101010110101010"; -- DATA para escrever no registrador = 0x55AA#
		wait for 100 ns; -- Espera a rotina de inicialização
		
		write_en <= '1'; -- Ativa o enable, permitindo a escrita no registrador selecionado (registrador 1)
		datawr_reg <= "1010101001010101"; -- DATA para escrever no registrador = 0xAA55#
		wait for 100 ns;
		
		write_en <= '0'; -- Desativando o enable
		sel_reg1 <= "001"; -- Lendo o registrador 1 na segunda saída
		sel_wr_reg <= "000"; -- Selecionando o registrador 0 para escrita
		datawr_reg <= "1111111111111111"; -- DATA para escrever no registrador = 0xFFFF#
		wait for 100 ns;
		
		write_en <= '1'; -- Ativa o enable, mas não escreve no registrador selecionado (registrador 0)
		wait for 100 ns;
		
		sel_wr_reg <= "100"; -- Selecionando o registrador 4 para escrita
		datawr_reg <= "0000000000000011"; -- DATA para escrever no registrador = 0x0003#
		wait for 100 ns;
		
		write_en <= '0'; -- Desativando o enable
		sel_reg0 <= "001"; -- Lendo o registrador 1 na primeira saída
		sel_reg1 <= "100"; -- Lendo o registrador 4 na segunda saída
		datawr_reg <= "0000000000000000"; -- DATA para escrever no registrador = 0x0000#
		wait for 100 ns;
		
		wait;
	end process;
	
end architecture;
	
