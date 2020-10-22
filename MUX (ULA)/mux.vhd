library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux is
	port(	sel_mux:	in std_logic; -- Porta seletora da mux
			data0_mux:	in unsigned(15 downto 0):= "0000000000000000"; -- Entrada 0 da mux
			data1_mux:	in unsigned(15 downto 0):= "0000000000000000"; -- Entrada 1 da mux
			
			out_mux:	out unsigned(15 downto 0):= "0000000000000000" -- Saída da mux
	);
end entity;

architecture a_mux of mux is
begin
	out_mux <= 	data0_mux when sel_mux = '0' else -- Quando o seletor = 0, Saída = Entrada 0
				data1_mux when sel_mux = '1' else -- Quando o seletor = 1, Saída = Entrada 1
				"0000000000000000";
end architecture;
