library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity proc is
	port (
		i_boot : in std_logic;
		i_clk_proc : in std_logic;
		i_data_mem : in std_logic;
		o_addr_mem : out std_logic_vector(R_XLEN)
	);
end proc;

architecture Structure of proc is
	component datapath is
		port (
			-- REGFILE
			i_clk_proc : in std_logic;
			i_wr_reg : in std_logic;
			i_addr_d : in std_logic_vector(R_REGS);
			-- ALU
			i_immed : in std_logic_vector(R_IMMED);
			i_alu_opcode : in std_logic_vector(R_OP_CODE);
			-- CONTROL
			i_rb_imm : in std_logic
		);
	end component;
	component control_unit is
		port (
			i_boot : in std_logic;
			i_clk_proc: in std_logic;
			i_ins : in std_logic_vector(R_INS);
			-- ALU
			o_alu_opcode : out std_logic_vector(R_OP_CODE);
			o_immed : out std_logic_vector(R_IMMED);
			-- PC
			o_pc : out std_logic_vector(R_XLEN);
			-- REGS
			o_addr_d_reg : out std_logic_vector(R_REGS);
			--CONTROL
			o_wr_reg : out std_logic
		);
	end component;
begin
end Structure;
