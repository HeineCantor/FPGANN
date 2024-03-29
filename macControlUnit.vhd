library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity macControlUnit is
    port(
        clock, reset: in std_logic;
        setBias, startAccumulate, prodFinished: in std_logic;
   
        startProd, accumulateCompleted, selAccRegister, loadAccRegister: out std_logic
    );
end macControlUnit;

architecture Behavioral of macControlUnit is

    type state is (idle, selectingBias, settingBias, waitForSet, mulStart, waitingForMul, sumStart, waitAccumulation, accumulationCompleted);
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
    
    automa: process(currentState, startAccumulate, setBias, prodFinished)
    begin
        accumulateCompleted <= '0';
        startProd <= '0';
    
        case currentState is
            when idle =>
                selAccRegister <= '0';
                loadAccRegister <= '0';
            
                if (setBias = '1') then
                    nextState <= selectingBias;
                elsif (startAccumulate = '1') then
                    nextState <= mulStart;
                else
                    nextState <= idle;
                end if;
            when selectingBias =>
                selAccRegister <= '1';
                nextState <= settingBias;
            when settingBias =>
                loadAccRegister <= '1';
                nextState <= waitForSet;
            when waitForSet =>
                nextState <= idle; 
            when mulStart =>
                startProd <= '1';
                nextState <= waitingForMul;
            when waitingForMul =>
                if (prodFinished = '1') then
                    nextState <= sumStart;
                else
                    nextState <= waitingForMul;
                end if;
            when sumStart =>
                loadAccRegister <= '1';
                nextState <= waitAccumulation;
            when waitAccumulation =>
                loadAccRegister <= '0';
                nextState <= accumulationCompleted;
            when accumulationCompleted =>
                accumulateCompleted <= '1';
                nextState <= idle;
        end case;
    end process;

end Behavioral;
