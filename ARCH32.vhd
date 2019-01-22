library ieee;
use ieee.std_logic_1164.all;

package ARCH32 is
	-- BUS RANGES
	subtype R_XLEN is natural range 31 downto 0;
	subtype R_INS is natural range 31 downto 0;
	subtype R_OP_CODE is natural range 5 downto 0;
	subtype R_REGS is natural range 5 downto 0;
	subtype R_IMMED is natural range 20 downto 0;
	subtype R_NUM_REGS is natural range 31 downto 0;
	-- LOCATION OF THE INFORMATION IN THE DIFFERENT TYPES OF INSTRUCTIONS
	subtype R_INS_OPCODE is natural range 6 downto 0;
	-- R-type
	subtype R_INSR_FUNCT7 is natural range 31 downto 25;
	subtype R_INSR_RS2 is natural range 24 downto 20;
	subtype R_INSR_RS1 is natural range 19 downto 15;
	subtype R_INSR_FUNCT3 is natural range 14 downto 12;
	subtype R_INSR_RD is natural range 11 downto 7;
	-- I-type
	subtype R_INSI_IMM is natural range 31 downto 20;
	subtype R_INSI_RS1 is natural range 19 downto 15;
	subtype R_INSI_FUNCT3 is natural range 14 downto 12;
	subtype R_INSI_RD is natural range 11 downto 7;
	-- S-type
	subtype R_INSS_IMM1 is natural range 31 downto 25;
	subtype R_INSS_RS2 is natural range 24 downto 20;
	subtype R_INSS_RS1 is natural range 19 downto 15;
	subtype R_INSS_FUNCT3 is natural range 14 downto 12;
	subtype R_INSS_IMM0 is natural range 11 downto 7;
	-- B-type
	constant R_INSB_IMM3 : integer := 31;
	subtype R_INSB_IMM1 is natural range 30 downto 25;
	subtype R_INSB_RS2 is natural range 24 downto 20;
	subtype R_INSB_RS1 is natural range 19 downto 15;
	subtype R_INSB_FUNCT3 is natural range 14 downto 12;
	subtype R_INSB_IMM0 is natural range 11 downto 8;
	constant R_INSB_IMM2 : integer := 7;
	-- U-tpye
	subtype R_INSU_IMM is natural range 31 downto 12;
	subtype R_INSU_RD is natural range 11 downto 7;
	-- J-type
	constant R_INSJ_IMM3 : integer := 31;
	subtype R_INSJ_IMM0 is natural range 30 downto 21;
	constant R_INSJ_IMM1 : integer := 20;
	subtype R_INSJ_IMM2 is natural range 19 downto 12;
	subtype R_INSJ_RD is natural range 11 downto 7;

	-- ALU OP CODES
	constant ALU_LUI : std_logic_vector := "00001";
	-- INS OP CODE
	constant LUI : std_logic_vector := "0110111";
end ARCH32;
