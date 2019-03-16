library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity alu is
	port (
		i_adata    : in std_logic_vector(R_XLEN);
		i_bdata    : in std_logic_vector(R_XLEN);
		i_opcode   : in std_logic_vector(R_OP_CODE);
		o_wdata    : out std_logic_vector(R_XLEN);
		o_overflow : out std_logic
	);
end alu;

architecture Structure of alu is
begin
	o_wdata <= i_bdata(19 downto 0) & x"000" when i_opcode = ALU_LUI else
		std_logic_vector(signed(i_adata) + signed(i_bdata)) when i_opcode = ALU_ADD else
		std_logic_vector(signed(i_adata) - signed(i_bdata)) when i_opcode = ALU_SUB else
		std_logic_vector(shift_left(signed(i_adata), to_integer(unsigned(i_bdata(4 downto 0))))) when i_opcode = ALU_SLL else
		std_logic_vector(shift_right(signed(i_adata), to_integer(unsigned(i_bdata(4 downto 0))))) when i_opcode = ALU_SLL and i_bdata(31) = '1' else
		i_adata xor i_bdata when i_opcode = ALU_XOR else
		std_logic_vector(shift_right(unsigned(i_adata), to_integer(unsigned(i_bdata(4 downto 0))))) when i_opcode = ALU_SRL else
		std_logic_vector(shift_left(unsigned(i_adata), to_integer(unsigned(i_bdata(4 downto 0))))) when i_opcode = ALU_SRL and i_bdata(31) = '1' else
		std_logic_vector(shift_right(signed(i_adata), to_integer(unsigned(i_bdata(4 downto 0))))) when i_opcode = ALU_SRA else
		std_logic_vector(shift_left(unsigned(i_adata), to_integer(unsigned(i_bdata(4 downto 0))))) when i_opcode = ALU_SRA and i_bdata(31) = '1' else
		i_adata or i_bdata when i_opcode = ALU_OR else
		i_adata and i_bdata when i_opcode = ALU_AND else
		(others => '0');
end Structure;
