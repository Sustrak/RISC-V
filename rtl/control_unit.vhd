library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity control_unit is
	port (
		i_boot         : in std_logic;
		i_clk_proc     : in std_logic;
		i_ins          : in std_logic_vector(R_INS);
		-- ALU
		o_alu_opcode   : out std_logic_vector(R_OP_CODE);
		o_immed        : out std_logic_vector(R_IMMED);
		-- REGS
		o_addr_d_reg   : out std_logic_vector(R_REGS);
		o_addr_a_reg   : out std_logic_vector(R_REGS);
		o_addr_b_reg   : out std_logic_vector(R_REGS);
		o_wr_reg       : out std_logic;
		-- CONTROL
		o_rb_imm       : out std_logic;
		o_alu_mem      : out std_logic;
		-- BRANCH
		o_pc_br        : out std_logic_vector(R_XLEN);
		-- MEMORY
		i_addr_mem     : in std_logic_vector(R_XLEN);
		o_addr_mem     : out std_logic_vector(R_XLEN);
		i_ld_st        : in std_logic;
		i_bhw          : in std_logic_vector(R_MEM_ACCS);
		o_ld_st        : out std_logic;
		o_bhw          : out std_logic_vector(R_MEM_ACCS);
		o_ld_st_to_mc  : out std_logic;
		o_bhw_to_mc    : out std_logic_vector(R_MEM_ACCS);
		o_mem_unsigned : out std_logic
	);
end control_unit;

architecture Structure of control_unit is
	component ins_decoder is
		port (
			i_ins          : in std_logic_vector(R_INS);
			-- ALU
			o_alu_opcode   : out std_logic_vector(R_OP_CODE);
			o_immed        : out std_logic_vector(R_IMMED);
			-- REGS
			o_addr_d_reg   : out std_logic_vector(R_REGS);
			o_addr_a_reg   : out std_logic_vector(R_REGS);
			o_addr_b_reg   : out std_logic_vector(R_REGS);
			o_wr_reg       : out std_logic;
			-- CONTROL
			o_rb_imm       : out std_logic;
			o_alu_mem      : out std_logic;
			-- MEMORY
			o_ld_st        : out std_logic;
			o_bhw          : out std_logic_vector(R_MEM_ACCS);
			o_mem_unsigned : out std_logic
		);
	end component;

	component reg_if_id is
		port (
			i_clk_proc : in std_logic;
			i_ins      : in std_logic_vector(R_INS);
			i_pc       : in std_logic_vector(R_XLEN);
			o_ins      : out std_logic_vector(R_INS);
			o_pc       : out std_logic_vector(R_XLEN)
		);
	end component;
	component multi is
		port (
			i_boot        : in std_logic;
			i_clk_proc    : in std_logic;
			o_inc_pc      : out std_logic;
			-- MEMORY
			i_pc          : in std_logic_vector(R_XLEN);
			i_addr_mem    : in std_logic_vector(R_XLEN);
			o_addr_mem    : out std_logic_vector(R_XLEN);
			i_ld_st       : in std_logic;
			i_bhw         : in std_logic_vector(R_MEM_ACCS);
			o_ld_st_to_mc : out std_logic;
			o_bhw_to_mc   : out std_logic_vector(R_MEM_ACCS)
		);
	end component;

	-- SIGNALS
	signal s_pc     : std_logic_vector(R_XLEN);
	signal s_inc_pc : std_logic;
	signal s_ins    : std_logic_vector(R_INS);
begin
	c_ins_dec : ins_decoder
	port map(
		i_ins          => s_ins,
		o_alu_opcode   => o_alu_opcode,
		o_immed        => o_immed,
		o_addr_d_reg   => o_addr_d_reg,
		o_addr_a_reg   => o_addr_a_reg,
		o_addr_b_reg   => o_addr_b_reg,
		o_wr_reg       => o_wr_reg,
		o_rb_imm       => o_rb_imm,
		o_alu_mem      => o_alu_mem,
		-- MEMORY
		o_ld_st        => o_ld_st,
		o_bhw          => o_bhw,
		o_mem_unsigned => o_mem_unsigned
	);
	c_reg_if_id : reg_if_id
	port map(
		i_clk_proc => i_clk_proc,
		i_ins      => i_ins,
		i_pc       => s_pc,
		o_ins      => s_ins,
		o_pc       => o_pc_br
	);
	c_multi : multi
	port map(
		i_boot        => i_boot,
		i_clk_proc    => i_clk_proc,
		o_inc_pc      => s_inc_pc,
		-- MEMORY
		i_pc          => s_pc,
		i_addr_mem    => i_addr_mem,
		o_addr_mem    => o_addr_mem,
		i_ld_st       => i_ld_st,
		i_bhw         => i_bhw,
		o_ld_st_to_mc => o_ld_st_to_mc,
		o_bhw_to_mc   => o_bhw_to_mc
	);

	-- PROGRAM COUNTER
	process (i_clk_proc, i_boot)
	begin
		if (rising_edge(i_clk_proc)) then
			if (i_boot = '1') then
				s_pc <= x"00001000";
			elsif s_inc_pc = '1' then
				s_pc <= std_logic_vector(unsigned(s_pc) + 4);
			end if;
		end if;
	end process;
end Structure;