LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY reg_rom IS
	PORT (
		clk : IN std_logic; -- Porta do clock do REG_ROM
		rst : IN std_logic; -- Porta do reset do REG_ROM
		wr_en_regrom : IN std_logic; -- Porta do enable para escrever no REG_ROM
		data_in_regrom : IN unsigned(16 DOWNTO 0) := "00000000000000000"; -- DATA da entrada do REG_ROM = Próxima instrução

		data_out_regrom : OUT unsigned(16 DOWNTO 0) := "00000000000000000" -- DATA da saída do REG_ROM = Instrução atual
	);
END ENTITY;

ARCHITECTURE a_reg_rom OF reg_rom IS
	SIGNAL registro : unsigned(16 DOWNTO 0) := "00000000000000000"; -- Memória do REG_ROM

BEGIN

	PROCESS (clk, rst, wr_en_regrom)
	BEGIN
		IF rst = '1' THEN -- Se o reset = 1, memória = 0x00000#
			registro <= "00000000000000000";
		ELSIF wr_en_regrom = '1' THEN -- Se o reset = 0 e o enable = 1
			IF rising_edge(clk) THEN -- Na borda de subida do clock, registra a instrução atual na memória do REG_ROM
				registro <= data_in_regrom;
			END IF;
		END IF;
	END PROCESS;

	data_out_regrom <= registro; -- Envia a instrução atual para o restante do circuito
END ARCHITECTURE;