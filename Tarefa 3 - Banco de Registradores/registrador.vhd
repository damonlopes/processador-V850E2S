library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registrador is
	port(	clk		:in std_logic; -- Porta do clock do registrador
			rst		:in std_logic; -- Porta do reset do registrador
			wr_en	:in std_logic; -- Porta do enable para escrever no registrador
			data_in	:in unsigned(15 downto 0):= "0000000000000000"; -- DATA da entrada do registrador
			
			data_out:out unsigned(15 downto 0):= "0000000000000000" -- DATA da saída do registrador
	);
end entity;

architecture a_registrador of registrador is
	signal registro: unsigned(15 downto 0); -- Memória do registrador
	
begin
	
	process(clk,rst,wr_en)
	begin
		if rst = '1' then -- Se o reset = 1, memória = 0x0000#
			registro <= "0000000000000000";
		elsif wr_en = '1' then -- Se o reset = 0 e o enable = 1
			if rising_edge(clk) then -- Na borda de subida do clock, registra a informação na entrada do registrador na memória
				registro <= data_in;
			end if;
		end if;
	end process;
	
	data_out <= registro;
end architecture;

