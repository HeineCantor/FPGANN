library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignPreservingShiftRegister is
    generic(
        width:  integer := 8
    );
    port(
        parallelIn:                in std_logic_vector(width-1 downto 0);
        clock, shift, reset, load:  in std_logic;
        parallelOut:               out std_logic_vector(width-1 downto 0)
    );
end SignPreservingShiftRegister;

architecture Behavioral of SignPreservingShiftRegister is

    signal internalValue:   std_logic_vector(width-1 downto 0);

begin

    shiftRegisterProcess: process(clock)
    begin
        if(clock'event and clock='1') then
            if(reset = '1') then
                internalValue <= (others => '0');
            else
                if (load = '1') then
                    internalValue <= parallelIn;
                elsif (shift = '1') then
                    internalValue(width-2 downto 0) <= internalValue(width-1 downto 1);
                end if;
            end if;
        end if;
    end process;
    
    parallelOut <= internalValue;

end Behavioral;
