LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY maq_estados_tb IS
END ENTITY;

ARCHITECTURE a_maq_estados_tb OF maq_estados_tb IS
	COMPONENT maq_estados
		PORT (
			clk, rst : IN std_logic; -- Portas de clock e reset da FSM

			enable_pc : OUT std_logic; -- Porta lógica de enable da escrita no PC
			enable_rom : OUT std_logic; -- Porta lógica de enable da escrita no REG_ROM
			enable_banco : OUT std_logic; -- Porta lógica de enable da escrita no Banco de registradores
			estado : OUT unsigned(1 DOWNTO 0) := "00" -- Porta para indicar o estado atual da FSM
		);
	END COMPONENT;

	SIGNAL clk, rst, enable_pc, enable_rom, enable_banco : std_logic;
	SIGNAL estado : unsigned(1 DOWNTO 0) := "00";

BEGIN

	uut : maq_estados PORT MAP(
		clk => clk, -- Conectando as portas da FSM
		rst => rst,
		enable_pc => enable_pc,
		enable_rom => enable_rom,
		enable_banco => enable_banco,
		estado => estado
	);
	-- Início do tb da FSM
	PROCESS
		-- Rotina de inicialização/teste
	BEGIN

		clk <= '0';
		WAIT FOR 50 ns;

		clk <= '1';
		WAIT FOR 50 ns;

	END PROCESS;

	PROCESS

	BEGIN

		rst <= '1';
		WAIT FOR 100 ns;

		rst <= '0';
		WAIT;
	END PROCESS;
END ARCHITECTURE;