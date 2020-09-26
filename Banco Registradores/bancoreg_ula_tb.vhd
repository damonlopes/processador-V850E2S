library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoreg_ula_tb is
end entity;

architecture a_bancoreg_ula_tb of bancoreg_ula_tb is
	component bancoreg_ula
		port(	clk:		in std_logic; -- Porta do clock do top level (banco+ULA+mux)
				rst:		in std_logic; -- Porta do reset do top level
				wr_en:		in std_logic; -- Porta do enable para escrever do top level
				sel_mux:	in std_logic; -- Porta da seleção da mux do top level
				sel_ula:	in std_logic_vector(1 downto 0):= "00"; -- Seletor da operação da ULA no top level
				sel_reg0:	in unsigned(2 downto 0):= "000"; -- Seletor para leitura do primeiro registrador no top level
				sel_reg1:	in unsigned(2 downto 0):= "000"; -- Seletor para leitura do segundo registrador no top level
				sel_wr_reg:	in unsigned(2 downto 0):= "000"; -- Seletor para escrita do registrador no top level
				data_ext:	in unsigned(15 downto 0):= "0000000000000000"; -- DATA para escrita no registrador
				
				out_cmp:	out std_logic; -- Saída lógica com o resultado da operação da ULA (Comparação) no top level
				out_ula:	out unsigned(15 downto 0):= "0000000000000000" -- Saída com o resultado da operação da ULA (soma/subtração) no top level
		);
	end component;
	
	signal clk, rst, wr_en, sel_mux, out_cmp: std_logic;
	signal sel_ula: std_logic_vector(1 downto 0):= "00";
	signal sel_reg0, sel_reg1, sel_wr_reg: unsigned(2 downto 0):= "000";
	signal data_ext, out_ula: unsigned(15 downto 0):= "0000000000000000";
	
begin

	uut: bancoreg_ula 	port map(	clk=>clk, -- Conectando as portas do top level
									rst=>rst,
									wr_en=>wr_en,
									sel_mux=>sel_mux,
									sel_ula=>sel_ula,
									sel_reg0=>sel_reg0,
									sel_reg1=>sel_reg1,
									sel_wr_reg=>sel_wr_reg,
									data_ext=>data_ext,
									out_cmp=>out_cmp,
									out_ula=>out_ula
						);
	-- Início do tb do top level
	process
	-- Rotina de clock do top level
	begin
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
	end process;
	
	process
	-- Rotina de inicialização do top level
	begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;
	
	process
	-- Rotina de teste do top level
	begin
		wr_en <= '0';					-- Após inicializar, ele desativa a escrita no banco, seleciona a entrada 0 da mux
		sel_mux <= '0';					-- seleciona a primeira operação da ULA, para as duas leituras de registrador seleciona o reg0 e
		sel_ula <= "00";				-- indica o reg0 para escrita e deixa a DATA constante para 0x0005# 
		sel_reg0 <= "000";			
		sel_reg1 <= "000";			
		sel_wr_reg <= "000";		
		data_ext <= "0000000000000101";
		wait for 100 ns;
		
		wr_en <= '1';					-- Ativa o enable para escrever no banco de registradores, seleciona a entrada 1 da mux com a DATA externa,
		sel_mux <= '1';					-- mantém a primeira operação da ULA, seleciona o reg0 e o reg2 para leitura de dados e seleciona o reg1 para
		sel_reg0 <= "000";              -- a escrita.
		sel_reg1 <= "010";
		sel_wr_reg <= "001";
		wait for 100 ns;
		
		sel_mux <= '1';					-- Mantém o enable da escrita ativo e a entrada 1 do mux, seleciona o reg2 e o reg1 para leitura de dados, seleciona
		sel_reg0 <= "010";				-- o reg3 para a escrita e altera a DATA externa para 0x0003#
		sel_reg1 <= "001";				
		sel_wr_reg <= "011";
		data_ext <= "0000000000000011";
		wait for 100 ns;
		
		wr_en <= '0';					-- Desativa o enable da escrita, seleciona a entrada 0 da mux com a DATA do banco de registradores,
		sel_mux <= '0';					-- seleciona a terceira operação da ULA, seleciona o reg2 e o reg3 para a leitura de dados, e seleciona o reg0
		sel_ula <= "10";				-- para a escrita.
		sel_reg0 <= "010";
		sel_reg1 <= "011";
		sel_wr_reg <= "000";
		wait for 100 ns;
		
		sel_mux <= '0'; 				-- Mantém selecionado a entrada 0 da mux, seleciona a quarta operação da ULA, seleciona o reg2 e o reg3 para leitura
		sel_ula <= "11";				-- de dados e seleciona o reg0 para a escrita de dados.
		sel_reg0 <= "010";				
		sel_reg1 <= "011";
		sel_wr_reg <= "000";
		wait for 100 ns;
		
		wait;
		
	end process;
	
end architecture;