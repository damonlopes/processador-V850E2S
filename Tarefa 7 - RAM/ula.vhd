LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ula IS
	PORT (
		op : IN unsigned (1 DOWNTO 0); -- Porta seletora da operação da ULA
		in_a : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada A da ULA (Banco de registradores)
		in_b : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada B da ULA (MUX)

		cmp_carry : OUT std_logic; -- Flag de carry para a ULA
		cmp_zero : OUT std_logic; -- Flag de zero para a ULA
		out_data : OUT unsigned (15 DOWNTO 0) := "0000000000000000" -- Saída com o resultado da operação da ULA (soma/subtração)
	);
END ENTITY;

ARCHITECTURE a_ula OF ula IS
	SIGNAL in_a_17, in_b_17, soma_17, subtracao_17 : unsigned (16 DOWNTO 0) := "00000000000000000";

BEGIN
	in_a_17 <= '0' & in_a;
	in_b_17 <= '0' & in_b;
	soma_17 <= in_a_17 + in_b_17;
	subtracao_17 <= in_a_17 - in_b_17;

	out_data <= soma_17(15 DOWNTO 0) WHEN op = "00" ELSE -- Saída = soma das portas A e B
		subtracao_17(15 DOWNTO 0) WHEN op = "01" ELSE -- Saída = subtração das portas A e B
		in_b WHEN op = "11" ELSE -- Saída = constante/registrador nas operações de MOV
		"0000000000000000";

	cmp_carry <= soma_17(16) WHEN op = "00" ELSE
		subtracao_17(16) when op = "01" ELSE
		subtracao_17(16) when op = "10" ELSE
		'0';

	cmp_zero <= '1' when soma_17(15 downto 0) = "0000000000000000" and op = "00" else
		'1' when subtracao_17(15 downto 0) = "0000000000000000" and op = "01" else
		'1' when subtracao_17(15 downto 0) = "0000000000000000" and op = "10" else
		'0';


END ARCHITECTURE;