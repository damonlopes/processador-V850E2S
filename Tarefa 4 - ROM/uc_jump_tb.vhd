library ieee;	
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_jump_tb is
end entity;

architecture a_uc_jump_tb of uc_jump_tb is
	component uc_jump
		port(	data_rom:	in 	unsigned(16 downto 0):= "00000000000000000"; -- valor do endereço da ROM
				jump_en:	out std_logic									 -- flag do JUMP
		);
	end component;

	signal jump_en: 	std_logic;
	signal data_rom:	unsigned(16 downto 0):= "00000000000000000";
	
begin

	uut: uc_jump port map( 	jump_en => jump_en, -- Conectando as portas da UC
							data_rom => data_rom
						);
	-- Início do tb da UC(provisória)
	process
	-- Rotina de teste
	begin
				
		data_rom <= "00000000000000000";
		wait for 100 ns;
		
		data_rom <= "00110000000000000";
		wait for 100 ns;
		
		data_rom <= "01000000000000000";
		wait for 100 ns;
		
		data_rom <= "11100000000000000";
		wait for 100 ns;
		
		data_rom <= "11110000000000000";
		wait for 100 ns;
		
		data_rom <= "00110000000000000";
		wait for 100 ns;
		
		wait;

	end process;
end architecture;
	
		