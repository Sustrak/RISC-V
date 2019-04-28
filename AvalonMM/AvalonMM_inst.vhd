	component AvalonMM is
		port (
			clk_clk                   : in    std_logic                     := 'X';             -- clk
			mm_bridge_s_waitrequest   : out   std_logic;                                        -- waitrequest
			mm_bridge_s_readdata      : out   std_logic_vector(31 downto 0);                    -- readdata
			mm_bridge_s_readdatavalid : out   std_logic;                                        -- readdatavalid
			mm_bridge_s_burstcount    : in    std_logic_vector(0 downto 0)  := (others => 'X'); -- burstcount
			mm_bridge_s_writedata     : in    std_logic_vector(31 downto 0) := (others => 'X'); -- writedata
			mm_bridge_s_address       : in    std_logic_vector(27 downto 0) := (others => 'X'); -- address
			mm_bridge_s_write         : in    std_logic                     := 'X';             -- write
			mm_bridge_s_read          : in    std_logic                     := 'X';             -- read
			mm_bridge_s_byteenable    : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- byteenable
			mm_bridge_s_debugaccess   : in    std_logic                     := 'X';             -- debugaccess
			pp_hex_03_HEX0            : out   std_logic_vector(6 downto 0);                     -- HEX0
			pp_hex_03_HEX1            : out   std_logic_vector(6 downto 0);                     -- HEX1
			pp_hex_03_HEX2            : out   std_logic_vector(6 downto 0);                     -- HEX2
			pp_hex_03_HEX3            : out   std_logic_vector(6 downto 0);                     -- HEX3
			pp_hex_47_HEX4            : out   std_logic_vector(6 downto 0);                     -- HEX4
			pp_hex_47_HEX5            : out   std_logic_vector(6 downto 0);                     -- HEX5
			pp_hex_47_HEX6            : out   std_logic_vector(6 downto 0);                     -- HEX6
			pp_hex_47_HEX7            : out   std_logic_vector(6 downto 0);                     -- HEX7
			pp_key_export             : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- export
			pp_led_g_export           : out   std_logic_vector(8 downto 0);                     -- export
			pp_led_r_export           : out   std_logic_vector(17 downto 0);                    -- export
			pp_switch_export          : in    std_logic_vector(17 downto 0) := (others => 'X'); -- export
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
			sdram_clk_clk             : out   std_logic;                                        -- clk
			switch_int_irq            : out   std_logic                                         -- irq
		);
	end component AvalonMM;

	u0 : component AvalonMM
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
			pp_hex_03_HEX0            => CONNECTED_TO_pp_hex_03_HEX0,            --   pp_hex_03.HEX0
			pp_hex_03_HEX1            => CONNECTED_TO_pp_hex_03_HEX1,            --            .HEX1
			pp_hex_03_HEX2            => CONNECTED_TO_pp_hex_03_HEX2,            --            .HEX2
			pp_hex_03_HEX3            => CONNECTED_TO_pp_hex_03_HEX3,            --            .HEX3
			pp_hex_47_HEX4            => CONNECTED_TO_pp_hex_47_HEX4,            --   pp_hex_47.HEX4
			pp_hex_47_HEX5            => CONNECTED_TO_pp_hex_47_HEX5,            --            .HEX5
			pp_hex_47_HEX6            => CONNECTED_TO_pp_hex_47_HEX6,            --            .HEX6
			pp_hex_47_HEX7            => CONNECTED_TO_pp_hex_47_HEX7,            --            .HEX7
			pp_key_export             => CONNECTED_TO_pp_key_export,             --      pp_key.export
			pp_led_g_export           => CONNECTED_TO_pp_led_g_export,           --    pp_led_g.export
			pp_led_r_export           => CONNECTED_TO_pp_led_r_export,           --    pp_led_r.export
			pp_switch_export          => CONNECTED_TO_pp_switch_export,          --   pp_switch.export
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
			sdram_clk_clk             => CONNECTED_TO_sdram_clk_clk,             --   sdram_clk.clk
			switch_int_irq            => CONNECTED_TO_switch_int_irq             --  switch_int.irq
		);

