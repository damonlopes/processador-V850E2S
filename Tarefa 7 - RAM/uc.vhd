LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY uc IS
	PORT (
		data_rom : IN unsigned(16 DOWNTO 0) := "00000000000000000"; -- valor do opcode da ROM

		jump_en : OUT std_logic; -- flag do JUMP
		branch_en : OUT std_logic; -- flag de qualquer operação BRANCH
		sel_mux_reg : OUT std_logic; -- seletor de dados da mux da ula (0 - registrador/1 - constante)
		sel_ula : OUT unsigned(1 DOWNTO 0) := "00"; --  seletor de operação da ULA (00 - soma/01 - subtração/10 - a<b/11 - a>b)
		sel_wr_reg : OUT unsigned(2 DOWNTO 0) := "000"; -- seletor para qual registrador o resultado será escrito
		sel_branchtype : OUT unsigned(2 downto 0) := "000";
		sel_regorigem : OUT unsigned(2 DOWNTO 0) := "000"; -- seletor do registrador que a saída está conectado na mux
		sel_regdestino : OUT unsigned(2 DOWNTO 0) := "000"; -- seletor do registrador que a saída está conectado direto na ULA, e será o destino do resultado da mesma
		sel_opcode : OUT unsigned(3 DOWNTO 0) := "0000"
	);
END ENTITY;

ARCHITECTURE a_uc OF uc IS

	SIGNAL opcode : unsigned(3 DOWNTO 0) := "0000"; -- Sinal para detectar qual tipo de instrução que está sendo recebida na UC
	SIGNAL constante : unsigned(6 DOWNTO 0) := "0000000";
	SIGNAL reg1, reg2 : unsigned(2 DOWNTO 0) := "000"; -- Sinal para detectar quais registradores serão envolvidos nessa instrução

