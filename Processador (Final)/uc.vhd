LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uc IS
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
END ENTITY;

ARCHITECTURE a_uc OF uc IS

	SIGNAL opcode : unsigned(3 DOWNTO 0) := "0000"; -- Sinal para detectar qual tipo de instrução que está sendo recebida na UC
	SIGNAL reg0, reg1, reg2 : unsigned(2 DOWNTO 0) := "000"; -- Sinal para detectar quais registradores serão envolvidos nessa instrução
	SIGNAL state : unsigned(1 DOWNTO 0) := "00"; -- Sinal para detectar em qual estado o programa está
BEGIN

	opcode <= data_rom(16 DOWNTO 13); -- Puxa os MSB da ROM
	reg0 <= data_rom(8 DOWNTO 6); -- Puxa os bits da constante
	reg1 <= data_rom(5 DOWNTO 3); -- Puxa os bits do registrador 1
	reg2 <= data_rom(2 DOWNTO 0); -- Puxa os bits do registrador 2
	state <= estado_fsm;

	PROCESS (opcode, reg1, reg2, state)
	BEGIN
		CASE opcode IS
			WHEN "0010" => -- ADD  imm7, reg2 (GR[reg2] + sign-extend(imm7) -> GR[reg2])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '1'; -- Selecionando constante
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "001"; -- Operação de soma
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= "000"; -- Como vai usar a constante na ULA, não importa
				sel_regdestino <= reg2; -- Registrador que será utilizado na ULA
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '1';
				END IF;

			WHEN "0011" => -- ADD  reg1, reg2 (GR[reg2] + GR[reg1] -> GR[reg2])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "001"; -- Operação de soma
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= reg1; -- Registrador que será utilizado na ULA
				sel_regdestino <= reg2; -- Registrador que será utilizado na ULA
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '1';
				END IF;

			WHEN "0100" => -- SUB  reg1, reg2 (GR[reg2] - GR[reg1] -> GR[reg2])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "010"; -- Operação de subtração
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= reg1; -- Registrador que será utilizado na ULA
				sel_regdestino <= reg2; -- Registrador que será utilizado na ULA
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '1';
				END IF;

			WHEN "0101" => -- SUBR reg1, reg2 (GR[reg1] - GR[reg2] -> GR[reg1])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "010"; -- Operação de subtração
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= reg1; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= reg2; -- Registrador que será utilizado na ULA
				sel_regdestino <= reg1; -- Registrador que será utilizado na ULA
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '1';
				END IF;

			WHEN "0110" => -- MUL imm7, reg2, reg2 (GR[reg2] * sign-extend(imm7) -> GR[reg3])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '1'; -- Selecionando constante
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "011"; -- Operação de multiplicação
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= "000"; -- Como é uma operação de MOV com constante, não importa
				sel_regdestino <= reg1; -- Como é uma operação de MOV, não importa
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '0';
				END IF;

			WHEN "0111" => -- MUL reg1, reg2, reg3 (GR[reg2] * GR[reg1] -> GR[reg3])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "011"; -- Operação de multiplicação
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= reg0; -- Registrador que será utilizado na ULA
				sel_regdestino <= reg1; -- Como é uma operação de MOV, não importa
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '0';
				END IF;

			WHEN "1000" => -- CMP  imm7, reg2 (GR[reg2] - sign-extend(imm7) -> result)
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '1'; -- Selecionando constante
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "110"; -- Operação de comparação
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= "000"; -- Como é operação de comparação, não importa
				sel_regorigem <= "000"; -- Como vai usar a constante na ULA, não importa
				sel_regdestino <= reg2; -- Registrador que será utilizado na ULA
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '1';
				END IF;

			WHEN "1001" => -- CMP  reg1, reg2 (GR[reg2] - GR[reg1] -> result)
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "110"; -- Operação de comparação
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= "000"; -- Como é operação de comparação, não importa
				sel_regorigem <= reg1; -- Registrador que será utilizado na ULA
				sel_regdestino <= reg2; -- Registrador que será utilizado na ULA
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '1';
				END IF;

			WHEN "1010" => -- MOV  imm7, reg2 (sign-extend(imm7) -> GR[reg2])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '1'; -- Selecionando constante
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "100"; -- Operação de mover
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= "000"; -- Como é uma operação de MOV com constante, não importa
				sel_regdestino <= "000"; -- Como é uma operação de MOV, não importa
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '0';
				END IF;

			WHEN "1011" => -- MOV  reg1, reg2 (GR[reg1] -> GR[reg2])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "100"; -- Operação de mover
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= reg1; -- Registrador que será utilizado na ULA
				sel_regdestino <= "000"; -- Como é uma operação de MOV, não importa
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '0';
				END IF;

			WHEN "1100" => -- LD.W disp7[reg1], reg2 (1- GR[reg1] + sign-extend(disp7) -> addr/2- loadmem(addr,Word) -> GR[reg2])
				jump_en <= '0'; -- Não é uma operação de jump
				branch_en <= '0'; -- Não é uma operação de branch
				sel_mux_reg <= '1'; -- Operação de memória RAM, puxa a constante
				sel_mux_ram <= '1'; -- Selecionando RAM
				sel_ula <= "101"; -- Operação de memória RAM (LD.W/ST.W)
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= reg2; -- Como é operação de jump, não importa
				sel_regorigem <= "000"; -- Como é operação de jump, não importa
				sel_regdestino <= reg1; -- Como é operação de jump, não importa
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '0';
				END IF;

			WHEN "1101" => -- ST.W reg2, disp7[reg1] (1- GR[reg1] + sign-extend(disp7) -> addr/2- storemem(addr,GR[reg2],Word))
				jump_en <= '0'; -- Não é uma operação de jump
				branch_en <= '0'; -- Não é uma operação de branch
				sel_mux_reg <= '1'; -- Operação de memória RAM, puxa a constante
				sel_mux_ram <= '0'; -- Selecionando ULA
				sel_ula <= "101"; -- Operação de memória RAM (LD.W/ST.W)
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= "000"; -- Como é operação de ST.W, não importa
				sel_regorigem <= reg2; -- Como é operação de jump, não importa
				sel_regdestino <= reg1; -- Como é operação de jump, não importa
				IF (state = "10") THEN
					ram_wr <= '1';
					flag_wr <= '0';
				END IF;

			WHEN "1110" => -- Bcond imm7 (imm7 + PC -> PC se cumprir as condições)
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '1'; -- Operação de branch
				sel_mux_reg <= '0'; -- Como é operação de branch, não importa
				sel_mux_ram <= '0'; -- Como é operação de branch, não importa
				sel_ula <= "000"; -- Como é operação de branch, não importa
				sel_branchtype <= reg2; -- Como é operação de branch, seleciona o respectivo tipo
				sel_wr_reg <= "000"; -- Como é operação de branch, não importa
				sel_regorigem <= "000"; -- Como é operação de branch, não importa
				sel_regdestino <= "000"; -- Como é operação de branch, não importa
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '0';
				END IF;

			WHEN "1111" => -- JMP  imm7, reg1 (imm7 + GR[reg1] -> PC)
				jump_en <= '1'; -- Operação de jump
				branch_en <= '0'; -- Não é uma operação de branch
				sel_mux_reg <= '0'; -- Como é operação de jump, não importa
				sel_mux_ram <= '0'; -- Como é operação de jump, não importa
				sel_ula <= "000"; -- Como é operação de jump, não importa
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= "000"; -- Como é operação de jump, não importa
				sel_regorigem <= "000"; -- Como é operação de jump, não importa
				sel_regdestino <= "000"; -- Como é operação de jump, não importa
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '0';
				END IF;

			WHEN OTHERS => -- NOP (como não tem outras instruções implementadas, o resto delas seria NOP)
				jump_en <= '0'; -- Não é uma operação de jump
				branch_en <= '0'; -- Não é uma operação de branch
				sel_mux_reg <= '0'; -- Como é operação de NOP, não importa
				sel_mux_ram <= '0'; -- Como é operação de NOP, não importa
				sel_ula <= "000"; -- Como é operação de NOP, não importa
				sel_branchtype <= "000"; -- Como não é operação de branch, não importa
				sel_wr_reg <= "000"; -- Como é operação de NOP, não importa
				sel_regorigem <= "000"; -- Como é operação de NOP, não importa
				sel_regdestino <= "000"; -- Como é operação de NOP, não importa
				IF (state = "10") THEN
					ram_wr <= '0';
					flag_wr <= '0';
				END IF;

		END CASE;

		IF (state = "00") THEN
			pc_wr <= '0';
			rom_wr <= '1';
			ram_wr <= '0';
			flag_wr <= '0';
			banco_wr <= '0';
		ELSIF (state = "01") THEN
			pc_wr <= '1';
			rom_wr <= '0';
			ram_wr <= '0';
			flag_wr <= '0';
			banco_wr <= '0';
		ELSIF (state = "10") THEN
			pc_wr <= '0';
			rom_wr <= '0';
			banco_wr <= '1';
		END IF;

	END PROCESS;
END ARCHITECTURE;