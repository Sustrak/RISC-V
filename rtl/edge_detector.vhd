library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32.all;

entity edge_detector is
	port (
		i_clk    : in std_logic;
		i_signal : in std_logic;
		i_data   : in std_logic_vector(R_XLEN);
		o_data   : out std_logic_vector(R_XLEN);
		o_edge   : out std_logic
	);
end edge_detector;

architecture Structure of edge_detector is

	signal s_reg1 : std_logic;
	signal s_reg2 : std_logic;
	signal s_data : std_logic_vector(R_XLEN);

begin
	reg : process (i_clk)
	begin
		if rising_edge(i_clk) then
			s_reg1 <= i_signal;
			s_reg2 <= s_reg1;
			s_data <= i_data;
		end if;
	end process;

	o_edge <= s_reg1 and (not s_reg2);
	o_data <= s_data;

end Structure;