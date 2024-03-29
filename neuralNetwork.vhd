library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity neuralNetwork is
    port(
        clock, reset: in std_logic;
        startInference: in std_logic;
        
        inferenceCompleted: out std_logic
    );
end neuralNetwork;

architecture structural of neuralNetwork is

    component neuralLayer is
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
    
    component networkControlUnit is
        port(
            clock, reset: in std_logic;
            startInference: in std_logic;
            inferenceCompletedVector: in std_logic_vector(0 to 1);
            
            startInferenceVector: out std_logic_vector(0 to 1);
            inferenceCompleted: out std_logic
        );
    end component;

    signal inputMemoryRead, inputMemoryNext: std_logic;
    signal inputMemoryDataOut: std_logic_vector(7 downto 0);
    
    signal startInferenceVector, inferenceCompletedVector: std_logic_vector(0 to 1);
    
    signal inputDataL1, outputDataL1ToL2, outputL1Memory, outputDataL2ToOut, outputOutMemory: std_logic_vector(31 downto 0);
    signal writeToL1Memory, readFromL1Memory, nextL1Memory, writeToOutputMemory, readFromOutputMemory, nextOutputMemory: std_logic;

begin

    nnCU: networkControlUnit
    port map(
        clock => clock,
        reset => reset,
        startInference => startInference,
        inferenceCompletedVector => inferenceCompletedVector,
        
        startInferenceVector => startInferenceVector,
        inferenceCompleted => inferenceCompleted
    );

    inputMemory: CyclicMemory
    generic map(
        addressLength => 10, --2^10 = 1024 per contenere 784 pixel
        dataLength => 8,
        memLength => 784
    )
    port map(
        clock => clock,
        reset => reset,
        dataInput => (others => '0'), 
        
        read => inputMemoryRead,
        write => '0', --non possiamo scrivere in questa memoria
        nextAddress => inputMemoryNext,
        
        dataOutput => inputMemoryDataOut
    );
    
    inputDataL1 <= "000000000000000000000000" & inputMemoryDataOut;
    
    layer1: neuralLayer
    generic map(
        inputSize => 784,
        outputSize => 100
    )
    port map(
        clock => clock,
        reset => reset,
        startInference => startInferenceVector(0),
        inputData => inputDataL1,
        
        outputData => outputDataL1ToL2,
        readInput => inputMemoryRead,
        nextInput => inputMemoryNext,
        
        writeOutput => writeToL1Memory,
        nextOutput => nextL1Memory,
        
        inferenceCompleted => inferenceCompletedVector(0)
    );

    L1ToL2Memory: CyclicMemory
    generic map(
        addressLength => 7, --2^7 = 128 per contenere 100 output
        dataLength => 32,
        memLength => 100
    )
    port map(
        clock => clock,
        reset => reset,
        dataInput => outputDataL1ToL2, 
        
        read => readFromL1Memory,
        write => writeToL1Memory,
        nextAddress => nextL1Memory,
        
        dataOutput => outputL1Memory
    );
    
    layer2: neuralLayer
    generic map(
        inputSize => 100,
        outputSize => 10
    )
    port map(
        clock => clock,
        reset => reset,
        startInference => startInferenceVector(1),
        inputData => outputL1Memory,
        
        outputData => outputDataL2ToOut,
        readInput => readFromL1Memory,
        nextInput => nextL1Memory,
        
        writeOutput => writeToOutputMemory,
        nextOutput => nextOutputMemory,
        
        inferenceCompleted => inferenceCompletedVector(1)
    );
    
    OutputMemory: CyclicMemory
    generic map(
        addressLength => 4, --2^4 = 16 per contenere 10 output
        dataLength => 32,
        memLength => 10
    )
    port map(
        clock => clock,
        reset => reset,
        dataInput => outputDataL2ToOut, 
        
        read => readFromOutputMemory,
        write => writeToOutputMemory,
        nextAddress => nextOutputMemory,
        
        dataOutput => outputOutMemory
    );

end structural;
