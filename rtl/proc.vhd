library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity proc is
	port (
		i_boot            : in std_logic;
        i_clk_50          : in std_logic;
		i_clk_proc        : in std_logic;
		-- MEMORY
		i_rdata_mem       : in std_logic_vector(R_XLEN);
		o_wdata_mem       : out std_logic_vector(R_XLEN);
		o_addr_mem        : out std_logic_vector(R_XLEN);
		o_bhw             : out std_logic_vector(R_MEM_ACCS);
		o_ld_st           : out std_logic_vector(R_MEM_LDST);
		i_avalon_readvalid : in std_logic;
        o_proc_data_read  : out std_logic;
        o_int_ack         : out std_logic;
        i_int             : in std_logic;
        i_int_mcause      : in std_logic_vector(R_XLEN)
	);
end proc;

architecture Structure of proc is
	component datapath is
		port (
			-- REGFILE
			i_clk_proc     : in std_logic;
            i_reset        : in std_logic;
			i_wr_reg       : in std_logic;
			i_addr_d_reg   : in std_logic_vector(R_REGS);
			i_addr_a_reg   : in std_logic_vector(R_REGS);
			i_addr_b_reg   : in std_logic_vector(R_REGS);
			-- ALU
			i_immed        : in std_logic_vector(R_IMMED);
			i_alu_opcode   : in std_logic_vector(R_OP_CODE);
			-- CONTROL
			i_rb_imm       : in std_logic;
			i_ra_pc        : in std_logic;
			i_alu_mem_pc   : in std_logic_vector(R_REG_DATA);
            i_reg_stall    : in std_logic;
            -- INTERRUPT
            i_mcause       : in std_logic_vector(R_XLEN);
            i_mtval        : in std_logic_vector(R_XLEN);
            o_trap_enabled : out std_logic;
            i_csr_op       : in std_logic_vector(R_CSR_OP);
            i_addr_csr     : in std_logic_vector(R_CSR);
            i_mret         : in std_logic;
            i_trap_ack      : in std_logic;
            o_trap_ack      : out std_logic;
			-- BRANCH
			i_pc_br        : in std_logic_vector(R_XLEN);
			o_new_pc       : out std_logic_vector(R_XLEN);
			o_tkbr         : out std_logic;
			-- MEMORY
			i_rdata_mem    : in std_logic_vector(R_XLEN);
			o_wdata_mem    : out std_logic_vector(R_XLEN);
			o_addr_mem     : out std_logic_vector(R_XLEN);
			i_ld_st        : in std_logic_vector(R_MEM_LDST);
			i_bhw          : in std_logic_vector(R_MEM_ACCS);
			o_ld_st        : out std_logic_vector(R_MEM_LDST);
			o_bhw          : out std_logic_vector(R_MEM_ACCS);
			i_mem_unsigned : in std_logic;
            -- STATES
            i_states       : in std_logic_vector(R_STATES)
		);
	end component;
	component control_unit is
		port (
			i_boot            : in std_logic;
            i_clk_50          : in std_logic;
			i_clk_proc        : in std_logic;
			i_ins             : in std_logic_vector(R_INS);
			-- ALU
			o_alu_opcode      : out std_logic_vector(R_OP_CODE);
			o_immed           : out std_logic_vector(R_IMMED);
			-- REGS
			o_addr_d_reg      : out std_logic_vector(R_REGS);
			o_addr_a_reg      : out std_logic_vector(R_REGS);
			o_addr_b_reg      : out std_logic_vector(R_REGS);
			o_wr_reg          : out std_logic;
			--CONTROL
			o_rb_imm          : out std_logic;
			o_ra_pc           : out std_logic;
			o_alu_mem_pc      : out std_logic_vector(R_REG_DATA);
            o_reg_stall       : out std_logic;
			-- BRANCH
			o_pc_br           : out std_logic_vector(R_XLEN);
			i_new_pc          : in std_logic_vector(R_XLEN);
			i_tkbr            : in std_logic;
			-- MEMORY
			i_addr_mem        : in std_logic_vector(R_XLEN);
			o_addr_mem        : out std_logic_vector(R_XLEN);
			i_ld_st           : in std_logic_vector(R_MEM_LDST);
			i_bhw             : in std_logic_vector(R_MEM_ACCS);
			o_ld_st           : out std_logic_vector(R_MEM_LDST);
			o_bhw             : out std_logic_vector(R_MEM_ACCS);
			o_mem_unsigned    : out std_logic;
			o_ld_st_to_mc     : out std_logic_vector(R_MEM_LDST);
			o_bhw_to_mc       : out std_logic_vector(R_MEM_ACCS);
			i_avalon_readvalid : in std_logic;
            o_proc_data_read  : out std_logic;
            -- STATES
            o_states          : out std_logic_vector(R_STATES);
            -- INTERRUPTS/EXCEPTIONS
            i_trap_enabled    : in std_logic;
            i_int_trap        : in std_logic;
            i_exc_ack         : in std_logic;
            o_exc_in_order    : out std_logic;
            o_csr_op          : out std_logic_vector(R_CSR_OP);
            o_addr_csr        : out std_logic_vector(R_CSR);
            o_mret            : out std_logic;
            o_trap_ack        : out std_logic;
            o_mcause          : out std_logic_vector(R_XLEN);
            o_mtval           : out std_logic_vector(R_XLEN)
		);
	end component;

	signal s_wr_reg       : std_logic;
	signal s_wr_reg_multi : std_logic;
	signal s_addr_d_reg   : std_logic_vector(R_REGS);
	signal s_immed        : std_logic_vector(R_IMMED);
	signal s_alu_opcode   : std_logic_vector(R_OP_CODE);
	signal s_rb_imm       : std_logic;
	signal s_ra_pc        : std_logic;
	signal s_alu_mem_pc   : std_logic_vector(R_REG_DATA);
	signal s_addr_mem     : std_logic_vector(R_XLEN);
	signal s_pc_br        : std_logic_vector(R_XLEN);
	signal s_ld_st_cu     : std_logic_vector(R_MEM_LDST);
	signal s_ld_st_dp     : std_logic_vector(R_MEM_LDST);
	signal s_bhw_cu       : std_logic_vector(R_MEM_ACCS);
	signal s_bhw_dp       : std_logic_vector(R_MEM_ACCS);
	signal s_addr_a_reg   : std_logic_vector(R_REGS);
	signal s_addr_b_reg   : std_logic_vector(R_REGS);
	signal s_mem_unsigned : std_logic;
	signal s_new_pc       : std_logic_vector(R_XLEN);
	signal s_tkbr         : std_logic;
    signal s_reg_stall    : std_logic;
    signal s_mret         : std_logic;
    signal s_csr_op       : std_logic_vector(R_CSR_OP);
    signal s_addr_csr     : std_logic_vector(R_CSR);
    signal s_states       : std_logic_vector(R_STATES);
    signal s_trap_enabled : std_logic;
    signal s_int_trap     : std_logic;
    signal s_trap_ack     : std_logic;
    signal s_exc_mcause   : std_logic_vector(R_XLEN);
    signal s_mtval        : std_logic_vector(R_XLEN);
    signal s_trap_ack_to_controller : std_logic;
    signal s_exc_in_order     : std_logic;
    signal s_exc_ack      : std_logic;
    signal s_mcause       : std_logic_vector(R_XLEN);
