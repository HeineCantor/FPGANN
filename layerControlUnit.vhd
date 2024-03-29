library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity layerControlUnit is
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
end layerControlUnit;

architecture Behavioral of layerControlUnit is

	type state is (idle, setBiasAcc, waitBiasAcc1, waitBiasAcc2, goToWeights, loadOperands, waitForOperands, nextOperands, startMACop, waitMACop, writeOutput, shiftOutput, endState);
	signal currentState, nextState: state;
	
begin

    updateProcess: process(clock)
    begin
        if (clock'event and clock='1') then
            if (reset = '1') then
                currentState <= idle;
            else
                currentState <= nextState;
            end if;
        end if;
    end process;
    
    automa: process(currentState, startInference, MACfinished, counterInput, counterNeuron)
    begin
        inferenceCompleted <= '0';
        startMAC <= '0';
        nextWeight <= '0';
        nextInput <= '0';
        nextOutput <= '0';
        readWeight <= '0';
        readInput <= '0';
        countInInput <= '0';
        countInNeuron <= '0';
        writeAcc <= '0';
        
        case currentState is
            when idle =>
                if (startInference = '1') then
                    nextState <= setBiasAcc;
                else
                    nextState <= idle;
                end if;
            when setBiasAcc =>
                readWeight <= '1';
                setBias <= '1';
                nextState <= waitBiasAcc1;
            when waitBiasAcc1 =>
                nextState <= waitBiasAcc2;
            when waitBiasAcc2 =>
                nextState <= goToWeights;
            when goToWeights =>
                setBias <= '0';
                nextWeight <= '1';
                nextState <= loadOperands;
            when loadOperands =>
                readWeight <= '1';
                readInput <= '1';
                nextState <= waitForOperands;
            when waitForOperands =>
                readWeight <= '1';
                readInput <= '1';
                nextState <= startMACop;
            when startMACop =>
                startMAC <= '1';
                nextState <= waitMACop;
            when waitMACop =>
                if (MACfinished = '1') then
                    if (counterInput = maxCountInput) then
                        nextState <= writeOutput;
                    else
                        nextState <= nextOperands;
                    end if;
                    
                    countInInput <= '1';
                end if;
            when nextOperands =>
                nextWeight <= '1';
                nextInput <= '1';
                nextState <= loadOperands;
            when writeOutput =>
                writeAcc <= '1';
                
                if (counterNeuron = maxCountNeuron) then
                    nextState <= endState;
                else
                    nextState <= shiftOutput;
                end if;
                
                countInNeuron <= '1';
            when shiftOutput =>
                nextOutput <= '1';
                
                nextState <= setBiasAcc;
            when endState =>
                inferenceCompleted <= '1';
                nextState <= idle;
        end case;
    end process;

end Behavioral;
