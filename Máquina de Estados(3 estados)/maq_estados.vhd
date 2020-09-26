LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY maq_estados IS
    PORT (
        clk, rst : IN std_logic; -- Portas de clock e reset da FSM

        enable_pc : OUT std_logic; -- Porta lógica de enable da escrita no PC
        enable_rom : OUT std_logic; -- Porta lógica de enable da escrita no REG_ROM
        enable_banco : OUT std_logic; -- Porta lógica de enable da escrita no Banco de registradores
        estado : OUT unsigned(1 DOWNTO 0) := "00" -- Porta para indicar o estado atual da FSM
    );
END ENTITY;

ARCHITECTURE a_maq_estados OF maq_estados IS
    SIGNAL estado_s : unsigned(1 DOWNTO 0) := "00";

BEGIN

    PROCESS (clk, rst) -- Rotina de avanço de estados da FSM
    BEGIN
        IF rst = '1' THEN
            estado_s <= "00";
        ELSIF rising_edge(clk) THEN
            IF estado_s = "10" THEN -- se agora esta em 2
                estado_s <= "00"; -- o prox vai voltar ao zero
            ELSE
                estado_s <= estado_s + 1; -- senao avanca
            END IF;
        END IF;
    END PROCESS;

    PROCESS (estado_s) -- Rotina para identificar quais enables serão ativados, dependendo de cada estado
    BEGIN
        CASE estado_s IS
            WHEN "00" => -- Estado 0 (Fetch): Será escrito o valor do dado correspondente ao endereço atual no REG_ROM
                enable_pc <= '0';
                enable_rom <= '1';
                enable_banco <= '0';
            WHEN "01" => -- Estado 1 (Decode): O PC vai ser atualizado com o próximo endereço
                enable_pc <= '1';
                enable_rom <= '0';
                enable_banco <= '0';
            WHEN "10" => -- Estado 2 (Execute): Após fazer a instrução, gravará os resultados no banco
                enable_pc <= '0';
                enable_rom <= '0';
                enable_banco <= '1';
            WHEN OTHERS => -- Só para garantir que não comprometerá com o programa, desativa todos os enables
                enable_pc <= '0';
                enable_rom <= '0';
                enable_banco <= '0';
        END CASE;
    END PROCESS;
    estado <= estado_s;

END ARCHITECTURE;