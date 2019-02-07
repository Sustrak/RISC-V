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
		i_alu_mem : in std_logic;
		i_port_b_reg : in std_logic_vector(R_XLEN);
		o_port_b_reg : out std_logic_vector(R_XLEN);
		o_wdata : out std_logic_vector(R_XLEN);
		o_addr_d_reg : out std_logic_vector(R_REGS);
		o_wr_reg : out std_logic;
		o_alu_mem : out std_logic;
		-- MEMORY
		i_ld_st : in std_logic;
		i_bhw : in std_logic_vector(R_MEM_ACCS);
		o_ld_st : out std_logic;
		o_bhw : out std_logic_vector(R_MEM_ACCS);
		i_mem_unsigned : in std_logic;
		o_mem_unsigned : out std_logic
	);
end reg_ex_mem;

architecture Structure of reg_ex_mem is
	signal s_wdata : std_logic_vector(R_XLEN);
	signal s_addr_d_reg : std_logic_vector(R_REGS);
	signal s_port_b_reg : std_logic_vector(R_XLEN);
	signal s_wr_reg : std_logic;
	signal s_id_st : std_logic;
	signal s_alu_mem : std_logic;
	signal s_ld_st : std_logic;
	signal s_bhw : std_logic_vector(R_MEM_ACCS);
	signal s_mem_unsigned : std_logic
begin
	process (i_clk_proc)
	begin
		if rising_edge(i_clk_proc) then
			s_wdata <= i_wdata;
			s_addr_d_reg <= i_addr_d_reg;
			s_port_b_reg <= i_port_b_reg;
			s_wr_reg <= i_wr_reg;
			s_alu_mem <= i_alu_mem;
			s_ld_st <= i_ld_st;
			s_bhw <= i_bhw;
			s_mem_unsigned <= i_mem_unsigned;
		end if;
	end process;
	o_wdata <= s_wdata;
	o_addr_d_reg <= s_addr_d_reg;
	o_port_b_reg <= s_port_b_reg;
	o_wr_reg <= s_wr_reg;
	o_alu_mem <= s_alu_mem;
	o_ld_st <= s_ld_st;
	o_bhw <= s_bhw;
	o_mem_unsigned <= s_mem_unsigned;
end Structure;
