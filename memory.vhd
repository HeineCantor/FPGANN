library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

entity memory is
    generic(
        addressLength: natural := 16;
        dataLength: natural := 8
    );
    port(
        clock: in std_logic;
        read, write: in std_logic;
        
        address: in std_logic_vector(addressLength-1 downto 0);
        dataInput: in std_logic_vector(dataLength-1 downto 0);
        
        dataOutput: out std_logic_vector(dataLength-1 downto 0)
    );
end memory;

architecture memArch of memory is

    type ramType is array (0 to 2**addressLength-1) of std_logic_vector(dataLength-1 downto 0);
    signal ram: ramType := (others=>"00000001");

begin

    process(clock) is
    begin
        if (clock'event and clock='1') then
            if (read = '1') then
                dataOutput <= ram(conv_integer(unsigned(address)));
            elsif (write = '1') then
                ram(conv_integer(unsigned(address))) <= dataInput;
            end if;
        end if;
    end process;

end memArch;
