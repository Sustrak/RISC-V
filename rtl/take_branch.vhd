library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity take_branch is
	port (
		i_adata  : in std_logic_vector(R_XLEN);
		i_bdata  : in std_logic_vector(R_XLEN);
		i_opcode : in std_logic_vector(R_OP_CODE);
		o_tkbr   : out std_logic
	);
end take_branch;

architecture Structure of take_branch is
begin
	o_tkbr <= '1' when (i_adata = i_bdata and i_opcode = ALU_BEQ) or
		(signed(i_adata) >= signed(i_bdata) and i_opcode = ALU_BGE) or
		(unsigned(i_adata) >= unsigned(i_bdata) and i_opcode = ALU_BGEU) or
		(signed(i_adata) < signed(i_bdata) and i_opcode = ALU_BLT) or
		(unsigned(i_adata) < unsigned(i_bdata) and i_opcode = ALU_BLTU) or
		(i_adata /= i_bdata and i_opcode = ALU_BNE) or
		i_opcode = ALU_JAL or
		i_opcode = ALU_JARL else
		'0';

end Structure;