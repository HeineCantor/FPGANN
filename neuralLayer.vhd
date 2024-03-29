library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity neuralLayer is
    generic(
        inputSize: natural := 784;
        outputSize: natural := 100
    );
    port(
        clock, reset: in std_logic;
        startInference: in std_logic;
        inputData: in std_logic_vector(31 downto 0);
        
        outputData: out std_logic_vector(31 downto 0);
        readInput, nextInput, writeOutput, nextOutput: out std_logic;
        inferenceCompleted: out std_logic
    );
end neuralLayer;

architecture structural of neuralLayer is

    component MAC is
        port(
            clock, reset: in std_logic;
            startAccumulation: in std_logic;
            setBias: in std_logic;
            
            X, Y: in std_logic_vector(31 downto 0);
            bias: in std_logic_vector(31 downto 0);
            
            Z: out std_logic_vector(31 downto 0);
            accumulationCompleted: out std_logic
        );
    end component;
    
    component ReLU is
        generic(
            width : integer range 1 to 32 := 8
        );
        port(
            inData: in std_logic_vector(width-1 downto 0);
            
            outData: out std_logic_vector(width-1 downto 0)
        );
    end component;
    
    component CyclicMemory is
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
    
    component layerControlUnit is
        port(
            clock, reset: in std_logic;
            startInference, MACfinished: in std_logic;
            counterInput, counterNeuron: in std_logic_vector(9 downto 0);
            maxCountInput, maxCountNeuron: in std_logic_vector(9 downto 0);
            
            setBias, startMAC, writeAcc: out std_logic;
            nextWeight, nextInput, nextOutput, readWeight, readInput: out std_logic;
            countInInput, countInNeuron: out std_logic;
            inferenceCompleted: out std_logic
        );
    end component;
    
    --signal log2Weights: integer := integer(ceil(log2(real((inputSize+1)*outputSize))));
    
    signal startAccumulation, setBias: std_logic;
    signal accumulationOutput: std_logic_vector(31 downto 0);
    
    signal operand1, operand2: std_logic_vector(31 downto 0);
    signal bias: std_logic_vector(31 downto 0);
    
    signal memRead, memWrite, memNextAddress: std_logic := '0';
    signal memoryAddress: std_logic_vector(23 downto 0);
    signal readWeight: std_logic_vector(7 downto 0);
    
    signal countInInput, countInNeuron: std_logic;
    signal counterInput, counterNeuron, maxCountInput, maxCountNeuron: std_logic_vector(9 downto 0);
    
    signal activationOutput: std_logic_vector(31 downto 0);
    signal macCompleted: std_logic;

begin

    layerCU: layerControlUnit
    port map(
        clock => clock,
        reset => reset,
        startInference => startInference,
        MACfinished => macCompleted,
        counterInput => counterInput,
        counterNeuron => counterNeuron,
        
        maxCountInput => maxCountInput,
        maxCountNeuron => maxCountNeuron,
        
        setBias => setBias,
        startMAC => startAccumulation,
        writeAcc => writeOutput,
        
        nextWeight => memNextAddress,
        nextInput => nextInput,
        nextOutput => nextOutput,
        readWeight => memRead,
        readInput => readInput,
        countInInput => countInInput,
        countInNeuron => countInNeuron,
        inferenceCompleted => inferenceCompleted
    );

    inputCounter: CounterGeneric
    generic map( counterBits => 10 )
    port map(
        clock => clock,
        reset => reset,
        count_in => countInInput,
        
        maxCount => maxCountInput,
        
        count => counterInput
    );
    
    neuronCounter: CounterGeneric
    generic map( counterBits => 10 )
    port map(
        clock => clock,
        reset => reset,
        count_in => countInNeuron,
        
        maxCount => maxCountNeuron,
        
        count => counterNeuron
    );

    weightsMemory: CyclicMemory
    generic map(
        addressLength => 24,
        dataLength => 8,
        memLength => (inputSize+1)*outputSize
    )
    port map(
        clock => clock,
        reset => reset,
        
        read => memRead,
        write => memWrite,
        nextAddress => memNextAddress,
        
        dataInput => (others => '0'), -- non serve scrivere nella memoria dei pesi
        
        dataOutput => readWeight
    );

    macEntity: MAC
    port map(
        clock => clock,
        reset => reset,
        
        startAccumulation => startAccumulation,
        setBias => setBias,
        
        X => operand1,
        Y => operand2,
        
        bias => bias,
        
        Z => accumulationOutput,
        accumulationCompleted => macCompleted
    );
    
    activationFunction: ReLU
    generic map( width => 32 )
    port map(
        inData => accumulationOutput,
        
        outData => activationOutput
    );

    bias <= "000000000000000000000000" & readWeight; -- quando viene effettuato il set del bias, il peso letto è proprio quello del bias

    maxCountInput <= std_logic_vector(to_unsigned(inputSize, 10));
    maxCountNeuron <= std_logic_vector(to_unsigned(outputSize-1, 10));

    operand1 <= "000000000000000000000000" & readWeight;
    operand2 <= inputData;
    
    outputData <= activationOutput;

end structural;
