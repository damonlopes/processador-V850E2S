LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processador IS
    PORT (
        clk : IN std_logic;
        rst : IN std_logic;

        estado_out : OUT unsigned(1 DOWNTO 0) := "00";
        pc_out : OUT unsigned(6 DOWNTO 0) := "0000000";
        opcode : OUT unsigned(16 DOWNTO 0) := "00000000000000000";
        reg1_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000";
        reg2_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000";
        ula_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000"
    );
END ENTITY;

ARCHITECTURE a_processador OF processador IS
    COMPONENT adder_one_pc IS
        PORT (
            in_adder_one_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada da adder_one_pc

            out_adder_one_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da adder_one_pc
        );
    END COMPONENT;

    COMPONENT adder_x_pc IS
		PORT (
			in_a_adder_x_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada A da adder_x_pc
        	in_b_adder_x_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada B da adder_x_pc

			out_adder_x_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da adder_x_pc
		);
	END COMPONENT;

    COMPONENT bancoreg IS
        PORT (
            clk : IN std_logic; -- Porta do clock do banco
            rst : IN std_logic; -- Porta do reset do banco
            write_en : IN std_logic; -- Porta do enable para escrever no banco de registradores
            sel_reg0 : IN unsigned(2 DOWNTO 0) := "000"; -- Seletor para leitura do primeiro registrador (conectado a mux)
            sel_reg1 : IN unsigned(2 DOWNTO 0) := "000"; -- Seletor para leitura do segundo registrador (conectado direto na ULA)
            sel_wr_reg : IN unsigned(2 DOWNTO 0) := "000"; -- Seletor para escolher em qual registrador vai gravar a DATA (destino)
            datawr_reg : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- DATA para gravar no registrador

            data_reg0 : OUT unsigned(15 DOWNTO 0) := "0000000000000000"; -- DATA do primeiro registrador
            data_reg1 : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- DATA do segundo registrador
        );
    END COMPONENT;

    COMPONENT maq_estados IS
        PORT (
            clk, rst : IN std_logic; -- Portas de clock e reset da FSM

            enable_pc : OUT std_logic; -- Porta lógica de enable da escrita no PC
            enable_rom : OUT std_logic; -- Porta lógica de enable da escrita no REG_ROM
            enable_banco : OUT std_logic; -- Porta lógica de enable da escrita no Banco de registradores
            estado : OUT unsigned(1 DOWNTO 0) := "00" -- Porta para indicar o estado atual da FSM
        );
    END COMPONENT;

    COMPONENT mux_pc IS
        PORT (
            sel_mux_pc : IN std_logic; -- Porta seletora da mux_pc
            data0_mux_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 0 da mux_pc (PC + 1)
            data1_mux_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 1 da mux_pc (JUMP)

            out_mux_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da mux_pc
        );
    END COMPONENT;

    COMPONENT mux_ula IS
        PORT (
            sel_mux_ula : IN std_logic; -- Porta seletora da mux
            data0_mux_ula : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 0 da mux = registrador
            data1_mux_ula : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 1 da mux = constante

            out_mux_ula : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- Saída da mux
        );
    END COMPONENT;

    COMPONENT mux_branch IS
		PORT (
			flag_branch : IN std_logic; -- Flag de operação BRANCH
        	flag_comp : IN std_logic; --Flag de resultado da comparação feita na ULA
			data0_mux_branch : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 0 da mux_branch (PC + 1)
			data1_mux_branch : IN unsigned(6 DOWNTO 0) := "0000000"; -- Entrada 1 da mux_branch (BRANCH)

			out_mux_branch : OUT unsigned(6 DOWNTO 0) := "0000000" -- Saída da mux_branch
		);
	END COMPONENT;

    COMPONENT pc IS
        PORT (
            clk : IN std_logic; -- Porta do clock do PC
            rst : IN std_logic; -- Porta do reset do PC
            wr_en_pc : IN std_logic; -- Porta do enable para escrever no PC
            data_in_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- DATA do próximo endereço do PC

            data_out_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- DATA do endereço atual do PC
        );
    END COMPONENT;

    COMPONENT reg_rom IS
        PORT (
            clk : IN std_logic; -- Porta do clock do REG_ROM
            rst : IN std_logic; -- Porta do reset do REG_ROM
            wr_en_regrom : IN std_logic; -- Porta do enable para escrever no REG_ROM
            data_in_regrom : IN unsigned(16 DOWNTO 0) := "00000000000000000"; -- DATA da entrada do REG_ROM = Próxima instrução

            data_out_regrom : OUT unsigned(16 DOWNTO 0) := "00000000000000000" -- DATA da saída do REG_ROM = Instrução atual
        );
    END COMPONENT;

    COMPONENT rom IS
        PORT (
            clk : IN std_logic; -- Clock da ROM
            endereco : IN unsigned(6 DOWNTO 0) := "0000000"; -- Endereço da ROM
            dado : OUT unsigned(16 DOWNTO 0) := "00000000000000000" -- Instrução correspondente ao endereço na ROM
        );
    END COMPONENT;

    COMPONENT signextend IS
        PORT (
            data7bits : IN unsigned (6 DOWNTO 0) := "0000000"; -- Constante vinda do opcode
            data16bits : OUT unsigned (15 DOWNTO 0) := "0000000000000000" -- Constante convertida para 16 bits
        );
    END COMPONENT;

    COMPONENT uc IS
        PORT (
            data_rom : IN unsigned(16 DOWNTO 0) := "00000000000000000"; -- valor do opcode da ROM

            jump_en : OUT std_logic; -- flag do JUMP
            branch_en : OUT std_logic; -- flag de qualquer operação BRANCH
            sel_mux_reg : OUT std_logic; -- seletor de dados da mux da ula (0 - registrador/1 - constante)
            sel_ula : OUT unsigned(1 DOWNTO 0) := "00"; --  seletor de operação da ULA (00 - soma/01 - subtração/10 - a<b/11 - a>b)
            sel_wr_reg : OUT unsigned(2 DOWNTO 0) := "000"; -- seletor para qual registrador o resultado será escrito
            sel_regorigem : OUT unsigned(2 DOWNTO 0) := "000"; -- seletor do registrador que a saída está conectado na mux
            sel_regdestino : OUT unsigned(2 DOWNTO 0) := "000" -- seletor do registrador que a saída está conectado direto na ULA, e será o destino do resultado da mesma
        );
    END COMPONENT;

    COMPONENT ula IS
        PORT (
            op : IN unsigned (1 DOWNTO 0); -- Porta seletora da operação da ULA
            in_a : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada A da ULA (Banco de registradores)
            in_b : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada B da ULA (MUX)

            out_data : OUT unsigned (15 DOWNTO 0) := "0000000000000000"; -- Saída com o resultado da operação da ULA (soma/subtração)
            out_cmp : OUT std_logic -- Saída lógica com o resultado da operação da ULA (Comparação)
        );
    END COMPONENT;

    SIGNAL sel_data_pc, sel_data_ula, pc_en, rom_en, banco_en, sel_branch, sel_cmp : std_logic;
    SIGNAL sel_op_ula : unsigned(1 DOWNTO 0) := "00";
    SIGNAL sel_bancoreg1, sel_bancoreg2, sel_bancoregwr : unsigned(2 DOWNTO 0) := "000";
    SIGNAL dado_pc, dado_endereco, dado_adder, dado_adder_one, dado_adder_x : unsigned(6 DOWNTO 0) := "0000000";
    SIGNAL dado_reg1, dado_reg2, dado_mux, dado_ula, dado_signextend : unsigned(15 DOWNTO 0) := "0000000000000000";
    SIGNAL dado_rom, dado_reg_rom : unsigned(16 DOWNTO 0) := "00000000000000000";

