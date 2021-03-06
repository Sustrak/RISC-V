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
	subtype R_LED_R is natural range 17 downto 0;
	subtype R_LED_G is natural range 8 downto 0;
	subtype R_HEX is natural range 55 downto 0;
	subtype R_KEY is natural range 3 downto 0;
	subtype R_SWITCH is natural range 17 downto 0;
	subtype R_CSR is natural range 11 downto 0;
	
	-- LOCATION OF THE INFORMATION IN THE DIFFERENT TYPES OF INSTRUCTIONS
	subtype R_INS_OPCODE is natural range 6 downto 0;
	subtype R_INS_FUNCT3 is natural range 14 downto 12;
	subtype R_INS_RS1 is natural range 19 downto 15;
	subtype R_INS_RS2 is natural range 24 downto 20;
	subtype R_INS_RD is natural range 11 downto 7;
	subtype R_INS_FUNCT7 is natural range 31 downto 25;
	
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

	-- NOP OPERATION
	constant NOP        : std_logic_vector := x"00000013";
	
	-- ALU OP CODES
	constant ALU_LUI    : std_logic_vector := "000001";
	constant ALU_ADD    : std_logic_vector := "000010";
	constant ALU_SUB    : std_logic_vector := "000011";
	constant ALU_SLL    : std_logic_vector := "000100";
	constant ALU_XOR    : std_logic_vector := "000101";
	constant ALU_SRL    : std_logic_vector := "000110";
	constant ALU_SRA    : std_logic_vector := "000111";
	constant ALU_OR     : std_logic_vector := "001000";
	constant ALU_AND    : std_logic_vector := "001001";
	constant ALU_SLT    : std_logic_vector := "001010";
	constant ALU_SLTU   : std_logic_vector := "001011";
	constant ALU_AUIPC  : std_logic_vector := "001100";
	constant ALU_BEQ    : std_logic_vector := "001101";
	constant ALU_BGE    : std_logic_vector := "001110";
	constant ALU_BGEU   : std_logic_vector := "001111";
	constant ALU_BLT    : std_logic_vector := "010000";
	constant ALU_BLTU   : std_logic_vector := "010001";
	constant ALU_BNE    : std_logic_vector := "010010";
	constant ALU_JAL    : std_logic_vector := "010011";
	constant ALU_JALR   : std_logic_vector := "010100";
	constant ALU_PASS_B : std_logic_vector := "010101";
	constant ALU_PASS_A : std_logic_vector := "010110";
	constant ALU_MRET   : std_logic_vector := "010111";
	constant ALU_MUL    : std_logic_vector := "011000";
	constant ALU_MULH   : std_logic_vector := "011001";
	constant ALU_MULHSU : std_logic_vector := "011010";
	constant ALU_MULHU  : std_logic_vector := "011011";
	constant ALU_DIV    : std_logic_vector := "011100";
	constant ALU_DIVU   : std_logic_vector := "011101";
	constant ALU_REM    : std_logic_vector := "011110";
	constant ALU_REMU   : std_logic_vector := "011111";

	-- INS OP CODE
	constant LUI        : std_logic_vector := "0110111";
	constant AUIPC      : std_logic_vector := "0010111";
	constant JAL        : std_logic_vector := "1101111";
	constant JARL       : std_logic_vector := "1100111";
	constant BRANCH     : std_logic_vector := "1100011";
	constant LOAD       : std_logic_vector := "0000011";
	constant STORE      : std_logic_vector := "0100011";
	constant ARITHI     : std_logic_vector := "0010011";
	constant ARITH      : std_logic_vector := "0110011";
	constant SYSTEM     : std_logic_vector := "1110011";
	
	-- FUNCT3 CODES
	constant F3_BYTE    : std_logic_vector := "000";
	constant F3_HALF    : std_logic_vector := "001";
	constant F3_WORD    : std_logic_vector := "010";
	constant F3_BYTEU   : std_logic_vector := "100";
	constant F3_HALFU   : std_logic_vector := "101";
	constant F3_ADDI    : std_logic_vector := "000";
	constant F3_ADD     : std_logic_vector := "000";
	constant F3_SUB     : std_logic_vector := "000";
	constant F3_SLL     : std_logic_vector := "001";
	constant F3_SLT     : std_logic_vector := "010";
	constant F3_SLTU    : std_logic_vector := "011";
	constant F3_XOR     : std_logic_vector := "100";
	constant F3_SRL     : std_logic_vector := "101";
	constant F3_SRA     : std_logic_vector := "101";
	constant F3_OR      : std_logic_vector := "110";
	constant F3_AND     : std_logic_vector := "111";
	constant F3_SLTI    : std_logic_vector := "010";
	constant F3_SLTIU   : std_logic_vector := "011";
	constant F3_XORI    : std_logic_vector := "100";
	constant F3_ORI     : std_logic_vector := "110";
	constant F3_ANDI    : std_logic_vector := "111";
	constant F3_SLLI    : std_logic_vector := "001";
	constant F3_SRLI    : std_logic_vector := "101";
	constant F3_SRAI    : std_logic_vector := "101";
	constant F3_BEQ     : std_logic_vector := "000";
	constant F3_BGE     : std_logic_vector := "101";
	constant F3_BGEU    : std_logic_vector := "111";
	constant F3_BLT     : std_logic_vector := "100";
	constant F3_BLTU    : std_logic_vector := "110";
	constant F3_BNE     : std_logic_vector := "001";
	constant F3_CSRRW   : std_logic_vector := "001";
	constant F3_CSRRS   : std_logic_vector := "010";
	constant F3_CSRRC   : std_logic_vector := "011";
	constant F3_CSRRWI  : std_logic_vector := "101";
	constant F3_CSRRSI  : std_logic_vector := "110";
	constant F3_CSRRCI  : std_logic_vector := "111";
	constant F3_MUL     : std_logic_vector := "000";
	constant F3_MULH    : std_logic_vector := "001";
	constant F3_MULHSU  : std_logic_vector := "010";
	constant F3_MULHU   : std_logic_vector := "011";
	constant F3_DIV     : std_logic_vector := "100";
	constant F3_DIVU    : std_logic_vector := "101";
	constant F3_REM     : std_logic_vector := "110";
	constant F3_REMU    : std_logic_vector := "111";

	-- FUNCT7 CODES
	constant F7_SLLI    : std_logic_vector := "0000000";
	constant F7_SRLI    : std_logic_vector := "0000000";
	constant F7_SRAI    : std_logic_vector := "0100000";
	constant F7_ADD     : std_logic_vector := "0000000";
	constant F7_SUB     : std_logic_vector := "0100000";
	constant F7_SLL     : std_logic_vector := "0000000";
	constant F7_SLT     : std_logic_vector := "0000000";
	constant F7_SLTU    : std_logic_vector := "0000000";
	constant F7_XOR     : std_logic_vector := "0000000";
	constant F7_SRL     : std_logic_vector := "0000000";
	constant F7_SRA     : std_logic_vector := "0100000";
	constant F7_OR      : std_logic_vector := "0000000";
	constant F7_AND     : std_logic_vector := "0000000";
	constant F7_MEXT    : std_logic_vector := "0000001";

	-- PRIVILEGED INSTRUCTIONS (I-TYPE) CODES
	constant PRIV_MRET  : std_logic_vector := "001100000010";
	constant PRIV_ECALL : std_logic_vector := x"00000073";
	
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
	
	-- SELECT RA OR PC
	constant ALU_PC     : std_logic        := '1';
	constant ALU_RA     : std_logic        := '0';
	
	-- SELECT ALU DATA OR MEM DATA OR PC TO BE WRITTEN IN REGISTER
	subtype R_REG_DATA is natural range 1 downto 0;
	constant ALU_DATA   : std_logic_vector := "00";
	constant MEM_DATA   : std_logic_vector := "01";
	constant PC_DATA    : std_logic_vector := "10";
	
	-- DATA FROM MEM IS SIGNED OR UNSIGNED
	constant M_UNSIGNED : std_logic        := '1';
	constant M_SIGNED   : std_logic        := '0';
	
	-- PROCESSOR STATES
	subtype R_STATES is natural range 2 downto 0;
	constant FETCH_STATE  : std_logic_vector := "000";
	constant DECODE_STATE : std_logic_vector := "001";
	constant EXEC_STATE   : std_logic_vector := "010";
	constant MEM_STATE    : std_logic_vector := "011";
	constant WB_STATE     : std_logic_vector := "100";
	constant INI_STATE    : std_logic_vector := "101";
	constant SYS_STATE    : std_logic_vector := "110";
	
	-- HEX RANGES
	subtype R_HEX0 is natural range 6 downto 0;
	subtype R_HEX1 is natural range 13 downto 7;
	subtype R_HEX2 is natural range 20 downto 14;
	subtype R_HEX3 is natural range 27 downto 21;
	subtype R_HEX4 is natural range 34 downto 28;
	subtype R_HEX5 is natural range 41 downto 35;
	subtype R_HEX6 is natural range 48 downto 42;
	subtype R_HEX7 is natural range 55 downto 49;
	
	-- CSR
	constant CSR_MSTATUS : std_logic_vector := x"300";
	constant CSR_MTVEC   : std_logic_vector := x"305";
	constant CSR_MTVAL   : std_logic_vector := x"343";
	constant CSR_MPEC    : std_logic_vector := x"341";
	constant CSR_MCAUSE  : std_logic_vector := x"342";
	subtype R_CSR_OP is natural range 2 downto 0;
	constant CSRNOP                     : std_logic_vector := "000";
	constant CSRRW                      : std_logic_vector := "001";
	constant CSRRWI                     : std_logic_vector := "010";
	constant CSRRS                      : std_logic_vector := "011";
	constant CSRRSI                     : std_logic_vector := "100";
	constant CSRRC                      : std_logic_vector := "101";
	constant CSRRCI                     : std_logic_vector := "110";
	
	-- INT CODES (MCAUSE)
	constant MCAUSE_NO_INT              : std_logic_vector := x"FFFFFFFF";
	constant MCAUSE_SW                  : std_logic_vector := x"80000010";
	constant MCAUSE_KEY                 : std_logic_vector := x"80000011";
	constant MCAUSE_PS2                 : std_logic_vector := x"80000012";
	constant MCAUSE_INS_ADDR_MISS_ALIGN : std_logic_vector := x"00000000";
	constant MCAUSE_ILLEGAL_INS         : std_logic_vector := x"00000002";
	constant MCAUSE_LD_ADDR_MISS_ALIGN  : std_logic_vector := x"00000004";
	constant MCAUSE_ST_ADDR_MISS_ALIGN  : std_logic_vector := x"00000006";
	constant MCAUSE_ECALL               : std_logic_vector := x"00000008";
	constant MCAUSE_ILLEGAL_MEM         : std_logic_vector := x"00000018";
	
	-- PRIVILEGE LEVELS
	constant U_PRIV                     : std_logic        := '0';
	constant M_PRIV                     : std_logic        := '1';

	-- DATAPATH BUS
	-- -----------------------------------------------------------------------------------------------------------------------------------
	-- INTACK|CSROP|ADDRCSR|MRET|NEWP_PC|PC|RA_PC|DATA A|DATA B|IMM|ALU_OPCODE|RB_IMM|DATA W|LD_ST|BHW|ALU_MEM|MEM_UNSIGNED|ADDR D|WR_REG|
	-- -----------------------------------------------------------------------------------------------------------------------------------
	constant R_DPB_WRREG                : integer          := 0;
	subtype R_DPB_ADDRD is natural range R_DPB_WRREG + 5 downto R_DPB_WRREG + 1;
	constant R_DPB_MEMUNSIG : integer := R_DPB_ADDRD'high + 1;
	subtype R_DPB_ALUMEMPC is natural range R_DPB_MEMUNSIG + 2 downto R_DPB_MEMUNSIG + 1;
	subtype R_DPB_BHW is natural range R_DPB_ALUMEMPC'high + 2 downto R_DPB_ALUMEMPC'high + 1;
	subtype R_DPB_LDST is natural range R_DPB_BHW'high + 2 downto R_DPB_BHW'high + 1;
	subtype R_DPB_DATAW is natural range R_DPB_LDST'high + 32 downto R_DPB_LDST'high + 1;
	constant R_DPB_RBIMM : integer := R_DPB_DATAW'high + 1;
	subtype R_DPB_OPCODE is natural range R_DPB_RBIMM + 6 downto R_DPB_RBIMM + 1;
	subtype R_DPB_IMMED is natural range R_DPB_OPCODE'high + 20 downto R_DPB_OPCODE'high + 1;
	subtype R_DPB_DATAB is natural range R_DPB_IMMED'high + 32 downto R_DPB_IMMED'high + 1;
	subtype R_DPB_DATAA is natural range R_DPB_DATAB'high + 32 downto R_DPB_DATAB'high + 1;
	constant R_DPB_RAPC : integer := R_DPB_DATAA'high + 1;
	subtype R_DPB_PC is natural range R_DPB_RAPC + 32 downto R_DPB_RAPC + 1;
	constant R_DPB_TKBR : integer := R_DPB_PC'high + 1;
	subtype R_DPB_NEWPC is natural range R_DPB_TKBR + 32 downto R_DPB_TKBR + 1;
	constant R_DPB_MRET : integer := R_DPB_NEWPC'high + 1;
	subtype R_DPB_ADDRCSR is natural range R_DPB_MRET + 12 downto R_DPB_MRET + 1;
	subtype R_DPB_CSROP is natural range R_DPB_ADDRCSR'high + 3 downto R_DPB_ADDRCSR'high + 1;
	constant R_DPB_TRAPACK : integer := R_DPB_CSROP'high + 1;
	subtype R_DATAPATH_BUS is natural range R_DPB_TRAPACK downto 0;

	-- MEMORY SDRAM MAPPING
	-- *------------------------------------* 0x07FF FFFF
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *             USER   DATA            *
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *                                    * 0x0500 0000
	-- *------------------------------------* 
	-- *                                    * 0x04FF FFFF 
	-- *             USER  CODE             *
	-- *                                    * 0x0400 0000
	-- *------------------------------------*
	-- *                                    * 0x03FF FFFF
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *           SYSTEM   DATA            *
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *                                    *
	-- *                                    * 0x0100 0000
	-- *------------------------------------* 
	-- *                                    * 0x00FF FFFF 
	-- *           SYSTEM   CODE            *
	-- *                                    * 0x0000 0000
	-- *------------------------------------* 

	constant MEM_USR_CODE_INI : std_logic_vector := x"04000000";
	constant MEM_USR_DATA_INI : std_logic_vector := x"05000000";
	constant MEM_SYS_CODE_INI : std_logic_vector := x"00000000";
	constant MEM_SYS_DATA_INI : std_logic_vector := x"01000000";
	constant RESET_VECTOR     : std_logic_vector := x"00000000";
	constant INT_VECTOR       : std_logic_vector := x"00FE0000";

end ARCH32;