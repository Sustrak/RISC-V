library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity alu is
	port (
		i_adata: in std_logic_vector(R_XLEN);
		i_bdata: in std_logic_vector(R_XLEN);
		i_opcode: in std_logic_vector(R_OP_CODE);
		o_wdata: out std_logic_vector(R_XLEN);
		o_overflow : out std_logic
	);
end alu;

architecture Structure of alu is
begin
	o_wdata <= i_bdata when i_opcode = ALU_LUI
			   else (others => '0');
end Structure;
