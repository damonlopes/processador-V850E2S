library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_tb is
end entity;

architecture a_mux_tb of mux_tb is
	component mux 
		port(	sel_mux:	in std_logic; -- Porta seletora da mux
				data0_mux:	in unsigned(15 downto 0):= "0000000000000000"; -- Entrada 0 da mux
				data1_mux:	in unsigned(15 downto 0):= "0000000000000000"; -- Entrada 1 da mux
			
				out_mux:	out unsigned(15 downto 0):= "0000000000000000" -- Saída da mux
		);
	end component;
	
	signal sel_mux: std_logic;
	signal data0_mux, data1_mux, out_mux: unsigned(15 downto 0):= "0000000000000000";
		
begin
	uut: mux port map(	data0_mux => data0_mux,  -- Conectando as portas da mux
						data1_mux => data1_mux,
						sel_mux => sel_mux,
						out_mux => out_mux
	);
	-- Início do tb da mux
	process
	-- Rotina de teste
	begin
		data0_mux <= "0110011011000011"; -- Informação na porta 0
		data1_mux <= "1001100100111100"; -- Informação na porta 1
		sel_mux <= '0'; -- Saída = Entrada 0
		wait for 50 ns;
		
		sel_mux <= '1'; -- Saída = Entrada 1
		wait for 50 ns;
		
		wait;
	end process;
end architecture;