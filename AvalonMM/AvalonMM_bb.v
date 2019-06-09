
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
	pp_key_export,
	pp_key_int_irq,
	pp_led_g_export,
	pp_led_r_export,
	pp_sev_seg03_export,
	pp_sev_seg47_export,
	pp_switch_export,
	pp_switch_int_irq,
	ps2_CLK,
	ps2_DAT,
	ps2_int_irq,
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
	sram_DQ,
	sram_ADDR,
	sram_LB_N,
	sram_UB_N,
	sram_CE_N,
	sram_OE_N,
	sram_WE_N,
	vga_CLK,
	vga_HS,
	vga_VS,
	vga_BLANK,
	vga_SYNC,
	vga_R,
	vga_G,
	vga_B);	

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
	input	[3:0]	pp_key_export;
	output		pp_key_int_irq;
	output	[8:0]	pp_led_g_export;
	output	[17:0]	pp_led_r_export;
	output	[31:0]	pp_sev_seg03_export;
	output	[31:0]	pp_sev_seg47_export;
	input	[17:0]	pp_switch_export;
	output		pp_switch_int_irq;
	inout		ps2_CLK;
	inout		ps2_DAT;
	output		ps2_int_irq;
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
	inout	[15:0]	sram_DQ;
	output	[19:0]	sram_ADDR;
	output		sram_LB_N;
	output		sram_UB_N;
	output		sram_CE_N;
	output		sram_OE_N;
	output		sram_WE_N;
	output		vga_CLK;
	output		vga_HS;
	output		vga_VS;
	output		vga_BLANK;
	output		vga_SYNC;
	output	[7:0]	vga_R;
	output	[7:0]	vga_G;
	output	[7:0]	vga_B;
endmodule
