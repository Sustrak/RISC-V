library ieee;
use ieee.std_logic_1164.all;
use work.ARCH32.all;

entity reg_if_id is
	port (
		i_clk_proc: in std_logic;
		i_ins: in std_logic_vector(R_INS);
		i_pc : in std_logic_vector(R_XLEN);
		o_ins: out std_logic_vector(R_INS);
		o_pc : out std_logic_vector(R_XLEN)
	);
end reg_if_id;

architecture Structure of reg_if_id is
	signal s_ins : std_logic_vector(R_INS);
	signal s_pc  : std_logic_vector(R_XLEN);
begin
	process(i_clk_proc)
	begin
		if rising_edge(i_clk_proc) then
			s_ins <= i_ins;
			s_pc <= i_pc;
		end if;
	end process;
	
	o_ins <= s_ins;
	o_pc <= s_pc;
end Structure;
