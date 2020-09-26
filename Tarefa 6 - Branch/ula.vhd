LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ula IS
	PORT (
		op : IN unsigned (1 DOWNTO 0); -- Porta seletora da operação da ULA
		in_a : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada A da ULA (Banco de registradores)
		in_b : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada B da ULA (MUX)

		out_data : OUT unsigned (15 DOWNTO 0) := "0000000000000000"; -- Saída com o resultado da operação da ULA (soma/subtração)
		out_cmp : OUT std_logic -- Saída lógica com o resultado da operação da ULA (Comparação)
	);
END ENTITY;

ARCHITECTURE a_ula OF ula IS
BEGIN
	--Se for alguma das operações soma/subtração
	out_data <= in_a + in_b WHEN op = "00" ELSE -- Saída = soma das portas A e B
		in_a - in_b WHEN op = "01" ELSE -- Saída = subtração das portas A e B
		"0000000000000000";
	-- Se for alguma das comparações
	out_cmp <= '1' WHEN in_a < in_b AND op = "10" ELSE -- Saída = 1 se B > A
		'1' WHEN in_a = in_b AND op = "11" ELSE -- Saída = 1 se A = B
		'0';
END ARCHITECTURE;
