library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.constants.all;


entity filter is
    port(
        CLK: in std_logic;
        RST_n : in std_logic;
        VIN : in std_logic;
        DIN : in std_logic_vector (13 downto 0);
        b0  : in std_logic_vector(13 downto 0);
        b1  : in std_logic_vector(13 downto 0);
        a1  : in std_logic_vector(13 downto 0);
        VOUT: out std_logic;
        DOUT: out std_logic_vector (13 downto 0)
        );
end filter;
    


architecture structural of filter is
    
    component iir is
    port (
      CLK : in std_logic;
      RST_n : in std_logic;
      VIN : in std_logic;
      DIN : in std_logic_vector (13 downto 0);
      b0  : in std_logic_vector(13 downto 0);
      b1  : in std_logic_vector(13 downto 0);
      a1  : in std_logic_vector(13 downto 0);
      VOUT: out std_logic;
      DOUT: out std_logic_vector (13 downto 0)
      );
    end component;

    component REG is
		generic(
				nbit: integer := 2
			);
		port(
		    CLK: in std_logic;
		    RST: in std_logic;
		    D  : in std_logic_vector (nbit-1 downto 0);
		    Q  : out std_logic_vector (nbit-1 downto 0)
		    );
    end component;
    
    component FFD is
    port(
        CLK: in std_logic;
        RST: in std_logic;
        D  : in std_logic;
        Q  : out std_logic
        );
    end component;

    signal int_VIN: std_logic;
    signal int_DIN: std_logic_vector (13 downto 0);
    signal int_DOUT: std_logic_vector (13 downto 0);
    signal int_VOUT: std_logic;
    

begin



input_reg: REG                 --reg at the input of the filter
    generic map (14)		    
    port map (CLK,RST_n,DIN,int_DIN);


VIN_reg: FFD             --reg in the feedback loop  
    port map (CLK,RST_n,VIN,int_VIN);

myfilter_iir: iir
    port map (CLK,RST_n,int_VIN,int_DIN,b0,b1,a1,int_VOUT,int_DOUT);


output_reg: REG               -- output reg
    generic map (14)
    port map (CLK,RST_n,int_DOUT,DOUT);

VOUT_reg: FFD -- vout reg
    port map (CLK,RST_n,int_VOUT,VOUT);

end structural;
