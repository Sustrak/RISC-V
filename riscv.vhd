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
			i_wdata_mem : out std_logic_vector(R_XLEN);
			o_addr_mem : out std_logic_vector(R_XLEN)
		);
	end component;	
	signal clk_p : std_logic := '0';
	signal count : integer := 0;
begin

	-- Base clock for the processor 
	process (CLOCK_50)
		begin
			if rising_edge(CLOCK_50) then
				count <= count + 1;
				if count = 3 then
					clk_p <= not clk_p;
				end if;
			end if;
		end process;
end Structure;

