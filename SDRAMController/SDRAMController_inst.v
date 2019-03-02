	SDRAMController u0 (
		.clk_clk                  (<connected-to-clk_clk>),                  //        clk.clk
		.reset_reset_n            (<connected-to-reset_reset_n>),            //      reset.reset_n
		.sdram_clk_clk            (<connected-to-sdram_clk_clk>),            //  sdram_clk.clk
		.sdram_addr               (<connected-to-sdram_addr>),               //      sdram.addr
		.sdram_ba                 (<connected-to-sdram_ba>),                 //           .ba
		.sdram_cas_n              (<connected-to-sdram_cas_n>),              //           .cas_n
		.sdram_cke                (<connected-to-sdram_cke>),                //           .cke
		.sdram_cs_n               (<connected-to-sdram_cs_n>),               //           .cs_n
		.sdram_dq                 (<connected-to-sdram_dq>),                 //           .dq
		.sdram_dqm                (<connected-to-sdram_dqm>),                //           .dqm
		.sdram_ras_n              (<connected-to-sdram_ras_n>),              //           .ras_n
		.sdram_we_n               (<connected-to-sdram_we_n>),               //           .we_n
		.controller_address       (<connected-to-controller_address>),       // controller.address
		.controller_byteenable_n  (<connected-to-controller_byteenable_n>),  //           .byteenable_n
		.controller_chipselect    (<connected-to-controller_chipselect>),    //           .chipselect
		.controller_writedata     (<connected-to-controller_writedata>),     //           .writedata
		.controller_read_n        (<connected-to-controller_read_n>),        //           .read_n
		.controller_write_n       (<connected-to-controller_write_n>),       //           .write_n
		.controller_readdata      (<connected-to-controller_readdata>),      //           .readdata
		.controller_readdatavalid (<connected-to-controller_readdatavalid>), //           .readdatavalid
		.controller_waitrequest   (<connected-to-controller_waitrequest>)    //           .waitrequest
	);

