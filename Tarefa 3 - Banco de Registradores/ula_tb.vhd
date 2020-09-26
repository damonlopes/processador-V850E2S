library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
        port(	op: in std_logic_vector (1 downto 0); -- Porta seletora da operação da ULA
				in_a, in_b: in unsigned (15 downto 0) := "0000000000000000"; -- Entradas de DATA A e B da ULA

				out_a: out unsigned (15 downto 0) := "0000000000000000"; -- Saída com o resultado da operação da ULA (soma/subtração)
				out_b: out std_logic -- Saída lógica com o resultado da operação da ULA (Comparação)
		);
    end component;
	signal op: std_logic_vector (1 downto 0);
    signal in_a, in_b, out_a: unsigned (15 downto 0) := "0000000000000000";
	signal out_b: std_logic;
    
begin
    uut: ula port map( -- Conectando as portas da ULA
        in_a => in_a,
        in_b => in_b,
        out_a => out_a,
		out_b => out_b,
        op => op
    );
	-- Início do tb da ULA
    process
	-- Rotina de teste
    begin
        in_a <= "0000000000000001"; -- Informação na porta A = 0x0001#
        in_b <= "0000000000000011"; -- Informação na porta B = 0x0003#
        op <= "00"; -- Operação soma
        wait for 50 ns;

        in_a <= "0000000000000011"; -- Informação na porta A = 0x0003#
        in_b <= "0000000000000001"; -- Informação na porta B = 0x0001#
        op <= "01"; -- Operação subtração
        wait for 50 ns;

        in_a <= "0000000000000001"; -- Informação na porta A = 0x0001#
        in_b <= "0000000000000011"; -- Informação na porta B = 0x0003#
        op <= "10"; -- Operação compara se A < B
        wait for 50 ns;

        in_a <= "0000000000000011"; -- Informação na porta B = 0x0003#
        in_b <= "0000000000000001"; -- Informação na porta A = 0x0001#
        op <= "10"; -- Operação compara se A < B
        wait for 50 ns;

        in_a <= "0000000000000011"; -- Informação na porta B = 0x0003#
        in_b <= "0000000000000011"; -- Informação na porta B = 0x0003#
        op <= "10"; -- Operação compara se A < B
        wait for 50 ns;

        in_a <= "0000000000000001"; -- Informação na porta A = 0x0001#
        in_b <= "0000000000000011"; -- Informação na porta B = 0x0003#
        op <= "11"; -- Operação compara se A > B
        wait for 50 ns;

        in_a <= "0000000000000011"; -- Informação na porta B = 0x0003#
        in_b <= "0000000000000001"; -- Informação na porta A = 0x0001#
        op <= "11"; -- Operação compara se A > B
        wait for 50 ns;

        in_a <= "0000000000000011"; -- Informação na porta B = 0x0003#
        in_b <= "0000000000000011"; -- Informação na porta B = 0x0003#
        op <= "11"; -- Operação compara se A > B
        wait for 50 ns;

        wait;
    end process;
end architecture;
