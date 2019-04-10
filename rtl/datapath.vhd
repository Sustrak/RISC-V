library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity datapath is
	port (
		-- REGFILE
		i_clk_proc     : in std_logic;
		i_wr_reg       : in std_logic;
		i_wr_reg_multi : in std_logic;
		i_addr_d_reg   : in std_logic_vector(R_REGS);
		i_addr_a_reg   : in std_logic_vector(R_REGS);
		i_addr_b_reg   : in std_logic_vector(R_REGS);
		-- ALU
		i_immed        : in std_logic_vector(R_IMMED);
		i_alu_opcode   : in std_logic_vector(R_OP_CODE);
		-- CONTROL
		i_rb_imm       : in std_logic;
		i_ra_pc        : in std_logic;
		i_alu_mem_pc      : in std_logic_vector(R_REG_DATA);
		-- BRANCH
		i_pc_br        : in std_logic_vector(R_XLEN);
        o_new_pc       : out std_logic_vector(R_XLEN);
        o_tkbr         : out std_logic;
		-- MEMORY
		i_rdata_mem    : in std_logic_vector(R_XLEN);
		o_wdata_mem    : out std_logic_vector(R_XLEN);
		o_addr_mem     : out std_logic_vector(R_XLEN);
		i_ld_st        : in std_logic_vector(R_MEM_LDST);
		i_bhw          : in std_logic_vector(R_MEM_ACCS);
		o_ld_st        : out std_logic_vector(R_MEM_LDST);
		o_bhw          : out std_logic_vector(R_MEM_ACCS);
		i_mem_unsigned : in std_logic
	);
end datapath;

architecture Structure of datapath is
	component reg_file
		port (
			i_clk_proc : in std_logic;
			i_wr       : in std_logic;
			i_port_d   : in std_logic_vector(R_XLEN);
			i_addr_d   : in std_logic_vector(R_REGS);
			i_addr_a   : in std_logic_vector(R_REGS);
			i_addr_b   : in std_logic_vector(R_REGS);
			o_port_a   : out std_logic_vector(R_XLEN);
			o_port_b   : out std_logic_vector(R_XLEN)
		);
	end component;
	component alu
		port (
			i_adata    : in std_logic_vector(R_XLEN);
			i_bdata    : in std_logic_vector(R_XLEN);
			i_opcode   : in std_logic_vector(R_OP_CODE);
			o_wdata    : out std_logic_vector(R_XLEN);
			o_overflow : out std_logic
		);
	end component;
	component sign_extensor is
		port (
			i_data     : in std_logic_vector(R_XLEN);
			i_bhw      : in std_logic_vector(R_MEM_ACCS);
			i_unsigned : in std_logic;
			o_data     : out std_logic_vector(R_XLEN)
		);
	end component;
    component take_branch is
        port (
            i_adata : in std_logic_vector(R_XLEN);
            i_bdata : in std_logic_vector(R_XLEN);
            i_opcode : in std_logic_vector(R_OP_CODE);
            o_tkbr  : out std_logic
        );
     end component;
	-- SIGNALS
	signal s_wdata         : std_logic_vector(R_XLEN);
	signal s_wr	       : std_logic;
	signal s_port_a        : std_logic_vector(R_XLEN);
	signal s_port_b        : std_logic_vector(R_XLEN);
	signal s_bdata         : std_logic_vector(R_XLEN);
	signal s_adata         : std_logic_vector(R_XLEN);
    signal s_port_d         : std_logic_vector(R_XLEN);
	signal s_overflow      : std_logic;
	signal s_wdata_mem_alu : std_logic_vector(R_XLEN);
	signal s_rdata_mem_ws  : std_logic_vector(R_XLEN);
	signal s_wdata_wb  : std_logic_vector(R_XLEN);
    signal s_tkbr          : std_logic;
	-- REGISTERS
	signal r_id_ex         : std_logic_vector(R_DATAPATH_BUS);
	signal r_ex_mem        : std_logic_vector(R_DATAPATH_BUS);
	signal r_mem_wb        : std_logic_vector(R_DATAPATH_BUS);
