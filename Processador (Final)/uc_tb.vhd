LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uc_tb IS
END ENTITY;

ARCHITECTURE a_uc_tb OF uc_tb IS
	COMPONENT uc
		PORT (
			estado_fsm : IN unsigned (1 DOWNTO 0) := "00"; -- estado atual do programa 
			data_rom : IN unsigned(16 DOWNTO 0) := "00000000000000000"; -- valor do opcode da ROM

			jump_en : OUT std_logic; -- flag do JUMP
			branch_en : OUT std_logic; -- flag de qualquer operação BRANCH
			sel_mux_reg : OUT std_logic; -- seletor de dados da mux da ula (0 - registrador/1 - constante)
			sel_mux_ram : OUT std_logic; -- seletor de dados da mux da ram (0 - ULA/1 - RAM)
			pc_wr : OUT std_logic; -- write_enable do PC
			ram_wr : OUT std_logic; -- write_enable da RAM
			rom_wr : OUT std_logic; -- write_enable do Reg. de instrução da ROM
			flag_wr : OUT std_logic; -- write_enable da Reg. de Flags
			banco_wr : OUT std_logic; -- write_eneble do Banco de regs.
			sel_ula : OUT unsigned(2 DOWNTO 0) := "000"; --  seletor de operação da ULA (00 - soma/01 - subtração/10 - a<b/11 - a>b)
			sel_wr_reg : OUT unsigned(2 DOWNTO 0) := "000"; -- seletor para qual registrador o resultado será escrito
			sel_branchtype : OUT unsigned(2 DOWNTO 0) := "000"; -- seletor do tipo de branch
			sel_regorigem : OUT unsigned(2 DOWNTO 0) := "000"; -- seletor do registrador que a saída está conectado na mux
			sel_regdestino : OUT unsigned(2 DOWNTO 0) := "000" -- seletor do registrador que a saída está conectado direto na ULA, e será o destino do resultado da mesma
		);
	END COMPONENT;

	SIGNAL jump_en, branch_en, sel_mux_reg, sel_mux_ram, pc_wr, ram_wr, rom_wr, flag_wr, banco_wr : std_logic;
	SIGNAL estado_fsm : unsigned(1 DOWNTO 0) := "00";
	SIGNAL sel_ula, sel_branchtype, sel_wr_reg, sel_regorigem, sel_regdestino : unsigned(2 DOWNTO 0) := "000";
	SIGNAL data_rom : unsigned(16 DOWNTO 0) := "00000000000000000";

BEGIN

	uut : uc PORT MAP(
		data_rom => data_rom,
		jump_en => jump_en, -- Conectando as portas da UC
		branch_en => branch_en,
		sel_mux_reg => sel_mux_reg,
		sel_mux_ram => sel_mux_ram,
		pc_wr => pc_wr,
		ram_wr => ram_wr,
		rom_wr => rom_wr,
		flag_wr => flag_wr,
		banco_wr => banco_wr,
		sel_ula => sel_ula,
		estado_fsm => estado_fsm,
		sel_branchtype => sel_branchtype,
		sel_wr_reg => sel_wr_reg,
		sel_regorigem => sel_regorigem,
		sel_regdestino => sel_regdestino
	);
	-- Início do tb da UC(provisória)
	PROCESS
		-- Rotina de teste
	BEGIN

		data_rom <= "00000000000000000"; -- Opcode = 0x00000 (NOP)
		estado_fsm <= "00"; -- Estado 0 (fetch)
		WAIT FOR 100 ns;

		data_rom <= "00100000101000011"; -- Opcode = 0x04143 (ADD 5, R8)
		estado_fsm <= "00"; -- Estado 0 (fetch)
		WAIT FOR 100 ns;

		data_rom <= "00110000000011101"; -- Opcode = 0x0601D (ADD R8, R10)
		estado_fsm <= "00"; -- Estado 0 (fetch)
		WAIT FOR 100 ns;

		data_rom <= "01000000000110101"; -- Opcode = 0x08035 (SUB R11, R10)
		estado_fsm <= "01"; -- Estado 1 (decode)
		WAIT FOR 100 ns;

		data_rom <= "01110000000101011"; -- Opcode = 0x0E02B (MOV R10, R8)
		estado_fsm <= "00"; -- Estado 0 (fetch)
		WAIT FOR 100 ns;

		data_rom <= "11110000011000000"; -- Opcode = 0x1E0C0 (JMP 3)
		estado_fsm <= "00"; -- Estado 0 (fetch)
		WAIT FOR 100 ns;

		data_rom <= "01100000011000011"; -- Opcode = 0x0C0C3 (MOV 3, R8)
		estado_fsm <= "01"; -- Estado 1 (decode)
		WAIT FOR 100 ns;

		data_rom <= "01010000000001101"; -- Opcode = 0x0A00D (SUBR R6, R8)
		estado_fsm <= "00"; -- Estado 0 (fetch)
		WAIT FOR 100 ns;

		data_rom <= "11101110110000001"; -- Opcode = 0x1DD81 (BNE -10)
		estado_fsm <= "00"; -- Estado 0 (fetch)
		WAIT FOR 100 ns;

		data_rom <= "10110000000100000"; -- Opcode = 0x16020 (ST.W R8, 0[R0])
		estado_fsm <= "10"; -- Estado 2 (execute)
		WAIT FOR 100 ns;

		data_rom <= "11101111101000001"; -- Opcode = 0x1DF41 (BNE -3)
		estado_fsm <= "00"; -- Estado 0 (fetch)
		WAIT FOR 100 ns;

		data_rom <= "01100000011000011"; -- Opcode = 0x0C0C3 (MOV 3, R8)
		estado_fsm <= "11"; -- Estado 3 (??????)
		WAIT FOR 100 ns;

		data_rom <= "10100000000010001"; -- Opcode = 0x14011 (LD.W 0[R7], R6)
		estado_fsm <= "10"; -- Estado 2 (execute)
		WAIT FOR 100 ns;
		WAIT;

	END PROCESS;
END ARCHITECTURE;