LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY bancoreg IS
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
END ENTITY;

ARCHITECTURE a_bancoreg OF bancoreg IS
	COMPONENT registrador IS -- Criando o registrador dentro do banco
		PORT (
			clk : IN std_logic; -- Porta do clock do registrador
			rst : IN std_logic; -- Porta do reset do registrador
			wr_en : IN std_logic; -- Porta do enable para escrever no registrador
			data_in : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- DATA da entrada do registrador

			data_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- DATA da saída do registrador
		);
	END COMPONENT;

	SIGNAL out0, out1, out2, out3, out4, out5, out6, out7 : unsigned(15 DOWNTO 0); -- Saída dos oito registradores do banco
	SIGNAL en_0, en_1, en_2, en_3, en_4, en_5, en_6, en_7 : std_logic; -- Enable dos oito registradores do banco

BEGIN

	reg0 : registrador PORT MAP(clk => clk, rst => rst, wr_en => en_0, data_in => datawr_reg, data_out => out0); -- Linkando cada porta dos registradores com a porta dos bancos
	reg1 : registrador PORT MAP(clk => clk, rst => rst, wr_en => en_1, data_in => datawr_reg, data_out => out1); -- Tirando as portas de seletores de registrador
	reg2 : registrador PORT MAP(clk => clk, rst => rst, wr_en => en_2, data_in => datawr_reg, data_out => out2);
	reg3 : registrador PORT MAP(clk => clk, rst => rst, wr_en => en_3, data_in => datawr_reg, data_out => out3);
	reg4 : registrador PORT MAP(clk => clk, rst => rst, wr_en => en_4, data_in => datawr_reg, data_out => out4);
	reg5 : registrador PORT MAP(clk => clk, rst => rst, wr_en => en_5, data_in => datawr_reg, data_out => out5);
	reg6 : registrador PORT MAP(clk => clk, rst => rst, wr_en => en_6, data_in => datawr_reg, data_out => out6);
	reg7 : registrador PORT MAP(clk => clk, rst => rst, wr_en => en_7, data_in => datawr_reg, data_out => out7);

	data_reg0 <= "0000000000000000" WHEN sel_reg0 = "000" ELSE -- Quando selecionado o registrador para leitura, ele irá mandar a DATA gravada
		out1 WHEN sel_reg0 = "001" ELSE -- nele para a saída do banco. O registrador 0 sempre vai ter o valor 0x0000#, mesmo
		out2 WHEN sel_reg0 = "010" ELSE -- que tenha sido selecionado para escrever a DATA em sua memória.
		out3 WHEN sel_reg0 = "011" ELSE
		out4 WHEN sel_reg0 = "100" ELSE
		out5 WHEN sel_reg0 = "101" ELSE
		out6 WHEN sel_reg0 = "110" ELSE
		out7 WHEN sel_reg0 = "111" ELSE
		"0000000000000000";

	data_reg1 <= "0000000000000000" WHEN sel_reg1 = "000" ELSE
		out1 WHEN sel_reg1 = "001" ELSE
		out2 WHEN sel_reg1 = "010" ELSE
		out3 WHEN sel_reg1 = "011" ELSE
		out4 WHEN sel_reg1 = "100" ELSE
		out5 WHEN sel_reg1 = "101" ELSE
		out6 WHEN sel_reg1 = "110" ELSE
		out7 WHEN sel_reg1 = "111" ELSE
		"0000000000000000";

	en_1 <= '1' WHEN write_en = '1' AND sel_wr_reg = "001" ELSE -- Tirando o registrador 0, se o enable da escrita do banco estiver ativo e o registrador
		'0'; 
	en_2 <= '1' WHEN write_en = '1' AND sel_wr_reg = "010" ELSE -- estiver selecionado, vai ser gravado em sua memória a DATA da entrada
		'0';
	en_3 <= '1' WHEN write_en = '1' AND sel_wr_reg = "011" ELSE
		'0';
	en_4 <= '1' WHEN write_en = '1' AND sel_wr_reg = "100" ELSE
		'0';
	en_5 <= '1' WHEN write_en = '1' AND sel_wr_reg = "101" ELSE
		'0';
	en_6 <= '1' WHEN write_en = '1' AND sel_wr_reg = "110" ELSE
		'0';
	en_7 <= '1' WHEN write_en = '1' AND sel_wr_reg = "111" ELSE
		'0';

END ARCHITECTURE;