
module UART (
	clk_clk,
	int_irq,
	reset_reset_n,
	uart_rxd,
	uart_txd,
	wire_address,
	wire_begintransfer,
	wire_chipselect,
	wire_read_n,
	wire_write_n,
	wire_writedata,
	wire_readdata,
	wire_endofpacket);	

	input		clk_clk;
	output		int_irq;
	input		reset_reset_n;
	input		uart_rxd;
	output		uart_txd;
	input	[2:0]	wire_address;
	input		wire_begintransfer;
	input		wire_chipselect;
	input		wire_read_n;
	input		wire_write_n;
	input	[15:0]	wire_writedata;
	output	[15:0]	wire_readdata;
	output		wire_endofpacket;
endmodule
