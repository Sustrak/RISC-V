
module AvalonMM (
	clk_clk,
	mm_bridge_s_waitrequest,
	mm_bridge_s_readdata,
	mm_bridge_s_readdatavalid,
	mm_bridge_s_burstcount,
	mm_bridge_s_writedata,
	mm_bridge_s_address,
	mm_bridge_s_write,
	mm_bridge_s_read,
	mm_bridge_s_byteenable,
	mm_bridge_s_debugaccess,
	reset_reset_n,
	sdram_addr,
	sdram_ba,
	sdram_cas_n,
	sdram_cke,
	sdram_cs_n,
	sdram_dq,
	sdram_dqm,
	sdram_ras_n,
	sdram_we_n,
	sdram_clk_clk,
	pp_led_g_export,
	pp_switch_export);	

	input		clk_clk;
	output		mm_bridge_s_waitrequest;
	output	[31:0]	mm_bridge_s_readdata;
	output		mm_bridge_s_readdatavalid;
	input	[0:0]	mm_bridge_s_burstcount;
	input	[31:0]	mm_bridge_s_writedata;
	input	[27:0]	mm_bridge_s_address;
	input		mm_bridge_s_write;
	input		mm_bridge_s_read;
	input	[3:0]	mm_bridge_s_byteenable;
	input		mm_bridge_s_debugaccess;
	input		reset_reset_n;
	output	[12:0]	sdram_addr;
	output	[1:0]	sdram_ba;
	output		sdram_cas_n;
	output		sdram_cke;
	output		sdram_cs_n;
	inout	[31:0]	sdram_dq;
	output	[3:0]	sdram_dqm;
	output		sdram_ras_n;
	output		sdram_we_n;
	output		sdram_clk_clk;
	output	[8:0]	pp_led_g_export;
	input	[17:0]	pp_switch_export;
endmodule
