## Generated SDC file "RISCV.sdc"

## Copyright (C) 2018  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and its AMPP partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"

## DATE    "Tue May 07 13:22:06 2019"

##
## DEVICE  "EP4CE115F29C7"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {altera_reserved_tck} -period 100.000 -waveform { 0.000 50.000 } [get_ports {altera_reserved_tck}]
create_clock -name {CLOCK_50} -period 20.000 -waveform { 0.000 10.000 } [get_ports {CLOCK_50}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {c_system_pll|altpll_component|auto_generated|pll1|clk[0]} -source [get_pins {c_system_pll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 2 -master_clock {CLOCK_50} [get_pins {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {c_system_pll|altpll_component|auto_generated|pll1|clk[1]} -source [get_pins {c_system_pll|altpll_component|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 4 -master_clock {CLOCK_50} [get_pins {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] 
create_generated_clock -name {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]} -source [get_pins {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -master_clock {CLOCK_50} [get_pins {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] 
create_generated_clock -name {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[1]} -source [get_pins {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|inclk[0]}] -duty_cycle 50/1 -multiply_by 1 -phase -54.000 -master_clock {CLOCK_50} [get_pins {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[1]}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -rise_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {altera_reserved_tck}] -fall_to [get_clocks {altera_reserved_tck}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -rise_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -rise_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -setup 0.070  
set_clock_uncertainty -fall_from [get_clocks {CLOCK_50}] -fall_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -hold 0.100  
set_clock_uncertainty -rise_from [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {c_mem_ctrl|c_avalonmm|sdram_pll|sys_pll|PLL_for_DE_Series_Boards|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {CLOCK_50}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {CLOCK_50}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {CLOCK_50}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {CLOCK_50}] -hold 0.070  
set_clock_uncertainty -rise_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {CLOCK_50}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {CLOCK_50}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {CLOCK_50}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {CLOCK_50}] -hold 0.070  
set_clock_uncertainty -fall_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -rise_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[1]}] -fall_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -rise_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}] -rise_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  
set_clock_uncertainty -fall_from [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}] -fall_to [get_clocks {c_system_pll|altpll_component|auto_generated|pll1|clk[0]}]  0.020  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks {altera_reserved_tck}] 


#**************************************************************
# Set False Path
#**************************************************************

set_false_path -to [get_keepers {*altera_std_synchronizer:*|din_s1}]
set_false_path -to [get_pins -nocase -compatibility_mode {*|alt_rst_sync_uq1|altera_reset_synchronizer_int_chain*|clrn}]
set_false_path -from [get_registers {*altera_jtag_src_crosser:*|sink_data_buffer*}] -to [get_registers {*altera_jtag_src_crosser:*|src_data*}]


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

