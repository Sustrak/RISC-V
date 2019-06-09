library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity alu is
	port (
		i_adata    : in std_logic_vector(R_XLEN);
		i_bdata    : in std_logic_vector(R_XLEN);
		i_opcode   : in std_logic_vector(R_OP_CODE);
		o_wdata    : out std_logic_vector(R_XLEN)
	);
end alu;

architecture Structure of alu is
	signal s_jarl  : std_logic_vector(R_XLEN);
    signal s_mul   : std_logic_vector(63 downto 0);
    signal s_mulu  : std_logic_vector(63 downto 0);
    signal s_mulsu : std_logic_vector(63 downto 0);
    signal s_div   : std_logic_vector(R_XLEN);
    signal s_divu  : std_logic_vector(R_XLEN);
    signal s_rem   : std_logic_vector(R_XLEN);
    signal s_remu  : std_logic_vector(R_XLEN);
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
        -- MUL
        s_mul(R_XLEN) when i_opcode = ALU_MUL else
        -- MULH
        s_mul(63 downto 32) when i_opcode = ALU_MULH else
        -- MULHU
        s_mulu(63 downto 32) when i_opcode = ALU_MULHU else
        -- MULHSU
        s_mulsu(63 downto 32) when i_opcode = ALU_MULHSU else
        -- DIV
        s_div when i_opcode = ALU_DIV else
        -- DIVU
        s_divu when i_opcode = ALU_DIVU else
        -- REM
        s_rem when i_opcode = ALU_REM else
        -- REMU
        s_remu when i_opcode = ALU_REMU else
		-- AUIPC
		std_logic_vector(signed(i_bdata(19 downto 0) & x"000") + signed(i_adata)) when i_opcode = ALU_AUIPC else
		-- BRANCH
		std_logic_vector(signed(i_adata) + signed(shift_left(signed(i_bdata), 1))) when i_opcode = ALU_BEQ or i_opcode = ALU_BGE or i_opcode = ALU_BGEU or i_opcode = ALU_BLT or i_opcode = ALU_BLTU or i_opcode = ALU_BNE or i_opcode = ALU_JAL else
		s_jarl(R_XLEN'high downto R_XLEN'low + 1) & '0' when i_opcode = ALU_JALR else
        i_bdata when i_opcode = ALU_PASS_B else
        i_adata when i_opcode = ALU_PASS_A else
        i_adata when i_opcode = ALU_MRET else
		(others => '0');

	s_jarl <= std_logic_vector(signed(i_adata) + signed(i_bdata));
    s_mul <= std_logic_vector(signed(i_adata) * signed(i_bdata));
    s_mulu <= std_logic_vector(unsigned(i_adata) * unsigned(i_bdata));
    s_mulsu <= std_logic_vector(-signed(s_mulu)) when i_adata(31) = '1' else
               s_mulu;

    s_div <= x"FFFFFFFF" when i_bdata = x"00000000" else
             x"80000000" when i_adata = x"80000000" and i_bdata = x"FFFFFFFF" else
             std_logic_vector(signed(i_adata) / signed(i_bdata));

    s_divu <= x"FFFFFFFF" when i_bdata = x"00000000" else
              std_logic_vector(unsigned(i_adata) / unsigned(i_bdata));

    s_rem  <= i_adata when i_bdata = x"00000000" else
              x"00000000" when i_adata = x"80000000" and i_bdata = x"FFFFFFFF" else
              std_logic_vector(signed(i_adata) mod signed(i_bdata));

    s_remu <= i_adata when i_bdata = x"00000000" else
              std_logic_vector(unsigned(i_adata) mod unsigned(i_bdata));
end Structure;
