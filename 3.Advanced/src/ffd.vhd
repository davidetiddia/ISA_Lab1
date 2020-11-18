library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity FFD is
    port(
        CLK: in std_logic;
        RST: in std_logic;
        D  : in std_logic;
        Q  : out std_logic
        );
end FFD;

architecture SYNCHRONOUS of FFD is

begin
    process (CLK,RST)
    begin
      if (RST='0') then -- active low reset 
	      Q <='0';      
      elsif rising_edge(CLK) then -- positive edge triggered:
	      Q <= D; -- input is written on output
	    end if;
    end process;
    
end SYNCHRONOUS;
