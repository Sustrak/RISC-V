	SRAMController u0 (
		.clk_clk                  (<connected-to-clk_clk>),                  //        clk.clk
		.reset_reset_n            (<connected-to-reset_reset_n>),            //      reset.reset_n
		.sram_DQ                  (<connected-to-sram_DQ>),                  //       sram.DQ
		.sram_ADDR                (<connected-to-sram_ADDR>),                //           .ADDR
		.sram_LB_N                (<connected-to-sram_LB_N>),                //           .LB_N
		.sram_UB_N                (<connected-to-sram_UB_N>),                //           .UB_N
		.sram_CE_N                (<connected-to-sram_CE_N>),                //           .CE_N
		.sram_OE_N                (<connected-to-sram_OE_N>),                //           .OE_N
		.sram_WE_N                (<connected-to-sram_WE_N>),                //           .WE_N
		.controller_address       (<connected-to-controller_address>),       // controller.address
		.controller_byteenable    (<connected-to-controller_byteenable>),    //           .byteenable
		.controller_read          (<connected-to-controller_read>),          //           .read
		.controller_write         (<connected-to-controller_write>),         //           .write
		.controller_writedata     (<connected-to-controller_writedata>),     //           .writedata
		.controller_readdata      (<connected-to-controller_readdata>),      //           .readdata
		.controller_readdatavalid (<connected-to-controller_readdatavalid>)  //           .readdatavalid
	);

