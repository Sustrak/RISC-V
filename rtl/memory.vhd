library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use ieee.numeric_std.all;
use work.ARCH32.all;
entity memory is
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
end entity;

architecture comportament of memory is

	-- RAM block 8x2^16
	type BLOQUE_RAM is array (2 ** 16 - 1 downto 0) of std_logic_vector(7 downto 0);
	signal s_mem                                        : BLOQUE_RAM;

	-- Registres i xarxes
	signal s_addr1                                      : std_logic_vector(15 downto 0);
	signal s_addr2                                      : std_logic_vector(15 downto 0);
	signal s_addr3                                      : std_logic_vector(15 downto 0);
	signal s_test                                       : std_logic_vector(15 downto 0);

	-- Instructions to read a text file into RAM --
	procedure Load_FitxerDadesMemoria (signal data_word : inout BLOQUE_RAM) is
		-- Open File in Read Mode
		file romfile                                        : text open read_mode is "memory.hex";
		variable lbuf                                       : line;
		variable i                                          : integer := 0;--4194304; -- X"40 0000" ==> 4096 adreca inicial S.O.
		variable fdata                                      : std_logic_vector (31 downto 0);
	begin
		while not endfile(romfile) loop
			-- read data from input file
			readline(romfile, lbuf);
			hread(lbuf, fdata);
			data_word(i)     <= fdata(7 downto 0);
			data_word(i + 1) <= fdata(15 downto 8);
			data_word(i + 2) <= fdata(23 downto 16);
			data_word(i + 3) <= fdata(31 downto 24);
			i := i + 4;
		end loop;
	end procedure;

begin

	-- Assignacions continues
	s_addr1   <= std_logic_vector(to_unsigned(to_integer(unsigned(i_addr)) + 1, s_addr1'length));
	s_addr2   <= std_logic_vector(to_unsigned(to_integer(unsigned(i_addr)) + 2, s_addr2'length));
	s_addr3   <= std_logic_vector(to_unsigned(to_integer(unsigned(i_addr)) + 3, s_addr3'length));

	s_test    <= s_mem(to_integer(unsigned(s_addr1))) & s_mem(to_integer(unsigned(i_addr)));

	-- lectura asincrona
	-- si llegim un sol byte (byte_m=1), aleshores extenem el signe
	o_rd_data <= std_logic_vector(resize(signed(s_mem(to_integer(unsigned(i_addr)))), o_rd_data'length)) when i_byte_m = '1' else
		std_logic_vector(resize(signed(s_test), o_rd_data'length)) when i_half_m = '1' else
		s_mem(to_integer(unsigned(s_addr3))) & s_mem(to_integer(unsigned(s_addr2))) & s_mem(to_integer(unsigned(s_addr1))) & s_mem(to_integer(unsigned(i_addr)));
	-- Comportament inicialitzacio i escritura sincrona
	process (i_clk)
	begin
		if (i_clk'event and i_clk = '1') then
			if i_boot = '1' then
				-- Procedural Call --
				Load_FitxerDadesMemoria(s_mem);
			else
				if (i_we = '1') then
					if (i_byte_m = '1') then
						s_mem(to_integer(unsigned(i_addr))) <= i_wr_data(7 downto 0); -- escrivim nomes 1 byte (8 bits)
					elsif (i_half_m = '1') then
						s_mem(to_integer(unsigned(i_addr)))  <= i_wr_data(7 downto 0); -- escrivim 2 bytes (16 bits)
						s_mem(to_integer(unsigned(s_addr1))) <= i_wr_data(15 downto 8);
					else
						s_mem(to_integer(unsigned(i_addr)))  <= i_wr_data(7 downto 0); -- escrivim 4 bytes (32 bits)
						s_mem(to_integer(unsigned(s_addr1))) <= i_wr_data(15 downto 8);
						s_mem(to_integer(unsigned(s_addr2))) <= i_wr_data(23 downto 16);
						s_mem(to_integer(unsigned(s_addr3))) <= i_wr_data(31 downto 24);
					end if;
				end if;
			end if;
		end if;
	end process;

end comportament;
