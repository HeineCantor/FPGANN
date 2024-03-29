library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_generic is
    generic(
        width : integer range 1 to 32 := 8
    );
    port(
        dataInput:                  in std_logic_vector(width-1 downto 0);
        clock, reset, load:         in std_logic;
        dataOutput:                 out std_logic_vector(width-1 downto 0)  
    );
end register_generic;

architecture Behavioral of register_generic is

    signal internalValue:   std_logic_vector(width-1 downto 0);

begin

    registerProcess: process(clock)
    begin
        if (clock'event and clock='1') then
            if(reset = '1') then
                internalValue <= (others => '0');
            else
                if(load = '1') then
                    internalValue <= dataInput;
                end if;
            end if;
        end if;
    end process;
    
    dataOutput <= internalValue;

end Behavioral;
