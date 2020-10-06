LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY processador_tb IS
END ENTITY;

ARCHITECTURE a_processador_tb OF processador_tb IS
    COMPONENT processador
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
    END COMPONENT;

    SIGNAL clk, rst : std_logic;
    SIGNAL estado_out : unsigned(1 DOWNTO 0) := "00";
    SIGNAL pc_out : unsigned(6 DOWNTO 0) := "0000000";
    SIGNAL reg1_out, reg2_out, ula_out : unsigned (15 DOWNTO 0) := "0000000000000000";
    SIGNAL opcode : unsigned (16 downto 0) := "00000000000000000";

BEGIN

    uut : processador PORT MAP(
        clk => clk,
        rst => rst,
        estado_out => estado_out,
        pc_out => pc_out,
        opcode => opcode,
        reg1_out => reg1_out,
        reg2_out => reg2_out,
        ula_out => ula_out
    );

    PROCESS

    BEGIN

        clk <= '0';
        WAIT FOR 50 ns;
        clk <= '1';
        WAIT FOR 50 ns;

    END PROCESS;

    PROCESS

    BEGIN

        rst <= '1';
        WAIT FOR 100 ns;
        rst <= '0';
        WAIT;

    END PROCESS;

END ARCHITECTURE;