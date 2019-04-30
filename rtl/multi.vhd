library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity multi is
	port (
		i_boot            : in std_logic;
		i_clk_proc        : in std_logic;
		-- MEMORY
		i_pc              : in std_logic_vector(R_XLEN);
		i_addr_mem        : in std_logic_vector(R_XLEN);
		o_addr_mem        : out std_logic_vector(R_XLEN);
		i_ld_st           : in std_logic_vector(R_MEM_LDST);
		i_bhw             : in std_logic_vector(R_MEM_ACCS);
		o_ld_st_to_mc     : out std_logic_vector(R_MEM_LDST);
		o_bhw_to_mc       : out std_logic_vector(R_MEM_ACCS);
		i_avalon_readvalid : in std_logic;
		-- REGISTERS
		o_wr_reg          : out std_logic;
		-- STATE
		o_states          : out std_logic_vector(R_STATES)
	);
end entity;

architecture Structure of multi is
	type proc_state is (INI, FETCH, ID, EX, MEM, MEM2, WB);
	signal state : proc_state := FETCH;
begin
	process (i_clk_proc, i_boot, i_avalon_readvalid)
	begin
		if i_boot = '1' then
			state <= INI;
		elsif rising_edge(i_clk_proc) then
			if state = INI then
				state <= FETCH;
			elsif state = FETCH then
				if i_avalon_readvalid = '1' then
					state <= ID;
				end if;
			elsif state = ID then
				state <= EX;
			elsif state = EX then
				state <= MEM;
			elsif state = MEM then
				-- If the instruction is a load the we have to wait for the signal readvalid to proceed
				if i_ld_st = LD_SDRAM then
					if i_avalon_readvalid = '1' then
						-- Go to MEM2 to wait for the readvalid set its value to 0 so it doesn't interfere with the FETCH cycle
						state <= MEM2;
					end if;
				else
					state <= WB;
				end if;
			elsif state = MEM2 then
				if i_avalon_readvalid = '0' then
					state <= WB;
				end if;
			elsif state = WB then
				state <= FETCH;
			end if;
		end if;
	end process;
	o_ld_st_to_mc <= LD_SDRAM when state = FETCH else
		i_ld_st when state = MEM else
		IDLE_SDRAM;
	o_bhw_to_mc <= W_ACCESS when state = FETCH else
		i_bhw;

	o_addr_mem <= i_pc when state = FETCH else
		i_addr_mem;

	o_wr_reg <= '1' when state = WB else
		'0';

	o_states <= FETCH_STATE when state = FETCH else
		DECODE_STATE when state = ID else
		EXEC_STATE when state = EX else
		MEM_STATE when state = MEM or state = MEM2 else
		WB_STATE when state = WB else
		INI_STATE;

end Structure;
