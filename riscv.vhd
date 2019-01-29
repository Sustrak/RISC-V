library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity riscv is
	port (
		CLOCK_50: in std_logic
	);
end riscv;

architecture Structure of riscv is
	component proc is	
		port (
			i_boot : in std_logic;
			i_clk_proc : in std_logic;
			i_rdata_mem : in std_logic_vector(R_XLEN);
			o_wdata_mem : out std_logic_vector(R_XLEN);
			o_addr_mem : out std_logic_vector(R_XLEN)
		);
	end component;	
	signal s_clk_p : std_logic := '0';
	signal s_count : integer := 0;
	signal s_rdata_mem : std_logic_vector(R_XLEN);
	signal s_wdata_mem : std_logic_vector(R_XLEN);
	signal s_addr_mem : std_logic_vector(R_XLEN);
begin
	c_proc: proc
		port map (
			i_boot => '1',
			i_clk_proc => s_clk_p,
			i_rdata_mem => s_rdata_mem,
			o_wdata_mem => s_wdata_mem,
			o_addr_mem => s_addr_mem
		);

	-- Base clock for the processor 
	process (CLOCK_50)
		begin
			if rising_edge(CLOCK_50) then
				s_count <= s_count + 1;
				if s_count = 3 then
					s_clk_p <= not s_clk_p;
				end if;
			end if;
		end process;
end Structure;

