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
    signal s_jarl : std_logic_vector(R_XLEN);
begin
	o_wdata <= i_bdata(19 downto 0) & x"000" when i_opcode = ALU_LUI else
		-- ADD
		std_logic_vector(signed(i_adata) + signed(i_bdata)) when i_opcode = ALU_ADD else
		-- SUB
		std_logic_vector(signed(i_adata) - signed(i_bdata)) when i_opcode = ALU_SUB else
		-- SLL
		std_logic_vector(shift_left(signed(i_adata), to_integer(unsigned(i_bdata(4 downto 0))))) when i_opcode = ALU_SLL else
		-- SRL
		std_logic_vector(shift_right(unsigned(i_adata), to_integer(unsigned(i_bdata(4 downto 0))))) when i_opcode = ALU_SRL else
		-- SRA
		std_logic_vector(shift_right(signed(i_adata), to_integer(unsigned(i_bdata(4 downto 0))))) when i_opcode = ALU_SRA else
		-- XOR
		i_adata xor i_bdata when i_opcode = ALU_XOR else
		-- OR
		i_adata or i_bdata when i_opcode = ALU_OR else
		-- AND
		i_adata and i_bdata when i_opcode = ALU_AND else
		-- SLT
		x"00000001" when i_opcode = ALU_SLT and signed(i_adata) < signed(i_bdata) else
		-- SLTU
		x"00000001" when i_opcode = ALU_SLTU and unsigned(i_adata) < unsigned(i_bdata) else
        -- AUIPC
        std_logic_vector(signed(i_bdata(19 downto 0) & x"000") + signed(i_adata)) when i_opcode = ALU_AUIPC else
        -- BRANCH
        std_logic_vector(signed(i_adata) + shift_left(signed(i_bdata), 1)) when i_opcode = ALU_BEQ or i_opcode = ALU_BGE or i_opcode = ALU_BGEU or i_opcode = ALU_BLT or i_opcode = ALU_BLTU or i_opcode = ALU_BNE or i_opcode = ALU_JAL else
        s_jarl(R_XLEN'high downto R_XLEN'low+1) & '0' when i_opcode = ALU_JARL else
		(others => '0');

    s_jarl <= std_logic_vector(signed(i_adata) + signed(i_bdata));
end Structure;
