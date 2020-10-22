LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ram IS
    PORT (
        clk : IN std_logic; -- Porta do Clock
        ramwr_en : IN std_logic; -- Porta do enable_write na memória
        endereco : IN unsigned (6 DOWNTO 0) := "0000000"; -- Porta do endereço a ser selecionado na memória
        dadoram_in : IN unsigned (15 DOWNTO 0) := "0000000000000000"; -- DATA de entrada na memória
        dadoram_out : OUT unsigned (15 DOWNTO 0) := "0000000000000000" -- DATA de saída da memória, relativa ao endereço
    );
END ENTITY;

ARCHITECTURE a_ram OF ram IS
    TYPE mem IS ARRAY (0 TO 127) OF unsigned(15 DOWNTO 0); -- Cria a memória com todos os endereços possíveis
    SIGNAL conteudo_ram : mem;

BEGIN
    PROCESS (clk, ramwr_en)
    BEGIN
        IF rising_edge(clk) THEN
            IF (ramwr_en = '1') THEN -- Quando estiver ativado o enable_write, vai escrever no endereço correspondente
                conteudo_ram(to_integer(endereco)) <= dadoram_in; -- a DATA de entrada da memória
            END IF;
        END IF;
    END PROCESS;
    dadoram_out <= conteudo_ram(to_integer(endereco)); -- Envia a DATA correspondente ao endereço selecionado para a saída da memória

END ARCHITECTURE;