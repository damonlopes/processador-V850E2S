LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processador_tb IS
END ENTITY;

ARCHITECTURE a_processador_tb OF processador_tb IS
    COMPONENT processador
        PORT (
            clk : IN std_logic; -- Porta do clock do procesador
            rst : IN std_logic; -- Porta de reset do processador 

            estado_out : OUT unsigned(1 DOWNTO 0) := "00"; -- Porta do estados da FSM
            pc_out : OUT unsigned(6 DOWNTO 0) := "0000000"; -- Porta do endereço do PC
            opcode : OUT unsigned(16 DOWNTO 0) := "00000000000000000"; -- Porta do opcode da ROM
            reg1_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000"; -- Porta da entrada A da ULA
            reg2_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000"; -- Porta da entrada B da ULA
            ula_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000"; -- Porta da saída da ULA
            ram_endereco : OUT unsigned (6 DOWNTO 0) := "0000000"; -- Porta do endereço da RAM
            ram_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- Porta do dado de saída da RAM
        );
    END COMPONENT;

    SIGNAL clk, rst : std_logic;
    SIGNAL estado_out : unsigned(1 DOWNTO 0) := "00";
    SIGNAL pc_out, ram_endereco : unsigned(6 DOWNTO 0) := "0000000";
    SIGNAL reg1_out, reg2_out, ula_out, ram_out : unsigned (15 DOWNTO 0) := "0000000000000000";
    SIGNAL opcode : unsigned (16 DOWNTO 0) := "00000000000000000";

BEGIN

    uut : processador PORT MAP(
        clk => clk, -- Conectando as portas do processador
        rst => rst,
        estado_out => estado_out,
        pc_out => pc_out,
        opcode => opcode,
        reg1_out => reg1_out,
        reg2_out => reg2_out,
        ula_out => ula_out,
        ram_endereco => ram_endereco,
        ram_out => ram_out
    );
    -- Início do tb do processador
    PROCESS
    -- Rotina de clock
    BEGIN

        clk <= '0';
        WAIT FOR 50 ns;
        clk <= '1';
        WAIT FOR 50 ns;

    END PROCESS;

    PROCESS
    -- Rotina de teste
    BEGIN

        rst <= '1';
        WAIT FOR 100 ns;
        rst <= '0';
        WAIT;

    END PROCESS;

END ARCHITECTURE;