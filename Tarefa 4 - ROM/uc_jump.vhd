library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc_jump is
	port(	data_rom:	in 	unsigned(16 downto 0):= "00000000000000000"; -- valor do endereço da ROM
			jump_en:	out std_logic									 -- flag do JUMP
		);
end entity;

architecture a_uc_jump of uc_jump is

	signal opcode: unsigned(3 downto 0):= "0000"; -- Memória da UC, para pegar os quatro bits mais significativos da ROM
	
begin
	
	opcode <= data_rom(16 downto 13); 				-- Puxa os MSB da ROM
	
	jump_en <= 	'1' when opcode = "1111" else		-- Se for 0xF#, o que equivale ao JUMP, ele ativa a flag
				'0';

end architecture;
			