LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY rom_tb IS
END;

ARCHITECTURE a_rom_tb OF rom_tb IS
	COMPONENT rom
		PORT (
			clk : IN std_logic; -- Clock da ROM
			endereco : IN unsigned(6 DOWNTO 0) := "0000000"; -- Endereço da ROM
			dado : OUT unsigned(16 DOWNTO 0) := "00000000000000000" -- Instrução correspondente ao endereço na ROM
		);
	END COMPONENT;

	SIGNAL clk : std_logic;
	SIGNAL endereco : unsigned(6 DOWNTO 0) := "0000000";
	SIGNAL dado : unsigned(16 DOWNTO 0) := "00000000000000000";

BEGIN

	uut : rom PORT MAP(
		clk => clk, -- Conectando as portas da ROM
		endereco => endereco,
		dado => dado
	);
	-- Início do tb da ROM
	PROCESS
		-- Rotina de clock
	BEGIN
		clk <= '0';
		WAIT FOR 50 ns;

		clk <= '1';
		WAIT FOR 50 ns;

	END PROCESS;
	-- Rotina de teste
	PROCESS

	BEGIN

		endereco <= "0000000"; -- Endereço = 0x00
		WAIT FOR 100 ns;

		endereco <= "0000001"; -- Endereço = 0x01
		WAIT FOR 100 ns;

		endereco <= "0000010"; -- Endereço = 0x02
		WAIT FOR 100 ns;

		endereco <= "0000011"; -- Endereço = 0x03
		WAIT FOR 100 ns;

		endereco <= "0000100"; -- Endereço = 0x04
		WAIT FOR 100 ns;

		endereco <= "0000101"; -- Endereço = 0x05
		WAIT FOR 100 ns;

		endereco <= "0000110"; -- Endereço = 0x06
		WAIT FOR 100 ns;

		endereco <= "0000111"; -- Endereço = 0x07
		WAIT FOR 100 ns;

		endereco <= "0010100"; -- Endereço = 0x14
		WAIT FOR 100 ns;

		endereco <= "0010101"; -- Endereço = 0x15
		WAIT FOR 100 ns;

		endereco <= "0001000"; -- Endereço = 0x08
		WAIT FOR 100 ns;
		WAIT;

	END PROCESS;
END ARCHITECTURE;