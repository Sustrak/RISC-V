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

	u0 : component SDRAMController
		port map (
			clk_clk                  => CONNECTED_TO_clk_clk,                  --        clk.clk
			reset_reset_n            => CONNECTED_TO_reset_reset_n,            --      reset.reset_n
			sdram_clk_clk            => CONNECTED_TO_sdram_clk_clk,            --  sdram_clk.clk
			sdram_addr               => CONNECTED_TO_sdram_addr,               --      sdram.addr
			sdram_ba                 => CONNECTED_TO_sdram_ba,                 --           .ba
			sdram_cas_n              => CONNECTED_TO_sdram_cas_n,              --           .cas_n
			sdram_cke                => CONNECTED_TO_sdram_cke,                --           .cke
			sdram_cs_n               => CONNECTED_TO_sdram_cs_n,               --           .cs_n
			sdram_dq                 => CONNECTED_TO_sdram_dq,                 --           .dq
			sdram_dqm                => CONNECTED_TO_sdram_dqm,                --           .dqm
			sdram_ras_n              => CONNECTED_TO_sdram_ras_n,              --           .ras_n
			sdram_we_n               => CONNECTED_TO_sdram_we_n,               --           .we_n
			controller_address       => CONNECTED_TO_controller_address,       -- controller.address
			controller_byteenable_n  => CONNECTED_TO_controller_byteenable_n,  --           .byteenable_n
			controller_chipselect    => CONNECTED_TO_controller_chipselect,    --           .chipselect
			controller_writedata     => CONNECTED_TO_controller_writedata,     --           .writedata
			controller_read_n        => CONNECTED_TO_controller_read_n,        --           .read_n
			controller_write_n       => CONNECTED_TO_controller_write_n,       --           .write_n
			controller_readdata      => CONNECTED_TO_controller_readdata,      --           .readdata
			controller_readdatavalid => CONNECTED_TO_controller_readdatavalid, --           .readdatavalid
			controller_waitrequest   => CONNECTED_TO_controller_waitrequest    --           .waitrequest
		);

