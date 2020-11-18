library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;


entity iir is
      port (
        CLK : in std_logic;
        RST_n : in std_logic;
        VIN : in std_logic;
		DIN : in std_logic_vector (13 downto 0);
		b0      : in std_logic_vector(13 downto 0);
		b1      : in std_logic_vector(13 downto 0);
		a1      : in std_logic_vector(13 downto 0);
        VOUT: out std_logic;
        DOUT: out std_logic_vector (13 downto 0)
        );
end iir;


architecture BEHAVIORAL of iir is

	signal fb : std_logic_vector (Nb+1 downto 0) ; --:= (others => '0');  --feedback value sw[i]*a[i]
	signal ff : std_logic_vector (Nb+1 downto 0) ;--:= (others => '0');  --feedforward value sw[i]*b[i]
	signal w  : std_logic_vector (Nb downto 0) ;--:= (others => '0'); -- x[n]+fb
	signal sw : std_logic_vector (Nb downto 0) ;--:= (others => '0'); -- sw[i]
    signal y  : std_logic_vector (Nb+1 downto 0) ;--:= (others => '0'); -- w*b0 

begin

	process(CLK)
	begin
		if (rising_edge(CLK)) then
			if (RST_n='0') then
				sw <= (others => '0');
			elsif (RST_n ='1' and VIN='0') then
				sw <= sw;
			elsif (RST_n = '1' and VIN = '1') then
				sw <= w;
			end if;
		end if;
	end process;

	ff <= std_logic_vector(resize(shift_right(signed(sw)*signed(b1),Nb-1),ff'length));
	fb <= std_logic_vector(resize(shift_right(signed(sw)*signed(a1),Nb-1),fb'length));
	w  <= std_logic_vector(resize(signed(DIN)-signed(fb),Nb+1));
	y  <= std_logic_vector(resize(shift_right(signed(w)*signed(b0),Nb-1),y'length));
	
	DOUT <= std_logic_vector(resize(signed(y)+signed(ff),Nb));
	VOUT <= '1' when VIN='1' else
			  '0' when VIN='0';

end BEHAVIORAL;





        
                


