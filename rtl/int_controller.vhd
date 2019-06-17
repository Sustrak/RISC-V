library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity int_controller is
	port (
		i_clk     : in std_logic;
		i_reset   : in std_logic;
		i_int_ack : in std_logic;
		i_int_sw  : in std_logic;
		i_int_key : in std_logic;
		i_int_ps2 : in std_logic;
		o_int     : out std_logic;
		o_mcause  : out std_logic_vector(R_XLEN)
	);
end int_controller;

architecture Structure of int_controller is
	component edge_detector is
		port (
			i_clk    : in std_logic;
			i_signal : in std_logic;
			i_data   : in std_logic_vector(R_XLEN);
			o_data   : out std_logic_vector(R_XLEN);
			o_edge   : out std_logic
		);
	end component;

	signal s_edge_int_sw  : std_logic;
	signal s_edge_int_key : std_logic;
	signal s_edge_int_ps2 : std_logic;
	signal s_mcause       : std_logic_vector(R_XLEN);

	-- IO devices
	signal s_int_sw       : std_logic;
	signal s_int_key      : std_logic;
	signal s_int_ps2      : std_logic;

begin
	c_edge_detector_sw : edge_detector
	port map(
		i_clk    => i_clk,
		i_signal => i_int_sw,
		i_data => (others => '0'),
		o_data   => open,
		o_edge   => s_edge_int_sw
	);

	c_edge_detector_key : edge_detector
	port map(
		i_clk    => i_clk,
		i_signal => i_int_key,
		i_data => (others => '0'),
		o_data   => open,
		o_edge   => s_edge_int_key
	);

	c_edge_detector_ps2 : edge_detector
	port map(
		i_clk    => i_clk,
		i_signal => i_int_ps2,
		i_data => (others => '0'),
		o_data   => open,
		o_edge   => s_edge_int_ps2
	);

	int_capture : process (i_clk, i_reset)
	begin
		if rising_edge(i_clk) then
			if i_int_ack = '1' then
				if s_int_sw = '1' then
					s_int_sw <= '0';
					s_mcause <= MCAUSE_SW;
				elsif s_int_key = '1' then
					s_int_key <= '0';
					s_mcause  <= MCAUSE_KEY;
				elsif s_int_ps2 = '1' then
					s_int_ps2 <= '0';
					s_mcause  <= MCAUSE_PS2;
				end if;
			end if;
			if s_edge_int_sw = '1' then
				s_int_sw <= '1';
			end if;
			if s_edge_int_key = '1' then
				s_int_key <= '1';
			end if;
			if s_edge_int_ps2 = '1' then
				s_int_ps2 <= '1';
			end if;
		end if;
		if i_reset = '1' then
			s_int_sw  <= '0';
			s_int_key <= '0';
			s_int_ps2 <= '0';
			s_mcause  <= MCAUSE_NO_INT;
		end if;
	end process;

	o_mcause <= s_mcause;
	o_int    <= s_int_sw or s_int_key or s_int_ps2;

end Structure;