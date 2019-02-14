	UART u0 (
		.clk_clk            (<connected-to-clk_clk>),            //   clk.clk
		.reset_reset_n      (<connected-to-reset_reset_n>),      // reset.reset_n
		.uart_rxd           (<connected-to-uart_rxd>),           //  uart.rxd
		.uart_txd           (<connected-to-uart_txd>),           //      .txd
		.int_irq            (<connected-to-int_irq>),            //   int.irq
		.wire_address       (<connected-to-wire_address>),       //  wire.address
		.wire_begintransfer (<connected-to-wire_begintransfer>), //      .begintransfer
		.wire_chipselect    (<connected-to-wire_chipselect>),    //      .chipselect
		.wire_read_n        (<connected-to-wire_read_n>),        //      .read_n
		.wire_write_n       (<connected-to-wire_write_n>),       //      .write_n
		.wire_writedata     (<connected-to-wire_writedata>),     //      .writedata
		.wire_readdata      (<connected-to-wire_readdata>),      //      .readdata
		.wire_endofpacket   (<connected-to-wire_endofpacket>)    //      .endofpacket
	);

