LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ram_tb IS
END ENTITY;

ARCHITECTURE a_ram_tb OF ram_tb IS
    COMPONENT ram
        PORT (
            clk : IN std_logic; -- Porta do Clock da memória
            ramwr_en : IN std_logic; -- Porta do enable_write na memória
            endereco : IN unsigned (6 DOWNTO 0) := "0000000"; -- Porta do endereço a ser selecionado na memória
            dadoram_in : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- DATA de entrada na memória
            dadoram_out : OUT unsigned (15 DOWNTO 0) := "0000000000000000" -- DATA de saída da memória, relativa ao endereço
        );
    END COMPONENT;

    SIGNAL clk, ramwr_en : std_logic;
    SIGNAL endereco : unsigned (6 DOWNTO 0) := "0000000";
    SIGNAL dadoram_in, dadoram_out : unsigned (15 DOWNTO 0) := "0000000000000000";

BEGIN
    uut : ram PORT MAP(
        clk => clk, -- Conectando as portas da RAM
        ramwr_en => ramwr_en,
        endereco => endereco,
        dadoram_in => dadoram_in,
        dadoram_out => dadoram_out
    );
    -- Início do tb da RAM
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
        endereco <= "1000001"; -- Endereço = 0x41   
        ramwr_en <= '1'; -- Enable_write ativado
        dadoram_in <= "0111111111111110"; -- DATA de entrada = 0x7FFE
        WAIT FOR 100 ns;

        endereco <= "1001001"; -- Endereço = 0x41
        ramwr_en <= '0'; -- Enable_write ativado
        dadoram_in <= "1010101010010101"; -- DATA de entrada = 0x7FFE
        WAIT FOR 100 ns;

        endereco <= "0010100"; -- Endereço = 0x49
        ramwr_en <= '0'; -- Enable_write desativado
        dadoram_in <= "1111111111111111"; -- DATA de entrada = 0xFFFF
        WAIT FOR 100 ns;

        endereco <= "1000001"; -- Endereço = 0x41
        ramwr_en <= '0'; -- Enable_write desativado
        dadoram_in <= "1010001001001001"; -- DATA de entrada = 0x7FFE
        WAIT FOR 100 ns;

        endereco <= "0000000"; -- Endereço = 0x00
        ramwr_en <= '1'; -- Enable_write ativado
        dadoram_in <= "1111100000001111"; -- DATA de entrada = 0xF80F
        WAIT FOR 100 ns;

        endereco <= "1010101"; -- Endereço = 0x55
        ramwr_en <= '1'; -- Enable_write ativado
        dadoram_in <= "1110010010010111"; -- DATA de entrada = 0xE497
        WAIT FOR 100 ns;

        endereco <= "0000000"; -- Endereço = 0x00
        ramwr_en <= '0'; -- Enable_write desativado
        dadoram_in <= "1100100100101001"; -- DATA de entrada = 0xC929
        WAIT FOR 100 ns;

        endereco <= "0000000"; -- Endereço = 0x00
        ramwr_en <= '1'; -- Enable_write desativado
        dadoram_in <= "1100101111101001"; -- DATA de entrada = 0xCBE9
        WAIT FOR 100 ns;

        WAIT;
    END PROCESS;
END ARCHITECTURE;