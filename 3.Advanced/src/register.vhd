library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;


entity REG is
	generic (
		nbit: integer := 2
	);
    port (
        CLK: in std_logic;
        RST: in std_logic;
        D  : in std_logic_vector (nbit-1 downto 0);
        Q  : out std_logic_vector (nbit-1 downto 0)
    );
end REG;

architecture SYNCHRONOUS of REG is
	component FFD is
		port(
			CLK: in std_logic;
			RST: in std_logic;
			D  : in std_logic;
			Q  : out std_logic
			);
	end component;

begin

	generate_regs: for i in 0 to nbit-1 generate
		regx : FFD 
			port map (CLK,RST,D(i),Q(i));
	end generate generate_regs;
	
    

    -- process (CLK,RST)
    -- begin
	--   if rising_edge(CLK) then -- positive edge triggered:
	--     if RST='0' then -- active low reset 
	--       Q <= (others => '0'); 
	--     else
	--       Q <= D; -- input is written on output
	--     end if;
	--   end if;
    -- end process;
    
end SYNCHRONOUS;
