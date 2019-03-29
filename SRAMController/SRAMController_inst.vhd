	component SRAMController is
		port (
			clk_clk                  : in    std_logic                     := 'X';             -- clk
			reset_reset_n            : in    std_logic                     := 'X';             -- reset_n
			sram_DQ                  : inout std_logic_vector(15 downto 0) := (others => 'X'); -- DQ
			sram_ADDR                : out   std_logic_vector(19 downto 0);                    -- ADDR
			sram_LB_N                : out   std_logic;                                        -- LB_N
			sram_UB_N                : out   std_logic;                                        -- UB_N
			sram_CE_N                : out   std_logic;                                        -- CE_N
			sram_OE_N                : out   std_logic;                                        -- OE_N
			sram_WE_N                : out   std_logic;                                        -- WE_N
			controller_address       : in    std_logic_vector(19 downto 0) := (others => 'X'); -- address
			controller_byteenable    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- byteenable
			controller_read          : in    std_logic                     := 'X';             -- read
			controller_write         : in    std_logic                     := 'X';             -- write
			controller_writedata     : in    std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			controller_readdata      : out   std_logic_vector(15 downto 0);                    -- readdata
			controller_readdatavalid : out   std_logic                                         -- readdatavalid
		);
	end component SRAMController;

	u0 : component SRAMController
		port map (
			clk_clk                  => CONNECTED_TO_clk_clk,                  --        clk.clk
			reset_reset_n            => CONNECTED_TO_reset_reset_n,            --      reset.reset_n
			sram_DQ                  => CONNECTED_TO_sram_DQ,                  --       sram.DQ
			sram_ADDR                => CONNECTED_TO_sram_ADDR,                --           .ADDR
			sram_LB_N                => CONNECTED_TO_sram_LB_N,                --           .LB_N
			sram_UB_N                => CONNECTED_TO_sram_UB_N,                --           .UB_N
			sram_CE_N                => CONNECTED_TO_sram_CE_N,                --           .CE_N
			sram_OE_N                => CONNECTED_TO_sram_OE_N,                --           .OE_N
			sram_WE_N                => CONNECTED_TO_sram_WE_N,                --           .WE_N
			controller_address       => CONNECTED_TO_controller_address,       -- controller.address
			controller_byteenable    => CONNECTED_TO_controller_byteenable,    --           .byteenable
			controller_read          => CONNECTED_TO_controller_read,          --           .read
			controller_write         => CONNECTED_TO_controller_write,         --           .write
			controller_writedata     => CONNECTED_TO_controller_writedata,     --           .writedata
			controller_readdata      => CONNECTED_TO_controller_readdata,      --           .readdata
			controller_readdatavalid => CONNECTED_TO_controller_readdatavalid  --           .readdatavalid
		);

