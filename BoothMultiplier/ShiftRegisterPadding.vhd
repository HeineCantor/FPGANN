library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ShiftRegisterPadding is
    generic(
        width:  integer := 16; 
        padding: integer := 1;
        signPreserve: boolean := true
    );
    port(
        parallelIn:                 in std_logic_vector(width-1 downto 0);
        clock, shift, reset, load:  in std_logic;
        
        serialIn:                   in std_logic;
        
        parallelOut:                out std_logic_vector(width-1 downto 0);
        paddingOut:                 out std_logic_vector(padding-1 downto 0)
    );
end ShiftRegisterPadding;

architecture Behavioral of ShiftRegisterPadding is

    signal internalValue:   std_logic_vector(width+padding-1 downto 0);

begin

    shiftRegisterProcess: process(clock)
    begin
        if(clock'event and clock='1') then
            if(reset = '1') then
                internalValue <= (others => '0');
            else
                if (load = '1') then
                    internalValue(width downto padding) <= parallelIn;
                    internalValue(0) <= '0';
                elsif (shift = '1') then
                    internalValue(width+padding-2 downto 0) <= internalValue(width+padding-1 downto 1);
                    if (not signPreserve) then
                        internalValue(width+padding-1) <= serialIn;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    parallelOut <= internalValue(width downto padding);
    paddingOut <= internalValue(padding-1 downto 0);

end Behavioral;
