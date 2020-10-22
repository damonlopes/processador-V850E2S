LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY signextend_tb IS
END ENTITY;

ARCHITECTURE a_signextend_tb OF signextend_tb IS
    COMPONENT signextend
        PORT (
            data7bits : IN unsigned (6 DOWNTO 0) := "0000000"; -- Constante vinda do opcode 
            data16bits : OUT unsigned (15 DOWNTO 0) := "0000000000000000" -- Constante convertida para 16 bits
        );
    END COMPONENT;

    SIGNAL data7bits : unsigned (6 DOWNTO 0) := "0000000";
    SIGNAL data16bits : unsigned (15 DOWNTO 0) := "0000000000000000";

BEGIN
    uut : signextend PORT MAP(
        data7bits => data7bits, -- Conectando as portas do signextend
        data16bits => data16bits
    );

    PROCESS
    -- Rotina de teste
    BEGIN

        data7bits <= "0000100"; -- Constante = 0x04
        WAIT FOR 100 ns;

        data7bits <= "1010101"; -- Constante = 0x55
        WAIT FOR 100 ns;

        data7bits <= "0111111"; -- Constante = 0x3F
        WAIT FOR 100 ns;

        data7bits <= "1000000"; -- Constante = 0x40
        WAIT FOR 100 ns;

        data7bits <= "0000000"; -- Constante = 0x00
        WAIT FOR 100 ns;

        data7bits <= "1111111"; -- Constante = 0x7F
        WAIT FOR 100 ns;

        data7bits <= "0110110"; -- Constante = 0x36
        WAIT FOR 100 ns;

        data7bits <= "0011111"; -- Constante = 0x1F
        WAIT FOR 100 ns;

        WAIT;
    END PROCESS;
END ARCHITECTURE;