BEGIN

	opcode <= data_rom(16 DOWNTO 13); -- Puxa os MSB da ROM
	constante <= data_rom(12 DOWNTO 6); -- Puxa os bits da constante
	reg1 <= data_rom(5 DOWNTO 3); -- Puxa os bits do registrador 1
	reg2 <= data_rom(2 DOWNTO 0); -- Puxa os bits do registrador 2

	PROCESS (opcode, reg1, reg2)
	BEGIN
		CASE opcode IS
			WHEN "0010" => -- ADD  imm7, reg2 (GR[reg2] + imm7-> GR[reg2])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '1'; -- Selecionando constante
				sel_ula <= "00"; -- Operação de soma
				sel_branchtype <= "000";
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= "000"; -- Como vai usar a constante na ULA, não importa
				sel_regdestino <= reg2; -- Registrador que será utilizado na ULA
				sel_opcode <= opcode;

			WHEN "0011" => -- ADD  reg1, reg2 (GR[reg2] + GR[reg1] -> GR[reg2])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_ula <= "00"; -- Operação de soma
				sel_branchtype <= "000";
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= reg1; -- Registrador que será utilizado na ULA
				sel_regdestino <= reg2; -- Registrador que será utilizado na ULA
				sel_opcode <= opcode;

			WHEN "0100" => -- SUB  reg1, reg2 (GR[reg2] - GR[reg1] -> GR[reg2])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_ula <= "01"; -- Operação de subtração
				sel_branchtype <= "000";
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= reg1; -- Registrador que será utilizado na ULA
				sel_regdestino <= reg2; -- Registrador que será utilizado na ULA
				sel_opcode <= opcode;

			WHEN "0101" => -- SUBR reg1, reg2 (GR[reg1] - GR[reg2] -> GR[reg1])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_ula <= "01"; -- Operação de subtração
				sel_branchtype <= "000";
				sel_wr_reg <= reg1; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= reg2; -- Registrador que será utilizado na ULA
				sel_regdestino <= reg1; -- Registrador que será utilizado na ULA
				sel_opcode <= opcode;

			WHEN "0110" => -- MOV  imm7, reg2 (imm7 -> GR[reg2])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '1'; -- Selecionando constante
				sel_ula <= "11"; -- Operação de mover
				sel_branchtype <= "000";
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= "000"; -- Como é uma operação de MOV com constante, não importa
				sel_regdestino <= "000"; -- Como é uma operação de MOV, não importa
				sel_opcode <= opcode;

			WHEN "0111" => -- MOV  reg1, reg2 (GR[reg1] -> GR[reg2])
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_ula <= "11"; -- Operação de mover
				sel_branchtype <= "000";
				sel_wr_reg <= reg2; -- Registrador onde vai ser guardado o resultado
				sel_regorigem <= reg1; -- Registrador que será utilizado na ULA
				sel_regdestino <= "000"; -- Como é uma operação de MOV, não importa
				sel_opcode <= opcode;

			WHEN "1000" => -- CMP  imm7, reg2 (GR[reg2] - imm7 -> result)
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '1'; -- Selecionando constante
				sel_ula <= "10"; -- Operação de comparação
				sel_branchtype <= "000";
				sel_wr_reg <= "000"; -- Como é operação de comparação, não importa
				sel_regorigem <= "000"; -- Como vai usar a constante na ULA, não importa
				sel_regdestino <= reg2; -- Registrador que será utilizado na ULA
				sel_opcode <= opcode;

			WHEN "1001" => -- CMP  reg1, reg2 (GR[reg2] - GR[reg1] -> result)
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '0'; -- Não é operação de branch
				sel_mux_reg <= '0'; -- Selecionando registrador
				sel_ula <= "10"; -- Operação de comparação
				sel_branchtype <= "000";
				sel_wr_reg <= "000"; -- Como é operação de comparação, não importa
				sel_regorigem <= reg1; -- Registrador que será utilizado na ULA
				sel_regdestino <= reg2; -- Registrador que será utilizado na ULA
				sel_opcode <= opcode;

			WHEN "1110" => -- Bcond imm7 (imm7 + PC -> PC se cumprir as condições)
				jump_en <= '0'; -- Não é operação de jump
				branch_en <= '1'; -- Operação de branch
				sel_mux_reg <= '0'; -- Como é operação de branch, não importa
				sel_ula <= "00"; -- Como é operação de branch, não importa
				sel_branchtype <= reg2;
				sel_wr_reg <= "000"; -- Como é operação de branch, não importa
				sel_regorigem <= "000"; -- Como é operação de branch, não importa
				sel_regdestino <= "000"; -- Como é operação de branch, não importa
				sel_opcode <= opcode;

			WHEN "1111" => -- JMP  imm7, reg1 (imm7 + GR[reg1] -> PC)
				jump_en <= '1'; -- Operação de jump
				branch_en <= '0'; -- Não é uma operação de branch
				sel_mux_reg <= '0'; -- Como é operação de jump, não importa
				sel_ula <= "00"; -- Como é operação de jump, não importa
				sel_branchtype <= "000";
				sel_wr_reg <= "000"; -- Como é operação de jump, não importa
				sel_regorigem <= "000"; -- Como é operação de jump, não importa
				sel_regdestino <= "000"; -- Como é operação de jump, não importa
				sel_opcode <= opcode;

			WHEN OTHERS => -- NOP (como não tem outras instruções implementadas, o resto delas seria NOP)
				jump_en <= '0'; -- Não é uma operação de jump
				branch_en <= '0'; -- Não é uma operação de branch
				sel_mux_reg <= '0'; -- Como é operação de NOP, não importa
				sel_ula <= "00"; -- Como é operação de NOP, não importa
				sel_branchtype <= "000";
				sel_wr_reg <= "000"; -- Como é operação de NOP, não importa
				sel_regorigem <= "000"; -- Como é operação de NOP, não importa
				sel_regdestino <= "000"; -- Como é operação de NOP, não importa
				sel_opcode <= opcode;

		END CASE;
	END PROCESS;
END ARCHITECTURE;