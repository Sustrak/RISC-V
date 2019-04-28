
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
	pp_hex_03_HEX0,
	pp_hex_03_HEX1,
	pp_hex_03_HEX2,
	pp_hex_03_HEX3,
	pp_hex_47_HEX4,
	pp_hex_47_HEX5,
	pp_hex_47_HEX6,
	pp_hex_47_HEX7,
	pp_key_export,
	pp_led_g_export,
	pp_led_r_export,
	pp_switch_export,
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
	switch_int_irq);	

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
	output	[6:0]	pp_hex_03_HEX0;
	output	[6:0]	pp_hex_03_HEX1;
	output	[6:0]	pp_hex_03_HEX2;
	output	[6:0]	pp_hex_03_HEX3;
	output	[6:0]	pp_hex_47_HEX4;
	output	[6:0]	pp_hex_47_HEX5;
	output	[6:0]	pp_hex_47_HEX6;
	output	[6:0]	pp_hex_47_HEX7;
	input	[3:0]	pp_key_export;
	output	[8:0]	pp_led_g_export;
	output	[17:0]	pp_led_r_export;
	input	[17:0]	pp_switch_export;
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
	output		switch_int_irq;
endmodule
