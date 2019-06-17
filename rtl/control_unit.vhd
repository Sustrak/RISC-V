library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity control_unit is
	port (
		i_boot             : in std_logic;
		i_clk_50           : in std_logic;
		i_clk_proc         : in std_logic;
		i_ins              : in std_logic_vector(R_INS);
		-- ALU
		o_alu_opcode       : out std_logic_vector(R_OP_CODE);
		o_immed            : out std_logic_vector(R_IMMED);
		-- REGS
		o_addr_d_reg       : out std_logic_vector(R_REGS);
		o_addr_a_reg       : out std_logic_vector(R_REGS);
		o_addr_b_reg       : out std_logic_vector(R_REGS);
		o_wr_reg           : out std_logic;
		-- CONTROL
		o_rb_imm           : out std_logic;
		o_ra_pc            : out std_logic;
		o_alu_mem_pc       : out std_logic_vector(R_REG_DATA);
		o_reg_stall        : out std_logic;
		-- BRANCH
		o_pc_br            : out std_logic_vector(R_XLEN);
		i_new_pc           : in std_logic_vector(R_XLEN);
		i_tkbr             : in std_logic;
		-- MEMORY
		i_addr_mem         : in std_logic_vector(R_XLEN);
		o_addr_mem         : out std_logic_vector(R_XLEN);
		i_ld_st            : in std_logic_vector(R_MEM_LDST);
		i_bhw              : in std_logic_vector(R_MEM_ACCS);
		o_ld_st            : out std_logic_vector(R_MEM_LDST);
		o_bhw              : out std_logic_vector(R_MEM_ACCS);
		o_ld_st_to_mc      : out std_logic_vector(R_MEM_LDST);
		o_bhw_to_mc        : out std_logic_vector(R_MEM_ACCS);
		o_mem_unsigned     : out std_logic;
		i_avalon_readvalid : in std_logic;
		o_proc_data_read   : out std_logic;
		-- STATE
		o_states           : out std_logic_vector(R_STATES);
		-- INTERRUPTS/EXCEPTIONS
		i_trap_enabled     : in std_logic;
		i_int_trap         : in std_logic;
		i_exc_ack          : in std_logic;
		o_exc_in_order     : out std_logic;
		o_csr_op           : out std_logic_vector(R_CSR_OP);
		o_addr_csr         : out std_logic_vector(R_CSR);
		o_mret             : out std_logic;
		o_trap_ack         : out std_logic;
		o_mcause           : out std_logic_vector(R_XLEN);
		o_mtval            : out std_logic_vector(R_XLEN);
		-- PRIVILEGES
		i_priv_lvl         : in std_logic
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
			o_ra_pc        : out std_logic;
			o_alu_mem_pc   : out std_logic_vector(R_REG_DATA);
			o_ld_pc        : out std_logic;
			-- MEMORY
			o_ld_st        : out std_logic_vector(R_MEM_LDST);
			o_bhw          : out std_logic_vector(R_MEM_ACCS);
			o_mem_unsigned : out std_logic;
			-- INTERRUPTS
			o_csr_op       : out std_logic_vector(R_CSR_OP);
			o_addr_csr     : out std_logic_vector(R_CSR);
			o_mret         : out std_logic;
			o_trap_ack     : out std_logic;
			-- EXCEPTIONS
			o_illegal_ins  : out std_logic;
			o_ecall        : out std_logic;
			-- PRIVILEGES
			i_priv_lvl     : in std_logic
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
			i_boot             : in std_logic;
			i_clk_proc         : in std_logic;
			-- MEMORY
			i_pc               : in std_logic_vector(R_XLEN);
			i_addr_mem         : in std_logic_vector(R_XLEN);
			o_addr_mem         : out std_logic_vector(R_XLEN);
			i_ld_st            : in std_logic_vector(R_MEM_LDST);
			i_bhw              : in std_logic_vector(R_MEM_ACCS);
			o_ld_st_to_mc      : out std_logic_vector(R_MEM_LDST);
			o_bhw_to_mc        : out std_logic_vector(R_MEM_ACCS);
			i_avalon_readvalid : in std_logic;
			o_proc_data_read   : out std_logic;
			-- REGISTER
			o_reg_stall        : out std_logic;
			-- STATE
			o_states           : out std_logic_vector(R_STATES);
			-- INTERRUPTS
			i_trap             : in std_logic
		);
	end component;

	component exc_controller is
		port (
			i_clk                   : in std_logic;
			i_reset                 : in std_logic;
			i_current_pc            : in std_logic_vector(R_XLEN);
			i_state_fetch           : in std_logic;
			i_trap_enabled          : in std_logic;
			i_exc_ack               : in std_logic;
			o_exc_trap              : out std_logic;
			o_exc_in_order          : out std_logic;
			o_mcause                : out std_logic_vector(R_XLEN);
			o_mtval                 : out std_logic_vector(R_XLEN);
			-- EXCEPTIONS
			i_ins_addr_miss_align   : in std_logic;
			i_illegal_ins           : in std_logic;
			i_load_addr_miss_align  : in std_logic;
			i_store_addr_miss_align : in std_logic;
			i_illegal_mem_access    : in std_logic;
			i_ecall                 : in std_logic
		);
	end component;

	-- SIGNALS
	signal s_pc                   : std_logic_vector(R_XLEN);
	signal s_aux_pc               : std_logic_vector(R_XLEN);
	signal s_inc_pc               : std_logic;
	signal s_ins0                 : std_logic_vector(R_INS);
	signal s_ins                  : std_logic_vector(R_INS);
	signal s_ld_pc                : std_logic;
	signal s_states               : std_logic_vector(R_STATES);
	signal s_trap                 : std_logic;
	signal s_state_fetch          : std_logic;
	signal s_ld_st                : std_logic_vector(R_MEM_ACCS);
	-- EXCEPTIONS
	signal s_exc_trap             : std_logic;
	signal s_ecall                : std_logic;
	signal s_illegal_ins          : std_logic;
	signal s_ins_addr_miss_align  : std_logic;
	signal s_load_addr_miss_align : std_logic;
	signal s_store_add_miss_align : std_logic;
	signal s_illegal_mem_access   : std_logic;

