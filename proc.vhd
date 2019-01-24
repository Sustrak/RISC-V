library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity proc is
	port (
		i_boot : in std_logic;
		i_clk_proc : in std_logic;
		i_rdata_mem : in std_logic_vector(R_XLEN);
		o_wdata_mem : out std_logic_vector(R_XLEN);
		o_addr_mem : out std_logic_vector(R_XLEN)
	);
end proc;

architecture Structure of proc is
	component datapath is
		port (
			-- REGFILE
			i_clk_proc : in std_logic;
			i_wr_reg : in std_logic;
			i_addr_d : in std_logic_vector(R_REGS);
			-- ALU
			i_immed : in std_logic_vector(R_IMMED);
			i_alu_opcode : in std_logic_vector(R_OP_CODE);
			-- CONTROL
			i_rb_imm : in std_logic
		);
	end component;
	component control_unit is
		port (
			i_boot : in std_logic;
			i_clk_proc: in std_logic;
			i_ins : in std_logic_vector(R_INS);
			-- ALU
			o_alu_opcode : out std_logic_vector(R_OP_CODE);
			o_immed : out std_logic_vector(R_IMMED);
			-- PC
			o_pc : out std_logic_vector(R_XLEN);
			-- REGS
			o_addr_d_reg : out std_logic_vector(R_REGS);
			o_wr_reg : out std_logic;			
			--CONTROL
			o_rb_imm : out std_logic			
		);
	end component;

	signal s_wr_reg : std_logic;
	signal s_addr_d : std_logic_vector(R_REGS);
	signal s_immed : std_logic_vector(R_IMMED);
	signal s_alu_opcode : std_logic_vector(R_OP_CODE);
	signal s_rb_imm : std_logic;
begin
	c_datapath: datapath
		port map (
			i_clk_proc => i_clk_proc,
			i_wr_reg => s_wr_reg,
			i_addr_d => s_addr_d,
			i_immed => s_immed,
			i_alu_opcode => s_alu_opcode,
			i_rb_imm => s_rb_imm
		);
	c_cu : control_unit
		port map (
			i_boot => i_boot,
			i_clk_proc => i_clk_proc,
			i_ins => i_rdata_mem,
			o_alu_opcode => s_alu_opcode,
			o_immed => s_immed,
			o_pc => o_addr_mem,
			o_addr_d_reg => s_addr_d,
			o_wr_reg => s_wr_reg
		);
end Structure;
