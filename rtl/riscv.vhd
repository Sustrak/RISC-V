library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity riscv is
	port (
		-- CLOCK
		CLOCK_50    : in std_logic;
	    CLOCK2_50   : in std_logic;
		CLOCK3_50	: in std_logic;
		-- SDRAM
		DRAM_ADDR   : out std_logic_vector(12 downto 0);
		DRAM_BA     : out std_logic_vector(1 downto 0);
		DRAM_CAS_N  : out std_logic;
		DRAM_CKE    : out std_logic;
		DRAM_CLK    : out std_logic;
		DRAM_CS_N   : out std_logic;
		DRAM_DQ     : inout std_logic_vector(31 downto 0);
		DRAM_DQM   : out std_logic_vector(3 downto 0);
		DRAM_RAS_N  : out std_logic;
		DRAM_WE_N   : out std_logic;
		-- SEG7
		HEX0        : out std_logic_vector(6 downto 0);
		HEX1        : out std_logic_vector(6 downto 0);
		HEX2        : out std_logic_vector(6 downto 0);
		HEX3        : out std_logic_vector(6 downto 0);
		HEX4        : out std_logic_vector(6 downto 0);
		HEX5        : out std_logic_vector(6 downto 0);
		HEX6        : out std_logic_vector(6 downto 0);
		HEX7        : out std_logic_vector(6 downto 0);
		-- KEY
		KEY         : in std_logic_vector(3 downto 0);
		-- LED
		LEDR        : out std_logic_vector(17 downto 0);
		LEDG		: out std_logic_vector(8 downto 0);
		-- PS2
		PS2_CLK     : inout std_logic;
		PS2_CLK2    : inout std_logic;
		PS2_DAT     : inout std_logic;
		PS2_DAT2    : inout std_logic;
		-- SW
		SW          : in std_logic_vector(17 downto 0);
		-- VGA
		VGA_BLANK_N : out std_logic;
		VGA_B       : out std_logic_vector(7 downto 0);
		VGA_CLK     : out std_logic;
		VGA_G       : out std_logic_vector(7 downto 0);
		VGA_HS      : out std_logic;
		VGA_R       : out std_logic_vector(7 downto 0);
		VGA_SYNC_N  : out std_logic;
		VGA_VS      : out std_logic;
		-- LCD
		LCD_BLON	: out std_logic;
        LCD_DATA	: inout std_logic_vector(7 downto 0);
        LCD_EN		: out std_logic;
        LCD_ON		: out std_logic;
        LCD_RS		: out std_logic;
        LCD_RW		: out std_logic;
		-- RS232
		UART_CTS	: out std_logic;
		UART_RTS	: in std_logic;
		UART_RXD	: in std_logic;
		UART_TXD	: out std_logic;
		-- EEPROM
		EEP_I2C_SCLK : out std_logic;
		EEP_I2C_SDAT : inout std_logic;
		-- Ethernet 0
		ENET0_GTX_CLK : out std_logic;
		ENET0_INT_N		: in std_logic;
		ENET0_LINK100	: in std_logic;
		ENET0_MDC		: out std_logic;
		ENET0_MDIO		: inout std_logic;
		ENET0_RST_N		: out std_logic;
		ENET0_RX_CLK	: in std_logic;
		ENET0_RX_COL	: in std_logic;
		ENET0_RX_CRS	: in std_logic;
		ENET0_RX_DATA	: in std_logic_vector(3 downto 0);
		ENET0_RX_DV		: in std_logic;
		ENET0_RX_ER		: in std_logic;
		ENET0_TX_CLK	: in std_logic;
		ENET0_TX_DATA	: out std_logic_vector(3 downto 0);
		ENET0_TX_EN		: out std_logic;
		ENET0_TX_ER		: out std_logic;
		ENETCLK_25		: in std_logic;
		-- USB
		OTG_ADDR 		: out std_logic_vector(1 downto 0);
		OTG_CS_N		: out std_logic;
		OTG_DACK_N		: out std_logic_vector(1 downto 0);
		OTG_DATA		: inout std_logic_vector(15 downto 0);
		OTG_DREQ		: in std_logic_vector(1 downto 0);
		OTG_FSPEED		: inout std_logic;
		OTG_INT			: in std_logic_vector(1 downto 0);
		OTG_LSPEED		: inout std_logic;
		OTG_RD_N		: out std_logic;
		OTG_RST_N		: out std_logic;
		OTG_WE_N		: out std_logic; 		
		-- SRAM
		SRAM_ADDR		: out std_logic_vector(19 downto 0);
        SRAM_CE_N		: out std_logic;
        SRAM_DQ			: inout std_logic_vector(15 downto 0);
        SRAM_LB_N		: out std_logic;
        SRAM_OE_N		: out std_logic;
        SRAM_UB_N		: out std_logic;
        SRAM_WE_N		: out std_logic
	);
