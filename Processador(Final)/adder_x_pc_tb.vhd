LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adder_x_pc_tb IS
END ENTITY;

ARCHITECTURE a_adder_x_pc_tb OF adder_x_pc_tb IS
	COMPONENT adder_x_pc
		PORT (
			in_a_adder_x_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada A da adder_x_pc
            in_b_adder_x_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada B da adder_x_pc

			out_adder_x_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da adder_x_pc
		);
	END COMPONENT;

	SIGNAL in_a_adder_x_pc, in_b_adder_x_pc, out_adder_x_pc : unsigned(6 DOWNTO 0) := "0000000";

BEGIN
	uut : adder_x_pc PORT MAP(
    	in_a_adder_x_pc => in_a_adder_x_pc, -- Conectando as portas da adder_x_pc
		in_b_adder_x_pc => in_b_adder_x_pc,
		out_adder_x_pc => out_adder_x_pc
	);
	-- Início do tb da adder_x_pc
	PROCESS
		-- Rotina de teste
	BEGIN
		in_a_adder_x_pc <= "0000011"; -- Informação na entrada do adder_x_pc
        in_b_adder_x_pc <= "0100010"; -- Informação na entrada do adder_x_pc
		WAIT FOR 100 ns;

		in_a_adder_x_pc <= "0111100"; -- Informação na entrada do adder_x_pc
        in_b_adder_x_pc <= "0000011"; -- Informação na entrada do adder_x_pc
		WAIT FOR 100 ns;

		WAIT;
	END PROCESS;
END ARCHITECTURE;
