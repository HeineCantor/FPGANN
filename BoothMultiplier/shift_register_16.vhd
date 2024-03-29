library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register_16 is
    port(
        parallelIn:                in std_logic_vector(15 downto 0);
        clock, shift, reset, load:  in std_logic;
        parallelOut:               out std_logic_vector(15 downto 0)
    );
end shift_register_16;

architecture Behavioral of shift_register_16 is

    signal internalValue:   std_logic_vector(15 downto 0);
    signal lsv:             std_logic;

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
                    internalValue(14 downto 0) <= internalValue(15 downto 1);
                    -- internalValue(15) <= lsv; preserviamo l'ultimo bit, è uno shift register modificato per il booth mutliplier
                end if;
            end if;
        end if;
    end process;
    
    parallelOut <= internalValue;

end Behavioral;
