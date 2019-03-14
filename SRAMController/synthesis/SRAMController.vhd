-- SRAMController.vhd

-- Generated using ACDS version 18.1 625

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SRAMController is
	port (
		clk_clk                  : in    std_logic                     := '0';             --        clk.clk
		controller_address       : in    std_logic_vector(19 downto 0) := (others => '0'); -- controller.address
		controller_byteenable    : in    std_logic_vector(1 downto 0)  := (others => '0'); --           .byteenable
		controller_read          : in    std_logic                     := '0';             --           .read
		controller_write         : in    std_logic                     := '0';             --           .write
		controller_writedata     : in    std_logic_vector(15 downto 0) := (others => '0'); --           .writedata
		controller_readdata      : out   std_logic_vector(15 downto 0);                    --           .readdata
		controller_readdatavalid : out   std_logic;                                        --           .readdatavalid
		reset_reset_n            : in    std_logic                     := '0';             --      reset.reset_n
		sram_DQ                  : inout std_logic_vector(15 downto 0) := (others => '0'); --       sram.DQ
		sram_ADDR                : out   std_logic_vector(19 downto 0);                    --           .ADDR
		sram_LB_N                : out   std_logic;                                        --           .LB_N
		sram_UB_N                : out   std_logic;                                        --           .UB_N
		sram_CE_N                : out   std_logic;                                        --           .CE_N
		sram_OE_N                : out   std_logic;                                        --           .OE_N
		sram_WE_N                : out   std_logic                                         --           .WE_N
	);
end entity SRAMController;

architecture rtl of SRAMController is
	component SRAMController_sram_controller is
		port (
			clk           : in    std_logic                     := 'X';             -- clk
			reset         : in    std_logic                     := 'X';             -- reset
			SRAM_DQ       : inout std_logic_vector(15 downto 0) := (others => 'X'); -- export
			SRAM_ADDR     : out   std_logic_vector(19 downto 0);                    -- export
			SRAM_LB_N     : out   std_logic;                                        -- export
			SRAM_UB_N     : out   std_logic;                                        -- export
			SRAM_CE_N     : out   std_logic;                                        -- export
			SRAM_OE_N     : out   std_logic;                                        -- export
			SRAM_WE_N     : out   std_logic;                                        -- export
			address       : in    std_logic_vector(19 downto 0) := (others => 'X'); -- address
			byteenable    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			read          : in    std_logic                     := 'X';             -- read
			write         : in    std_logic                     := 'X';             -- write
			writedata     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			readdata      : out   std_logic_vector(15 downto 0);                    -- readdata
			readdatavalid : out   std_logic                                         -- readdatavalid
		);
	end component SRAMController_sram_controller;

	component altera_reset_controller is
		generic (
			NUM_RESET_INPUTS          : integer := 6;
			OUTPUT_RESET_SYNC_EDGES   : string  := "deassert";
			SYNC_DEPTH                : integer := 2;
			RESET_REQUEST_PRESENT     : integer := 0;
			RESET_REQ_WAIT_TIME       : integer := 1;
			MIN_RST_ASSERTION_TIME    : integer := 3;
			RESET_REQ_EARLY_DSRT_TIME : integer := 1;
			USE_RESET_REQUEST_IN0     : integer := 0;
			USE_RESET_REQUEST_IN1     : integer := 0;
			USE_RESET_REQUEST_IN2     : integer := 0;
			USE_RESET_REQUEST_IN3     : integer := 0;
			USE_RESET_REQUEST_IN4     : integer := 0;
			USE_RESET_REQUEST_IN5     : integer := 0;
			USE_RESET_REQUEST_IN6     : integer := 0;
			USE_RESET_REQUEST_IN7     : integer := 0;
			USE_RESET_REQUEST_IN8     : integer := 0;
			USE_RESET_REQUEST_IN9     : integer := 0;
			USE_RESET_REQUEST_IN10    : integer := 0;
			USE_RESET_REQUEST_IN11    : integer := 0;
			USE_RESET_REQUEST_IN12    : integer := 0;
			USE_RESET_REQUEST_IN13    : integer := 0;
			USE_RESET_REQUEST_IN14    : integer := 0;
			USE_RESET_REQUEST_IN15    : integer := 0;
			ADAPT_RESET_REQUEST       : integer := 0
		);
		port (
			reset_in0      : in  std_logic := 'X'; -- reset
			clk            : in  std_logic := 'X'; -- clk
			reset_out      : out std_logic;        -- reset
			reset_req      : out std_logic;        -- reset_req
			reset_req_in0  : in  std_logic := 'X'; -- reset_req
			reset_in1      : in  std_logic := 'X'; -- reset
			reset_req_in1  : in  std_logic := 'X'; -- reset_req
			reset_in2      : in  std_logic := 'X'; -- reset
			reset_req_in2  : in  std_logic := 'X'; -- reset_req
			reset_in3      : in  std_logic := 'X'; -- reset
			reset_req_in3  : in  std_logic := 'X'; -- reset_req
			reset_in4      : in  std_logic := 'X'; -- reset
			reset_req_in4  : in  std_logic := 'X'; -- reset_req
			reset_in5      : in  std_logic := 'X'; -- reset
			reset_req_in5  : in  std_logic := 'X'; -- reset_req
			reset_in6      : in  std_logic := 'X'; -- reset
			reset_req_in6  : in  std_logic := 'X'; -- reset_req
			reset_in7      : in  std_logic := 'X'; -- reset
			reset_req_in7  : in  std_logic := 'X'; -- reset_req
			reset_in8      : in  std_logic := 'X'; -- reset
			reset_req_in8  : in  std_logic := 'X'; -- reset_req
			reset_in9      : in  std_logic := 'X'; -- reset
			reset_req_in9  : in  std_logic := 'X'; -- reset_req
			reset_in10     : in  std_logic := 'X'; -- reset
			reset_req_in10 : in  std_logic := 'X'; -- reset_req
			reset_in11     : in  std_logic := 'X'; -- reset
			reset_req_in11 : in  std_logic := 'X'; -- reset_req
			reset_in12     : in  std_logic := 'X'; -- reset
			reset_req_in12 : in  std_logic := 'X'; -- reset_req
			reset_in13     : in  std_logic := 'X'; -- reset
			reset_req_in13 : in  std_logic := 'X'; -- reset_req
			reset_in14     : in  std_logic := 'X'; -- reset
			reset_req_in14 : in  std_logic := 'X'; -- reset_req
			reset_in15     : in  std_logic := 'X'; -- reset
			reset_req_in15 : in  std_logic := 'X'  -- reset_req
		);
	end component altera_reset_controller;

	signal rst_controller_reset_out_reset : std_logic; -- rst_controller:reset_out -> sram_controller:reset
	signal reset_reset_n_ports_inv        : std_logic; -- reset_reset_n:inv -> rst_controller:reset_in0

