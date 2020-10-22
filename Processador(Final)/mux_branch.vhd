LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY mux_branch IS
	PORT (
		flag_branch : IN std_logic; -- Flag de operação BRANCH
        flag_comp : IN std_logic; -- Flag de resultado da comparação feita na ULA
		data0_mux_branch : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 0 da mux_branch (PC + 1)
		data1_mux_branch : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 1 da mux_branch (BRANCH)

		out_mux_branch : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da mux_branch
	);
END ENTITY;

ARCHITECTURE a_mux_branch OF mux_branch IS
BEGIN
	out_mux_branch <= 	data1_mux_branch WHEN (flag_branch = '1' AND flag_comp = '1') ELSE -- Saída = BRANCH
						data0_mux_branch; -- Saída = PC + 1
END ARCHITECTURE;