begin
	c_datapath : datapath
	port map(
		i_clk_proc     => i_clk_proc,
        i_reset        => i_boot,
		i_wr_reg       => s_wr_reg,
		i_addr_d_reg   => s_addr_d_reg,
		i_addr_a_reg   => s_addr_a_reg,
		i_addr_b_reg   => s_addr_b_reg,
		i_immed        => s_immed,
		i_alu_opcode   => s_alu_opcode,
		i_rb_imm       => s_rb_imm,
		i_ra_pc        => s_ra_pc,
		i_alu_mem_pc   => s_alu_mem_pc,
		i_pc_br        => s_pc_br,
		o_new_pc       => s_new_pc,
		o_tkbr         => s_tkbr,
        i_reg_stall    => s_reg_stall,
        i_mcause       => s_mcause,
        i_mtval        => s_mtval,
		-- MEMORY
		i_rdata_mem    => i_rdata_mem,
		o_wdata_mem    => o_wdata_mem,
		o_addr_mem     => s_addr_mem,
		i_ld_st        => s_ld_st_cu,
		i_bhw          => s_bhw_cu,
		o_ld_st        => s_ld_st_dp,
		o_bhw          => s_bhw_dp,
		i_mem_unsigned => s_mem_unsigned,
        -- INTERRPUTS
        i_csr_op       => s_csr_op,
        o_trap_enabled => s_trap_enabled,
        i_addr_csr     => s_addr_csr,
        i_mret         => s_mret,
        i_trap_ack     => s_trap_ack,
        o_trap_ack     => s_trap_ack_to_controller,
        i_states       => s_states
	);
	c_cu : control_unit
	port map(
		i_boot            => i_boot,
        i_clk_50          => i_clk_50,
		i_clk_proc        => i_clk_proc,
		i_ins             => i_rdata_mem,
		o_alu_opcode      => s_alu_opcode,
		o_immed           => s_immed,
		o_addr_d_reg      => s_addr_d_reg,
		o_addr_a_reg      => s_addr_a_reg,
		o_addr_b_reg      => s_addr_b_reg,
		o_wr_reg          => s_wr_reg,
		o_rb_imm          => s_rb_imm,
		o_ra_pc           => s_ra_pc,
		o_alu_mem_pc      => s_alu_mem_pc,
		o_pc_br           => s_pc_br,
		i_new_pc          => s_new_pc,
		i_tkbr            => s_tkbr,
        o_reg_stall       => s_reg_stall,
		-- MEMORY
		i_addr_mem        => s_addr_mem,
		i_ld_st           => s_ld_st_dp,
		i_bhw             => s_bhw_dp,
		o_ld_st           => s_ld_st_cu,
		o_bhw             => s_bhw_cu,
		o_ld_st_to_mc     => o_ld_st,
		o_bhw_to_mc       => o_bhw,
		o_addr_mem        => o_addr_mem,
		o_mem_unsigned    => s_mem_unsigned,
		i_avalon_readvalid => i_avalon_readvalid,
        o_proc_data_read  => o_proc_data_read,
        o_states          => s_states,
        -- INTERRUPTS/EXCEPTIONS
        i_trap_enabled     => s_trap_enabled,
        i_int_trap         => s_int_trap,
        i_exc_ack          => s_exc_ack,
        o_exc_in_order     => s_exc_in_order,
        o_csr_op           => s_csr_op,
        o_addr_csr         => s_addr_csr,
        o_mret             => s_mret,
        o_trap_ack         => s_trap_ack,
        o_mcause           => s_exc_mcause,
        o_mtval            => s_mtval
	);

    s_int_trap <= s_trap_enabled and i_int;

    -- We prioritize exceptions over interrupts
    o_int_ack <= s_trap_ack_to_controller when s_exc_in_order = '0' else
                  '0';

    s_exc_ack <= s_trap_ack_to_controller when s_exc_in_order = '1' else
                 '0';

    s_mcause <= s_exc_mcause when s_exc_in_order = '1' else
                i_int_mcause;
end Structure;
