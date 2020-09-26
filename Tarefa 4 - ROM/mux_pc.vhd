library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_pc is
	port(	sel_mux_pc:	in std_logic; -- Porta seletora da mux_pc
			data0_mux_pc:	in unsigned(6 downto 0):= "0000000"; -- Entrada 0 da mux_pc
			data1_mux_pc:	in unsigned(6 downto 0):= "0000000"; -- Entrada 1 da mux_pc

			out_mux_pc:	out unsigned(6 downto 0):= "0000000" -- Saída da mux_pc
	);
end entity;

architecture a_mux_pc of mux_pc is
begin
	out_mux_pc <= 	data0_mux_pc when sel_mux_pc = '0' else -- Quando o seletor = 0, Saída = Entrada 0
				data1_mux_pc when sel_mux_pc = '1' else -- Quando o seletor = 1, Saída = Entrada 1
				"0000000";
end architecture;
