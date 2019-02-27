library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity riscv is
	port (
		-- CLOCK
		CLOCK_50    : in std_logic;
		-- SDRAM
		DRAM_ADDR   : out std_logic_vector(12 downto 0);
		DRAM_BA     : out std_logic_vector(1 downto 0);
		DRAM_CAS_N  : out std_logic;
		DRAM_CKE    : out std_logic;
		DRAM_CLK    : out std_logic;
		DRAM_CS_N   : out std_logic;
		DRAM_DQ     : inout std_logic_vector(15 downto 0);
		DRAM_LDQM   : out std_logic;
		DRAM_RAS_N  : out std_logic;
		DRAM_UDQM   : out std_logic;
		DRAM_WE_N   : out std_logic;
		-- SEG7
		HEX0        : out std_logic_vector(6 downto 0);
		HEX1        : out std_logic_vector(6 downto 0);
		HEX2        : out std_logic_vector(6 downto 0);
		HEX3        : out std_logic_vector(6 downto 0);
		HEX4        : out std_logic_vector(6 downto 0);
		HEX5        : out std_logic_vector(6 downto 0);
		-- KEY
		KEY         : in std_logic_vector(3 downto 0);
		-- LED
		LEDR        : out std_logic_vector(9 downto 0);
		-- PS2
		PS2_CLK     : inout std_logic;
		PS2_CLK2    : inout std_logic;
		PS2_DAT     : inout std_logic;
		PS2_DAT2    : inout std_logic;
		-- SW
		SW          : in std_logic_vector(9 downto 0);
		-- VGA
		VGA_BLANK_N : out std_logic;
		VGA_B       : out std_logic_vector(7 downto 0);
		VGA_CLK     : out std_logic;
		VGA_G       : out std_logic_vector(7 downto 0);
		VGA_HS      : out std_logic;
		VGA_R       : out std_logic_vector(7 downto 0);
		VGA_SYNC_N  : out std_logic;
		VGA_VS      : out std_logic;
		-- UART
		UART_RX		: in std_logic;
		UART_TX		: out std_logic
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
			o_ld_st     : out std_logic
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
			io_dram_dq   : inout std_logic_vector(15 downto 0);
			o_dram_ldqm  : out std_logic;
			o_dram_ras_n : out std_logic;
			o_dram_udqm  : out std_logic;
			o_dram_we_n  : out std_logic;
			-- PROC
			i_clk_50     : in std_logic;
			i_boot       : in std_logic;
			i_addr       : in std_logic_vector(R_XLEN);
			i_bhw        : in std_logic_vector(R_MEM_ACCS);
			i_wr_data    : in std_logic_vector(R_XLEN);
			i_ld_st      : in std_logic;
			o_rd_data    : out std_logic_vector(R_XLEN)
		);
	end component;
	component bootloader is
		port (
			i_rxd : in std_logic;
			o_txd : out std_logic;
			i_clk_50 : in std_logic;
			i_reset : in std_logic
		);
	end component;
	signal s_clk_p     : std_logic := '0';
	signal s_count     : integer   := 0;
	signal s_rdata_mem : std_logic_vector(R_XLEN);
	signal s_wdata_mem : std_logic_vector(R_XLEN);
	signal s_addr_mem  : std_logic_vector(R_XLEN);
	signal s_ld_st     : std_logic;
	signal s_bhw       : std_logic_vector(R_MEM_ACCS);
begin
	c_proc : proc
	port map(
		i_boot      => SW(9),
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
		o_dram_ldqm  => DRAM_LDQM,
		o_dram_ras_n => DRAM_RAS_N,
		o_dram_udqm  => DRAM_UDQM,
		o_dram_we_n  => DRAM_WE_N,
		-- PROC
		i_clk_50     => CLOCK_50,
		i_boot       => SW(9),
		i_addr       => s_addr_mem,
		i_bhw        => s_bhw,
		i_wr_data    => s_wdata_mem,
		i_ld_st      => s_ld_st,
		o_rd_data    => s_rdata_mem
	);
	
	c_bootloader : bootloader
		port map (
			i_rxd => UART_RX,
			o_txd => UART_TX,
			i_clk_50 => CLOCK_50,
			i_reset => SW(8)
		);
	-- Base clock for the processor 
	process (CLOCK_50)
	begin
		if rising_edge(CLOCK_50) then
			s_count <= s_count + 1;
			if s_count = 3 then
				s_clk_p <= not s_clk_p;
			end if;
		end if;
	end process;

	LEDR(0) <= SW(0);
end Structure;
