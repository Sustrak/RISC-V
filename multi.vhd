library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity multi is
	port (
		i_boot : in std_logic;
		i_clk_proc : in std_logic;
		o_inc_pc : out std_logic
	);
end entity;

architecture Structure of multi is
	type proc_state is (FETCH, ID, EX, MEM, WB);
	signal state : proc_state;
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
end Structure;
