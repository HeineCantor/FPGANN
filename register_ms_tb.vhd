library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_ms_tb is
--  Port ( );
end register_ms_tb;

architecture structural of register_ms_tb is

    component register_generic_ms is
        generic(
            width : integer range 1 to 32 := 8
        );
        port(
            dataInput:                  in std_logic_vector(width-1 downto 0);
            clock, reset, load:         in std_logic;
            dataOutput:                 out std_logic_vector(width-1 downto 0)  
        );
    end component;

    signal testData, output: std_logic_vector(7 downto 0);

    signal clock, reset, load: std_logic;
    constant CLK_period : time := 10 ns;

begin

    simClock: process    
    begin
        clock <= '0';
        wait for CLK_period;
        clock <= '1';
        wait for CLK_period;
    end process;

    dut: register_generic_ms
    port map(
        dataInput => testData,
        
        clock => clock,
        reset => reset,
        load => load,
        
        dataOutput => output
    );
    
    simProcess: process
    begin
        wait for 100 ns;
        
        reset <= '0';
        testData <= "01010101";
        
        wait for 10ns;
        
        load <= '1';
        
        wait for 15ns;
        testData <= "10101010";
        
        wait for 100ns;
        
        load <= '0';
        
        wait;
    end process;

end structural;
