library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CyclicMemory is
    generic(
        addressLength: natural := 16;
        dataLength: natural := 8;
        memLength: integer := 100
    );
    port(
        clock, reset: in std_logic;
        dataInput: in std_logic_vector(dataLength-1 downto 0);
        
        read, write, nextAddress: in std_logic;
        
        dataOutput: out std_logic_vector(dataLength-1 downto 0)
    );
end CyclicMemory;

architecture structural of CyclicMemory is

    component memory is
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
    end component;
    
    component CounterGeneric is
        generic(
            counterBits : natural := 2
        );
        port( 
            clock, reset: in std_logic;
            count_in: in std_logic;
            maxCount: in std_logic_vector(counterBits-1 downto 0) := (others => '1');
            
            count: out std_logic_vector(counterBits-1 downto 0)
        );
    end component;

    signal currentAddress: std_logic_vector(addressLength-1 downto 0);
    signal maxCount: std_logic_vector(addressLength-1 downto 0);

begin

    memoryBank: memory
    generic map(
        addressLength => addressLength,
        dataLength => dataLength
    )
    port map(
        clock => clock,
        read => read,
        write => write,
        
        address => currentAddress,
        dataInput => dataInput,
        
        dataOutput => dataOutput
    );
    
    addressCounter: CounterGeneric
    generic map(
        counterBits => addressLength
    )
    port map(
        clock => clock,
        reset => reset,
        
        count_in => nextAddress,
        maxCount => maxCount,
        
        count => currentAddress
    );
    
    maxCount <= std_logic_vector(to_unsigned(memLength, addressLength));
    

end structural;
