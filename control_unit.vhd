library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity control_unit is
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
		-- CONTROL
		o_wr_reg : out std_logic
	);
end control_unit;

architecture Structure of control_unit is
	component ins_decoder is
		port (
			i_ins : in std_logic_vector(R_INS);
			-- ALU
			o_alu_opcode: out std_logic_vector(R_OP_CODE);
			o_immed : out std_logic_vector(R_IMMED);
			-- REGS
			o_addr_d_reg: out std_logic_vector(R_REGS);
			-- CONTROL
			o_wr_reg : out std_logic
		);
	end component;

	-- SIGNALS
	signal s_pc : std_logic_vector(R_XLEN);
begin

	-- PROGRAM COUNTER
	process(i_clk_proc, i_boot)
	begin
		if (rising_edge(i_clk_proc)) then
			if (i_boot = '1') then
				s_pc <= x"00001000";
			else
				s_pc <= std_logic_vector(unsigned(s_pc) + 1);
			end if;
		end if;
	end process;
end Structure;
