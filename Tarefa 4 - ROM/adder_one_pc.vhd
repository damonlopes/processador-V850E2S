library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_one_pc is
	port(	in_adder_one_pc:	in unsigned(6 downto 0):= "0000000"; -- Entrada da adder_one_pc

			out_adder_one_pc:	out unsigned(6 downto 0):= "0000000" -- Saída da adder_one_pc
	);
end entity;

architecture a_adder_one_pc of adder_one_pc is
begin
	out_adder_one_pc <= in_adder_one_pc + 1;
end architecture;

