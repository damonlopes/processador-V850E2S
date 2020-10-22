LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY reg_flag_tb IS
END ENTITY;

ARCHITECTURE a_reg_flag_tb OF reg_flag_tb IS
    COMPONENT reg_flag
        PORT (
            clk : IN std_logic; -- Porta de clock do registrador de flags
            rst : IN std_logic; -- Porta de reset do registrador de flags
            flagwr_en : IN std_logic; -- Porta de enable_write do registrador de flags
            flagcarry_in : IN std_logic; -- Sinal do flag de carry
            flagzero_in : IN std_logic; -- Sinal do flag de zero
            flagneg_in : IN std_logic; -- Sinal do flag de negativo
            sel_branch : IN unsigned (2 DOWNTO 0) := "000"; -- Seletor do tipo de branch 
    
            flag_out : OUT std_logic -- Saída do registrador de flag
        );
    END COMPONENT;

    SIGNAL clk, rst, flagwr_en, flagcarry_in, flagzero_in, flagneg_in, flag_out : std_logic;
    SIGNAL sel_branch : unsigned (2 DOWNTO 0) := "000";

BEGIN
    uut : reg_flag PORT MAP(
        clk => clk, -- Conectando as portas do registrador de flags
        rst => rst,
        flagwr_en => flagwr_en,
        flagcarry_in => flagcarry_in,
        flagzero_in => flagzero_in,
        flagneg_in => flagneg_in,
        sel_branch => sel_branch,
        flag_out => flag_out
    );
    -- Início do tb do registrador de flags
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
        sel_branch <= "000"; -- BE (Branch if Equal) | zero = 1
        flagcarry_in <= '0'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '0'; -- Flag do negativo vindo da ULA
        flagwr_en <= '0'; -- Não escreve na memória
        wait for 100 ns;

        sel_branch <= "000"; -- BE (Branch if Equal) | zero = 1
        flagcarry_in <= '1'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '0'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "000"; -- BE (Branch if Equal) | zero = 1
        flagcarry_in <= '1'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '1'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "000"; -- BE (Branch if Equal) | zero = 1
        flagcarry_in <= '0'; -- Flag de carry vindo da ULA
        flagzero_in <= '1'; -- Flag do zero vindo da ULA
        flagneg_in <= '0'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "001"; -- BNE (Branch if Not Equal) | zero = 1
        flagcarry_in <= '0'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '1'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "000"; -- BE (Branch if Equal) | zero = 1
        flagcarry_in <= '1'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '0'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "010"; -- BNE (Branch if Not Equal) | zero = 0
        flagcarry_in <= '0'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '1'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "000"; -- BE (Branch if Equal) | zero = 1
        flagcarry_in <= '0'; -- Flag de carry vindo da ULA
        flagzero_in <= '1'; -- Flag do zero vindo da ULA
        flagneg_in <= '0'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "100"; -- BN (Branch if Negative) | negativo = 1
        flagcarry_in <= '0'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '1'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "000"; -- BE (Branch if Equal) | zero = 1
        flagcarry_in <= '1'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '0'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "010"; -- BL (Branch if Lower) | carry = 1
        flagcarry_in <= '0'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '1'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória 
        wait for 100 ns;

        sel_branch <= "000"; -- BE (Branch if Equal) | zero = 1
        flagcarry_in <= '0'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '0'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "101"; -- BP (Branch if Positive) | negativo = 0
        flagcarry_in <= '0'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '1'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;

        sel_branch <= "011"; -- BH (Branch if Higher) | carry = 0
        flagcarry_in <= '0'; -- Flag de carry vindo da ULA
        flagzero_in <= '0'; -- Flag do zero vindo da ULA
        flagneg_in <= '0'; -- Flag do negativo vindo da ULA
        flagwr_en <= '1'; -- Escreve na memória
        wait for 100 ns;
        wait;

    END PROCESS;
END ARCHITECTURE;