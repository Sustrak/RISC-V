library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity riscv is
	port (
		-- CLOCK
		CLOCK_50      : in std_logic;
		CLOCK2_50     : in std_logic;
		CLOCK3_50     : in std_logic;
		-- SDRAM
		DRAM_ADDR     : out std_logic_vector(12 downto 0);
		DRAM_BA       : out std_logic_vector(1 downto 0);
		DRAM_CAS_N    : out std_logic;
		DRAM_CKE      : out std_logic;
		DRAM_CLK      : out std_logic;
		DRAM_CS_N     : out std_logic;
		DRAM_DQ       : inout std_logic_vector(31 downto 0);
		DRAM_DQM      : out std_logic_vector(3 downto 0);
		DRAM_RAS_N    : out std_logic;
		DRAM_WE_N     : out std_logic;
		-- SEG7
		HEX0          : out std_logic_vector(6 downto 0);
		HEX1          : out std_logic_vector(6 downto 0);
		HEX2          : out std_logic_vector(6 downto 0);
		HEX3          : out std_logic_vector(6 downto 0);
		HEX4          : out std_logic_vector(6 downto 0);
		HEX5          : out std_logic_vector(6 downto 0);
		HEX6          : out std_logic_vector(6 downto 0);
		HEX7          : out std_logic_vector(6 downto 0);
		-- KEY
		KEY           : in std_logic_vector(3 downto 0);
		-- LED
		LEDR          : out std_logic_vector(17 downto 0);
		LEDG          : out std_logic_vector(8 downto 0);
		-- PS2
		PS2_CLK       : inout std_logic;
		PS2_CLK2      : inout std_logic;
		PS2_DAT       : inout std_logic;
		PS2_DAT2      : inout std_logic;
		-- SW
		SW            : in std_logic_vector(17 downto 0);
		-- VGA
		VGA_BLANK_N   : out std_logic;
		VGA_B         : out std_logic_vector(7 downto 0);
		VGA_CLK       : out std_logic;
		VGA_G         : out std_logic_vector(7 downto 0);
		VGA_HS        : out std_logic;
		VGA_R         : out std_logic_vector(7 downto 0);
		VGA_SYNC_N    : out std_logic;
		VGA_VS        : out std_logic;
		-- LCD
		LCD_BLON      : out std_logic;
		LCD_DATA      : inout std_logic_vector(7 downto 0);
		LCD_EN        : out std_logic;
		LCD_ON        : out std_logic;
		LCD_RS        : out std_logic;
		LCD_RW        : out std_logic;
		-- RS232
		UART_CTS      : out std_logic;
		UART_RTS      : in std_logic;
		UART_RXD      : in std_logic;
		UART_TXD      : out std_logic;
		-- EEPROM
		EEP_I2C_SCLK  : out std_logic;
		EEP_I2C_SDAT  : inout std_logic;
		-- Ethernet 0
		ENET0_GTX_CLK : out std_logic;
		ENET0_INT_N   : in std_logic;
		ENET0_LINK100 : in std_logic;
		ENET0_MDC     : out std_logic;
		ENET0_MDIO    : inout std_logic;
		ENET0_RST_N   : out std_logic;
		ENET0_RX_CLK  : in std_logic;
		ENET0_RX_COL  : in std_logic;
		ENET0_RX_CRS  : in std_logic;
		ENET0_RX_DATA : in std_logic_vector(3 downto 0);
		ENET0_RX_DV   : in std_logic;
		ENET0_RX_ER   : in std_logic;
		ENET0_TX_CLK  : in std_logic;
		ENET0_TX_DATA : out std_logic_vector(3 downto 0);
		ENET0_TX_EN   : out std_logic;
		ENET0_TX_ER   : out std_logic;
		ENETCLK_25    : in std_logic;
		-- USB
		OTG_ADDR      : out std_logic_vector(1 downto 0);
		OTG_CS_N      : out std_logic;
		OTG_DACK_N    : out std_logic_vector(1 downto 0);
		OTG_DATA      : inout std_logic_vector(15 downto 0);
		OTG_DREQ      : in std_logic_vector(1 downto 0);
		OTG_FSPEED    : inout std_logic;
		OTG_INT       : in std_logic_vector(1 downto 0);
		OTG_LSPEED    : inout std_logic;
		OTG_RD_N      : out std_logic;
		OTG_RST_N     : out std_logic;
		OTG_WE_N      : out std_logic;
		-- SRAM
		SRAM_ADDR     : out std_logic_vector(19 downto 0);
		SRAM_CE_N     : out std_logic;
		SRAM_DQ       : inout std_logic_vector(15 downto 0);
		SRAM_LB_N     : out std_logic;
		SRAM_OE_N     : out std_logic;
		SRAM_UB_N     : out std_logic;
		SRAM_WE_N     : out std_logic
	);
