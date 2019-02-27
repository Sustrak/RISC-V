library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity bootloader is
	port (
		-- UART
		i_rxd : in std_logic;
		o_txd : out std_logic;
		-- CLOCK
		i_clk_50 : in std_logic;
		-- RESET
		i_reset : in std_logic
	);
end bootloader;

architecture Structure of bootloader is
	-- ----------------------
	-- | ADDRESS | REGISTER |
	-- |   000   |    RX    |
	-- |   001   |	  TX	|
	-- |   002   |	STATUS  |
	-- |   003   |	CONTROL |
	-- |   004   |	DIVISOR |
	-- |   005   |	  EOP   |
	-- ----------------------
	-- CONTROL REGISTER
	-- --------------------------------------------------------------------------------------
	-- |EOP|RTS|CTS|TBREAK|EXCEPTION|READREADY|SHIFTREGREADY|TRANSOVERR|BREAK|FRAMING|PARITY|
	-- --------------------------------------------------------------------------------------
	component UART is
		port (
			clk_clk            : in  std_logic                     := 'X';           
			reset_reset_n      : in  std_logic                     := 'X';           
			uart_rxd           : in  std_logic                     := 'X';           
			uart_txd           : out std_logic;                                     
			int_irq            : out std_logic;                                      
			wire_address       : in  std_logic_vector(2 downto 0)  := (others => 'X'); 
			wire_begintransfer : in  std_logic                     := 'X';            
			wire_chipselect    : in  std_logic                     := 'X';            
			wire_read_n        : in  std_logic                     := 'X';            
			wire_write_n       : in  std_logic                     := 'X';            
			wire_writedata     : in  std_logic_vector(15 downto 0) := (others => 'X');
			wire_readdata      : out std_logic_vector(15 downto 0);                   
			wire_endofpacket   : out std_logic                                        
		);
	end component;

	component RAMonFPGA 
		PORT
			(
				address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				clock		: IN STD_LOGIC  := '1';
				data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
				wren		: IN STD_LOGIC ;
				q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
			);
	end component;
	-- UART STATES
	type state_uart is (IDLE, INT, READ, EOP);
	signal uart_state : state_uart := IDLE;
	signal s_int_irq : std_logic;
	signal s_addr : std_logic_vector(2 downto 0);
	signal s_begintransfer : std_logic;
	signal s_chipselect : std_logic;
	signal s_read_n : std_logic;
	signal s_write_n : std_logic;
	signal s_write_data : std_logic_vector(15 downto 0);
	signal s_read_data : std_logic_vector(15 downto 0);
	signal s_data_to_ram : std_logic_vector(7 downto 0);
	signal s_eop : std_logic;
	signal s_ram_addr : std_logic_vector(7 downto 0);
	signal s_ram_data : std_logic_vector(7 downto 0);
begin
	
	c_uart : UART
		port map (
			clk_clk            => i_clk_50, 
			reset_reset_n      => i_reset,
			uart_rxd           => i_rxd,
			uart_txd           => o_txd,
			int_irq            => s_int_irq,
			wire_address       => s_addr,
			wire_begintransfer => s_begintransfer,
			wire_chipselect    => s_chipselect,
			wire_read_n        => s_read_n,
			wire_write_n       => s_write_n,
			wire_writedata     => s_write_data,
			wire_readdata      => s_read_data,
			wire_endofpacket   => s_eop
		);

	c_ram : RAMonFPGA
		port map (
			clock => i_clk_50,
			address => s_ram_addr,
			data => s_data_to_ram,
			wren => '1',
			q => s_ram_data
		);

	u_state : process (i_reset, s_int_irq, s_addr, i_clk_50)
	begin
		if i_reset = '1' then
			uart_state <= IDLE;
		elsif s_int_irq = '1' and uart_state = IDLE then
			uart_state <= INT;
		elsif s_read_data(7) = '1' and uart_state = INT then
			uart_state <= READ;
		elsif s_read_data(12) = '1' and uart_state = INT then
			uart_state <= EOP;
		elsif uart_state = READ or uart_state = EOP then
			uart_state <= IDLE;
		end if;
	end process;

	s_addr <= "011" when uart_state = IDLE else
			  "010" when uart_state = INT else
			  "000";

	process (uart_state)
	begin
		if uart_state = IDLE then
			s_write_data <= x"1080";
		elsif uart_state = READ then
			s_ram_addr <= std_logic_vector(unsigned(s_ram_addr) + 1);
			s_data_to_ram <= s_read_data(7 downto 0);
			s_read_n <= '1';
		end if;
	end process;
end Structure;
