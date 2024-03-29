library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use ieee.std_logic_arith.all;

entity CounterGeneric is
    generic(
        counterBits : natural := 2
    );
	port( 
        clock, reset: in std_logic;
        count_in: in std_logic;
        maxCount: in std_logic_vector(counterBits-1 downto 0) := (others => '1');
        
		count: out std_logic_vector(counterBits-1 downto 0)
    );
end CounterGeneric;

architecture Behavioral of CounterGeneric is

    signal internalCounter: std_logic_vector(counterBits-1 downto 0) := (others => '0');

begin

    counterProcess: process(clock)
    begin
        if (clock'event and clock='1') then
            if (reset = '1') then
                internalCounter <= (others => '0');
            else
                if (count_in = '1') then
                    if (internalCounter = maxCount) then
                        internalCounter <= (others => '0'); 
                    else
                        internalCounter <= std_logic_vector(unsigned(internalCounter) + 1);
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    count <= internalCounter;

end Behavioral;
