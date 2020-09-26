library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port(	clk		:in std_logic; -- Porta do clock do pc
			rst		:in std_logic; -- Porta do reset do pc
			wr_en	:in std_logic; -- Porta do enable para escrever no pc
			data_in	:in unsigned(6 downto 0):= "0000000"; -- DATA da entrada do pc

			data_out:out unsigned(6 downto 0):= "0000000" -- DATA da saída do pc
	);
end entity;

architecture a_pc of pc is
	signal registro: unsigned(6 downto 0); -- Memória do pc

begin

	process(clk,rst,wr_en)
	begin
		if rst = '1' then -- Se o reset = 1, memória = 0x0000#
			registro <= "0000000";
		elsif wr_en = '1' then -- Se o reset = 0 e o enable = 1
			if rising_edge(clk) then -- Na borda de subida do clock, registra a informação na entrada do pc na memória
				registro <= data_in;
			end if;
		end if;
	end process;

	data_out <= registro;
end architecture;