begin

	sram_controller : component SRAMController_sram_controller
		port map (
			clk           => clk_clk,                        --                clk.clk
			reset         => rst_controller_reset_out_reset, --              reset.reset
			SRAM_DQ       => sram_DQ,                        -- external_interface.export
			SRAM_ADDR     => sram_ADDR,                      --                   .export
			SRAM_LB_N     => sram_LB_N,                      --                   .export
			SRAM_UB_N     => sram_UB_N,                      --                   .export
			SRAM_CE_N     => sram_CE_N,                      --                   .export
			SRAM_OE_N     => sram_OE_N,                      --                   .export
			SRAM_WE_N     => sram_WE_N,                      --                   .export
			address       => controller_address,             --  avalon_sram_slave.address
			byteenable    => controller_byteenable,          --                   .byteenable
			read          => controller_read,                --                   .read
			write         => controller_write,               --                   .write
			writedata     => controller_writedata,           --                   .writedata
			readdata      => controller_readdata,            --                   .readdata
			readdatavalid => controller_readdatavalid        --                   .readdatavalid
		);

	rst_controller : component altera_reset_controller
		generic map (
			NUM_RESET_INPUTS          => 1,
			OUTPUT_RESET_SYNC_EDGES   => "deassert",
			SYNC_DEPTH                => 2,
			RESET_REQUEST_PRESENT     => 0,
			RESET_REQ_WAIT_TIME       => 1,
			MIN_RST_ASSERTION_TIME    => 3,
			RESET_REQ_EARLY_DSRT_TIME => 1,
			USE_RESET_REQUEST_IN0     => 0,
			USE_RESET_REQUEST_IN1     => 0,
			USE_RESET_REQUEST_IN2     => 0,
			USE_RESET_REQUEST_IN3     => 0,
			USE_RESET_REQUEST_IN4     => 0,
			USE_RESET_REQUEST_IN5     => 0,
			USE_RESET_REQUEST_IN6     => 0,
			USE_RESET_REQUEST_IN7     => 0,
			USE_RESET_REQUEST_IN8     => 0,
			USE_RESET_REQUEST_IN9     => 0,
			USE_RESET_REQUEST_IN10    => 0,
			USE_RESET_REQUEST_IN11    => 0,
			USE_RESET_REQUEST_IN12    => 0,
			USE_RESET_REQUEST_IN13    => 0,
			USE_RESET_REQUEST_IN14    => 0,
			USE_RESET_REQUEST_IN15    => 0,
			ADAPT_RESET_REQUEST       => 0
		)
		port map (
			reset_in0      => reset_reset_n_ports_inv,        -- reset_in0.reset
			clk            => clk_clk,                        --       clk.clk
			reset_out      => rst_controller_reset_out_reset, -- reset_out.reset
			reset_req      => open,                           -- (terminated)
			reset_req_in0  => '0',                            -- (terminated)
			reset_in1      => '0',                            -- (terminated)
			reset_req_in1  => '0',                            -- (terminated)
			reset_in2      => '0',                            -- (terminated)
			reset_req_in2  => '0',                            -- (terminated)
			reset_in3      => '0',                            -- (terminated)
			reset_req_in3  => '0',                            -- (terminated)
			reset_in4      => '0',                            -- (terminated)
			reset_req_in4  => '0',                            -- (terminated)
			reset_in5      => '0',                            -- (terminated)
			reset_req_in5  => '0',                            -- (terminated)
			reset_in6      => '0',                            -- (terminated)
			reset_req_in6  => '0',                            -- (terminated)
			reset_in7      => '0',                            -- (terminated)
			reset_req_in7  => '0',                            -- (terminated)
			reset_in8      => '0',                            -- (terminated)
			reset_req_in8  => '0',                            -- (terminated)
			reset_in9      => '0',                            -- (terminated)
			reset_req_in9  => '0',                            -- (terminated)
			reset_in10     => '0',                            -- (terminated)
			reset_req_in10 => '0',                            -- (terminated)
			reset_in11     => '0',                            -- (terminated)
			reset_req_in11 => '0',                            -- (terminated)
			reset_in12     => '0',                            -- (terminated)
			reset_req_in12 => '0',                            -- (terminated)
			reset_in13     => '0',                            -- (terminated)
			reset_req_in13 => '0',                            -- (terminated)
			reset_in14     => '0',                            -- (terminated)
			reset_req_in14 => '0',                            -- (terminated)
			reset_in15     => '0',                            -- (terminated)
			reset_req_in15 => '0'                             -- (terminated)
		);

	reset_reset_n_ports_inv <= not reset_reset_n;

end architecture rtl; -- of SRAMController