LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY reg_flag IS
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
END ENTITY;

ARCHITECTURE a_reg_flag OF reg_flag IS
    SIGNAL flagcarry_mem, flagzero_mem, flagneg_mem : std_logic;

BEGIN

    PROCESS (clk, rst, flagwr_en, sel_branch, flagcarry_mem, flagzero_mem)
    BEGIN

        IF rst = '1' THEN -- Se o reset = '1' então limpa o registrador
            flagcarry_mem <= '0';
            flagzero_mem <= '0';
            flagneg_mem <= '0';
            flag_out <= '0';
        ELSIF flagwr_en = '1' THEN -- Caso o enable esteja ativado, escreve o sinal de entrada de cada flag na memória
            IF rising_edge(clk) THEN -- do registrador (vindo da ULA)
                flagcarry_mem <= flagcarry_in;
                flagzero_mem <= flagzero_in;
                flagneg_mem <= flagneg_in;
                flag_out <= '0';
            END IF;
        END IF;
        -- Seletor de branchs
        IF sel_branch = "000" THEN -- BE (Branch if equal)
            flag_out <= flagzero_mem; -- Verifica se zero = 1
        ELSIF sel_branch = "001" THEN -- BNE (Branch if not equal)
            flag_out <= NOT flagzero_mem; -- Verifica se zero = 0
        ELSIF sel_branch = "010" THEN -- BL (Branch if lower)
            flag_out <= flagcarry_mem; -- Verifica se carry = 1
        ELSIF sel_branch = "011" THEN -- BH (Branchh if higher)
            flag_out <= NOT flagcarry_mem; -- Verifica se carry = 0
        ELSIF sel_branch <= "100" THEN -- BN (Branch if negative)
            flag_out <= flagneg_mem; -- Verifica se negativo = 1
        ELSIF sel_branch <= "101" THEN -- BP (Branch if positive)
            flag_out <= NOT flagneg_mem; -- Verifica se negativo = 0
        END IF;

    END PROCESS;

END ARCHITECTURE;