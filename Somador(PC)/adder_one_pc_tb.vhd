LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adder_one_pc_tb IS
END ENTITY;

ARCHITECTURE a_adder_one_pc_tb OF adder_one_pc_tb IS
	COMPONENT adder_one_pc
		PORT (
			in_adder_one_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada da adder_one_pc

			out_adder_one_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da adder_one_pc
		);
	END COMPONENT;

	SIGNAL in_adder_one_pc, out_adder_one_pc : unsigned(6 DOWNTO 0) := "0000000";

BEGIN
	uut : adder_one_pc PORT MAP(
		in_adder_one_pc => in_adder_one_pc, -- Conectando as portas da adder_one_pc
		out_adder_one_pc => out_adder_one_pc
	);
	-- Início do tb da adder_one_pc
	PROCESS
		-- Rotina de teste
	BEGIN
		in_adder_one_pc <= "0000011"; -- Informação na entrada do adder_one_pc
		WAIT FOR 100 ns;

		in_adder_one_pc <= "0111100"; -- Informação na entrada do adder_one_pc
		WAIT FOR 100 ns;

		WAIT;
	END PROCESS;
END ARCHITECTURE;