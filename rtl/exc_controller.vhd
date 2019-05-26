library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity exc_controller is
    port (
        i_clk   : in std_logic;
        i_reset : in std_logic;
        i_current_pc : in std_logic_vector(R_XLEN);
        i_state_fetch : in std_logic;
        i_trap_enabled : in std_logic;
        i_exc_ack  : in std_logic;
        o_exc_trap : out std_logic;
        o_exc_in_order : out std_logic;
        o_mcause   : out std_logic_vector(R_XLEN);
        o_mtval    : out std_logic_vector(R_XLEN);
        -- EXCEPTIONS
        i_ins_addr_miss_align : in std_logic;
        i_illegal_ins : in std_logic;
        i_load_addr_miss_align : in std_logic;
        i_store_addr_miss_align : in std_logic;
        i_illegal_mem_access   : in std_logic;
        i_ecall  : in std_logic
    ); 
end exc_controller;

architecture Structure of exc_controller is
    component edge_detector is
        port (
            i_clk      : in std_logic;
            i_signal   : in std_logic;
            i_data     : in std_logic_vector(R_XLEN); 
            o_data     : out std_logic_vector(R_XLEN);
            o_edge     : out std_logic
        );
    end component;

    signal s_mcause : std_logic_vector(R_XLEN);
    signal s_current_pc : std_logic_vector(R_XLEN);
    signal s_ins_addr_miss_align : std_logic;
    signal s_illegal_ins : std_logic;
    signal s_load_addr_miss_align : std_logic;
    signal s_store_addr_miss_align : std_logic;
    signal s_illegal_mem_access : std_logic;
    signal s_ecall : std_logic;
    -- EDGE CAPTURE
    signal s_ins_addr_miss_align_edge : std_logic;
    signal s_illegal_ins_edge : std_logic;
    signal s_load_addr_miss_align_edge : std_logic;
    signal s_store_addr_miss_align_edge : std_logic;
    signal s_illegal_mem_access_edge : std_logic;
    signal s_ecall_edge : std_logic;

begin
    iama_edge : edge_detector
    port map(
        i_clk => i_clk,
        i_signal => i_ins_addr_miss_align,
        i_data => (others => '0'),
        o_data => open,
        o_edge => s_ins_addr_miss_align_edge
    );
            
    illegal_ins_edge : edge_detector
    port map(
        i_clk => i_clk,
        i_signal => i_illegal_ins,
        i_data => (others => '0'),
        o_data => open,
        o_edge => s_illegal_ins_edge
    );

    lama_edge : edge_detector
    port map(
        i_clk => i_clk,
        i_signal => i_load_addr_miss_align,
        i_data => (others => '0'),
        o_data => open,
        o_edge => s_load_addr_miss_align_edge
    );

    sama_edge : edge_detector
    port map(
        i_clk => i_clk,
        i_signal => i_store_addr_miss_align, 
        i_data => (others => '0'),
        o_data => open,
        o_edge => s_store_addr_miss_align_edge 
    );


    ecall_edge : edge_detector
    port map(
        i_clk => i_clk,
        i_signal => i_ecall,
        i_data => (others => '0'),
        o_data => open,
        o_edge => s_ecall_edge 
    );

    illegal_mem_edge : edge_detector
    port map(
        i_clk => i_clk,
        i_signal => i_illegal_mem_access,
        i_data => (others => '0'),
        o_data => open,
        o_edge => s_illegal_mem_access_edge 
    );

    exceptions : process(i_clk, i_reset)
    begin
        if rising_edge(i_clk) then
            if i_state_fetch = '1' and i_trap_enabled = '1' then
                s_current_pc <= i_current_pc;
            end if;

            if s_ins_addr_miss_align_edge = '1' then
                s_ins_addr_miss_align <= '1'; 
            end if;
            if s_illegal_ins_edge = '1' then
                s_illegal_ins <= '1';
            end if;
            if s_load_addr_miss_align_edge = '1' then
                s_load_addr_miss_align <= '1';
            end if;
            if s_store_addr_miss_align_edge = '1' then
                s_store_addr_miss_align <= '1';
            end if;
            if s_ecall_edge = '1' then
                s_ecall <= '1';
            end if;
            if s_illegal_mem_access_edge = '1' then
                s_illegal_mem_access <= '0';
            end if;

            if i_exc_ack = '1' then
                if s_ins_addr_miss_align = '1' then
                    s_mcause <= MCAUSE_INS_ADDR_MISS_ALIGN;
                    s_ins_addr_miss_align <= '0'; 
                elsif s_illegal_ins = '1' then
                    s_mcause <= MCAUSE_ILLEGAL_INS;
                    s_illegal_ins <= '0';
                elsif s_load_addr_miss_align = '1' then
                    s_mcause <= MCAUSE_LD_ADDR_MISS_ALIGN;
                    s_load_addr_miss_align <= '0';
                elsif s_store_addr_miss_align = '1' then
                    s_mcause <= MCAUSE_ST_ADDR_MISS_ALIGN;
                    s_store_addr_miss_align <= '0';
                elsif s_ecall = '1' then
                    s_mcause <= MCAUSE_ECALL;
                    s_ecall <= '0';
                elsif s_illegal_mem_access = '1' then
                    s_mcause <= MCAUSE_ILLEGAL_MEM;
                    s_illegal_mem_access <= '0';
                end if;
            end if;
        end if;
        if i_reset = '1' then
            s_ins_addr_miss_align <= '0';
            s_illegal_ins <= '0';
            s_load_addr_miss_align <= '0';
            s_store_addr_miss_align <= '0';
            s_illegal_mem_access <= '0';
            s_ecall <= '0';
        end if;
    end process;

    o_mtval <= s_current_pc;
    o_mcause <= s_mcause;

    o_exc_in_order <= s_ins_addr_miss_align or s_illegal_ins or s_load_addr_miss_align or s_store_addr_miss_align or s_ecall or s_illegal_mem_access;
    o_exc_trap <= o_exc_in_order and i_trap_enabled;

end Structure;
