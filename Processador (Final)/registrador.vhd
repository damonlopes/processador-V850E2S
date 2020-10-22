LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY registrador IS
	PORT (
		clk : IN std_logic; -- Porta do clock do registrador
		rst : IN std_logic; -- Porta do reset do registrador
		wr_en : IN std_logic; -- Porta do enable para escrever no registrador
		data_in : IN unsigned(15 DOWNTO 0) := "0000000000000000"; -- DATA da entrada do registrador

		data_out : OUT unsigned(15 DOWNTO 0) := "0000000000000000" -- DATA da saída do registrador
	);
END ENTITY;

ARCHITECTURE a_registrador OF registrador IS
	SIGNAL registro : unsigned(15 DOWNTO 0); -- Memória do registrador

BEGIN

	PROCESS (clk, rst, wr_en)
	BEGIN
		IF rst = '1' THEN -- Se o reset = 1, memória = 0x0000#
			registro <= "0000000000000000";
		ELSIF wr_en = '1' THEN -- Se o reset = 0 e o enable = 1
			IF rising_edge(clk) THEN -- Na borda de subida do clock, registra a informação da entrada do registrador na memória
				registro <= data_in;
			END IF;
		END IF;
	END PROCESS;

	data_out <= registro; -- Envia a informação da memória para a saída
END ARCHITECTURE;