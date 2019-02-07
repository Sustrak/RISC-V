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
	subtype R_INS_RD  is natural range 11 downto 7;
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
	constant ALU_LUI : std_logic_vector := "000001";
	constant ALU_ADD : std_logic_vector := "000010";
	-- INS OP CODE
	constant LUI  : std_logic_vector := "0110111";
	constant LOAD  : std_logic_vector := "0000011";
	constant STORE   : std_logic_vector := "0100011";
	-- FUNCT3 CODES
	constant F3_BYTE : std_logic_vector := "000";
	constant F3_HALF : std_logic_vector := "001";
	constant F3_WORD : std_logic_vector := "010";
	constant F3_BYTEU : std_logic_vector := "100";
	constant F3_HALFU : std_logic_vector := "101";
	-- MEMORY ACCESS
	subtype  R_MEM_ACCS is natural range 1 downto 0;
	constant B_ACCESS : std_logic_vector := "10";
	constant H_ACCESS : std_logic_vector := "01";
	constant W_ACCESS : std_logic_vector := "00";
	-- MEMORY LOAD/STORE
	constant LD_MEM : std_logic := '0';
	constant ST_MEM : std_logic := '1';
	-- SELECT IMMEDIATE OR RB
	constant ALU_IMM : std_logic := '1';
	constant ALU_RB  : std_logic := '0';
	-- SELECT ALU DATA OR MEM DATA TO WRITE IN REGISTER
	constant ALU_DATA : std_logic := '0';
	constant MEM_DATA : std_logic := '1';
end ARCH32;
