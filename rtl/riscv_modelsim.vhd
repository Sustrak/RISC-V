library ieee;
use ieee.std_logic_1164.all;
use work.ARCH32.all;

entity riscv_modelsim is
end riscv_modelsim;

architecture Structure of riscv_modelsim is
	component memory is
		port (
			i_clk     : in std_logic;
			i_addr    : in std_logic_vector(15 downto 0);
			i_wr_data : in std_logic_vector(R_XLEN);
			o_rd_data : out std_logic_vector(R_XLEN);
			i_we      : in std_logic;
			i_byte_m  : in std_logic;
			i_half_m  : in std_logic;
			i_boot    : in std_logic
		);
	end component;
	component proc is
		port (
			i_boot      : in std_logic;
			i_clk_proc  : in std_logic;
			o_wdata_mem : out std_logic_vector(R_XLEN);
			i_rdata_mem : in std_logic_vector(R_XLEN);
			o_addr_mem  : out std_logic_vector(R_XLEN);
			o_bhw       : out std_logic_vector(R_MEM_ACCS);
			o_ld_st     : out std_logic_vector(R_MEM_LDST);
			i_sdram_readvalid : in std_logic
		);
	end component;

	signal s_boot_proc : std_logic := '1';
	signal s_clk_proc  : std_logic := '0';
	signal s_rst_ram   : std_logic := '0';
	signal s_wdata_mem : std_logic_vector(R_XLEN);
	signal s_rdata_mem : std_logic_vector(R_XLEN);
	signal s_addr_mem  : std_logic_vector(R_XLEN);
	signal s_mem_addr  : std_logic_vector(15 downto 0);
	signal s_we        : std_logic := '0';
	signal s_byte_m    : std_logic := '0';
	signal s_half_m    : std_logic := '0';
	signal s_bhw       : std_logic_vector(R_MEM_ACCS);
	signal s_ld_st       : std_logic_vector(R_MEM_LDST);
    signal s_sdram_readvalid : std_logic := '0';
begin
	c_proc : proc
	port map(
		i_boot      => s_boot_proc,
		i_clk_proc  => s_clk_proc,
		o_wdata_mem => s_wdata_mem,
		i_rdata_mem => s_rdata_mem,
		o_addr_mem  => s_addr_mem,
		o_ld_st     => s_ld_st,
		o_bhw       => s_bhw,
		i_sdram_readvalid => s_sdram_readvalid
	);
	c_mem : memory
	port map(
		i_clk     => s_clk_proc,
		i_addr    => s_mem_addr,
		i_wr_data => s_wdata_mem,
		o_rd_data => s_rdata_mem,
		i_we      => s_we,
		i_byte_m  => s_byte_m,
		i_half_m  => s_half_m,
		i_boot    => s_rst_ram
	);

	s_boot_proc <= '1' after 25 ns, '0' after 35 ns;
	s_clk_proc  <= not s_clk_proc after 10 ns;
	s_rst_ram   <= '1' after 5 ns, '0' after 15 ns;

	s_byte_m    <= '1' when s_bhw = B_ACCESS else
		'0';
	s_half_m <= '1' when s_bhw = H_ACCESS else
		'0';

	s_we <= '1' when s_ld_st = ST_SDRAM else
			'0';

    s_sdram_readvalid <= not s_sdram_readvalid after 20 ns;

    s_mem_addr <= s_addr_mem(19 downto 16) & s_addr_mem(11 downto 0);

end Structure;
