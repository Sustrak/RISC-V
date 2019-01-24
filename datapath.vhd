library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity datapath is 
	port (
		-- REGFILE
		i_clk_proc : in std_logic;
		i_wr_reg : in std_logic;
		i_addr_d : in std_logic_vector(R_REGS);
		-- ALU
		i_immed : in std_logic_vector(R_IMMED);
		i_alu_opcode : in std_logic_vector(R_OP_CODE);
		-- CONTROL
		i_rb_imm : in std_logic
	);
end datapath;

architecture Structure of datapath is
	component reg_file
		port (
			i_clk_proc : in std_logic;
			i_wr : in std_logic;
			i_data : in std_logic_vector(R_XLEN);
			i_addr_d : in std_logic_vector(R_REGS)
		);
	end component;
	component alu
		port (
			i_adata: in std_logic_vector(R_XLEN);
			i_bdata: in std_logic_vector(R_XLEN);
			i_opcode: in std_logic_vector(R_OP_CODE);
			o_wdata: out std_logic_vector(R_XLEN);
			o_overflow : out std_logic
		);
	end component;

	-- SIGNALS
	signal s_wdata : std_logic_vector(R_XLEN);
	signal s_bdata : std_logic_vector(R_XLEN);
	signal s_adata : std_logic_vector(R_XLEN);
begin
	c_reg_file: reg_file
	port map (
		i_clk_proc => i_clk_proc,
		i_wr => i_wr_reg,
		i_data => s_wdata,
		i_addr_d => i_addr_d
	);
	c_alu: alu
	port map (
		i_adata => s_adata,
		i_bdata => s_bdata,
		i_opcode => i_alu_opcode,
		o_wdata => s_wdata,
		o_overflow => open	
	);

	s_bdata <= std_logic_vector(resize(signed(i_immed), R_XLEN'high+1)) when i_alu_opcode = ALU_LUI else
			   (others => '0');
end Structure;
