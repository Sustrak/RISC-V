library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity ins_decoder is
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
		o_ld_pc        : out std_logic;
		-- MEMORY
		o_ld_st        : out std_logic_vector(R_MEM_LDST);
		o_bhw          : out std_logic_vector(R_MEM_ACCS);
		o_mem_unsigned : out std_logic
	);
end ins_decoder;

architecture Structure of ins_decoder is
	signal s_op     : std_logic_vector(R_INS_OPCODE);
	signal s_funct3 : std_logic_vector(R_INS_FUNCT3);
	signal s_funct7 : std_logic_vector(R_INS_FUNCT7);
begin
	s_op         <= i_ins(R_INS_OPCODE);
	s_funct3     <= i_ins(R_INS_FUNCT3);
	s_funct7     <= i_ins(R_INS_FUNCT7);

	o_alu_opcode <= ALU_LUI when s_op = LUI else
		ALU_ADD when s_op = LOAD or s_op = STORE or (s_op = ARITHI and s_funct3 = F3_ADDI) else
		(others => '0');

	o_wr_reg <= '1' when s_op = LUI or s_op = LOAD or s_op = ARITHI else
		'0';

	o_immed <= i_ins(R_INSU_IMM) when s_op = LUI else
		x"00" & i_ins(R_INSI_IMM) when s_op = LOAD and i_ins(31) = '0' else
		x"FF" & i_ins(R_INSI_IMM) when s_op = LOAD and i_ins(31) = '1' else
		x"00" & i_ins(R_INSS_IMM1) & i_ins(R_INSS_IMM0) when s_op = STORE and i_ins(31) = '0' else
		x"FF" & i_ins(R_INSS_IMM1) & i_ins(R_INSS_IMM0) when s_op = STORE and i_ins(31) = '1' else
		x"00" & i_ins(R_INSI_IMM) when s_op = ARITHI and i_ins(31) = '0' else
		x"FF" & i_ins(R_INSI_IMM) when s_op = ARITHI and i_ins(31) = '1' else
		(others => '0');

	o_addr_d_reg <= i_ins(R_INS_RD);
	o_addr_a_reg <= i_ins(R_INS_RS1);
	o_addr_b_reg <= i_ins(R_INS_RS2);

	o_rb_imm     <= ALU_IMM when s_op = LUI or s_op = LOAD or s_op = STORE or s_op = ARITHI else
		ALU_RB;

	o_ld_st <= ST_SDRAM when s_op = STORE else
		LD_SDRAM when s_op = LOAD else
		IDLE_SDRAM;

	o_alu_mem <= MEM_DATA when s_op = LOAD else
		ALU_DATA;

	o_bhw <= B_ACCESS when (s_op = STORE or s_op = LOAD) and (s_funct3 = F3_BYTE or s_funct3 = F3_BYTEU) else
		H_ACCESS when (s_op = STORE or s_op = LOAD) and (s_funct3 = F3_HALF or s_funct3 = F3_HALFU) else
		W_ACCESS;

	o_mem_unsigned <= M_UNSIGNED when s_op = LOAD and (s_funct3 = F3_BYTEU or s_funct3 = F3_HALFU) else
		M_SIGNED;

	o_ld_pc <= '0' when i_ins = x"FFFFFFFF" else
			   '1';
end Structure;
