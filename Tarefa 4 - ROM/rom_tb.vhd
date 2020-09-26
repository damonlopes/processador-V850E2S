library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end;

architecture a_rom_tb of rom_tb is
	component rom
		port( 	clk:		in std_logic;									 -- clock
				endereco:	in unsigned(6 downto 0) := "0000000";			 -- endereço da ROM
				dado:		out unsigned(16 downto 0) := "00000000000000000" -- valor do endereço da ROM
		);	
	end component;
	
	signal clk: 		std_logic;
	signal endereco: 	unsigned(6 downto 0) := "0000000";
	signal dado:		unsigned(16 downto 0) := "00000000000000000";
	
begin

	uut: rom port map(	clk => clk, 			-- Conectando as portas da ROM
						endereco => endereco,
						dado => dado
					);
	-- Início do tb da ROM
	process
	-- Rotina de clock
	begin
		clk <= '0';
		wait for 50 ns;
		
		clk <= '1';
		wait for 50 ns;
	
	end process;
	-- Rotina de teste
	process
	
	begin
	
		wait for 100 ns;
		
		endereco <= "0000000";
		wait for 100 ns;
		
		endereco <= "0000001";
		wait for 100 ns;
		
		endereco <= "0000010";
		wait for 100 ns;
		
		endereco <= "0000011";
		wait for 100 ns;
		
		endereco <= "0000100";
		wait for 100 ns;
		
		endereco <= "0000101";
		wait for 100 ns;
		
		endereco <= "0000110";
		wait for 100 ns;
		
		endereco <= "0000111";
		wait for 100 ns;
		
		endereco <= "0001000";
		wait for 100 ns;
		
		endereco <= "0000000";
		wait for 100 ns;
		
		endereco <= "0001010";
		wait for 100 ns;
		
				
		wait;
		
	end process;
end architecture;
		