end riscv;

architecture Structure of riscv is
	component proc is
		port (
			i_boot      : in std_logic;
			i_clk_proc  : in std_logic;
			-- MEMORY
			i_rdata_mem : in std_logic_vector(R_XLEN);
			o_wdata_mem : out std_logic_vector(R_XLEN);
			o_addr_mem  : out std_logic_vector(R_XLEN);
			o_bhw       : out std_logic_vector(R_MEM_ACCS);
			o_ld_st     : out std_logic_vector(R_MEM_LDST)
		);
	end component;
	component memory_controller is
		port (
			-- SDRAM
			o_dram_addr  : out std_logic_vector(12 downto 0);
			o_dram_ba    : out std_logic_vector(1 downto 0);
			o_dram_cas_n : out std_logic;
			o_dram_cke   : out std_logic;
			o_dram_clk   : out std_logic;
			o_dram_cs_n  : out std_logic;
			io_dram_dq   : inout std_logic_vector(31 downto 0);
			o_dram_dqm	 : out std_logic_vector(3 downto 0);
			o_dram_ras_n : out std_logic;
			o_dram_we_n  : out std_logic;
			-- SRAM
			io_sram_dq	: inout std_logic_vector(15 downto 0);
        	o_sram_addr : out std_logic_vector(19 downto 0);
        	o_sram_lb	: out std_logic;  
        	o_sram_ub	: out std_logic;  
        	o_sram_ce	: out std_logic;  
        	o_sram_oe	: out std_logic;  
        	o_sram_we	: out std_logic;  
			-- PROC
			i_clk_50     : in std_logic;
			i_boot       : in std_logic;
			i_addr       : in std_logic_vector(R_XLEN);
			i_bhw        : in std_logic_vector(R_MEM_ACCS);
			i_wr_data    : in std_logic_vector(R_XLEN);
			i_ld_st      : in std_logic_vector(R_MEM_LDST);
			o_rd_data    : out std_logic_vector(R_XLEN)
		);
	end component;
	signal s_clk_p     : std_logic := '0';
	signal s_count     : std_logic_vector(1 downto 0) := "00";
	signal s_rdata_mem : std_logic_vector(R_XLEN);
	signal s_wdata_mem : std_logic_vector(R_XLEN);
	signal s_addr_mem  : std_logic_vector(R_XLEN);
	signal s_ld_st     : std_logic_vector(R_MEM_LDST);
	signal s_bhw       : std_logic_vector(R_MEM_ACCS);
begin
	c_proc : proc
	port map(
		i_boot      => SW(0),
		i_clk_proc  => s_clk_p,
		-- MEMORY
		i_rdata_mem => s_rdata_mem,
		o_wdata_mem => s_wdata_mem,
		o_addr_mem  => s_addr_mem,
		o_bhw       => s_bhw,
		o_ld_st     => s_ld_st
	);

	c_mem_ctrl : memory_controller
	port map(
		-- SDRAM
		o_dram_addr  => DRAM_ADDR,
		o_dram_ba    => DRAM_BA,
		o_dram_cas_n => DRAM_CAS_N,
		o_dram_cke   => DRAM_CKE,
		o_dram_clk   => DRAM_CLK,
		o_dram_cs_n  => DRAM_CS_N,
		io_dram_dq   => DRAM_DQ,
		o_dram_dqm   => DRAM_DQM,
		o_dram_ras_n => DRAM_RAS_N,
		o_dram_we_n  => DRAM_WE_N,
		-- SRAM
		io_sram_dq	 => SRAM_DQ,	
        o_sram_addr  => SRAM_ADDR,
        o_sram_lb	 => SRAM_LB_N,
        o_sram_ub	 => SRAM_UB_N,
        o_sram_ce	 => SRAM_CE_N,
        o_sram_oe	 => SRAM_OE_N,
        o_sram_we	 => SRAM_WE_N,
		-- PROC
		i_clk_50     => CLOCK_50,
		i_boot       => SW(0),
		i_addr       => s_addr_mem,
		i_bhw        => s_bhw,
		i_wr_data    => s_wdata_mem,
		i_ld_st      => s_ld_st,
		o_rd_data    => s_rdata_mem
	);

	-- Base clock for the processor 
	process (CLOCK_50)
	begin
		if rising_edge(CLOCK_50) then
			s_count <= std_logic_vector(unsigned(s_count) + 1);
		end if;
	end process;

	s_clk_p <= s_count(1);

	LEDR(17) <= SW(17);
	LEDR(16) <= '1';
end Structure;
