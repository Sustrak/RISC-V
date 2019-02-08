library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity datapath is
	port (
		-- REGFILE
		i_clk_proc     : in std_logic;
		i_wr_reg       : in std_logic;
		i_addr_d_reg   : in std_logic_vector(R_REGS);
		i_addr_a_reg   : in std_logic_vector(R_REGS);
		i_addr_b_reg   : in std_logic_vector(R_REGS);
		-- ALU
		i_immed        : in std_logic_vector(R_IMMED);
		i_alu_opcode   : in std_logic_vector(R_OP_CODE);
		-- CONTROL
		i_rb_imm       : in std_logic;
		i_alu_mem      : in std_logic;
		-- BRANCH
		i_pc_br        : in std_logic_vector(R_XLEN);
		-- MEMORY
		i_rdata_mem    : in std_logic_vector(R_XLEN);
		o_wdata_mem    : out std_logic_vector(R_XLEN);
		o_addr_mem     : out std_logic_vector(R_XLEN);
		i_ld_st        : in std_logic;
		i_bhw          : in std_logic_vector(R_MEM_ACCS);
		o_ld_st        : out std_logic;
		o_bhw          : out std_logic_vector(R_MEM_ACCS);
		i_mem_unsigned : in std_logic
	);
end datapath;

architecture Structure of datapath is
	component reg_file
		port (
			i_clk_proc : in std_logic;
			i_wr       : in std_logic;
			i_data     : in std_logic_vector(R_XLEN);
			i_addr_d   : in std_logic_vector(R_REGS);
			i_addr_a   : in std_logic_vector(R_REGS);
			i_addr_b   : in std_logic_vector(R_REGS);
			o_port_a   : out std_logic_vector(R_XLEN);
			o_port_b   : out std_logic_vector(R_XLEN)
		);
	end component;
	component alu
		port (
			i_adata    : in std_logic_vector(R_XLEN);
			i_bdata    : in std_logic_vector(R_XLEN);
			i_opcode   : in std_logic_vector(R_OP_CODE);
			o_wdata    : out std_logic_vector(R_XLEN);
			o_overflow : out std_logic
		);
	end component;
	component reg_id_ex
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
			o_addr_d_reg   : out std_logic_vector(R_REGS);
			i_immed        : in std_logic_vector(R_IMMED);
			i_rb_imm       : in std_logic;
			i_alu_mem      : in std_logic;
			i_alu_opcode   : in std_logic_vector(R_OP_CODE);
			o_pc           : out std_logic_vector(R_XLEN);
			o_wr_reg       : out std_logic;
			o_immed        : out std_logic_vector(R_IMMED);
			o_rb_imm       : out std_logic;
			o_alu_mem      : out std_logic;
			o_alu_opcode   : out std_logic_vector(R_OP_CODE);
			-- MEMORY
			i_ld_st        : in std_logic;
			i_bhw          : in std_logic_vector(R_MEM_ACCS);
			o_ld_st        : out std_logic;
			o_bhw          : out std_logic_vector(R_MEM_ACCS);
			i_mem_unsigned : in std_logic;
			o_mem_unsigned : out std_logic
		);
	end component;
	component reg_ex_mem is
		port (
			i_clk_proc     : in std_logic;
			i_wdata        : in std_logic_vector(R_XLEN);
			i_addr_d_reg   : in std_logic_vector(R_REGS);
			i_wr_reg       : in std_logic;
			i_alu_mem      : in std_logic;
			i_port_b_reg   : in std_logic_vector(R_XLEN);
			o_port_b_reg   : out std_logic_vector(R_XLEN);
			o_wdata        : out std_logic_vector(R_XLEN);
			o_addr_d_reg   : out std_logic_vector(R_REGS);
			o_wr_reg       : out std_logic;
			o_alu_mem      : out std_logic;
			-- MEMORY
			i_ld_st        : in std_logic;
			i_bhw          : in std_logic_vector(R_MEM_ACCS);
			o_ld_st        : out std_logic;
			o_bhw          : out std_logic_vector(R_MEM_ACCS);
			i_mem_unsigned : in std_logic;
			o_mem_unsigned : out std_logic
		);
	end component;
	component reg_mem_wb is
		port (
			i_clk_proc   : in std_logic;
			i_addr_d_reg : in std_logic_vector(R_REGS);
			i_wr_reg     : in std_logic;
			i_wdata      : in std_logic_vector(R_XLEN);
			o_addr_d_reg : out std_logic_vector(R_REGS);
			o_wr_reg     : out std_logic;
			o_wdata      : out std_logic_vector(R_XLEN)
		);
	end component;
	component sign_extensor is
		port (
			i_data     : in std_logic_vector(R_XLEN);
			i_bhw      : in std_logic_vector(R_MEM_ACCS);
			i_unsigned : in std_logic;
			o_data     : out std_logic_vector(R_XLEN)
		);
	end component;
	-- SIGNALS
	signal s_wdata              : std_logic_vector(R_XLEN);
	signal s_port_a             : std_logic_vector(R_XLEN);
	signal s_port_b             : std_logic_vector(R_XLEN);
	signal s_bdata              : std_logic_vector(R_XLEN);
	signal s_overflow           : std_logic;
	signal s_wdata_mem_alu      : std_logic_vector(R_XLEN);
	signal s_rdata_mem_ws       : std_logic_vector(R_XLEN);
	-- id/ex
	signal s_wr_reg_idex        : std_logic;
	signal s_alu_mem_idex       : std_logic;
	signal s_immed_idex         : std_logic_vector(R_IMMED);
	signal s_rb_imm_idex        : std_logic;
	signal s_addr_d_reg_idex    : std_logic_vector(R_REGS);
	signal s_alu_opcode_idex    : std_logic_vector(R_OP_CODE);
	signal s_port_a_reg_idex    : std_logic_vector(R_XLEN);
	signal s_port_b_reg_idex    : std_logic_vector(R_XLEN);
	signal s_adata_idex         : std_logic_vector(R_XLEN);
	signal s_bdata_idex         : std_logic_vector(R_XLEN);
	signal s_pc_idex            : std_logic_vector(R_XLEN);
	signal s_ld_st_idex         : std_logic;
	signal s_bhw_idex           : std_logic_vector(R_MEM_ACCS);
	signal s_mem_unsigned_idex  : std_logic;
	-- ex/mem
	signal s_wdata_exmem        : std_logic_vector(R_XLEN);
	signal s_addr_d_reg_exmem   : std_logic_vector(R_REGS);
	signal s_port_b_reg_exmem   : std_logic_vector(R_XLEN);
	signal s_wr_reg_exmem       : std_logic;
	signal s_alu_mem_exmem      : std_logic;
	signal s_mem_unsigned_exmem : std_logic;
	signal s_bhw_exmem          : std_logic_vector(R_MEM_ACCS);
	-- mem/wb
	signal s_wr_reg_memwb       : std_logic;
	signal s_addr_d_reg_memwb   : std_logic_vector(R_REGS);
	signal s_wdata_memwb        : std_logic_vector(R_XLEN);

