library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity memory_controller is
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
		-- PROC
		i_clk_50     : in std_logic;
		i_boot       : in std_logic;
		i_addr       : in std_logic_vector(R_XLEN);
		i_bhw        : in std_logic_vector(R_MEM_ACCS);
		i_wr_data    : in std_logic_vector(R_XLEN);
		i_ld_st      : in std_logic;
		o_rd_data    : out std_logic_vector(R_XLEN)
	);
end memory_controller;

architecture Structure of memory_controller is

	component SDRAMController is
		port (
			clk_clk                  : in    std_logic                     := 'X';             -- clk
			reset_reset_n            : in    std_logic                     := 'X';             -- reset_n
			sdram_clk_clk            : out   std_logic;                                        -- clk
			sdram_addr               : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba                 : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n              : out   std_logic;                                        -- cas_n
			sdram_cke                : out   std_logic;                                        -- cke
			sdram_cs_n               : out   std_logic;                                        -- cs_n
			sdram_dq                 : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_dqm                : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_ras_n              : out   std_logic;                                        -- ras_n
			sdram_we_n               : out   std_logic;                                        -- we_n
			controller_address       : in    std_logic_vector(24 downto 0) := (others => 'X'); -- address
			controller_byteenable_n  : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable_n
			controller_chipselect    : in    std_logic                     := 'X';             -- chipselect
			controller_writedata     : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			controller_read_n        : in    std_logic                     := 'X';             -- read_n
			controller_write_n       : in    std_logic                     := 'X';             -- write_n
			controller_readdata      : out   std_logic_vector(31 downto 0);                    -- readdata
			controller_readdatavalid : out   std_logic;                                        -- readdatavalid
			controller_waitrequest   : out   std_logic                                         -- waitrequest
		);
	end component SDRAMController;

	signal s_sdram_be       : std_logic_vector(3 downto 0);
	signal s_sdram_cs       : std_logic;
	signal s_sdram_wr_data  : std_logic_vector(31 downto 0);
	signal s_sdram_read     : std_logic;
	signal s_sdram_write    : std_logic;
	signal s_sdram_rd_data  : std_logic_vector(31 downto 0);
	signal s_sdram_rd_valid : std_logic;
	signal s_sdram_wait     : std_logic;
	signal s_dra2m_dqm       : std_logic_vector(3 downto 0);
begin
	c_sdram_controller : component SDRAMController
		port map (
			clk_clk                  => i_clk_50,                  --        clk.clk
			reset_reset_n            => i_boot,            --      reset.reset_n
			sdram_clk_clk            => o_dram_clk,            --  sdram_clk.clk
			sdram_addr               => o_dram_addr,               --      sdram.addr
			sdram_ba                 => o_dram_ba,                 --           .ba
			sdram_cas_n              => o_dram_cas_n,              --           .cas_n
			sdram_cke                => o_dram_cke,                --           .cke
			sdram_cs_n               => o_dram_cs_n,               --           .cs_n
			sdram_dq                 => io_dram_dq,                 --           .dq
			sdram_dqm                => o_dram_dqm,                --           .dqm
			sdram_ras_n              => o_dram_ras_n,              --           .ras_n
			sdram_we_n               => o_dram_we_n,               --           .we_n
			controller_address       => '0' & x"010000",       -- controller.address
			controller_byteenable_n  => "0000",  --           .byteenable_n
			controller_chipselect    => s_sdram_cs,    --           .chipselect
			controller_writedata     => i_wr_data,     --           .writedata
			controller_read_n        => '0',        --           .read_n
			controller_write_n       => '1',       --           .write_n
			controller_readdata      => o_rd_data,      --           .readdata
			controller_readdatavalid => s_sdram_rd_valid, --           .readdatavalid
			controller_waitrequest   => s_sdram_wait    --           .waitrequest
		);


	s_sdram_cs  <= '1';

	s_sdram_be  <= "1000" when i_bhw = B_ACCESS else
		"0000";

	s_sdram_wr_data <= i_wr_data;
	s_sdram_read    <= '1' when i_ld_st = LD_MEM else
		'0';
	s_sdram_write <= '1' when i_ld_st = ST_MEM else
		'0';
	--o_rd_data <= s_sdram_rd_data;
	--s_sdram_rd_valid,
	--s_sdram_wait,

end Structure;