BEGIN

    adder_one_pc_top : adder_one_pc PORT MAP(
        in_adder_one_pc => dado_endereco,
        out_adder_one_pc => dado_adder_one
    );

    adder_x_pc_top : adder_x_pc PORT MAP(
    	in_a_adder_x_pc => dado_endereco,
		in_b_adder_x_pc => dado_reg_rom(12 DOWNTO 6),
		out_adder_x_pc => dado_adder_x
	);

    bancoreg_top : bancoreg PORT MAP(
        clk => clk,
        rst => rst,
        write_en => banco_en,
        sel_reg0 => sel_bancoreg1,
        sel_reg1 => sel_bancoreg2,
        sel_wr_reg => sel_bancoregwr,
        datawr_reg => dado_ula,
        data_reg0 => dado_reg1,
        data_reg1 => dado_reg2
    );

    maq_estados_top : maq_estados PORT MAP(
        clk => clk,
        rst => rst,
        enable_pc => pc_en,
        enable_rom => rom_en,
        enable_banco => banco_en,
        estado => estado_out
    );

    mux_pc_top : mux_pc PORT MAP(
        sel_mux_pc => sel_data_pc,
        data0_mux_pc => dado_adder,
        data1_mux_pc => dado_reg_rom(12 DOWNTO 6),
        out_mux_pc => dado_pc
    );
    mux_branch_top : mux_branch PORT MAP(
        data0_mux_branch => dado_adder_one,
		data1_mux_branch => dado_adder_x,
		flag_branch => sel_branch,
		flag_comp => sel_cmp,
		out_mux_branch => dado_adder
    );
    mux_ula_top : mux_ula PORT MAP(
        sel_mux_ula => sel_data_ula,
        data0_mux_ula => dado_reg1,
        data1_mux_ula => dado_signextend,
        out_mux_ula => dado_mux
    );

    pc_top : pc PORT MAP(
        clk => clk,
        rst => rst,
        wr_en_pc => pc_en,
        data_in_pc => dado_pc,
        data_out_pc => dado_endereco
    );

    reg_rom_top : reg_rom PORT MAP(
        clk => clk,
        rst => rst,
        wr_en_regrom => rom_en,
        data_in_regrom => dado_rom,
        data_out_regrom => dado_reg_rom
    );

    rom_top : rom PORT MAP(
        clk => clk,
        endereco => dado_endereco,
        dado => dado_rom
    );

    signextend_top : signextend PORT MAP(
        data7bits => dado_reg_rom(12 DOWNTO 6),
        data16bits => dado_signextend
    );

    uc_top : uc PORT MAP(
        data_rom => dado_reg_rom,
        jump_en => sel_data_pc,
        branch_en => sel_branch,
        sel_mux_reg => sel_data_ula,
        sel_ula => sel_op_ula,
        sel_wr_reg => sel_bancoregwr,
        sel_regorigem => sel_bancoreg1,
        sel_regdestino => sel_bancoreg2
    );

    ula_top : ula PORT MAP(
        op => sel_op_ula,
        in_a => dado_reg2,
        in_b => dado_mux,
        out_data => dado_ula,
        out_cmp => sel_cmp
    );

    pc_out <= dado_endereco;
    opcode <= dado_reg_rom;
    reg1_out <= dado_reg1;
    reg2_out <= dado_reg2;
    ula_out <= dado_ula;

END ARCHITECTURE;