begin
	c_ins_dec : ins_decoder
	port map(
		i_ins          => s_ins0,
		o_alu_opcode   => o_alu_opcode,
		o_immed        => o_immed,
		o_addr_d_reg   => o_addr_d_reg,
		o_addr_a_reg   => o_addr_a_reg,
		o_addr_b_reg   => o_addr_b_reg,
		o_wr_reg       => o_wr_reg,
		o_rb_imm       => o_rb_imm,
		o_ra_pc        => o_ra_pc,
		o_alu_mem_pc   => o_alu_mem_pc,
		o_ld_pc        => s_ld_pc,
		-- MEMORY
		o_ld_st        => o_ld_st,
		o_bhw          => o_bhw,
		o_mem_unsigned => o_mem_unsigned,
		-- INTERRUPTS
		o_csr_op       => o_csr_op,
		o_addr_csr     => o_addr_csr,
		o_mret         => o_mret,
		o_trap_ack     => o_trap_ack,
		-- EXCEPTIONS
		o_illegal_ins  => s_illegal_ins,
		o_ecall        => s_ecall,
		-- PRIVILEGES
		i_priv_lvl     => i_priv_lvl
	);
	c_reg_if_id : reg_if_id
	port map(
		i_clk_proc => i_clk_proc,
		i_ins      => s_ins,
		i_pc       => s_pc,
		o_ins      => s_ins0,
		o_pc       => o_pc_br
	);
	c_multi : multi
	port map(
		i_boot             => i_boot,
		i_clk_proc         => i_clk_proc,
		-- MEMORY
		i_pc               => s_pc,
		i_addr_mem         => i_addr_mem,
		o_addr_mem         => o_addr_mem,
		i_ld_st            => s_ld_st,
		i_bhw              => i_bhw,
		o_ld_st_to_mc      => o_ld_st_to_mc,
		o_bhw_to_mc        => o_bhw_to_mc,
		i_avalon_readvalid => i_avalon_readvalid,
		o_proc_data_read   => o_proc_data_read,
		-- REGISTER
		o_reg_stall        => o_reg_stall,
		-- STATE
		o_states           => s_states,
		-- INTERRUPTS
		i_trap             => s_trap
	);

	c_exc_controller : exc_controller
	port map(
		i_clk                   => i_clk_50,
		i_reset                 => i_boot,
		i_current_pc            => s_pc,
		i_state_fetch           => s_state_fetch,
		i_trap_enabled          => i_trap_enabled,
		i_exc_ack               => i_exc_ack,
		o_exc_trap              => s_exc_trap,
		o_exc_in_order          => o_exc_in_order,
		o_mcause                => o_mcause,
		o_mtval                 => o_mtval,
		-- EXCEPTIONS
		i_ins_addr_miss_align   => s_ins_addr_miss_align,
		i_illegal_ins           => s_illegal_ins,
		i_load_addr_miss_align  => s_load_addr_miss_align,
		i_store_addr_miss_align => s_store_add_miss_align,
		i_illegal_mem_access    => s_illegal_mem_access,
		i_ecall                 => s_ecall
	);

	s_ins <= i_ins when s_states = FETCH_STATE and i_avalon_readvalid = '1' else
		NOP;

	o_states      <= s_states;

	s_trap        <= i_int_trap or s_exc_trap;

	s_state_fetch <= '1' when s_states = FETCH_STATE else
		'0';

	-- Instruction @ must be aligned to 4-byte
	s_ins_addr_miss_align <= '1' when s_states = WB_STATE and i_tkbr = '1' and i_new_pc(1 downto 0) /= "00" else
		'0';
	s_load_addr_miss_align <= '1' when s_states = MEM_STATE and o_ld_st_to_mc = LD_SDRAM and o_addr_mem(1 downto 0) /= "00" else
		'0';
	s_store_add_miss_align <= '1' when s_states = MEM_STATE and o_ld_st_to_mc = ST_SDRAM and o_addr_mem(1 downto 0) /= "00" else
		'0';

	-- System memory protection
	s_illegal_mem_access <= '1' when s_states = MEM_STATE and i_addr_mem < MEM_USR_CODE_INI and i_priv_lvl = U_PRIV and i_ld_st /= IDLE_SDRAM else
		'1' when s_states = FETCH_STATE and o_addr_mem < MEM_USR_CODE_INI and i_priv_lvl = U_PRIV else
		'0';

	s_ld_st <= IDLE_SDRAM when s_illegal_mem_access = '1' else
		i_ld_st;

	-- PROGRAM COUNTER
	process (i_boot, i_clk_proc)
	begin
		if i_boot = '1' then
			s_pc <= RESET_VECTOR;
		elsif rising_edge(i_clk_proc) then
			if s_states = DECODE_STATE then
				if s_ld_pc = '1' then
					s_pc <= std_logic_vector(unsigned(s_pc) + 4); -- Default behaivour
				end if;
			elsif s_states = WB_STATE then
				if i_tkbr = '1' then
					s_pc <= i_new_pc; -- A jump/branch has been executed
				end if;
			elsif s_states = SYS_STATE then
				s_pc <= i_new_pc; -- An interruption/Exception has ocurred
			end if;
		end if;
	end process;

end Structure;