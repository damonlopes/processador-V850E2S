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
	0 => "10100000001000001", --				MOV 1, R6 		    0x14041
	1 => "00100000001000001", --				ADD 1, R6  			0x04041
	2 => "11010000000001001", --				ST.W R6, 0[R6]		0x1A009
	3 => "10000100000000001", --                CMP 32, R6			0x10801
	4 => "11101111101000001", --				BNE -3				0x1DF41
	5 => "10100000001000010", -- 				MOV 1, R7			0x14042
	6 => "00100000001000010", --				ADD 1, R7			0x04042
	7 => "01100000010010011", -- 				MUL 2, R7, R8		0x0C093
	8 => "11010000000011000", --				ST.W R0, 0[R8]		0x1A018
	9 => "10000100000000011", --				CMP 32, R8			0x10803
	10 => "11101111100000100", -- 				BN -4				0x1DF04
	11 => "10100000001000010", -- 				MOV 1, R7			0x14042
	12 => "00100000001000010", --				ADD 1, R7			0x04042
	13 => "01100000011010011", -- 				MUL 3, R7, R8		0x0C0D3
	14 => "11010000000011000", --				ST.W R0, 0[R8]		0x1A018
	15 => "10000100000000011", --				CMP 32, R8			0x10803
	16 => "11101111100000100", -- 				BN -4				0x1DF04
	17 => "10100000001000010", -- 				MOV 1, R7			0x14042
	18 => "00100000001000010", --				ADD 1, R7			0x04042
	19 => "01100000101010011", -- 				MUL 5, R7, R8		0x0C153
	20 => "11010000000011000", --				ST.W R0, 0[R8]		0x1A018
	21 => "10000100000000011", --				CMP 32, R8			0x10803
	22 => "11101111100000100", -- 				BN -4				0x1DF04
	23 => "10100000000000001", --				MOV 0, R6 		    0x14001
	24 => "10100000001000010", -- 				MOV 1, R7   		0x14042
	25 => "00100000001000010", -- 				ADD 1, R7			0x04042
	26 => "11000000000010001", --				LD.W 0[R7], R6		0x18011
	27 => "10000100000000010", -- 				CMP 32, R7			0x10802
	28 => "11101111101000001", --               BNE -3				0x1DF41

	OTHERS => (OTHERS => '0')
	); -- R6 = 001(R1), R7 = 010(R2), R8 = 011(R3), R9 = 100(R4), R10 = 101(R5), R11 = 110(R6), R12 = 111(R7)

BEGIN
	PROCESS (clk)
	BEGIN
		IF (rising_edge(clk)) THEN
			dado <= conteudo_rom(to_integer(endereco)); -- Envia a DATA correspondente ao endereço selecionado para a saída
		END IF;
	END PROCESS;
END ARCHITECTURE;
