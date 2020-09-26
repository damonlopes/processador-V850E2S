library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port(	op: in std_logic_vector (1 downto 0); -- Porta seletora da operação da ULA
			in_a, in_b: in unsigned (15 downto 0) := "0000000000000000"; -- Entradas de DATA A e B da ULA

			out_a: out unsigned (15 downto 0) := "0000000000000000"; -- Saída com o resultado da operação da ULA (soma/subtração)
			out_b: out std_logic -- Saída lógica com o resultado da operação da ULA (Comparação)
    );
end entity;

architecture a_ula of ula is
begin
	--Se for alguma das operações soma/subtração
    out_a <=  in_a + in_b when op = "00" else -- Saída = soma das portas A e B
			  in_a - in_b when op = "01" else -- Saída = subtração das portas A e B
              "0000000000000000";
	-- Se for alguma das comparações		  
	out_b <=  '1' when in_a < in_b and op = "10" else -- Saída = 1 se B > A
			  '1' when in_a > in_b and op = "11" else -- Saída = 1 se A > B
			  '0';
end architecture;
