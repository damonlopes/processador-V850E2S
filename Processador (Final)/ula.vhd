LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ula IS
	PORT (
		op : IN unsigned (2 DOWNTO 0) := "000"; -- Porta seletora da operação da ULA
		in_a : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada A da ULA (Banco de registradores)
		in_b : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada B da ULA (MUX)

		cmp_carry : OUT std_logic; -- Flag de carry para a ULA
		cmp_zero : OUT std_logic; -- Flag de zero para a ULA
		cmp_neg : OUT std_logic; -- Flag de negativo para a ULA
		out_data : OUT unsigned (15 DOWNTO 0) := "0000000000000000" -- Saída com o resultado da operação da ULA (soma/subtração)
	);
END ENTITY;

ARCHITECTURE a_ula OF ula IS
	SIGNAL in_a_17, in_b_17, soma_17, subtracao_17: unsigned (16 DOWNTO 0) := "00000000000000000";
    SIGNAL multiplicacao_17 : unsigned (33 downto 0) := "0000000000000000000000000000000000";
BEGIN
	in_a_17 <= '0' & in_a;
	in_b_17 <= '0' & in_b;
	soma_17 <= in_a_17 + in_b_17;
	subtracao_17 <= in_a_17 - in_b_17;
	multiplicacao_17 <= in_a_17 * in_b_17;

	out_data <= soma_17(15 DOWNTO 0) WHEN op = "001" ELSE -- Saída = soma das portas A e B
		subtracao_17(15 DOWNTO 0) WHEN op = "010" ELSE -- Saída = subtração das portas A e B
		multiplicacao_17(15 DOWNTO 0) WHEN op = "011" ELSE -- Saída = multiplicação das portas A e B
		in_b WHEN op = "100" ELSE -- Saída = constante/registrador nas operações de MOV
		soma_17(15 DOWNTO 0) WHEN op = "101" ELSE -- Saída = endereço selecionado na RAM
		"0000000000000000";

	cmp_carry <= soma_17(16) WHEN op = "001" ELSE -- Operação de soma
		subtracao_17(16) WHEN op = "010" ELSE -- Operação de subtração
		multiplicacao_17(16) WHEN op = "011" ELSE -- Operação de multiplicação
		subtracao_17(16) WHEN op = "110" ELSE -- Operação de comparação
		'0';

	cmp_neg <= '1' WHEN soma_17(15 DOWNTO 0) > "0111111111111111" AND op = "001" ELSE -- Operação de soma
		'1' WHEN subtracao_17(15 DOWNTO 0) > "0111111111111111" AND op = "010" ELSE -- Operação de subtração
		'1' WHEN multiplicacao_17(15 DOWNTO 0) > "0111111111111111" AND op = "011" ELSE -- Operação de multiplicação
		'1' WHEN subtracao_17(15 DOWNTO 0) > "0111111111111111" AND op = "110" ELSE -- Operação de comparação
		'0';

	cmp_zero <= '1' WHEN soma_17(15 DOWNTO 0) = "0000000000000000" AND op = "001" ELSE -- Operação de soma
		'1' WHEN subtracao_17(15 DOWNTO 0) = "0000000000000000" AND op = "010" ELSE -- Operação de subtração
		'1' WHEN multiplicacao_17(15 DOWNTO 0) = "0000000000000000" AND op = "011" ELSE -- Operação de multiplicação
		'1' WHEN subtracao_17(15 DOWNTO 0) = "0000000000000000" AND op = "110" ELSE -- Operação de comparação
		'0';

END ARCHITECTURE;-- 000 nada 001 soma 010 sub 011 mul 100 mov 110 cmp 101 ld.w/st.w