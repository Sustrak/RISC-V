
module SRAMController (
	clk_clk,
	reset_reset_n,
	sram_DQ,
	sram_ADDR,
	sram_LB_N,
	sram_UB_N,
	sram_CE_N,
	sram_OE_N,
	sram_WE_N,
	controller_address,
	controller_byteenable,
	controller_read,
	controller_write,
	controller_writedata,
	controller_readdata,
	controller_readdatavalid);	

	input		clk_clk;
	input		reset_reset_n;
	inout	[15:0]	sram_DQ;
	output	[19:0]	sram_ADDR;
	output		sram_LB_N;
	output		sram_UB_N;
	output		sram_CE_N;
	output		sram_OE_N;
	output		sram_WE_N;
	input	[19:0]	controller_address;
	input	[1:0]	controller_byteenable;
	input		controller_read;
	input		controller_write;
	input	[15:0]	controller_writedata;
	output	[15:0]	controller_readdata;
	output		controller_readdatavalid;
endmodule