end riscv;

architecture Structure of riscv is
	component proc is
		port (
			i_boot            : in std_logic;
			i_clk_proc        : in std_logic;
            i_clk_50          : in std_logic;
			-- MEMORY
			i_rdata_mem       : in std_logic_vector(R_XLEN);
			o_wdata_mem       : out std_logic_vector(R_XLEN);
			o_addr_mem        : out std_logic_vector(R_XLEN);
			o_bhw             : out std_logic_vector(R_MEM_ACCS);
			o_ld_st           : out std_logic_vector(R_MEM_LDST);
			i_avalon_readvalid : in std_logic;
            o_proc_data_read  : out std_logic;
            i_int             : in std_logic;
            i_int_mcause      : in std_logic_vector(R_XLEN);
            o_int_ack         : out std_logic
		);
	end component;
	component memory_controller is
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
            i_proc_data_read  : in std_logic;
            i_int_ack         : in std_logic;
            o_int             : out std_logic;
            o_mcause          : out std_logic_vector(R_XLEN);
            -- IO
            o_led_r           : out std_logic_vector(R_LED_R);
            o_led_g           : out std_logic_vector(R_LED_G);
            o_hex             : out std_logic_vector(R_HEX);
            i_key             : in std_logic_vector(R_KEY);
            i_switch          : in std_logic_vector(R_SWITCH);
            io_ps2_CLK        : inout std_logic;
            io_ps2_DAT        : inout std_logic;
            -- VGA
            o_vga_CLK         : out   std_logic;
            o_vga_HS          : out   std_logic;
            o_vga_VS          : out   std_logic;
            o_vga_BLANK       : out   std_logic;
            o_vga_SYNC        : out   std_logic;
            o_vga_R           : out   std_logic_vector(7 downto 0);
            o_vga_G           : out   std_logic_vector(7 downto 0);
            o_vga_B           : out   std_logic_vector(7 downto 0);
            o_sram_DQ         : inout std_logic_vector(15 downto 0) := (others => 'X');
            o_sram_ADDR       : out   std_logic_vector(19 downto 0);
            o_sram_LB_N       : out   std_logic;
            o_sram_UB_N       : out   std_logic;
            o_sram_CE_N       : out   std_logic;
            o_sram_OE_N       : out   std_logic;
            o_sram_WE_N       : out   std_logic
		);
	end component;
    component system_pll is
        port (
            inclk0 : in std_logic;
            c0     : out std_logic;
            c1     : out std_logic
        );
    end component;

	signal s_clk_p           : std_logic                    := '0';
    signal s_clock_100       : std_logic;
	signal s_rdata_mem       : std_logic_vector(R_XLEN);
	signal s_wdata_mem       : std_logic_vector(R_XLEN);
	signal s_addr_mem        : std_logic_vector(R_XLEN);
	signal s_ld_st           : std_logic_vector(R_MEM_LDST);
	signal s_bhw             : std_logic_vector(R_MEM_ACCS);
	signal s_avalon_readvalid : std_logic;
    signal s_proc_data_read  : std_logic;
    signal s_hex_bus         : std_logic_vector(R_HEX);
    signal s_key             : std_logic_vector(R_KEY);
    signal s_int_ack         : std_logic;
    signal s_int             : std_logic;
    signal s_mcause          : std_logic_vector(R_XLEN);