begin
	c_reg_file : reg_file
	port map(
		i_clk_proc => i_clk_proc,
		i_wr       => s_wr,
		i_port_d   => s_port_d,
		i_addr_d   => r_mem_wb(R_DPB_ADDRD),
		i_addr_a   => i_addr_a_reg,
		i_addr_b   => i_addr_b_reg,
		o_port_a   => s_port_a,
		o_port_b   => s_port_b
	);
	c_alu : alu
	port map(
		i_adata    => s_adata,
		i_bdata    => s_bdata,
		i_opcode   => r_id_ex(R_DPB_OPCODE),
		o_wdata    => s_wdata,
		o_overflow => s_overflow
	);
	c_sign_extensor : sign_extensor
	port map(
		i_data     => i_rdata_mem,
		i_bhw      => r_ex_mem(R_DPB_BHW),
		i_unsigned => r_ex_mem(R_DPB_MEMUNSIG),
		o_data     => s_rdata_mem_ws
	);
    c_take_branch : take_branch
    port map(
        i_adata => r_id_ex(R_DPB_DATAA),
        i_bdata => r_id_ex(R_DPB_DATAB),
        i_opcode => r_id_ex(R_DPB_OPCODE),
        o_tkbr => s_tkbr
    );

	s_bdata <= x"FFF" & r_id_ex(R_DPB_IMMED) when r_id_ex(R_DPB_RBIMM) = ALU_IMM and r_id_ex(R_DPB_IMMED)(R_DPB_IMMED'high) = '1' else
		x"000" & r_id_ex(R_DPB_IMMED) when r_id_ex(R_DPB_RBIMM) = ALU_IMM and r_id_ex(R_DPB_IMMED)(R_DPB_IMMED'high) = '0' else
		r_id_ex(R_DPB_DATAB);

    s_adata <= r_id_ex(R_DPB_PC) when r_id_ex(R_DPB_RAPC) = ALU_PC else
               r_id_ex(R_DPB_DATAA);

    s_port_d <= r_mem_wb(R_DPB_DATAW); 

	o_addr_mem     <= r_ex_mem(R_DPB_DATAW);
	o_wdata_mem    <= r_ex_mem(R_DPB_DATAB);
	o_bhw          <= r_ex_mem(R_DPB_BHW);
	o_ld_st        <= r_ex_mem(R_DPB_LDST);

	s_wdata_wb <= r_ex_mem(R_DPB_DATAW) when r_ex_mem(R_DPB_ALUMEMPC) = ALU_DATA else
                  std_logic_vector(unsigned(r_ex_mem(R_DPB_PC)) + 4) when r_ex_mem(R_DPB_ALUMEMPC) = PC_DATA else -- Save PC+4 when JAL or JARL
		          s_rdata_mem_ws;

    o_new_pc <= r_mem_wb(R_DPB_NEWPC);
    o_tkbr <= r_mem_wb(R_DPB_TKBR);

	s_wr <= r_mem_wb(R_DPB_WRREG) and i_wr_reg_multi;

	process (i_clk_proc)
	begin
		if rising_edge(i_clk_proc) then
			-- ID/EX REGISTER IN SIGNALS
			r_id_ex(R_DPB_IMMED)    <= i_immed;
			r_id_ex(R_DPB_OPCODE)   <= i_alu_opcode;
			r_id_ex(R_DPB_RBIMM)    <= i_rb_imm;
            r_id_ex(R_DPB_RAPC)     <= i_ra_pc;
			r_id_ex(R_DPB_LDST)     <= i_ld_st;
			r_id_ex(R_DPB_BHW)      <= i_bhw;
			r_id_ex(R_DPB_ALUMEMPC)   <= i_alu_mem_pc;
			r_id_ex(R_DPB_MEMUNSIG) <= i_mem_unsigned;
			r_id_ex(R_DPB_ADDRD)    <= i_addr_d_reg;
			r_id_ex(R_DPB_WRREG)    <= i_wr_reg;
			r_id_ex(R_DPB_DATAA)    <= s_port_a;
			r_id_ex(R_DPB_DATAB)    <= s_port_b;
            r_id_ex(R_DPB_PC)       <= i_pc_br;
			-- PASS THE SIGNAL TO THE OTHER REGISTERS
			r_mem_wb                <= r_ex_mem(R_DATAPATH_BUS'high downto R_DPB_DATAW'high+1) & s_wdata_wb & r_ex_mem(R_DPB_DATAW'low-1 downto 0);
			r_ex_mem                <= s_wdata & s_tkbr & r_id_ex(R_DPB_NEWPC'low-2 downto R_DPB_DATAW'high+1) & s_wdata & r_id_ex(R_DPB_DATAW'low-1 downto 0);
		end if;
	end process;
end Structure;
