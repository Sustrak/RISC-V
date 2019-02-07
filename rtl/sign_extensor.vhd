library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.ARCH32;

entity sign_extensor is
	port (
		i_data : in std_logic_vector(R_XLEN);
		i_bhw  : in std_logic_vector(R_MEM_ACCS);
		i_unsigned : in std_logic;
		o_data : out std_logic_vector(R_XLEN)
	);
end sign_extensor;

architecture Structure of sign_extensor is
begin
	o_data <= i_data when i_bhw = W_ACCESS else
			  x"FFFF" & i_data(15 downto 0) when i_bhw = H_ACCESS and i_unsigned = M_SIGNED and i_data(15) = '1' else
			  x"FFFFFF" & i_data(7 downto 0) when i_bhw = B_ACCESS and i_unsigned = M_SIGNED and i_data(7) = '1' else
			  x"0000" & i_data(15 downto 0) when i_bhw = H_ACCESS and (i_unsigned = M_UNSIGNED or i_data(15) = '0') else
			  x"000000" & i_data(7 downto 0) when i_bhw = B_ACCESS and (i_unsigned = M_UNSIGNED or i_data(7) = '0') else

end Structure;
