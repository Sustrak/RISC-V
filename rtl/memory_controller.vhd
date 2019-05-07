library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity memory_controller is
	port (
		-- SDRAM
		o_dram_addr       : out std_logic_vector(12 downto 0);
		o_dram_ba         : out std_logic_vector(1 downto 0);
		o_dram_cas_n      : out std_logic;
		o_dram_cke        : out std_logic;
		o_dram_clk        : out std_logic;
		o_dram_cs_n       : out std_logic;
		io_dram_dq        : inout std_logic_vector(31 downto 0);
		o_dram_dqm        : out std_logic_vector(3 downto 0);
		o_dram_ras_n      : out std_logic;
		o_dram_we_n       : out std_logic;
		-- PROC
		i_clk_50          : in std_logic;
		i_reset           : in std_logic;
		i_addr            : in std_logic_vector(R_XLEN);
		i_bhw             : in std_logic_vector(R_MEM_ACCS);
		i_wr_data         : in std_logic_vector(R_XLEN);
		i_ld_st           : in std_logic_vector(R_MEM_LDST);
		o_rd_data         : out std_logic_vector(R_XLEN);
		o_avalon_readvalid : out std_logic;
        i_proc_data_read : in std_logic;
        -- IO
        o_led_r           : out std_logic_vector(R_LED_R);
        o_led_g           : out std_logic_vector(R_LED_G);
        o_hex              : out std_logic_vector(R_HEX);
        i_key             : in std_logic_vector(R_KEY);
        i_switch          : in std_logic_vector(R_SWITCH)
	);
end memory_controller;

architecture Structure of memory_controller is

	component AvalonMM is
		port (
			clk_clk                   : in std_logic := 'X';
			mm_bridge_s_waitrequest   : out std_logic;
			mm_bridge_s_readdata      : out std_logic_vector(31 downto 0);
			mm_bridge_s_readdatavalid : out std_logic;
			mm_bridge_s_burstcount    : in std_logic_vector(0 downto 0)  := (others => 'X');
			mm_bridge_s_writedata     : in std_logic_vector(31 downto 0) := (others => 'X');
			mm_bridge_s_address       : in std_logic_vector(27 downto 0) := (others => 'X');
			mm_bridge_s_write         : in std_logic                     := 'X';
			mm_bridge_s_read          : in std_logic                     := 'X';
			mm_bridge_s_byteenable    : in std_logic_vector(3 downto 0)  := (others => 'X');
			mm_bridge_s_debugaccess   : in std_logic                     := 'X';
			reset_reset_n             : in std_logic                     := 'X';
			sdram_addr                : out std_logic_vector(12 downto 0);
			sdram_ba                  : out std_logic_vector(1 downto 0);
			sdram_cas_n               : out std_logic;
			sdram_cke                 : out std_logic;
			sdram_cs_n                : out std_logic;
			sdram_dq                  : inout std_logic_vector(31 downto 0) := (others => 'X');
			sdram_dqm                 : out std_logic_vector(3 downto 0);
			sdram_ras_n               : out std_logic;
			sdram_we_n                : out std_logic;
			sdram_clk_clk             : out std_logic;
			pp_led_g_export           : out std_logic_vector(8 downto 0);
			pp_switch_export          : in std_logic_vector(17 downto 0) := (others => 'X')
		);
	end component AvalonMM;

    component edge_detector is
        port (
            i_clk : in std_logic;
            i_signal : in std_logic;
            i_data : in std_logic_vector(R_XLEN);
            o_data : out std_logic_vector(R_XLEN);
            o_edge : out std_logic
        );
    end component;

	-- AVALON MM
	signal s_mm_waitrequest   : std_logic;
	signal s_mm_readdata      : std_logic_vector(31 downto 0);
	signal s_mm_readdatavalid : std_logic;
	signal s_mm_burstcount    : std_logic_vector(0 downto 0);
	signal s_mm_writedata     : std_logic_vector(31 downto 0);
	signal s_mm_address       : std_logic_vector(27 downto 0);
	signal s_mm_write         : std_logic;
    signal s_write            : std_logic;
	signal s_mm_read          : std_logic;
    signal s_read             : std_logic;
	signal s_mm_byteenable    : std_logic_vector(3 downto 0);
	signal s_mm_byteenable0   : std_logic_vector(3 downto 0);
	signal s_mm_debugaccess   : std_logic;
    signal s_switch_int       : std_logic;
    signal s_reset            : std_logic;
    signal s_mm_read_edge     : std_logic;
    signal s_mm_readdatavalid_edge : std_logic;
    signal s_readdata : std_logic_vector(R_XLEN);
    

    

    -- Unexpected readdatavalids from SDRAM
    signal s_expect_readdata : std_logic;
    signal s_last_ins        : std_logic_vector(R_XLEN);

    -- Read data / readdatavalid holder
    signal s_reg_readdata     : std_logic_vector(R_XLEN);
    signal s_reg_readdatavalid : std_logic;
    signal s_readdatavalid_ff : std_logic;
    signal s_readdatavalid    : std_logic;


