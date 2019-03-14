library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity multi is
	port (
		i_boot        : in std_logic;
		i_clk_proc    : in std_logic;
		o_inc_pc      : out std_logic;
		-- MEMORY
		i_pc          : in std_logic_vector(R_XLEN);
		i_addr_mem    : in std_logic_vector(R_XLEN);
		o_addr_mem    : out std_logic_vector(R_XLEN);
		i_ld_st       : in std_logic_vector(R_MEM_LDST);
		i_bhw         : in std_logic_vector(R_MEM_ACCS);
		o_ld_st_to_mc : out std_logic_vector(R_MEM_LDST);
		o_bhw_to_mc   : out std_logic_vector(R_MEM_ACCS)
	);
end entity;

architecture Structure of multi is
	type proc_state is (FETCH, ID, EX, MEM, WB);
	signal state : proc_state := FETCH;
begin
	process (i_clk_proc, i_boot)
	begin
		if i_boot = '1' then
			state <= FETCH;
		elsif rising_edge(i_clk_proc) then
			if state = FETCH then
				state <= ID;
			elsif state = ID then
				state <= EX;
			elsif state = EX then
				state <= MEM;
			elsif state = MEM then
				state <= WB;
			elsif state = WB then
				state <= FETCH;
			end if;
		end if;
	end process;

	o_inc_pc <= '1' when state = WB else
		'0';

	o_ld_st_to_mc <= LD_SDRAM when state = FETCH else
					 i_ld_st when state = MEM else
					 IDLE_SDRAM;
	o_bhw_to_mc <= W_ACCESS when state = FETCH else
		i_bhw;

	o_addr_mem <= i_pc when state = FETCH else
		i_addr_mem;
end Structure;
