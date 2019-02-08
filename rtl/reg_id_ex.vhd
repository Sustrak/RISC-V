library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity reg_id_ex is
	port (
		i_clk_proc     : in std_logic;
		i_pc           : in std_logic_vector(R_XLEN);
		-- REGS
		i_wr_reg       : in std_logic;
		i_addr_d_reg   : in std_logic_vector(R_REGS);
		i_port_a_reg   : in std_logic_vector(R_XLEN);
		i_port_b_reg   : in std_logic_vector(R_XLEN);
		o_port_a_reg   : out std_logic_vector(R_XLEN);
		o_port_b_reg   : out std_logic_vector(R_XLEN);
		i_immed        : in std_logic_vector(R_IMMED);
		i_rb_imm       : in std_logic;
		i_alu_mem      : in std_logic;
		i_alu_opcode   : in std_logic_vector(R_OP_CODE);
		o_pc           : out std_logic_vector(R_XLEN);
		o_wr_reg       : out std_logic;
		o_immed        : out std_logic_vector(R_IMMED);
		o_rb_imm       : out std_logic;
		o_alu_mem      : out std_logic;
		o_addr_d_reg   : out std_logic_vector(R_REGS);
		o_alu_opcode   : out std_logic_vector(R_OP_CODE);
		-- MEMORY
		i_ld_st        : in std_logic;
		i_bhw          : in std_logic_vector(R_MEM_ACCS);
		o_ld_st        : out std_logic;
		o_bhw          : out std_logic_vector(R_MEM_ACCS);
		i_mem_unsigned : in std_logic;
		o_mem_unsigned : out std_logic
	);
end reg_id_ex;

architecture Structure of reg_id_ex is
	signal s_pc           : std_logic_vector(R_XLEN);
	signal s_wr_reg       : std_logic;
	signal s_immed        : std_logic_vector(R_IMMED);
	signal s_rb_imm       : std_logic;
	signal s_alu_mem      : std_logic;
	signal s_addr_d_reg   : std_logic_vector(R_REGS);
	signal s_alu_opcode   : std_logic_vector(R_OP_CODE);
	signal s_ld_st        : std_logic;
	signal s_bhw          : std_logic_vector(R_MEM_ACCS);
	signal s_port_a_reg   : std_logic_vector(R_XLEN);
	signal s_port_b_reg   : std_logic_vector(R_XLEN);
	signal s_mem_unsigned : std_logic;
begin
	process (i_clk_proc)
	begin
		if rising_edge(i_clk_proc) then
			s_pc           <= i_pc;
			s_wr_reg       <= i_wr_reg;
			s_immed        <= i_immed;
			s_rb_imm       <= i_rb_imm;
			s_alu_mem      <= i_alu_mem;
			s_addr_d_reg   <= i_addr_d_reg;
			s_alu_opcode   <= i_alu_opcode;
			s_ld_st        <= i_ld_st;
			s_bhw          <= i_bhw;
			s_port_a_reg   <= i_port_a_reg;
			s_port_b_reg   <= i_port_b_reg;
			s_mem_unsigned <= i_mem_unsigned;
		end if;
	end process;

	o_pc           <= s_pc;
	o_wr_reg       <= s_wr_reg;
	o_immed        <= s_immed;
	o_rb_imm       <= s_rb_imm;
	o_alu_mem      <= s_alu_mem;
	o_addr_d_reg   <= s_addr_d_reg;
	o_alu_opcode   <= s_alu_opcode;
	o_ld_st        <= s_ld_st;
	o_bhw          <= s_bhw;
	o_port_a_reg   <= s_port_a_reg;
	o_port_b_reg   <= s_port_b_reg;
	o_mem_unsigned <= s_mem_unsigned;
end Structure;