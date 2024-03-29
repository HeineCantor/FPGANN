library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter_mod32 is
    port(
        clock, reset    :   in std_logic;
        count_in        :   in std_logic;
        count           :   out std_logic_vector(4 downto 0)       
    );
end counter_mod32;

architecture behavioral of counter_mod32 is
    
   signal innerCount : std_logic_vector(4 downto 0) := (others=>'0'); 
    
begin

    counterProcess: process(clock)
    begin
    
        if(clock'event and clock='1') then -- rising edge
            if (reset = '1') then
                innerCount <= (others => '0');
            else
                if (count_in = '1') then
                    innerCount <= std_logic_vector(unsigned(innerCount)+1);
                end if;
            end if;
        end if;
    end process;

    count <= innerCount;

end Behavioral;