library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity reg_id_ex is
	port (
		i_clk_proc : in std_logic;
		i_pc : in std_logic_vector(R_XLEN);
		i_reg_a : in std_logic_vector(R_XLEN);
		i_reg_b : in std_logic_vector(R_XLEN);
		i_wr_reg : in std_logic;
		i_immed : in std_logic_vector(R_IMMED);
		i_rb_imm : in std_logic;
		i_addr_d_reg : in std_logic_vector(R_REGS);
		i_alu_opcode : in std_logic_vector(R_OP_CODE);
		o_pc : out std_logic_vector(R_XLEN);
		o_reg_a : out std_logic_vector(R_XLEN);
		o_reg_b : out std_logic_vector(R_XLEN);
		o_wr_reg : out std_logic;
		o_immed : out std_logic_vector(R_IMMED);
		o_rb_imm : out std_logic;
		o_addr_d_reg : out std_logic_vector(R_REGS);
		o_alu_opcode : out std_logic_vector(R_OP_CODE)
	);
end reg_id_ex;

architecture Structure of reg_id_ex is
	signal s_pc : std_logic_vector(R_XLEN);
	signal s_reg_a : std_logic_vector(R_XLEN);
	signal s_reg_b : std_logic_vector(R_XLEN);
	signal s_wr_reg : std_logic;
	signal s_immed : std_logic_vector(R_IMMED);
	signal s_rb_imm : std_logic;
	signal s_addr_d_reg : std_logic_vector(R_REGS);
	signal s_alu_opcode : std_logic_vector(R_OP_CODE);
begin
	process (i_clk_proc)
	begin
		if rising_edge(i_clk_proc) then
			s_pc <= i_pc;
			s_reg_a <= i_reg_a;
			s_reg_b <= i_reg_b;
			s_wr_reg <= i_wr_reg;
			s_immed <= i_immed;
			s_rb_imm <= i_rb_imm;
			s_addr_d_reg <= i_addr_d_reg;
			s_alu_opcode <= i_alu_opcode;
		end if;
	end process;
	
	o_pc <= s_pc;
	o_reg_a <= s_reg_a;
	o_reg_b <= s_reg_b;
	o_wr_reg <= s_wr_reg;
	o_immed <= s_immed;
	o_rb_imm <= s_rb_imm;
	o_addr_d_reg <= s_addr_d_reg;
	o_alu_opcode <= s_alu_opcode;
end Structure;
