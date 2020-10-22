LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY pc IS
	PORT (
		clk : IN std_logic; -- Porta do clock do PC
		rst : IN std_logic; -- Porta do reset do PC
		wr_en_pc : IN std_logic; -- Porta do enable para escrever no PC
		data_in_pc : IN unsigned(6 DOWNTO 0) := "0000000"; -- DATA do próximo endereço do PC

		data_out_pc : OUT unsigned(6 DOWNTO 0) := "0000000" -- DATA do endereço atual do PC
	);
END ENTITY;

ARCHITECTURE a_pc OF pc IS
	SIGNAL registro : unsigned(6 DOWNTO 0) := "0000000"; -- Memória do PC

BEGIN

	PROCESS (clk, rst, wr_en_pc)
	BEGIN
		IF rst = '1' THEN -- Se o reset = 1, memória = 0x00#
			registro <= "0000000";
		ELSIF wr_en_pc = '1' THEN -- Se o reset = 0 e o enable = 1
			IF rising_edge(clk) THEN -- Na borda de subida do clock, registra o próximo endereço do programa na memória do PC
				registro <= data_in_pc;
			END IF;
		END IF;
	END PROCESS;

	data_out_pc <= registro; -- Envia o endereço atual pra ROM
END ARCHITECTURE;