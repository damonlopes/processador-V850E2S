LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY maq_estados IS
    PORT (
        clk, rst : IN std_logic; -- Portas de clock e reset da FSM
        
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

    estado <= estado_s;

END ARCHITECTURE;