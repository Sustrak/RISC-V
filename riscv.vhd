library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity riscv is
	port (
		CLOCK_50  : in STD_LOGIC;
		SRAM_ADDR : out std_logic_vector(17 downto 0);
		SRAM_DQ   : inout std_logic_vector(15 downto 0);
		SRAM_UB_N : out std_logic;
		SRAM_LB_N : out std_logic;
		SRAM_CE_N : out std_logic := '1';
		SRAM_OE_N : out std_logic := '1';
		SRAM_WE_N : out std_logic := '1';
		LEDG      : out STD_LOGIC_VECTOR(7 downto 0);
		LEDR      : out STD_LOGIC_VECTOR(7 downto 0);
		HEX0      : out STD_LOGIC_VECTOR(6 downto 0);
		HEX1      : out STD_LOGIC_VECTOR(6 downto 0);
		HEX2      : out STD_LOGIC_VECTOR(6 downto 0);
		HEX3      : out STD_LOGIC_VECTOR(6 downto 0);
		KEY       : in STD_LOGIC_VECTOR(3 downto 0);
		SW        : in std_logic_vector(9 downto 0);
		PS2_CLK   : inout std_logic;
		PS2_DAT   : inout std_logic;
		VGA_HS    : out std_logic;
		VGA_VS    : out std_logic;
		VGA_R     : out std_logic_vector(3 downto 0);
		VGA_G     : out std_logic_vector(3 downto 0);
		VGA_B     : out std_logic_vector(3 downto 0);
		VGA_BLANK : out std_logic;
		VGA_SYNC  : out std_logic;
		VGA_CLK   : out std_logic
	);
end riscv;

architecture Structure of riscv is
	component proc is	
		port (
			i_boot : in std_logic;
			i_clk_proc : in std_logic;
			i_data_mem : in std_logic;
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

