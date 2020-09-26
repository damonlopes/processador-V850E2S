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
	0 => "01100000000000011", --				MOV     0,  R8      0x0C003
	1 => "01100000000000100", -- 				MOV     0,  R9      0x0C004
	2 => "01100011110000110", -- 				MOV     30, R11     0x0C786
	3 => "00110000000011100", -- 				ADD     R8, R9      0x0601C
	4 => "00100000001000011", --				ADD     1,  R8      0x04043
	5 => "10101111110011110", -- 				BL      3, R8, R11 	0x15F9E
	6 => "01110000000100101", --				MOV     R9, R10     0x0E025
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