begin

    c_avalonmm : component AvalonMM
        port map (
           	clk_clk                   => i_clk_50,
			reset_reset_n             => i_reset,
			sdram_clk_clk             => o_dram_clk,
			sdram_addr                => o_dram_addr,
			sdram_ba                  => o_dram_ba,
			sdram_cas_n               => o_dram_cas_n,
			sdram_cke                 => o_dram_cke,
			sdram_cs_n                => o_dram_cs_n,
			sdram_dq                  => io_dram_dq,
			sdram_dqm                 => o_dram_dqm,
			sdram_ras_n               => o_dram_ras_n,
			sdram_we_n                => o_dram_we_n,
			mm_bridge_s_waitrequest   => s_mm_waitrequest,
			mm_bridge_s_readdata      => s_mm_readdata,
			mm_bridge_s_readdatavalid => s_mm_readdatavalid,
			mm_bridge_s_burstcount    => s_mm_burstcount,
			mm_bridge_s_writedata     => s_mm_writedata,
			mm_bridge_s_address       => s_mm_address,
			mm_bridge_s_write         => s_mm_write,
			mm_bridge_s_read          => s_mm_read,
			mm_bridge_s_byteenable    => s_mm_byteenable,
			mm_bridge_s_debugaccess   => s_mm_debugaccess,
            pp_led_g_export           => o_led_g,
            pp_switch_export          => i_switch
        );

    c_edge_detector0 : component edge_detector
        port map (
            i_clk => i_clk_50,
            i_signal => s_mm_read,
            i_data => (others => '0'),
            o_data => open,
            o_edge => s_mm_read_edge
        );

    c_edge_detector1 : component edge_detector
        port map (
            i_clk => i_clk_50,
            i_signal => s_mm_readdatavalid,
            i_data => s_mm_readdata,
            o_data => s_readdata,
            o_edge => s_mm_readdatavalid_edge
        );

	s_write <= '1' when i_ld_st = ST_SDRAM else
		'0';
	s_read <= '1' when i_ld_st = LD_SDRAM else
		'0';

	s_mm_byteenable0 <= "1111" when i_bhw = W_ACCESS else
		"0011" when i_bhw = H_ACCESS else
		"0001" when i_bhw = B_ACCESS else
		"0000";


    -- Read data holder
    expect_readdata: process(i_clk_50, s_mm_read_edge, i_proc_data_read, i_reset)
    begin
        if rising_edge(i_clk_50) and s_mm_read_edge = '1' then
            s_expect_readdata <= '1';
        end if;
        if i_proc_data_read = '1' or i_reset = '1' then
            s_expect_readdata <= '0';
        end if;
    end process;
    
    rd_hold: process(i_clk_50, s_mm_readdatavalid_edge, i_proc_data_read, i_reset)
    begin
        if rising_edge(i_clk_50) and s_mm_readdatavalid_edge = '1' and s_expect_readdata = '1' then
            if s_mm_address < x"0001000" then
                if s_last_ins /= s_mm_readdata then
                    s_reg_readdatavalid <= '1';
                    s_reg_readdata <= s_readdata;
                    s_last_ins <= s_readdata;
                end if;
            else
                s_reg_readdatavalid <= '1';
                s_reg_readdata <= s_readdata;
            end if;
        end if;
        if i_proc_data_read = '1' then
            s_reg_readdatavalid <= '0';
        end if;
        if i_reset = '1' then
            s_reg_readdatavalid <= '0';
            s_last_ins <= (others => '0');
        end if;
    end process;
    
    o_avalon_readvalid <= s_reg_readdatavalid;
    o_rd_data <= s_reg_readdata;

	process (i_clk_50)
	begin
		if rising_edge(i_clk_50) then
			s_mm_address      <= i_addr(27 downto 0);

            --o_rd_data         <= s_mm_readdata;
			s_mm_writedata    <= i_wr_data;

            s_mm_read <= s_read;
            s_mm_write <= s_write;


			s_mm_burstcount   <= "1";

			-- BYTE ENABLE
			-- 1111  -> Writes full 32 bits
			-- 0011  -> Writes lower 2 bytes
			-- 1100  -> Writes upper 2 bytes
			-- 0001  -> Writes byte 0
			-- 0010  -> Writes byte 1
			-- 0100  -> Writes byte 2
			-- 1000  -> Writes byte 3
			s_mm_byteenable   <= s_mm_byteenable0;

			--o_avalon_readvalid <= s_mm_readdatavalid;
		end if;
	end process;
end Structure;
