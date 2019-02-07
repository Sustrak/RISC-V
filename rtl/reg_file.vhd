library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity reg_file is
	port (
		i_clk_proc : in std_logic;
		i_wr : in std_logic;
		i_data : in std_logic_vector(R_XLEN);
		i_addr_d : in std_logic_vector(R_REGS);
		i_addr_a : in std_logic_vector(R_REGS);
		i_addr_b : in std_logic_vector(R_REGS);
		o_port_a : out std_logic_vector(R_XLEN);
		o_port_b : out std_logic_vector(R_XLEN)
	);
end reg_file;

architecture Structure of reg_file is
	type reg_bank is array (R_NUM_REGS) of std_logic_vector (R_XLEN);
	signal s_regs : reg_bank;
begin
	process(i_clk_proc)
	begin
		if (rising_edge(i_clk_proc)) then
			if (i_wr = '1' and (unsigned(i_addr_d) /= 0)) then
				s_regs(to_integer(unsigned(i_addr_d))) <= i_data;
			end if;
		end if;
	end process;

	o_port_a <= s_regs(to_integer(unsigned(i_addr_a))) when unsigned(i_addr_a) /= 0 else
				(others => '0');

	o_port_b <= s_regs(to_integer(unsigned(i_addr_b))) when unsigned(i_addr_b) /= 0 else
				(others => '0');
end Structure;

