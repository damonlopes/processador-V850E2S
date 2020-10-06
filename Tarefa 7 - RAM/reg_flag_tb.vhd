LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY reg_flag_tb IS
END ENTITY;

ARCHITECTURE a_reg_flag_tb OF reg_flag_tb IS
    COMPONENT reg_flag
        PORT (
            clk : IN std_logic;
            rst : IN std_logic;
            flagwr_en : IN std_logic;
            flagcarry_in : IN std_logic;
            flagzero_in : IN std_logic;
            sel_branch : IN unsigned (2 DOWNTO 0) := "000";
            opcode : IN unsigned (3 DOWNTO 0) := "0000";

            flag_out : OUT std_logic
        );
    END COMPONENT;

    SIGNAL clk, rst, flagwr_en, flagcarry_in, flagzero_in, flag_out : std_logic;
    SIGNAL sel_branch : unsigned (2 DOWNTO 0) := "000";
    SIGNAL opcode : unsigned(3 DOWNTO 0) := "0000";

BEGIN
    uut : reg_flag PORT MAP(
        clk => clk,
        rst => rst,
        flagwr_en => flagwr_en,
        flagcarry_in => flagcarry_in,
        flagzero_in => flagzero_in,
        sel_branch => sel_branch,
        opcode => opcode,
        flag_out => flag_out
    );

    PROCESS
        -- Rotina do clock
    BEGIN
        clk <= '0';
        WAIT FOR 50 ns;

        clk <= '1';
        WAIT FOR 50 ns;

    END PROCESS;

    PROCESS
        -- Rotina de inicialização
    BEGIN
        rst <= '1';
        WAIT FOR 100 ns;

        rst <= '0';

        WAIT;
    END PROCESS;

    PROCESS

    BEGIN
        opcode <= "0000";
        sel_branch <= "000";
        flagcarry_in <= '0';
        flagzero_in <= '0';
        flagwr_en <= '0';
        wait for 100 ns;

        opcode <= "0001";
        sel_branch <= "000";
        flagcarry_in <= '1';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "0010";
        sel_branch <= "000";
        flagcarry_in <= '1';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "0011";
        sel_branch <= "000";
        flagcarry_in <= '0';
        flagzero_in <= '1';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "1110";
        sel_branch <= "001";
        flagcarry_in <= '0';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "1001";
        sel_branch <= "000";
        flagcarry_in <= '1';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "1110";
        sel_branch <= "010";
        flagcarry_in <= '0';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "1001";
        sel_branch <= "000";
        flagcarry_in <= '0';
        flagzero_in <= '1';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "1110";
        sel_branch <= "100";
        flagcarry_in <= '0';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "0011";
        sel_branch <= "000";
        flagcarry_in <= '1';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "1110";
        sel_branch <= "010";
        flagcarry_in <= '0';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "1110";
        sel_branch <= "000";
        flagcarry_in <= '0';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "1110";
        sel_branch <= "001";
        flagcarry_in <= '0';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;

        opcode <= "1110";
        sel_branch <= "100";
        flagcarry_in <= '0';
        flagzero_in <= '0';
        flagwr_en <= '1';
        wait for 100 ns;
        wait;

    END PROCESS;
END ARCHITECTURE;