begin
	c_proc : proc
	port map(
		i_boot            => SW(0),
        i_clk_50          => CLOCK_50,
		i_clk_proc        => s_clk_p,
		-- MEMORY
		i_rdata_mem       => s_rdata_mem,
		o_wdata_mem       => s_wdata_mem,
		o_addr_mem        => s_addr_mem,
		o_bhw             => s_bhw,
		o_ld_st           => s_ld_st,
		i_avalon_readvalid => s_avalon_readvalid,
        o_proc_data_read  => s_proc_data_read,
        o_int_ack        => s_int_ack,
        i_int             => s_int,
        i_int_mcause          => s_mcause
	);

	c_mem_ctrl : memory_controller
	port map(
		-- SDRAM
		o_dram_addr       => DRAM_ADDR,
		o_dram_ba         => DRAM_BA,
		o_dram_cas_n      => DRAM_CAS_N,
		o_dram_cke        => DRAM_CKE,
		o_dram_clk        => DRAM_CLK,
		o_dram_cs_n       => DRAM_CS_N,
		io_dram_dq        => DRAM_DQ,
		o_dram_dqm        => DRAM_DQM,
		o_dram_ras_n      => DRAM_RAS_N,
		o_dram_we_n       => DRAM_WE_N,
		-- PROC
		i_clk_50          => CLOCK_50,
		i_reset           => SW(0),
		i_addr            => s_addr_mem,
		i_bhw             => s_bhw,
		i_wr_data         => s_wdata_mem,
		i_ld_st           => s_ld_st,
		o_rd_data         => s_rdata_mem,
		o_avalon_readvalid => s_avalon_readvalid,
        i_proc_data_read  => s_proc_data_read,
        i_int_ack         => s_int_ack,
        o_int             => s_int,
        o_mcause          => s_mcause,
        -- IO
        o_led_r           => LEDR,
        o_led_g           => LEDG,
        o_hex             => s_hex_bus,
        i_key             => s_key,
        i_switch          => SW(17 downto 1) & '0',
        io_ps2_CLK        => PS2_CLK,
        io_ps2_DAT        => PS2_DAT,
        -- VGA
        o_vga_CLK         => VGA_CLK,
        o_vga_HS          => VGA_HS,
        o_vga_VS          => VGA_VS,
        o_vga_BLANK       => VGA_BLANK_N,
        o_vga_SYNC        => VGA_SYNC_N,
        o_vga_R           => VGA_R,
        o_vga_G           => VGA_G,
        o_vga_B           => VGA_b,
        o_sram_DQ         => SRAM_DQ,
        o_sram_ADDR       =>  SRAM_ADDR,
        o_sram_LB_N       =>  SRAM_LB_N,
        o_sram_UB_N       =>  SRAM_UB_N,
        o_sram_CE_N       =>  SRAM_CE_N,
        o_sram_OE_N       =>  SRAM_OE_N, 
        o_sram_WE_N       =>  SRAM_WE_N 
	);

    c_system_pll : system_pll
    port map(
        inclk0 => CLOCK_50,
        c0 => s_clock_100,
        c1 => s_clk_p
    );

    s_key <= not KEY;

    HEX7 <= s_hex_bus(R_HEX7);
    HEX6 <= s_hex_bus(R_HEX6);
    HEX5 <= s_hex_bus(R_HEX5);
    HEX4 <= s_hex_bus(R_HEX4);
    HEX3 <= s_hex_bus(R_HEX3);
    HEX2 <= s_hex_bus(R_HEX2);
    HEX1 <= s_hex_bus(R_HEX1);
    HEX0 <= s_hex_bus(R_HEX0);
end Structure;
