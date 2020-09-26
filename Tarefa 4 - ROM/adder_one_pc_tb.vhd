library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_one_pc_tb is
end entity;

architecture a_adder_one_pc_tb of adder_one_pc_tb is
	component adder_one_pc
              	port(	in_adder_one_pc:	in unsigned(6 downto 0):= "0000000"; -- Entrada da adder_one_pc

              			out_adder_one_pc:	out unsigned(6 downto 0):= "0000000" -- Saída da adder_one_pc
              	);
	end component;

	signal in_adder_one_pc, out_adder_one_pc: unsigned(6 downto 0):= "0000000";

begin
	uut: adder_one_pc port map(	in_adder_one_pc => in_adder_one_pc,  -- Conectando as portas da adder_one_pc
								out_adder_one_pc => out_adder_one_pc
	);
	-- Início do tb da adder_one_pc
	process
	-- Rotina de teste
	begin
		in_adder_one_pc <= "0000011"; -- Informação na entrada do adder_one_pc
		wait for 100 ns;

		in_adder_one_pc <= "0111100"; -- Informação na entrada do adder_one_pc
		wait for 100 ns;

		wait;
	end process;
end architecture;
