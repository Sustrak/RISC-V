library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity bootloader is
	-- UART
	i_rxd : in std_logic;
	o_txd : out std_logic;
	-- CLOCK
	i_clk_50 : in std_logic;
end bootloader;

architecture Structure of bootloader is
	

	component UART is
		port (
			clk_clk            : in  std_logic                     := 'X';             -- clk
			reset_reset_n      : in  std_logic                     := 'X';             -- reset_n
			uart_rxd           : in  std_logic                     := 'X';             -- rxd
			uart_txd           : out std_logic;                                        -- txd
			int_irq            : out std_logic;                                        -- irq
			wire_address       : in  std_logic_vector(2 downto 0)  := (others => 'X'); -- address
			wire_begintransfer : in  std_logic                     := 'X';             -- begintransfer
			wire_chipselect    : in  std_logic                     := 'X';             -- chipselect
			wire_read_n        : in  std_logic                     := 'X';             -- read_n
			wire_write_n       : in  std_logic                     := 'X';             -- write_n
			wire_writedata     : in  std_logic_vector(15 downto 0) := (others => 'X'); -- writedata
			wire_readdata      : out std_logic_vector(15 downto 0);                    -- readdata
			wire_endofpacket   : out std_logic                                         -- endofpacket
		);
	end component UART;

	component RAMonFPGA 
		PORT
			(
				address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				clock		: IN STD_LOGIC  := '1';
				data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				wren		: IN STD_LOGIC ;
				q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
			);
begin
	
	c_uart : UART
		port map (
			clk_clk            => CONNECTED_TO_clk_clk,            --   clk.clk
			reset_reset_n      => CONNECTED_TO_reset_reset_n,      -- reset.reset_n
			uart_rxd           => CONNECTED_TO_uart_rxd,           --  uart.rxd
			uart_txd           => CONNECTED_TO_uart_txd,           --      .txd
			int_irq            => CONNECTED_TO_int_irq,            --   int.irq
			wire_address       => CONNECTED_TO_wire_address,       --  wire.address
			wire_begintransfer => CONNECTED_TO_wire_begintransfer, --      .begintransfer
			wire_chipselect    => CONNECTED_TO_wire_chipselect,    --      .chipselect
			wire_read_n        => CONNECTED_TO_wire_read_n,        --      .read_n
			wire_write_n       => CONNECTED_TO_wire_write_n,       --      .write_n
			wire_writedata     => CONNECTED_TO_wire_writedata,     --      .writedata
			wire_readdata      => CONNECTED_TO_wire_readdata,      --      .readdata
			wire_endofpacket   => CONNECTED_TO_wire_endofpacket    --      .endofpacket
		);

end component;
