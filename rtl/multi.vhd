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
        o_proc_data_read  : out std_logic;
		-- REGISTERS
        o_reg_stall       : out std_logic;
		-- STATE
		o_states          : out std_logic_vector(R_STATES);
        o_rebotes         : out std_logic_vector(15 downto 0);
        -- INTERRUPTS
        i_trap             : in std_logic
	);
end entity;

architecture Structure of multi is
	type proc_state is (INI, FETCH, ID, EX, MEM, MEM_LD_WAIT, WB, SYS);
	signal state : proc_state := FETCH;
    signal s_proc_data_read : std_logic;
    signal rebotes : std_logic_vector(15 downto 0);
begin

    process(i_boot)
    begin
        if rising_edge(i_boot) then
            rebotes <= std_logic_vector(unsigned(rebotes) +1);
        end if;
    end process;
    o_rebotes <= rebotes;



	process (i_clk_proc, i_boot, i_avalon_readvalid)
	begin
		if i_boot = '1' then
			state <= INI;
            s_proc_data_read <= '0';
		elsif rising_edge(i_clk_proc) then

            s_proc_data_read <= '0';
            
			if state = INI then
				state <= FETCH;
			elsif state = FETCH then
				if i_avalon_readvalid = '1' then
                    s_proc_data_read <= '1';
					state <= ID;
				end if;
			elsif state = ID then
				state <= EX;
			elsif state = EX then
				state <= MEM;
			elsif state = MEM then
                if i_ld_st = LD_SDRAM then
                    state <= MEM_LD_WAIT;
                else
                    state <= WB;
                end if;
            elsif state = MEM_LD_WAIT then
                if i_avalon_readvalid = '1' then
                    s_proc_data_read <= '1';
                    state <= WB;
                end if;
			elsif state = WB then
                if i_trap = '1' then
                    state <= SYS;
                else
				    state <= FETCH;
                end if;
            elsif state = SYS then
                state <= FETCH;
			end if;
		end if;
	end process;

    o_proc_data_read <= s_proc_data_read;

    o_reg_stall <= '1' when state = MEM_LD_WAIT else
                   '0';


	o_ld_st_to_mc <= LD_SDRAM when state = FETCH else
		i_ld_st when state = MEM else
		IDLE_SDRAM;
	o_bhw_to_mc <= W_ACCESS when state = FETCH else
		i_bhw;

	o_addr_mem <= i_pc when state = FETCH else
		i_addr_mem;

	o_states <= FETCH_STATE when state = FETCH else
		DECODE_STATE when state = ID else
		EXEC_STATE when state = EX else
		MEM_STATE when state = MEM else
		WB_STATE when state = WB else
        SYS_STATE when state = SYS else
		INI_STATE;

end Structure;
