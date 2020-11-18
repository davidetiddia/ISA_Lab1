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
		  DIN : in std_logic_vector (Nb-1 downto 0);
		  b0  : in std_logic_vector(Nb-1 downto 0);
        b1  : in std_logic_vector(Nb-1 downto 0);
        a1  : in std_logic_vector(Nb-1 downto 0);
        VOUT: out std_logic;
        DOUT: out std_logic_vector (Nb-1 downto 0) 
        );
end iir;


architecture BEHAVIORAL of iir is

	 signal fb : signed  (Nb+2 downto 0) ; --feedback value w[n-1]*(-a1)
	 signal ff1 : signed (Nb downto 0) ; --feedforward value w[n-1]*(-a1*b0)
	 signal ff2 : signed (Nb+2 downto 0) ; --feedforward value w[n-2]*(-a1*b1)
	 signal ff3 : signed (Nb+2 downto 0) ; --feedforward value prev_x*b1
	 signal ff4 : signed (Nb+2 downto 0) ; --feedforward value ff2+ff3
    signal ff5 : signed (Nb+2 downto 0); -- feedforward value ff1+ff5
	 signal w  : signed  (Nb downto 0); --w[n]
	 signal sw1: signed  (Nb downto 0); --w[n-1]
	 signal sw2: signed  (Nb downto 0); --w[n-2]
	 signal a1b0 : signed (28 downto 0); -- a1*b0 
	 signal a1b1 : signed (28 downto 0); -- a1*b1
	 signal y : signed (Nb downto 0 );


begin

	process(CLK)
	begin
		if (rising_edge(CLK)) then
			if (RST_n='0') then
				sw1 <= (others => '0');
				sw2 <= (others => '0');
			
			elsif (RST_n ='1' and VIN = '0') then
				sw1 <= sw1;
				sw2 <= sw2;		
			
			elsif (RST_n = '1' and VIN = '1') then
				sw1 <= w;
				sw2 <= sw1;

			end if;
		end if;
	end process;
	--a1b0 <= signed(a1)*signed(b0);
	--a1b1 <= signed(a1)*signed(b1);
	
	ff1 <= resize(shift_right(sw1*signed(b1),Nb-1),ff1'length);
	ff2 <= resize(- shift_right(sw1*signed(a1)*signed(b1),2*Nb-2),ff2'length);
	ff3 <= resize(- shift_right(sw2*signed(a1)*signed(b1),2*Nb-2),ff3'length);
	fb  <= resize(shift_right(sw2*signed(a1)*signed(a1),2*Nb-2),fb'length);
	
	ff4 <= ff2+ff3;
	ff5 <= ff1+ff4;
	w <= resize(signed(DIN)+fb,w'length);
	y <= resize(shift_right(w*signed(b0),Nb-1),y'length);
	DOUT <= std_logic_vector(resize(y+ff5,DOUT'length));
	
	VOUT <= '1' when VIN='1' else
			  '0' when VIN='0';

end BEHAVIORAL;





        
                


