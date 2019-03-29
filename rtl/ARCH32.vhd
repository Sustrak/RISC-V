library ieee;
use ieee.std_logic_1164.all;

package ARCH32 is
	-- BUS RANGES
	subtype R_XLEN is natural range 31 downto 0;
	subtype R_INS is natural range 31 downto 0;
	subtype R_OP_CODE is natural range 5 downto 0;
	subtype R_REGS is natural range 4 downto 0;
	subtype R_IMMED is natural range 19 downto 0;
	subtype R_NUM_REGS is natural range 31 downto 0;
	subtype R_FUNCT3 is natural range 2 downto 0;
	-- LOCATION OF THE INFORMATION IN THE DIFFERENT TYPES OF INSTRUCTIONS
	subtype R_INS_OPCODE is natural range 6 downto 0;
	subtype R_INS_FUNCT3 is natural range 14 downto 12;
	subtype R_INS_RS1 is natural range 19 downto 15;
	subtype R_INS_RS2 is natural range 24 downto 20;
	subtype R_INS_RD is natural range 11 downto 7;
	subtype R_INS_FUNCT7 is natural range 31 downto 25;
	-- R-type
	-- I-type
	subtype R_INSI_IMM is natural range 31 downto 20;
	-- S-type
	subtype R_INSS_IMM1 is natural range 31 downto 25;
	subtype R_INSS_IMM0 is natural range 11 downto 7;
	-- B-type
	constant R_INSB_IMM3 : integer := 31;
	subtype R_INSB_IMM1 is natural range 30 downto 25;
	subtype R_INSB_IMM0 is natural range 11 downto 8;
	constant R_INSB_IMM2 : integer := 7;
	-- U-tpye
	subtype R_INSU_IMM is natural range 31 downto 12;
	-- J-type
	constant R_INSJ_IMM3 : integer := 31;
	subtype R_INSJ_IMM0 is natural range 30 downto 21;
	constant R_INSJ_IMM1 : integer := 20;
	subtype R_INSJ_IMM2 is natural range 19 downto 12;

	-- ALU OP CODES
	constant ALU_LUI  : std_logic_vector := "000001";
	constant ALU_ADD  : std_logic_vector := "000010";
	constant ALU_SUB  : std_logic_vector := "000011";
	constant ALU_SLL  : std_logic_vector := "000100";
	constant ALU_XOR  : std_logic_vector := "000101";
	constant ALU_SRL  : std_logic_vector := "000110";
	constant ALU_SRA  : std_logic_vector := "000111";
	constant ALU_OR   : std_logic_vector := "001000";
	constant ALU_AND  : std_logic_vector := "001001";
	constant ALU_SLT  : std_logic_vector := "001010";
	constant ALU_SLTU : std_logic_vector := "001011";
	-- INS OP CODE
	constant LUI      : std_logic_vector := "0110111";
	constant LOAD     : std_logic_vector := "0000011";
	constant STORE    : std_logic_vector := "0100011";
	constant ARITHI   : std_logic_vector := "0010011";
	constant ARITH	  : std_logic_vector := "0110011";
	-- FUNCT3 CODES
	constant F3_BYTE  : std_logic_vector := "000";
	constant F3_HALF  : std_logic_vector := "001";
	constant F3_WORD  : std_logic_vector := "010";
	constant F3_BYTEU : std_logic_vector := "100";
	constant F3_HALFU : std_logic_vector := "101";
	constant F3_ADDI  : std_logic_vector := "000";
	constant F3_ADD	  : std_logic_vector := "000";
	constant F3_SUB	  : std_logic_vector := "000";
	constant F3_SLL   : std_logic_vector := "001";
	constant F3_SLT   : std_logic_vector := "010";
	constant F3_SLTU  : std_logic_vector := "011";
	constant F3_XOR   : std_logic_vector := "100";
	constant F3_SRL   : std_logic_vector := "101";
	constant F3_SRA   : std_logic_vector := "101";
	constant F3_OR    : std_logic_vector := "110";
	constant F3_AND   : std_logic_vector := "111";
	constant F3_SLTI  : std_logic_vector := "010";
	constant F3_SLTIU : std_logic_vector := "011";
	constant F3_XORI  : std_logic_vector := "100";
	constant F3_ORI   : std_logic_vector := "110";
	constant F3_ANDI  : std_logic_vector := "111";
	constant F3_SLLI  : std_logic_vector := "001";
	constant F3_SRLI  : std_logic_vector := "101";
	constant F3_SRAI  : std_logic_vector := "101";
	-- FUNCT7 CODES
	constant F7_SLLI  : std_logic_vector := "0000000";
	constant F7_SRLI  : std_logic_vector := "0000000";
	constant F7_SRAI  : std_logic_vector := "0100000";
	constant F7_ADD   : std_logic_vector := "0000000";
	constant F7_SUB   : std_logic_vector := "0100000";
	constant F7_SLL   : std_logic_vector := "0000000";
	constant F7_SLT   : std_logic_vector := "0000000";
	constant F7_SLTU  : std_logic_vector := "0000000";
	constant F7_XOR   : std_logic_vector := "0000000";
	constant F7_SRL   : std_logic_vector := "0000000";
	constant F7_SRA   : std_logic_vector := "0100000";
	constant F7_OR    : std_logic_vector := "0000000";
	constant F7_AND   : std_logic_vector := "0000000";
	-- MEMORY ACCESS
	subtype R_MEM_ACCS is natural range 1 downto 0;
	constant B_ACCESS : std_logic_vector := "10";
	constant H_ACCESS : std_logic_vector := "01";
	constant W_ACCESS : std_logic_vector := "00";
	-- MEMORY LOAD/STORE
	subtype R_MEM_LDST is natural range 1 downto 0;
	constant LD_SDRAM   : std_logic_vector := "00";
	constant ST_SDRAM   : std_logic_vector := "01";
	constant IDLE_SDRAM : std_logic_vector := "10";
	-- SELECT IMMEDIATE OR RB
	constant ALU_IMM    : std_logic        := '1';
	constant ALU_RB     : std_logic        := '0';
	-- SELECT ALU DATA OR MEM DATA TO WRITE IN REGISTER
	constant ALU_DATA   : std_logic        := '0';
	constant MEM_DATA   : std_logic        := '1';
	-- DATA FROM MEM IS SIGNED OR UNSIGNED
	constant M_UNSIGNED : std_logic        := '1';
	constant M_SIGNED   : std_logic        := '0';
	-- DATAPATH BUS
	-- -----------------------------------------------------------------------------------------
	-- |DATA A|DATA B|IMM|ALU_OPCODE|RB_IMM|DATA W|LD_ST|BHW|ALU_MEM|MEM_UNSIGNED|ADDR D|WR_REG|
	-- -----------------------------------------------------------------------------------------
	subtype R_DATAPATH_BUS is natural range 134 downto 0;
	subtype R_DPB_DATAA is natural range 134 downto 103;
	subtype R_DPB_DATAB is natural range 102 downto 71;
	subtype R_DPB_IMMED is natural range 70 downto 51;
	subtype R_DPB_OPCODE is natural range 50 downto 45;
	constant R_DPB_RBIMM : integer := 44;
	subtype R_DPB_DATAW is natural range 43 downto 12;
	subtype R_DPB_LDST is natural range 11 downto 10;
	subtype R_DPB_BHW is natural range 9 downto 8;
	constant R_DPB_ALUMEM   : integer := 7;
	constant R_DPB_MEMUNSIG : integer := 6;
	subtype R_DPB_ADDRD is natural range 5 downto 1;
	constant R_DPB_WRREG : integer := 0;
	subtype R_DPB_EXMEM is natural range 10 downto 0;
	subtype R_DPB_MEMWB is natural range 5 downto 0;

end ARCH32;
