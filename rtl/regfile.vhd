library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity regfile is
    port (
        i_clk_proc : in std_logic;
        i_reset    : in std_logic;
        i_wr       : in std_logic;
        i_port_d   : in std_logic_vector(R_XLEN);
        i_addr_d   : in std_logic_vector(R_REGS);
        i_addr_a   : in std_logic_vector(R_REGS);
        i_addr_b   : in std_logic_vector(R_REGS);
        i_addr_csr : in std_logic_vector(R_CSR);
        i_csr_op   : in std_logic_vector(R_CSR_OP);
        i_mret     : in std_logic;
        o_port_a   : out std_logic_vector(R_XLEN);
        o_port_b   : out std_logic_vector(R_XLEN);
        o_priv_lvl : out std_logic;
        -- INTERRUPTS
        i_mcause   : in std_logic_vector(R_XLEN);
        i_mtval    : in std_logic_vector(R_XLEN);
        o_trap_enabled : out std_logic;
        -- STATE
        i_states   : in std_logic_vector(R_STATES);
        i_ret_pc   : in std_logic_vector(R_XLEN)
    );
end regfile;

architecture Structure of regfile is
    component usr_regfile is
	    port (
	    	i_clk_proc : in std_logic;
	    	i_wr       : in std_logic;
	    	i_port_d   : in std_logic_vector(R_XLEN);
	    	i_addr_d   : in std_logic_vector(R_REGS);
	    	i_addr_a   : in std_logic_vector(R_REGS);
	    	i_addr_b   : in std_logic_vector(R_REGS);
	    	o_port_a   : out std_logic_vector(R_XLEN);
	    	o_port_b   : out std_logic_vector(R_XLEN)
	    );
    end component;

    component sys_regfile is
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
            -- SYS STATE
            i_sys_state : in std_logic;
            i_ret_pc    : in std_logic_vector(R_XLEN)
        );
    end component;

    signal s_sys_state : std_logic;
    signal s_wr_sys    : std_logic;
    signal s_usr_port_d : std_logic_vector(R_XLEN);
    signal s_usr_port_a : std_logic_vector(R_XLEN);
    signal s_sys_port_d : std_logic_vector(R_XLEN);
    signal s_sys_port_a : std_logic_vector(R_XLEN);

begin
    c_usr_regfile : usr_regfile
    port map (
        i_clk_proc => i_clk_proc,
        i_wr       => i_wr,
        i_port_d   => s_usr_port_d,
        i_addr_d   => i_addr_d,
        i_addr_a   => i_addr_a,
        i_addr_b   => i_addr_b,
        o_port_a   => s_usr_port_a,
        o_port_b   => o_port_b
    );

    c_sys_regfile : sys_regfile
    port map (
        i_clk_proc => i_clk_proc,
        i_reset    => i_reset,
        i_wr       => s_wr_sys,
        i_port_d   => i_port_d,
        i_addr_d   => i_addr_csr,
        i_addr_a   => i_addr_csr,
        o_port_a   => s_sys_port_a,
        o_priv_lvl => o_priv_lvl,
        i_mcause   => i_mcause,
        i_mtval    => i_mtval,
        i_mret     => i_mret,
        o_trap_enabled => o_trap_enabled,
        i_sys_state => s_sys_state,
        i_ret_pc   => i_ret_pc
    );

    s_wr_sys <= '0' when i_wr = '0' or i_csr_op = CSRNOP or i_csr_op = CSRRS or i_csr_op = CSRRSI or i_csr_op = CSRRC or i_csr_op = CSRRCI else
                '1';

    s_usr_port_d <= i_port_d when i_csr_op = CSRNOP else
                   s_sys_port_a;
    
    --s_sys_port_d <= s_usr_port_a when i_csr_op = CSRRW or i_csr_op = CSRRS or i_csr_op = CSRRC else
    --                i_port_d;
    
    o_port_a <= s_sys_port_a when i_mret = '1' or s_sys_state = '1' else
                s_usr_port_a;

    s_sys_state <= '1' when i_states= SYS_STATE else
                   '0';
end Structure;

        
