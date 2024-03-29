library IEEE;
use IEEE.STD_LOGIC_1164.ALL; 

entity UnitaControllo is
    port(
        clock, reset, start: in std_logic;
        count: in std_logic_vector(4 downto 0);
        
        q0, q_1: in std_logic;
        
        loadM, loadAQ, countIn, shiftAQ: out std_logic;
        selAQ, subSignal: out std_logic;
        
        productFinished: out std_logic
    );
end UnitaControllo;

architecture structural of UnitaControllo is

    type state is (idle, operandPreparation, waitForOperands, goSomma, goShift, goCount, endState);
    signal currentState, nextState: state;

begin

    updateState: process(clock)
    begin
        if(clock'event and clock='1') then
            if(reset='1') then
                currentState <= idle;
            else
                currentState <= nextState;
            end if;    
        end if;
    end process;
    
    automa: process(currentState, start, count, q0, q_1)
    begin
        countIn <= '0';
        subSignal <= '0';
        selAQ <= '0';
        loadAQ <= '0';
        loadM <= '0';
        shiftAQ <= '0';
        
        productFinished <= '0';
        
        CASE currentState is
            WHEN idle => 
                if (start='1') then
                    nextState <= operandPreparation;
                else
                    nextState <= idle;
                end if;
                
            WHEN operandPreparation =>
                loadM <= '1';
                loadAQ <= '1';
                
                nextState <= waitForOperands;
                
            WHEN waitForOperands =>
                nextState <= goSomma;         
                
            WHEN goSomma =>
                if (q0 = '1' and q_1 = '0') then
                    subSignal <= '1';
                
                    selAQ <= '1';
                    loadAQ <= '1';
                elsif (q0 = '0' and q_1 = '1') then
                    selAQ <= '1';
                    loadAQ <= '1';
                end if;
                
                nextState <= goShift;
                
            WHEN goShift =>
                shiftAQ <= '1';
                
                if(count = "11111") then
                    nextState <= endState;
                else             
                    nextState <= goCount;
                end if;

            WHEN goCount =>
                countIn <= '1';
                
                nextState <= goSomma;
                
            WHEN endState =>
                productFinished <= '1';
                countIn <= '1'; -- per resettare il counter per la prossima moltiplicazione
            
                nextState <= idle;
        END CASE;
    end process;

end structural;
