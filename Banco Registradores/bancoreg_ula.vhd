library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoreg_ula is
	port(	clk:		in std_logic; -- Porta do clock do top level (banco+ULA+mux)
			rst:		in std_logic; -- Porta do reset do top level
			wr_en:		in std_logic; -- Porta do enable para escrever do top level
			sel_mux:	in std_logic; -- Porta da seleção da mux do top level
			sel_ula:	in std_logic_vector(1 downto 0):= "00"; -- Seletor da operação da ULA no top level
			sel_reg0:	in unsigned(2 downto 0):= "000"; -- Seletor para leitura do primeiro registrador no top level
			sel_reg1:	in unsigned(2 downto 0):= "000"; -- Seletor para leitura do segundo registrador no top level
			sel_wr_reg:	in unsigned(2 downto 0):= "000"; -- Seletor para escrita do registrador no top level
			data_ext:	in unsigned(15 downto 0):= "0000000000000000"; -- DATA constante para escrita no registrador
			
			out_cmp:	out std_logic; -- Saída lógica com o resultado da operação da ULA (Comparação) no top level
			out_ula:	out unsigned(15 downto 0):= "0000000000000000" -- Saída com o resultado da operação da ULA (soma/subtração) no top level
	);
	
end entity;

architecture a_bancoreg_ula of bancoreg_ula is
	component mux is -- Criando a mux dentro top level
		port(	sel_mux:	in std_logic;  -- Porta seletora da mux
				data0_mux:	in unsigned(15 downto 0):= "0000000000000000"; -- Entrada 0 da mux = Saída de leitura de um dos registradores do banco
				data1_mux:	in unsigned(15 downto 0):= "0000000000000000"; -- Entrada 1 da mux = Entrada de uma DATA constante
			
				out_mux:	out unsigned(15 downto 0):= "0000000000000000" -- Saída da mux
		);
	end component;
	
	component ula is -- Criando a ULA dentro do top level
		port(	op: in std_logic_vector (1 downto 0); -- Porta seletora da operação da ULA
				in_a, in_b: in unsigned (15 downto 0) := "0000000000000000"; -- Entradas de DATA A e B da ULA
	
				out_a: out unsigned (15 downto 0) := "0000000000000000"; -- Saída com o resultado da operação da ULA (soma/subtração)
				out_b: out std_logic -- Saída lógica com o resultado da operação da ULA (Comparação)
		);
	end component;
	
	component bancoreg is -- Criando o banco dentro do top level
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

	signal data_a, data_b, data_mux, data_ula: unsigned(15 downto 0):="0000000000000000"; -- data_a: nó que conecta a entrada A da ULA e a saída do primeiro registrador do banco
																						  -- data_b: nó que conecta a saída da mux e a entrada B da ULA															
																						  -- data_mux: nó que conecta a entrada 0 da mux e a saída do segundo registrador do banco
																						  -- data_ula: nó que conecta a saída da soma/subtração da ULA e a DATA que vai gravar no banco
begin
	
	mux_top: mux 	port map(	data0_mux => data_mux,
								data1_mux => data_ext,
								sel_mux => sel_mux,
								out_mux => data_b
					);
	
	ula_top: ula	port map(	in_a => data_a,
								in_b => data_b,
								op => sel_ula,
								out_a => data_ula,
								out_b => out_cmp
					);
	
	bancoreg_top: bancoreg 	port map(	write_en => wr_en,
										clk => clk,
										rst => rst,
										sel_reg0 => sel_reg0,
										sel_reg1 => sel_reg1,
										sel_wr_reg => sel_wr_reg,	
										datawr_reg => data_ula,
										data_reg0 => data_a,
										data_reg1 => data_mux
							);
	out_ula <= data_ula;
	
end architecture;