library ieee;
 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity memory_controller is
	port (
		-- SDRAM
		o_dram_addr : out std_logic_vector(12 downto 0);
		o_dram_ba : out std_logic_vector(1 downto 0);
		o_dram_cas_n : out std_logic;
		o_dram_cke : out std_logic;
		o_dram_clk : out std_logic;
		o_dram_cs_n : out std_logic;
		io_dram_dq : inout std_logic_vector(15 downto 0);
		o_dram_ldqm : out std_logic;
		o_dram_ras_n : out std_logic;
		o_dram_udqm : out std_logic;
		o_dram_we_n : out std_logic;
		-- PROC
		i_clk_50 : in std_logic;
		i_boot : in std_logic;
		i_addr : in std_logic_vector(R_XLEN);
		i_bhw  : in std_logic_vector(R_MEM_ACCS);
		i_wr_data : in std_logic_vector(R_XLEN);
		i_ld_st : in std_logic;
		o_rd_data : out std_logic_vector(R_XLEN)
	);
end memory_controller;

architecture Structure of memory_controller is
	component SDRAMController is
    port (
		clk_clk             : in    std_logic                     := 'X';             -- clk
        reset_reset_n       : in    std_logic                     := 'X';             -- reset_n
        dram_clk_clk        : out   std_logic;                                        -- clk
        sdram_address       : in    std_logic_vector(24 downto 0) := (others => 'X'); -- address
        sdram_byteenable_n  : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable_n
        sdram_chipselect    : in    std_logic                     := 'X';             -- chipselect
        sdram_writedata     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
        sdram_read_n        : in    std_logic                     := 'X';             -- read_n
        sdram_write_n       : in    std_logic                     := 'X';             -- write_n
        sdram_readdata      : out   std_logic_vector(15 downto 0);                    -- readdata
        sdram_readdatavalid : out   std_logic;                                        -- readdatavalid
        sdram_waitrequest   : out   std_logic;                                        -- waitrequest
        wire_addr           : out   std_logic_vector(12 downto 0);                    -- addr
        wire_ba             : out   std_logic_vector(1 downto 0);                     -- ba
        wire_cas_n          : out   std_logic;                                        -- cas_n
        wire_cke            : out   std_logic;                                        -- cke
        wire_cs_n           : out   std_logic;                                        -- cs_n
        wire_dq             : inout std_logic_vector(15 downto 0) := (others => 'X'); -- dq
        wire_dqm            : out   std_logic_vector(1 downto 0);                     -- dqm
        wire_ras_n          : out   std_logic;                                        -- ras_n
        wire_we_n           : out   std_logic                                         -- we_n
    );
    end component SDRAMController;

	signal s_clk_143 : std_logic;
	signal s_sdram_be : std_logic_vector(1 downto 0);
	signal s_sdram_cs : std_logic;
	signal s_sdram_wr_data : std_logic_vector(15 downto 0);
	signal s_sdram_read : std_logic;
	signal s_sdram_write : std_logic;
	signal s_sdram_rd_data : std_logic_vector(15 downto 0);
	signal s_sdram_rd_valid : std_logic;
	signal s_sdram_wait : std_logic;
	signal s_dram_dqm : std_logic_vector(1 downto 0);
begin
	c_sdramcontroller : SDRAMController
	port map (
		clk_clk             => i_clk_50,
        reset_reset_n       => i_boot, 
        dram_clk_clk        => s_clk_143, 
        sdram_address       => i_addr(24 downto 0),
        sdram_byteenable_n  => s_sdram_be,
        sdram_chipselect    => s_sdram_cs,
        sdram_writedata     => s_sdram_wr_data,
        sdram_read_n        => s_sdram_read,
        sdram_write_n       => s_sdram_write,
        sdram_readdata      => s_sdram_rd_data,
        sdram_readdatavalid => s_sdram_rd_valid,
        sdram_waitrequest   => s_sdram_wait,
        wire_addr           => o_dram_addr,	
        wire_ba             => o_dram_ba,
        wire_cas_n          => o_dram_cas_n,
        wire_cke            => o_dram_cke,
        wire_cs_n           => o_dram_cs_n,
        wire_dq             => io_dram_dq,
        wire_dqm            => s_dram_dqm,
        wire_ras_n          => o_dram_ras_n,
        wire_we_n           => o_dram_we_n
	);

	o_dram_ldqm <= s_dram_dqm(0);
	o_dram_udqm <= s_dram_dqm(1);
	o_dram_clk <= s_clk_143;
	s_sdram_cs <= '1';
	
	s_sdram_be <= "10" when i_bhw = B_ACCESS else
				 "00";

	s_sdram_wr_data <= i_wr_data(15 downto 0);
	s_sdram_read <= '1' when i_ld_st = LD_MEM else
					'0';
	s_sdram_write <= '1' when i_ld_st = ST_MEM else
					 '0';
	o_rd_data <= x"0000" & s_sdram_rd_data;
	--s_sdram_rd_valid,
	--s_sdram_wait,

end Structure;
