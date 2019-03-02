
module SDRAMController (
	clk_clk,
	reset_reset_n,
	sdram_clk_clk,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	controller_address,
	controller_byteenable_n,
	controller_chipselect,
	controller_writedata,
	controller_read_n,
	controller_write_n,
	controller_readdata,
	controller_readdatavalid,
	controller_waitrequest);	

	input		clk_clk;
	input		reset_reset_n;
	output		sdram_clk_clk;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[31:0]	sdram_dq;
	output	[3:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	input	[24:0]	controller_address;
	input	[3:0]	controller_byteenable_n;
	input		controller_chipselect;
	input	[31:0]	controller_writedata;
	input		controller_read_n;
	input		controller_write_n;
	output	[31:0]	controller_readdata;
	output		controller_readdatavalid;
	output		controller_waitrequest;
endmodule
