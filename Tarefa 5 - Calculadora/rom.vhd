LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY rom IS
	PORT (
		clk : IN std_logic; -- Clock da ROM
		endereco : IN unsigned(6 DOWNTO 0) := "0000000"; -- Endereço da ROM
		dado : OUT unsigned(16 DOWNTO 0) := "00000000000000000" -- Instrução correspondente ao endereço na ROM
	);
END ENTITY;

ARCHITECTURE a_rom OF rom IS
	TYPE mem IS ARRAY (0 TO 127) OF unsigned (16 DOWNTO 0); -- De acordo com qual endereço estiver, ele vai mandar um valor
	CONSTANT conteudo_rom : mem := (-- para a saída da ROM, que vai para a UC e para os outros lugares do processador
	0 => "00000000000000000", -- 				NOP				0x00000
	1 => "00100000001000111", --				ADD	  1, R12	0x04047
	2 => "00100000101000011", -- 				ADD   5, R8		0x04143
	3 => "00100001000000100", -- 				ADD	  8, R9		0x04204
	4 => "01110000000011101", --				MOV  R8, R10	0x0E01D
	5 => "00110000000100101", -- 				ADD  R9, R10	0x06025
	6 => "01000000000111101", -- 				SUB R12, R10    0x0803D
	7 => "11110010100000000", --				JR   20			0x1E500
	20 => "01110000000101011", -- 				MOV R10, R8		0x0E02B
	21 => "11110000100000000", --				JR    4			0x1E100
	OTHERS => (OTHERS => '0')
	); -- (r6 = 001(r1), r7 = 010(r2) e por assim vai)

	SIGNAL valor : unsigned(16 DOWNTO 0) := "00000000000000000";
	SIGNAL operacao : unsigned(3 DOWNTO 0) := "0000";
	SIGNAL constante : unsigned(6 DOWNTO 0) := "0000000";
	SIGNAL reg1, reg2 : unsigned(2 DOWNTO 0) := "000";

BEGIN
	PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN
			dado <= conteudo_rom(to_integer(endereco));
			valor <= conteudo_rom(to_integer(endereco));
		END IF;
		operacao <= valor(16 DOWNTO 13); -- Porta interna para checar qual instrução é
		constante <= valor(12 DOWNTO 6); -- Porta interna para checar o valor da constante
		reg1 <= valor(5 DOWNTO 3); -- Porta interna para checar o registrador 1 (conectado na MUX)
		reg2 <= valor(2 DOWNTO 0); -- Porta interna para chegar o registrador 2 (conectado diretamente na ULA)
	END PROCESS;
END ARCHITECTURE;