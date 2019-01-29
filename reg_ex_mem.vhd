library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity reg_ex_mem is
	port (
		i_clk_proc : in std_logic;
		i_wdata : in std_logic_vector(R_XLEN);
		i_addr_d_reg : in std_logic_vector(R_REGS);
		i_wr_reg : in std_logic;
		o_wdata : out std_logic_vector(R_XLEN);
		o_addr_d_reg : out std_logic_vector(R_REGS);
		o_wr_reg : out std_logic	
	);
end reg_ex_mem;

architecture Structure of reg_ex_mem is
	signal s_wdata : std_logic_vector(R_XLEN);
	signal s_addr_d_reg : std_logic_vector(R_REGS);
	signal s_wr_reg : std_logic;
begin
	process (i_clk_proc)
	begin
		if rising_edge(i_clk_proc) then
			s_wdata <= i_wdata;
			s_addr_d_reg <= i_addr_d_reg;
			s_wr_reg <= i_wr_reg;
		end if;
	end process;
	o_wdata <= s_wdata;
	o_addr_d_reg <= s_addr_d_reg;
	o_wr_reg <= s_wr_reg;
end Structure;
