library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maq_estados is
	port(	clk:	in std_logic;
			rst:	in std_logic;
			estado: out std_logic
		);
end entity;

architecture a_maq_estados of maq_estados is

	signal estado_int: std_logic;

begin

	process(clk,rst)
	begin
		if rst = '1' then
			estado_int <= '0';
		elsif(rising_edge(clk)) then
			estado_int <= not estado_int;
		end if;
	end process;
	estado <= estado_int;
end architecture;