begin
	c_reg_file : reg_file
	port map(
		i_clk_proc => i_clk_proc,
		i_wr       => s_wr_reg_memwb,
		i_data     => s_wdata_memwb,
		i_addr_d   => s_addr_d_reg_memwb,
		i_addr_a   => i_addr_a_reg,
		i_addr_b   => i_addr_b_reg,
		o_port_a   => s_port_a,
		o_port_b   => s_port_b
	);
	c_alu : alu
	port map(
		i_adata    => s_port_a_reg_idex,
		i_bdata    => s_bdata,
		i_opcode   => s_alu_opcode_idex,
		o_wdata    => s_wdata,
		o_overflow => s_overflow
	);
	c_reg_id_ex : reg_id_ex
	port map(
		i_clk_proc     => i_clk_proc,
		i_pc           => i_pc_br,
		-- REGS
		i_wr_reg       => i_wr_reg,
		o_wr_reg       => s_wr_reg_idex,
		i_addr_d_reg   => i_addr_d_reg,
		o_addr_d_reg   => s_addr_d_reg_idex,
		i_port_a_reg   => s_port_a,
		o_port_a_reg   => s_port_a_reg_idex,
		i_port_b_reg   => s_port_b,
		o_port_b_reg   => s_port_b_reg_idex,
		i_immed        => i_immed,
		i_rb_imm       => i_rb_imm,
		i_alu_mem      => i_alu_mem,
		i_alu_opcode   => i_alu_opcode,
		o_pc           => s_pc_idex,
		o_immed        => s_immed_idex,
		o_rb_imm       => s_rb_imm_idex,
		o_alu_mem      => s_alu_mem_idex,
		o_alu_opcode   => s_alu_opcode_idex,
		-- MEMORY
		i_ld_st        => i_ld_st,
		i_bhw          => i_bhw,
		o_ld_st        => s_ld_st_idex,
		o_bhw          => s_bhw_idex,
		i_mem_unsigned => i_mem_unsigned,
		o_mem_unsigned => s_mem_unsigned_idex
	);
	c_reg_ex_mem : reg_ex_mem
	port map(
		i_clk_proc     => i_clk_proc,
		i_wdata        => s_wdata,
		i_addr_d_reg   => s_addr_d_reg_idex,
		i_wr_reg       => s_wr_reg_idex,
		i_alu_mem      => s_alu_mem_idex,
		i_port_b_reg   => s_port_b_reg_idex,
		o_port_b_reg   => s_port_b_reg_exmem,
		o_wdata        => s_wdata_exmem,
		o_addr_d_reg   => s_addr_d_reg_exmem,
		o_wr_reg       => s_wr_reg_exmem,
		o_alu_mem      => s_alu_mem_exmem,
		-- MEMORY
		i_ld_st        => s_ld_st_idex,
		i_bhw          => s_bhw_idex,
		o_ld_st        => o_ld_st,
		o_bhw          => s_bhw_exmem,
		i_mem_unsigned => i_mem_unsigned,
		o_mem_unsigned => s_mem_unsigned_exmem
	);
	c_reg_mem_wb : reg_mem_wb
	port map(
		i_clk_proc   => i_clk_proc,
		i_addr_d_reg => s_addr_d_reg_exmem,
		i_wr_reg     => s_wr_reg_exmem,
		i_wdata      => s_wdata_mem_alu,
		o_addr_d_reg => s_addr_d_reg_memwb,
		o_wr_reg     => s_wr_reg_memwb,
		o_wdata      => s_wdata_memwb
	);

	c_sign_extensor : sign_extensor
	port map(
		i_data     => i_rdata_mem,
		i_bhw      => s_bhw_exmem,
		i_unsigned => s_mem_unsigned_exmem,
		o_data     => s_rdata_mem_ws
	);

	s_bdata <= x"FFF" & s_immed_idex when s_rb_imm_idex = ALU_IMM and s_immed_idex(19) = '1' else
		x"000" & s_immed_idex when s_rb_imm_idex = ALU_IMM and s_immed_idex(19) = '0' else
		s_port_b_reg_idex;

	o_addr_mem      <= s_wdata_exmem;
	o_wdata_mem     <= s_port_b_reg_exmem;
	o_bhw           <= s_bhw_exmem;

	s_wdata_mem_alu <= s_rdata_mem_ws when s_alu_mem_exmem = MEM_DATA else
		s_wdata_exmem;
end Structure;