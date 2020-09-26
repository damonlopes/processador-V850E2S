library ieee;	
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity toplevel_pc_rom is
	port(	clk:		in std_logic;
			rst: 		in std_logic;
			saida_rom:	out unsigned(16 downto 0) := "00000000000000000"
	);
end entity;

architecture a_toplevel_pc_rom of toplevel_pc_rom is
	component rom is
		port( 	clk:		in std_logic;
				endereco:	in unsigned(6 downto 0) := "0000000";
				dado:		out unsigned(16 downto 0) := "00000000000000000"
		);
	end component;
	
	component pc is
		port(	clk		:in std_logic; -- Porta do clock do pc
				rst		:in std_logic; -- Porta do reset do pc
				wr_en	:in std_logic; -- Porta do enable para escrever no pc
				data_in	:in unsigned(6 downto 0):= "0000000"; -- DATA da entrada do pc

				data_out:out unsigned(6 downto 0):= "0000000" -- DATA da saída do pc
		);
	end component;
	
	component uc_jump is
		port(	data_rom:	in 	unsigned(16 downto 0):= "00000000000000000";
				jump_en:	out std_logic
		);
	end component;
	
	component mux_pc is
		port(	sel_mux_pc:	in std_logic; -- Porta seletora da mux_pc
				data0_mux_pc:	in unsigned(6 downto 0):= "0000000"; -- Entrada 0 da mux_pc
				data1_mux_pc:	in unsigned(6 downto 0):= "0000000"; -- Entrada 1 da mux_pc
	
				out_mux_pc:	out unsigned(6 downto 0):= "0000000" -- Saída da mux_pc
		);
	end component;
	
	component maq_estados is
		port(	clk:	in std_logic;
				rst:	in std_logic;
				estado: out std_logic
		);	
	end component;
		
	component adder_one_pc is
		port(	in_adder_one_pc:	in unsigned(6 downto 0):= "0000000"; -- Entrada da adder_one_pc

				out_adder_one_pc:	out unsigned(6 downto 0):= "0000000" -- Saída da adder_one_pc
		);	
	end component;
		
	signal saida_fsm, ctrl_mux: std_logic;
	signal saida_adder, saida_mux, saida_pc, entrada_mux: unsigned(6 downto 0):= "0000000";
	signal dado_rom: unsigned(16 downto 0):= "00000000000000000";
	
begin

	rom_top: rom port map(	clk => clk,
							endereco => saida_pc,
							dado => dado_rom
						);
	
	pc_top: pc port map(	clk => clk,
							rst => rst,
							wr_en => saida_fsm,
							data_in => saida_mux,
							data_out => saida_pc
						);
	
	uc_jump_top: uc_jump port map(	data_rom => dado_rom,
									jump_en => ctrl_mux
								);
								
	mux_pc_top: mux_pc port map(	sel_mux_pc => ctrl_mux,
									data0_mux_pc => saida_adder,
									data1_mux_pc => dado_rom(12 downto 6),
									out_mux_pc => saida_mux
								);
	
	maq_estados_top: maq_estados port map(	clk => clk,
											rst => rst,
											estado => saida_fsm
										);
	
	adder_one_pc_top: adder_one_pc port map(	in_adder_one_pc => saida_pc,
												out_adder_one_pc => saida_adder
											);
	saida_rom <= dado_rom;
	
end architecture;