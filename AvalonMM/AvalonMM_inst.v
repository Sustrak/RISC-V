	AvalonMM u0 (
		.clk_clk                   (<connected-to-clk_clk>),                   //         clk.clk
		.mm_bridge_s_waitrequest   (<connected-to-mm_bridge_s_waitrequest>),   // mm_bridge_s.waitrequest
		.mm_bridge_s_readdata      (<connected-to-mm_bridge_s_readdata>),      //            .readdata
		.mm_bridge_s_readdatavalid (<connected-to-mm_bridge_s_readdatavalid>), //            .readdatavalid
		.mm_bridge_s_burstcount    (<connected-to-mm_bridge_s_burstcount>),    //            .burstcount
		.mm_bridge_s_writedata     (<connected-to-mm_bridge_s_writedata>),     //            .writedata
		.mm_bridge_s_address       (<connected-to-mm_bridge_s_address>),       //            .address
		.mm_bridge_s_write         (<connected-to-mm_bridge_s_write>),         //            .write
		.mm_bridge_s_read          (<connected-to-mm_bridge_s_read>),          //            .read
		.mm_bridge_s_byteenable    (<connected-to-mm_bridge_s_byteenable>),    //            .byteenable
		.mm_bridge_s_debugaccess   (<connected-to-mm_bridge_s_debugaccess>),   //            .debugaccess
		.pp_hex_03_HEX0            (<connected-to-pp_hex_03_HEX0>),            //   pp_hex_03.HEX0
		.pp_hex_03_HEX1            (<connected-to-pp_hex_03_HEX1>),            //            .HEX1
		.pp_hex_03_HEX2            (<connected-to-pp_hex_03_HEX2>),            //            .HEX2
		.pp_hex_03_HEX3            (<connected-to-pp_hex_03_HEX3>),            //            .HEX3
		.pp_hex_47_HEX4            (<connected-to-pp_hex_47_HEX4>),            //   pp_hex_47.HEX4
		.pp_hex_47_HEX5            (<connected-to-pp_hex_47_HEX5>),            //            .HEX5
		.pp_hex_47_HEX6            (<connected-to-pp_hex_47_HEX6>),            //            .HEX6
		.pp_hex_47_HEX7            (<connected-to-pp_hex_47_HEX7>),            //            .HEX7
		.pp_key_export             (<connected-to-pp_key_export>),             //      pp_key.export
		.pp_led_g_export           (<connected-to-pp_led_g_export>),           //    pp_led_g.export
		.pp_led_r_export           (<connected-to-pp_led_r_export>),           //    pp_led_r.export
		.pp_switch_export          (<connected-to-pp_switch_export>),          //   pp_switch.export
		.reset_reset_n             (<connected-to-reset_reset_n>),             //       reset.reset_n
		.sdram_addr                (<connected-to-sdram_addr>),                //       sdram.addr
		.sdram_ba                  (<connected-to-sdram_ba>),                  //            .ba
		.sdram_cas_n               (<connected-to-sdram_cas_n>),               //            .cas_n
		.sdram_cke                 (<connected-to-sdram_cke>),                 //            .cke
		.sdram_cs_n                (<connected-to-sdram_cs_n>),                //            .cs_n
		.sdram_dq                  (<connected-to-sdram_dq>),                  //            .dq
		.sdram_dqm                 (<connected-to-sdram_dqm>),                 //            .dqm
		.sdram_ras_n               (<connected-to-sdram_ras_n>),               //            .ras_n
		.sdram_we_n                (<connected-to-sdram_we_n>),                //            .we_n
		.sdram_clk_clk             (<connected-to-sdram_clk_clk>),             //   sdram_clk.clk
		.switch_int_irq            (<connected-to-switch_int_irq>)             //  switch_int.irq
	);

