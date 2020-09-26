library ieee;	 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel_pc_rom_tb is
end entity;

architecture a_toplevel_pc_rom_tb of toplevel_pc_rom_tb is
	component toplevel_pc_rom
		port(	clk:		in std_logic;
				rst: 		in std_logic;
				saida_rom:	out unsigned(16 downto 0) := "00000000000000000"
		);
	end component;
	
	signal clk, rst: std_logic;
	signal saida_rom: unsigned(16 downto 0);
	
begin

	uut: toplevel_pc_rom port map(	clk => clk,
									rst => rst,
									saida_rom => saida_rom
								);
								
	process
	
	begin
		
		clk <= '0';
		wait for 50 ns;
		clk <= '1';
		wait for 50 ns;
		
	end process;
	
	process
	
	begin
		
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
		
	end process;
end architecture;