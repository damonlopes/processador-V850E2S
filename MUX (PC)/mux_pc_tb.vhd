library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_pc_tb is
end entity;

architecture a_mux_pc_tb of mux_pc_tb is
	component mux_pc
		port(	sel_mux_pc:	in std_logic; -- Porta seletora da mux_pc
				data0_mux_pc:	in unsigned(6 downto 0):= "0000000"; -- Entrada 0 da mux_pc
				data1_mux_pc:	in unsigned(6 downto 0):= "0000000"; -- Entrada 1 da mux_pc

				out_mux_pc:	out unsigned(6 downto 0):= "0000000" -- Saída da mux_pc
		);
	end component;

	signal sel_mux_pc: std_logic;
	signal data0_mux_pc, data1_mux_pc, out_mux_pc: unsigned(6 downto 0):= "0000000";

begin
	uut: mux_pc port map(	data0_mux_pc => data0_mux_pc,  -- Conectando as portas da mux_pc
						data1_mux_pc => data1_mux_pc,
						sel_mux_pc => sel_mux_pc,
						out_mux_pc => out_mux_pc
	);
	-- Início do tb da mux_pc
	process
	-- Rotina de teste
	begin
		data0_mux_pc <= "0000011"; -- Informação na porta 0
		data1_mux_pc <= "0111100"; -- Informação na porta 1
		sel_mux_pc <= '0'; -- Saída = Entrada 0
		wait for 50 ns;

		sel_mux_pc <= '1'; -- Saída = Entrada 1
		wait for 50 ns;

		wait;
	end process;
end architecture;
