library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bancoreg is
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
end entity;

architecture a_bancoreg of bancoreg is
	component registrador is -- Criando o registrador dentro do banco
		port(	clk		:in std_logic; -- Porta do clock do registrador
				rst		:in std_logic; -- Porta do reset do registrador
				wr_en	:in std_logic; -- Porta do enable para escrever no registrador
				data_in	:in unsigned(15 downto 0):= "0000000000000000"; -- DATA da entrada do registrador
				
				data_out:out unsigned(15 downto 0):= "0000000000000000" -- DATA da saída do registrador
		);
	end component;
	
	signal 	out0, out1, out2, out3, out4, out5, out6, out7: unsigned(15 downto 0); -- Saída dos oito registradores do banco
	signal	en_0, en_1, en_2, en_3, en_4, en_5, en_6, en_7: std_logic; -- Enable dos oito registradores do banco
	
begin
	
	reg0: registrador port map(clk=>clk, rst=>rst, wr_en=>en_0, data_in=>datawr_reg, data_out=>out0); -- Linkando cada porta dos registradores com a porta dos bancos
	reg1: registrador port map(clk=>clk, rst=>rst, wr_en=>en_1, data_in=>datawr_reg, data_out=>out1); -- Tirando as portas de seletores de registrador
	reg2: registrador port map(clk=>clk, rst=>rst, wr_en=>en_2, data_in=>datawr_reg, data_out=>out2); 
	reg3: registrador port map(clk=>clk, rst=>rst, wr_en=>en_3, data_in=>datawr_reg, data_out=>out3);
	reg4: registrador port map(clk=>clk, rst=>rst, wr_en=>en_4, data_in=>datawr_reg, data_out=>out4);
	reg5: registrador port map(clk=>clk, rst=>rst, wr_en=>en_5, data_in=>datawr_reg, data_out=>out5);
	reg6: registrador port map(clk=>clk, rst=>rst, wr_en=>en_6, data_in=>datawr_reg, data_out=>out6);
	reg7: registrador port map(clk=>clk, rst=>rst, wr_en=>en_7, data_in=>datawr_reg, data_out=>out7);
	
	data_reg0 <=	"0000000000000000" when sel_reg0 = "000" else -- Quando selecionado o registrador para leitura, ele irá mandar a DATA gravada
					out1 when sel_reg0 = "001" else				  -- nele para a saída do banco. O registrador 0 sempre vai ter o valor 0x0000#, mesmo
					out2 when sel_reg0 = "010" else				  -- que tenha sido selecionado para escrever a DATA em sua memória.
					out3 when sel_reg0 = "011" else
					out4 when sel_reg0 = "100" else
					out5 when sel_reg0 = "101" else
					out6 when sel_reg0 = "110" else
					out7 when sel_reg0 = "111" else
					"0000000000000000";
					
	data_reg1 <= 	"0000000000000000" when sel_reg1 = "000" else
					out1 when sel_reg1 = "001" else
					out2 when sel_reg1 = "010" else
					out3 when sel_reg1 = "011" else
					out4 when sel_reg1 = "100" else
					out5 when sel_reg1 = "101" else
					out6 when sel_reg1 = "110" else
					out7 when sel_reg1 = "111" else
					"0000000000000000";
	
	en_1 <= '1' when write_en = '1' and sel_wr_reg = "001" else -- Tirando o registrador 0, se o enable da escrita do banco estiver ativo e o registrador
			'0';												-- estiver selecionado, vai ser gravado em sua memória a DATA da entrada
	en_2 <= '1' when write_en = '1' and sel_wr_reg = "010" else
			'0';
	en_3 <= '1' when write_en = '1' and sel_wr_reg = "011" else
			'0';
	en_4 <= '1' when write_en = '1' and sel_wr_reg = "100" else
			'0';
	en_5 <= '1' when write_en = '1' and sel_wr_reg = "101" else
			'0';
	en_6 <= '1' when write_en = '1' and sel_wr_reg = "110" else
			'0';
	en_7 <= '1' when write_en = '1' and sel_wr_reg = "111" else
			'0';
			
end architecture;
	