library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity neuralNetwork_tb is
--  Port ( );
end neuralNetwork_tb;

architecture structural of neuralNetwork_tb is

    component neuralNetwork is
        port(
            clock, reset: in std_logic;
            startInference: in std_logic;
            
            inferenceCompleted: out std_logic
        );
    end component;

    signal clock, reset, startInference, inferenceCompleted: std_logic;
    constant CLK_period : time := 10 ns;

begin

    simClock: process    
    begin
        clock <= '0';
        wait for CLK_period;
        clock <= '1';
        wait for CLK_period;
    end process;

    dut: neuralNetwork
    port map(
        clock => clock,
        reset => reset,
        
        startInference => startInference,
        inferenceCompleted => inferenceCompleted
    );
    
    simulation: process
    begin
        wait for 100ns;
        
        reset <= '0';
        startInference <= '1';
        
        wait for 25ns;
        
        startInference <= '0';
        
        wait;
    end process;

end structural;
