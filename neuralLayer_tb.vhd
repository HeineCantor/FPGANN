library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity neuralLayer_tb is
--  Port ( );
end neuralLayer_tb;

architecture Behavioral of neuralLayer_tb is

    component neuralLayer is
        generic(
            inputSize: natural := 784;
            outputSize: natural := 100
        );
        port(
            clock, reset: in std_logic;
            startInference: in std_logic;
            
            readInput, nextInput, writeOutput, nextOutput: out std_logic;
            inferenceCompleted: out std_logic
        );
    end component;

    signal startInference, inferenceCompleted: std_logic;

    signal clock, reset: std_logic;
    constant CLK_period : time := 10 ns;

begin

    simClock: process    
    begin
        clock <= '0';
        wait for CLK_period;
        clock <= '1';
        wait for CLK_period;
    end process;
    
    dut: neuralLayer
    generic map(
        inputSize => 784,
        outputSize => 100
    )
    port map(clock, reset, startInference, open, open, open, open, inferenceCompleted);
    
    simProcess: process
    begin
        wait for 100ns;
        
        startInference <= '1';
        
        wait for 30ns;
        
        startInference <= '0';
        
        wait;
    end process;

end Behavioral;
