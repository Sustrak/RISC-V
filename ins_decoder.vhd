library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity ins_decoder is
	generic (
		XLEN: integer
	);
	port (
		i_ins : in std_logic_vector(R_INS);
		-- ALU
		o_alu_opcode: out std_logic_vector(R_OP_CODE);
		o_immed : out std_logic_vector(R_IMMED);
		-- REGS
		o_addr_d_reg : out std_logic_vector(R_REGS);
		-- CONTROL
		o_wr_reg : out std_logic
	);
end ins_decoder;

architecture Structure of ins_decoder is
	signal s_op : std_logic_vector(6 downto 0);
begin
	s_op <= i_ins(R_INS_OPCODE);
	o_alu_opcode <= ALU_LUI when s_op = LUI
					else x"0";

	o_wr_reg <= '1' when s_op = LUI
				else '0';

	o_immed <= i_ins(R_INSU_IMM) when s_op = LUI
			   else x"0";

	o_addr_d_reg <= i_ins(R_INSU_RD) when s_op = LUI
					else x"0";
end Structure;
