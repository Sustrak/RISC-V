library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity datapath is 
	port (
		-- REGFILE
		i_clk_proc : in std_logic;
		i_wr_reg : in std_logic;
		i_addr_d_reg : in std_logic_vector(R_REGS);
		-- ALU
		i_immed : in std_logic_vector(R_IMMED);
		i_alu_opcode : in std_logic_vector(R_OP_CODE);
		-- CONTROL
		i_rb_imm : in std_logic;
		-- BRANCH
		i_pc_br : in std_logic_vector(R_XLEN)
	);
end datapath;

architecture Structure of datapath is
	component reg_file
		port (
			i_clk_proc : in std_logic;
			i_wr : in std_logic;
			i_data : in std_logic_vector(R_XLEN);
			i_addr_d : in std_logic_vector(R_REGS)
		);
	end component;
	component alu
		port (
			i_adata: in std_logic_vector(R_XLEN);
			i_bdata: in std_logic_vector(R_XLEN);
			i_opcode: in std_logic_vector(R_OP_CODE);
			o_wdata: out std_logic_vector(R_XLEN);
			o_overflow : out std_logic
		);
	end component;
	component reg_id_ex
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
	end component;
	component reg_ex_mem is
		port (
			i_clk_proc : in std_logic;
			i_wdata : in std_logic_vector(R_XLEN);
			i_addr_d_reg : in std_logic_vector(R_REGS);
			i_wr_reg : in std_logic;
			o_wdata : out std_logic_vector(R_XLEN);
			o_addr_d_reg : out std_logic_vector(R_REGS);
			o_wr_reg : out std_logic	
		);
	end component;
	component reg_mem_wb is
		port (
			i_clk_proc : in std_logic;
			i_addr_d_reg : in std_logic_vector(R_REGS);
			i_wr_reg : in std_logic;
			i_wdata : in std_logic_vector(R_XLEN);
			o_addr_d_reg : out std_logic_vector(R_REGS);
			o_wr_reg : out std_logic;
			o_wdata : out std_logic_vector(R_XLEN)
		);
	end component;
	-- SIGNALS
	signal s_wdata : std_logic_vector(R_XLEN);
	signal s_bdata : std_logic_vector(R_XLEN);
	signal s_adata : std_logic_vector(R_XLEN);
	signal s_reg_a : std_logic_vector(R_XLEN);
	signal s_reg_b : std_logic_vector(R_XLEN);
	-- id/ex
	signal s_wr_reg_idex : std_logic;
	signal s_immed_idex : std_logic_vector(R_IMMED);
	signal s_rb_imm_idex : std_logic;
	signal s_addr_d_reg_idex : std_logic_vector(R_REGS);
	signal s_alu_opcode_idex : std_logic_vector(R_OP_CODE);
	signal s_reg_a_idex : std_logic_vector(R_XLEN);
	signal s_reg_b_idex : std_logic_vector(R_XLEN);
	signal s_adata_idex : std_logic_vector(R_XLEN);
	signal s_bdata_idex : std_logic_vector(R_XLEN);
	signal s_pc_idex : std_logic_vector(R_XLEN);
	-- ex/mem
	signal s_wdata_exmem : std_logic_vector(R_XLEN);
	signal s_addr_d_reg_exmem : std_logic_vector(R_REGS);
	signal s_wr_reg_exmem : std_logic;
	signal s_overflow_exmem : std_logic;
	-- mem/wb
	signal s_wr_reg_memwb : std_logic; 
	signal s_addr_d_reg_memwb : std_logic_vector(R_REGS);	
	signal s_wdata_memwb : std_logic_vector(R_XLEN);
	
begin
	c_reg_file: reg_file
	port map (
		i_clk_proc => i_clk_proc,
		i_wr => s_wr_reg_memwb,
		i_data => s_wdata_memwb,
		i_addr_d => s_addr_d_reg_memwb
	);
	c_alu: alu
	port map (
		i_adata => s_adata_idex,
		i_bdata => s_bdata,
		i_opcode => s_alu_opcode_idex,
		o_wdata => s_wdata,
		o_overflow => s_overflow_exmem
	);	
	c_reg_id_ex: reg_id_ex
	port map (
		i_clk_proc => i_clk_proc,
		i_pc => i_pc_br,
		i_reg_a => s_reg_a,
		i_reg_b => s_reg_b,
		i_wr_reg => i_wr_reg,
		i_immed => i_immed,
		i_rb_imm => i_rb_imm,
		i_addr_d_reg => i_addr_d_reg,
		i_alu_opcode => i_alu_opcode,
		o_pc => s_pc_idex,
		o_reg_a => s_reg_a_idex,
		o_reg_b => s_reg_b_idex,
		o_wr_reg => s_wr_reg_idex,
		o_immed => s_immed_idex,
		o_rb_imm => s_rb_imm_idex,
		o_addr_d_reg => s_addr_d_reg_idex,
		o_alu_opcode => s_alu_opcode_idex
	);
	c_reg_ex_mem : reg_ex_mem
	port map (
		i_clk_proc => i_clk_proc,
		i_wdata => s_wdata,
		i_addr_d_reg => s_addr_d_reg_idex,
		i_wr_reg => s_wr_reg_idex,
		o_wdata => s_wdata_exmem,
		o_addr_d_reg => s_addr_d_reg_exmem,
		o_wr_reg => s_wr_reg_exmem
	);
	c_reg_mem_wb : reg_mem_wb
	port map (
		i_clk_proc => i_clk_proc,
		i_addr_d_reg => s_addr_d_reg_exmem,
		i_wr_reg => s_wr_reg_exmem,
		i_wdata => s_wdata_exmem,
		o_addr_d_reg => s_addr_d_reg_memwb,
		o_wr_reg => s_wr_reg_memwb,
		o_wdata => s_wdata_memwb
	);

	s_bdata <=  s_immed_idex & x"000" when s_alu_opcode_idex = ALU_LUI else
			   (others => '0');
end Structure;
