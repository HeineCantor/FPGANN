library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity networkControlUnit is
    port(
        clock, reset: in std_logic;
        startInference: in std_logic;
        inferenceCompletedVector: in std_logic_vector(0 to 1);
        
        startInferenceVector: out std_logic_vector(0 to 1);
        inferenceCompleted: out std_logic
    );
end networkControlUnit;

architecture Behavioral of networkControlUnit is

    type state is (idle, startLayerInference, waitForLayerInference, endState);
    signal currentState, nextState: state;
    
    signal currentLayerIndex: std_logic_vector(0 downto 0) := (others => '0');

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
    
    automa: process(currentState, startInference, inferenceCompletedVector)
    begin
        startInferenceVector <= (others => '0');
        inferenceCompleted <= '0';
    
        case currentState is
            when idle =>
                if (startInference = '1') then
                    nextState <= startLayerInference;
                else
                    nextState <= idle;
                end if;
            when startLayerInference =>
                startInferenceVector(to_integer(unsigned(currentLayerIndex))) <= '1';
                nextState <= waitForLayerInference;
            when  waitForLayerInference =>
                if (inferenceCompletedVector(to_integer(unsigned(currentLayerIndex))) = '1') then
                    if (currentLayerIndex = "1") then
                        nextState <= endState;
                    else
                        currentLayerIndex <= std_logic_vector(unsigned(currentLayerIndex) + 1);
                        nextState <= startLayerInference;
                    end if;
                end if;
            when endState =>
                inferenceCompleted <= '1';
                nextState <= idle;                
        end case;
    end process;

end Behavioral;
