library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
	port( 	clk:		in std_logic;                              -- clock
			endereco:	in unsigned(6 downto 0) := "0000000";      -- endereço da ROM
			dado:		out unsigned(16 downto 0) := "00000000000000000" -- valor do endereço na ROM
		);
end entity;

architecture a_rom of rom is
	type mem is array (0 to 127) of unsigned (16 downto 0);    	-- De acordo com qual endereço estiver, ele vai mandar um valor
	constant conteudo_rom:	mem:=	(						   	-- para a saída da ROM, que vai para a UC e para os outros lugares do processador
		0  => "00000000000000000", -- 				NOP				0x00000
		1  => "00000000000000000", -- 				NOP				0x00000
		2  => "11110000101000000", -- 				JR tras			0x1E140
		3  => "00110000000000001", -- frente:		ADD r0, r6		0x06001
		4  => "01100000000001100", -- 				SUB r6, r9		0x0C00C
		5  => "00100001101000101", -- tras:			ADD 13, r7		0x04345
		6  => "00000000000000000", -- 				NOP				0x00000
		7  => "01100000000111001", -- 				SUB r12, r6		0x0C039
		8  => "11110000011000000", --				JR frente		0x1E0C0
		others => (others => '0')
	);	-- (r6 = 001(r1), r7 = 010(r2) e por assim vai)

begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			dado <= conteudo_rom(to_integer(endereco));
		end if;
	end process;
end architecture;