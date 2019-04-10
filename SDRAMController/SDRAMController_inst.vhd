	component SDRAMController is
		port (
			clk_clk                   : in    std_logic                     := 'X';             -- clk
			mm_bridge_s_waitrequest   : out   std_logic;                                        -- waitrequest
			mm_bridge_s_readdata      : out   std_logic_vector(31 downto 0);                    -- readdata
			mm_bridge_s_readdatavalid : out   std_logic;                                        -- readdatavalid
			mm_bridge_s_burstcount    : in    std_logic_vector(0 downto 0)  := (others => 'X'); -- burstcount
			mm_bridge_s_writedata     : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			mm_bridge_s_address       : in    std_logic_vector(26 downto 0) := (others => 'X'); -- address
			mm_bridge_s_write         : in    std_logic                     := 'X';             -- write
			mm_bridge_s_read          : in    std_logic                     := 'X';             -- read
			mm_bridge_s_byteenable    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			mm_bridge_s_debugaccess   : in    std_logic                     := 'X';             -- debugaccess
			reset_reset_n             : in    std_logic                     := 'X';             -- reset_n
			sdram_addr                : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_ba                  : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_cas_n               : out   std_logic;                                        -- cas_n
			sdram_cke                 : out   std_logic;                                        -- cke
			sdram_cs_n                : out   std_logic;                                        -- cs_n
			sdram_dq                  : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_dqm                 : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_ras_n               : out   std_logic;                                        -- ras_n
			sdram_we_n                : out   std_logic;                                        -- we_n
			sdram_clk_clk             : out   std_logic                                         -- clk
		);
	end component SDRAMController;

	u0 : component SDRAMController
		port map (
			clk_clk                   => CONNECTED_TO_clk_clk,                   --         clk.clk
			mm_bridge_s_waitrequest   => CONNECTED_TO_mm_bridge_s_waitrequest,   -- mm_bridge_s.waitrequest
			mm_bridge_s_readdata      => CONNECTED_TO_mm_bridge_s_readdata,      --            .readdata
			mm_bridge_s_readdatavalid => CONNECTED_TO_mm_bridge_s_readdatavalid, --            .readdatavalid
			mm_bridge_s_burstcount    => CONNECTED_TO_mm_bridge_s_burstcount,    --            .burstcount
			mm_bridge_s_writedata     => CONNECTED_TO_mm_bridge_s_writedata,     --            .writedata
			mm_bridge_s_address       => CONNECTED_TO_mm_bridge_s_address,       --            .address
			mm_bridge_s_write         => CONNECTED_TO_mm_bridge_s_write,         --            .write
			mm_bridge_s_read          => CONNECTED_TO_mm_bridge_s_read,          --            .read
			mm_bridge_s_byteenable    => CONNECTED_TO_mm_bridge_s_byteenable,    --            .byteenable
			mm_bridge_s_debugaccess   => CONNECTED_TO_mm_bridge_s_debugaccess,   --            .debugaccess
			reset_reset_n             => CONNECTED_TO_reset_reset_n,             --       reset.reset_n
			sdram_addr                => CONNECTED_TO_sdram_addr,                --       sdram.addr
			sdram_ba                  => CONNECTED_TO_sdram_ba,                  --            .ba
			sdram_cas_n               => CONNECTED_TO_sdram_cas_n,               --            .cas_n
			sdram_cke                 => CONNECTED_TO_sdram_cke,                 --            .cke
			sdram_cs_n                => CONNECTED_TO_sdram_cs_n,                --            .cs_n
			sdram_dq                  => CONNECTED_TO_sdram_dq,                  --            .dq
			sdram_dqm                 => CONNECTED_TO_sdram_dqm,                 --            .dqm
			sdram_ras_n               => CONNECTED_TO_sdram_ras_n,               --            .ras_n
			sdram_we_n                => CONNECTED_TO_sdram_we_n,                --            .we_n
			sdram_clk_clk             => CONNECTED_TO_sdram_clk_clk              --   sdram_clk.clk
		);

