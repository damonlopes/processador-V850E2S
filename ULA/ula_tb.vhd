LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ula_tb IS
END;

ARCHITECTURE a_ula_tb OF ula_tb IS
    COMPONENT ula
        PORT (
            op : IN unsigned (1 DOWNTO 0); -- Porta seletora da operação da ULA
            in_a : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada A da ULA (Banco de registradores)
            in_b : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- Entrada B da ULA (MUX)

            out_data : OUT unsigned (15 DOWNTO 0) := "0000000000000000"; -- Saída com o resultado da operação da ULA (soma/subtração)
            out_cmp : OUT std_logic -- Saída lógica com o resultado da operação da ULA (Comparação)
        );
    END COMPONENT;
    SIGNAL op : unsigned (1 DOWNTO 0):= "00";
    SIGNAL in_a, in_b, out_data : unsigned (15 DOWNTO 0) := "0000000000000000";
    SIGNAL out_cmp : std_logic;

BEGIN
    uut : ula PORT MAP(-- Conectando as portas da ULA
        in_a => in_a,
        in_b => in_b,
        out_data => out_data,
        out_cmp => out_cmp,
        op => op
    );
    -- Início do tb da ULA
    PROCESS
        -- Rotina de teste
    BEGIN
        in_a <= "0000000000000001"; -- Informação na porta A = 0x0001
        in_b <= "0000000000000011"; -- Informação na porta B = 0x0003
        op <= "00"; -- Operação soma
        WAIT FOR 50 ns;

        in_a <= "0000000000000011"; -- Informação na porta A = 0x0003
        in_b <= "0000000000000001"; -- Informação na porta B = 0x0001
        op <= "01"; -- Operação subtração
        WAIT FOR 50 ns;

        in_a <= "0000000000000001"; -- Informação na porta A = 0x0001
        in_b <= "0000000000000011"; -- Informação na porta B = 0x0003
        op <= "10"; -- Operação compara se A < B
        WAIT FOR 50 ns;

        in_a <= "0000000000000011"; -- Informação na porta B = 0x0003
        in_b <= "0000000000000001"; -- Informação na porta A = 0x0001
        op <= "10"; -- Operação compara se A < B
        WAIT FOR 50 ns;

        in_a <= "0000000000000011"; -- Informação na porta B = 0x0003
        in_b <= "0000000000000011"; -- Informação na porta B = 0x0003
        op <= "10"; -- Operação compara se A < B
        WAIT FOR 50 ns;

        in_a <= "0000000000000001"; -- Informação na porta A = 0x0001
        in_b <= "0000000000000011"; -- Informação na porta B = 0x0003
        op <= "11"; -- Operação compara se A = B
        WAIT FOR 50 ns;

        in_a <= "0000000000000011"; -- Informação na porta B = 0x0003
        in_b <= "0000000000000001"; -- Informação na porta A = 0x0001
        op <= "11"; -- Operação compara se A = B
        WAIT FOR 50 ns;

        in_a <= "0000000000000011"; -- Informação na porta B = 0x0003
        in_b <= "0000000000000011"; -- Informação na porta B = 0x0003
        op <= "11"; -- Operação compara se A = B
        WAIT FOR 50 ns;

        in_a <= "1111111111111111"; -- Informação na porta A = 0x0001
        in_b <= "0000000000000001"; -- Informação na porta B = 0x0003
        op <= "00"; -- Operação soma
        WAIT FOR 50 ns;

        WAIT;
    END PROCESS;
END ARCHITECTURE;
