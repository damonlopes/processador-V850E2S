LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processador IS
    PORT (
        clk : IN std_logic; -- Porta do clock do procesador
        rst : IN std_logic; -- Porta de reset do processador 

        estado_out : OUT unsigned(1 DOWNTO 0) := "00"; -- Porta do estados da FSM
        pc_out : OUT unsigned(6 DOWNTO 0) := "0000000"; -- Porta do endereço do PC
        opcode : OUT unsigned(16 DOWNTO 0) := "00000000000000000"; -- Porta do opcode da ROM
        reg1_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000"; -- Porta da entrada A da ULA
        reg2_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000"; -- Porta da entrada B da ULA
        ula_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000"; -- Porta da saída da ULA
        ram_endereco : OUT unsigned (6 downto 0) := "0000000"; -- Porta do endereço da RAM
        ram_out : OUT unsigned(15 downto 0) := "0000000000000000" -- Porta do dado de saída da RAM
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

    COMPONENT mux_ram IS
        PORT (
            sel_mux_ram : IN std_logic; -- Porta seletora da mux
            data0_mux_ram : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 0 da mux = ULA
            data1_mux_ram : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- Entrada 1 da mux = RAM

            out_mux_ram : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- Saída da mux
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

    COMPONENT ram IS
        PORT (
            clk : IN std_logic;
            ramwr_en : IN std_logic;
            endereco : IN unsigned (6 DOWNTO 0) := "0000000";
            dadoram_in : IN unsigned (15 DOWNTO 0) := "0000000000000000";
            dadoram_out : OUT unsigned (15 DOWNTO 0) := "0000000000000000"
        );
    END COMPONENT;

    COMPONENT reg_flag IS
        PORT (
            clk : IN std_logic;
            rst : IN std_logic;
            flagwr_en : IN std_logic;
            flagcarry_in : IN std_logic;
            flagzero_in : IN std_logic;
            flagneg_in : IN std_logic;
            sel_branch : IN unsigned (2 DOWNTO 0) := "000";

            flag_out : OUT std_logic
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

    COMPONENT ula IS
        PORT (
            op : IN unsigned (2 DOWNTO 0):= "000"; -- Porta seletora da operação da ULA
            in_a : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada A da ULA (Banco de registradores)
            in_b : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada B da ULA (MUX)

            cmp_carry : OUT std_logic; -- Flag de carry para a ULA
            cmp_zero : OUT std_logic; -- Flag de zero para a ULA
            cmp_neg : OUT std_logic; -- Flag de negativo para a ULA
            out_data : OUT unsigned (15 DOWNTO 0) := "0000000000000000" -- Saída com o resultado da operação da ULA (soma/subtração)
        );
    END COMPONENT;

    SIGNAL sel_data_pc, sel_data_ula, sel_data_ram, pc_en, ram_en, rom_en, flag_en, banco_en, sel_branch, sel_cmp, ula_carry, ula_zero, ula_neg : std_logic;
    SIGNAL uc_estado: unsigned(1 DOWNTO 0) := "00";
    SIGNAL sel_bancoreg1, sel_bancoreg2, sel_bancoregwr, uc_branchtype, sel_op_ula : unsigned(2 DOWNTO 0) := "000";
    SIGNAL dado_pc, dado_endereco, dado_adder, dado_adder_one, dado_adder_x : unsigned(6 DOWNTO 0) := "0000000";
    SIGNAL dado_ram, dado_reg1, dado_reg2, dado_mux, dado_ula, dado_signextend, dado_out : unsigned(15 DOWNTO 0) := "0000000000000000";
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
        datawr_reg => dado_out,
        data_reg0 => dado_reg1,
        data_reg1 => dado_reg2
    );

    maq_estados_top : maq_estados PORT MAP(
        clk => clk,
        rst => rst,
        estado => uc_estado
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

    mux_ram_top : mux_ram PORT MAP(
        sel_mux_ram => sel_data_ram,
        data0_mux_ram => dado_ula,
        data1_mux_ram => dado_ram,
        out_mux_ram => dado_out
    );

    pc_top : pc PORT MAP(
        clk => clk,
        rst => rst,
        wr_en_pc => pc_en,
        data_in_pc => dado_pc,
        data_out_pc => dado_endereco
    );

    ram_top : ram PORT MAP(
        clk => clk,
        ramwr_en => ram_en,
        endereco => dado_ula(6 DOWNTO 0),
        dadoram_in => dado_reg1,
        dadoram_out => dado_ram
    );

    reg_flag_top : reg_flag PORT MAP(
        clk => clk,
        rst => rst,
        flagwr_en => flag_en,
        flagcarry_in => ula_carry,
        flagzero_in => ula_zero,
        flagneg_in => ula_neg,
        sel_branch => uc_branchtype,
        flag_out => sel_cmp
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
        estado_fsm => uc_estado,
        data_rom => dado_reg_rom,
        jump_en => sel_data_pc,
        branch_en => sel_branch,
        sel_mux_reg => sel_data_ula,
        sel_mux_ram => sel_data_ram,
        pc_wr => pc_en,
        ram_wr => ram_en,
        rom_wr => rom_en,
        flag_wr => flag_en,
        banco_wr => banco_en,
        sel_ula => sel_op_ula,
        sel_branchtype => uc_branchtype,
        sel_wr_reg => sel_bancoregwr,
        sel_regorigem => sel_bancoreg1,
        sel_regdestino => sel_bancoreg2
    );

    ula_top : ula PORT MAP(
        op => sel_op_ula,
        in_a => dado_reg2,
        in_b => dado_mux,
        out_data => dado_ula,
        cmp_carry => ula_carry,
        cmp_zero => ula_zero,
        cmp_neg => ula_neg
    );

    pc_out <= dado_endereco;
    opcode <= dado_reg_rom;
    estado_out <= uc_estado;
    reg1_out <= dado_reg1;
    reg2_out <= dado_reg2;
    ula_out <= dado_ula;
    ram_endereco <= dado_ula(6 downto 0);
    ram_out <= dado_ram;

END ARCHITECTURE;