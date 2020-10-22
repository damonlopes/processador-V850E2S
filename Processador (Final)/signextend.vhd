LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY signextend IS
    PORT (
        data7bits : IN unsigned (6 DOWNTO 0) := "0000000"; -- Constante vinda do opcode 
        data16bits : OUT unsigned (15 DOWNTO 0) := "0000000000000000" -- Constante convertida para 16 bits
    );
END ENTITY;

ARCHITECTURE a_signextend OF signextend IS

BEGIN

    data16bits <= "000000000" & data7bits WHEN data7bits < "1000000" ELSE -- Se a constante for positiva, preenche os 9 bits faltantes com '0'
        "111111111" & data7bits WHEN data7bits >= "1000000" ELSE -- se não, preenche os 9 bits restantes com '1'
        "0000000000000000";
END ARCHITECTURE;