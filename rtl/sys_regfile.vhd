library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity sys_regfile is
    port (
        i_clk_proc : in std_logic;
        i_reset    : in std_logic;
        i_wr       : in std_logic;
        i_port_d   : in std_logic_vector(R_XLEN);
        i_addr_d   : in std_logic_vector(R_CSR);
        i_addr_a   : in std_logic_vector(R_CSR);
        o_port_a   : out std_logic_vector(R_XLEN);
        o_priv_lvl : out std_logic;
        -- INTERRUPTS
        i_mcause   : in std_logic_vector(R_XLEN);
        i_mtval    : in std_logic_vector(R_XLEN);
        i_mret     : in std_logic;
        o_trap_enabled : out std_logic;
        -- STATE
        i_sys_state : in std_logic;
        i_ret_pc   : in std_logic_vector(R_XLEN)
    );
end sys_regfile;

architecture Structure of sys_regfile is
    signal s_mstatus : std_logic_vector(R_XLEN); -- Holds the state of the hart
    signal s_mtvec   : std_logic_vector(R_XLEN); -- Interrupt vector
    signal s_mtval   : std_logic_vector(R_XLEN); -- Holds information about the trap to assist software
    signal s_mpec    : std_logic_vector(R_XLEN); -- Holds the PC of the instruction to return
    signal s_mcause  : std_logic_vector(R_XLEN); -- Which cause triggered the trap
begin

    process(i_clk_proc, i_reset)
    begin
        if rising_edge(i_clk_proc) then
            if i_wr = '1' then
                case i_addr_d is
                    when CSR_MSTATUS =>
                        s_mstatus <= i_port_d;
                    when CSR_MTVEC =>
                        s_mtvec <= i_port_d;
                    when CSR_MPEC =>
                        s_mpec <= i_port_d;
                    when others =>
                        null;
                end case;
            elsif i_sys_state = '1' then
                s_mstatus(3) <= '0'; -- Deactivate interrupts
                s_mstatus(11) <= M_PRIV; -- Enter mode system
                s_mpec <= i_ret_pc;
            elsif i_mret = '1' then
                s_mstatus(3) <= '1'; -- Activate interrupts
                s_mstatus(11) <= U_PRIV; -- Exit mode system
            end if;
        end if;
        if i_reset = '1' then
            s_mstatus <= x"00000800"; -- Interrputs dissabled on reset and mode system on
            s_mtvec <= INT_VECTOR;   -- Base address for the RSI
        end if;
    end process;

    s_mcause <= i_mcause;
    s_mtval <= i_mtval;

    o_port_a <= s_mstatus when i_addr_a = CSR_MSTATUS else
                s_mtvec when i_addr_a = CSR_MTVEC else
                s_mtval when i_addr_a = CSR_MTVAL else
                s_mpec  when i_addr_a = CSR_MPEC else
                s_mcause when i_addr_a = CSR_MCAUSE else
                s_mtvec when i_sys_state = '1' else
                s_mpec  when i_mret = '1' else
                (others => '0');

    o_trap_enabled <= s_mstatus(3);
    o_priv_lvl <= s_mstatus(11);

end Structure;
