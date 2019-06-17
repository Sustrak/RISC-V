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
		o_rb_imm       : out std_logic; -- Selects the value of RB or the IMMEDIATE as input of the ALU
		o_ra_pc        : out std_logic; -- Selects the value of RA or the PC as input of the ALU
		o_alu_mem_pc   : out std_logic_vector(R_REG_DATA); -- Selects which value has to be written to the registers
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
end ins_decoder;

architecture Structure of ins_decoder is
	signal s_op     : std_logic_vector(R_INS_OPCODE);
	signal s_funct3 : std_logic_vector(R_INS_FUNCT3);
	signal s_funct7 : std_logic_vector(R_INS_FUNCT7);
	signal s_csr_op : std_logic_vector(R_CSR_OP);
begin
	s_op         <= i_ins(R_INS_OPCODE);
	s_funct3     <= i_ins(R_INS_FUNCT3);
	s_funct7     <= i_ins(R_INS_FUNCT7);

	o_alu_opcode <= ALU_LUI when s_op = LUI else
		ALU_AUIPC when s_op = AUIPC else
		ALU_ADD when s_op = LOAD or s_op = STORE or (s_op = ARITHI and s_funct3 = F3_ADDI) or (s_op = ARITH and s_funct3 = F3_ADD and s_funct7 = F7_ADD) else
		ALU_SUB when (s_op = ARITH or s_op = ARITHI) and s_funct3 = F3_SUB and s_funct7 = F7_SUB else
		ALU_SLL when (s_op = ARITH or s_op = ARITHI) and s_funct3 = F3_SLL and s_funct7 = F7_SLL else
		ALU_SLT when (s_op = ARITH or s_op = ARITHI) and s_funct3 = F3_SLT and s_funct7 = F7_SLT else
		ALU_SLTU when (s_op = ARITH or s_op = ARITHI) and s_funct3 = F3_SLTU and s_funct7 = F7_SLTU else
		ALU_XOR when (s_op = ARITH or s_op = ARITHI) and s_funct3 = F3_XOR and s_funct7 = F7_XOR else
		ALU_SRL when (s_op = ARITH or s_op = ARITHI) and s_funct3 = F3_SRL and s_funct7 = F7_SRL else
		ALU_SRA when (s_op = ARITH or s_op = ARITHI) and s_funct3 = F3_SRA and s_funct7 = F7_SRA else
		ALU_OR when (s_op = ARITH or s_op = ARITHI) and s_funct3 = F3_OR and s_funct7 = F7_OR else
		ALU_AND when (s_op = ARITH or s_op = ARITHI) and s_funct3 = F3_AND and s_funct7 = F7_AND else
		ALU_MUL when s_op = ARITH and s_funct3 = F3_MUL and s_funct7 = F7_MEXT else
		ALU_MULH when s_op = ARITH and s_funct3 = F3_MULH and s_funct7 = F7_MEXT else
		ALU_MULHSU when s_op = ARITH and s_funct3 = F3_MULHSU and s_funct7 = F7_MEXT else
		ALU_MULHU when s_op = ARITH and s_funct3 = F3_MULHU and s_funct7 = F7_MEXT else
		ALU_DIV when s_op = ARITH and s_funct3 = F3_DIV and s_funct7 = F7_MEXT else
		ALU_DIVU when s_op = ARITH and s_funct3 = F3_DIVU and s_funct7 = F7_MEXT else
		ALU_REM when s_op = ARITH and s_funct3 = F3_REM and s_funct7 = F7_MEXT else
		ALU_REMU when s_op = ARITH and s_funct3 = F3_REMU and s_funct7 = F7_MEXT else
		ALU_JAL when s_op = JAL else
		ALU_JALR when s_op = JARL else
		ALU_BEQ when s_op = BRANCH and s_funct3 = F3_BEQ else
		ALU_BGE when s_op = BRANCH and s_funct3 = F3_BGE else
		ALU_BGEU when s_op = BRANCH and s_funct3 = F3_BGEU else
		ALU_BLT when s_op = BRANCH and s_funct3 = F3_BLT else
		ALU_BLTU when s_op = BRANCH and s_funct3 = F3_BLTU else
		ALU_BNE when s_op = BRANCH and s_funct3 = F3_BNE else
		ALU_PASS_B when s_op = SYSTEM and (s_funct3 = F3_CSRRWI or s_funct3 = F3_CSRRSI or s_funct3 = F3_CSRRCI) else
		ALU_PASS_A when s_op = SYSTEM and (s_funct3 = F3_CSRRW or s_funct3 = F3_CSRRS or s_funct3 = F3_CSRRC) else
		ALU_MRET when s_op = SYSTEM and i_ins(R_INSI_IMM) = PRIV_MRET else
		(others => '0');

	o_wr_reg <= '1' when s_op = LUI or s_op = AUIPC or s_op = JAL or s_op = JARL or s_op = LOAD or s_op = ARITHI or s_op = ARITH or (s_op = SYSTEM and (s_funct3 = F3_CSRRW or s_funct3 = F3_CSRRWI)) else
		'0';

	o_immed <= i_ins(R_INSU_IMM) when s_op = LUI or s_op = AUIPC else
		x"00" & i_ins(R_INSI_IMM) when (s_op = LOAD or s_op = JARL) and i_ins(31) = '0' else
		x"FF" & i_ins(R_INSI_IMM) when (s_op = LOAD or s_op = JARL) and i_ins(31) = '1' else
		x"00" & i_ins(R_INSS_IMM1) & i_ins(R_INSS_IMM0) when s_op = STORE and i_ins(31) = '0' else
		x"FF" & i_ins(R_INSS_IMM1) & i_ins(R_INSS_IMM0) when s_op = STORE and i_ins(31) = '1' else
		x"00" & i_ins(R_INSI_IMM) when s_op = ARITHI and i_ins(31) = '0' else
		x"FF" & i_ins(R_INSI_IMM) when s_op = ARITHI and i_ins(31) = '1' else
		i_ins(R_INSJ_IMM3) & i_ins(R_INSJ_IMM2) & i_ins(R_INSJ_IMM1) & i_ins(R_INSJ_IMM0) when s_op = JAL else
		x"00" & i_ins(R_INSB_IMM3) & i_ins(R_INSB_IMM2) & i_ins(R_INSB_IMM1) & i_ins(R_INSB_IMM0) when s_op = BRANCH and i_ins(31) = '0' else
		x"FF" & i_ins(R_INSB_IMM3) & i_ins(R_INSB_IMM2) & i_ins(R_INSB_IMM1) & i_ins(R_INSB_IMM0) when s_op = BRANCH and i_ins(31) = '1' else
		x"000" & "000" & i_ins(R_INS_RS1) when s_op = SYSTEM and (s_funct3 = F3_CSRRWI or s_funct3 = F3_CSRRSI or s_funct3 = F3_CSRRCI) else
		(others => '0');

	o_addr_d_reg <= i_ins(R_INS_RD);
	o_addr_a_reg <= i_ins(R_INS_RS1);
	o_addr_b_reg <= i_ins(R_INS_RS2);

	o_rb_imm     <= ALU_IMM when s_op = LUI or s_op = AUIPC or s_op = JAL or s_op = LOAD or s_op = STORE or s_op = ARITHI or s_op = BRANCH or s_op = JARL else
		ALU_RB;

	o_ra_pc <= ALU_PC when s_op = AUIPC or s_op = BRANCH or s_op = JAL else
		ALU_RA;

	o_ld_st <= ST_SDRAM when s_op = STORE else
		LD_SDRAM when s_op = LOAD else
		IDLE_SDRAM;

	o_alu_mem_pc <= MEM_DATA when s_op = LOAD else
		PC_DATA when s_op = JAL or s_op = JARL else
		ALU_DATA;

	o_bhw <= B_ACCESS when (s_op = STORE or s_op = LOAD) and (s_funct3 = F3_BYTE or s_funct3 = F3_BYTEU) else
		H_ACCESS when (s_op = STORE or s_op = LOAD) and (s_funct3 = F3_HALF or s_funct3 = F3_HALFU) else
		W_ACCESS;

	o_mem_unsigned <= M_UNSIGNED when s_op = LOAD and (s_funct3 = F3_BYTEU or s_funct3 = F3_HALFU) else
		M_SIGNED;

	o_ld_pc <= '0' when i_ins = x"FFFFFFFF" else
		'1';

	o_addr_csr <= i_ins(R_INSI_IMM);

	s_csr_op   <= CSRRW when s_op = SYSTEM and s_funct3 = F3_CSRRW else
		CSRRS when s_op = SYSTEM and s_funct3 = F3_CSRRS else
		CSRRC when s_op = SYSTEM and s_funct3 = F3_CSRRC else
		CSRRWI when s_op = SYSTEM and s_funct3 = F3_CSRRWI else
		CSRRSI when s_op = SYSTEM and s_funct3 = F3_CSRRSI else
		CSRRCI when s_op = SYSTEM and s_funct3 = F3_CSRRCI else
		CSRNOP;

	o_csr_op <= s_csr_op when i_priv_lvl = M_PRIV else
		CSRNOP;

	o_mret <= '1' when s_op = SYSTEM and i_ins(R_INSI_IMM) = PRIV_MRET else
		'0';

	o_trap_ack <= '1' when s_op = SYSTEM and i_ins(R_INSI_IMM) = CSR_MCAUSE else
		'0';

	o_ecall <= '1' when i_ins = PRIV_ECALL else
		'0';

	o_illegal_ins <= '1' when (o_csr_op /= CSRNOP and not (o_addr_csr = CSR_MSTATUS or o_addr_csr = CSR_MTVEC or o_addr_csr = CSR_MTVAL or o_addr_csr = CSR_MPEC or o_addr_csr = CSR_MCAUSE)) or
		(s_csr_op /= CSRNOP and i_priv_lvl = U_PRIV) else
		'0';
end Structure;