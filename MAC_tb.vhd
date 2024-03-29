library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MAC_tb is
--  Port ( );
end MAC_tb;

architecture structural of MAC_tb is

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
    
    signal clock, reset, setBias, startAccumulation, accFinished: std_logic;
    signal bias: std_logic_vector(31 downto 0);
    signal result: std_logic_vector(31 downto 0);
    
    signal X, Y: std_logic_vector(31 downto 0);
    
    constant CLK_period : time := 10 ns;

begin

    simClock: process    
    begin
        clock <= '0';
        wait for CLK_period;
        clock <= '1';
        wait for CLK_period;
    end process;
    
    dut: MAC
    port map(
        clock => clock,
        reset => reset,
        
        startAccumulation => startAccumulation,
        setBias => setBias,
        
        X => X,
        Y => Y,
        
        bias => bias,
        
        Z => result,
        accumulationCompleted => accFinished
    );
    
    simProcess: process
    begin
        wait for 100 ns;
        
        reset <= '0';
        bias <= std_logic_vector(to_signed(2, 32));
        
        X <= std_logic_vector(to_signed(-7, 32));
        Y <= std_logic_vector(to_signed(40, 32));
        
        wait for 10ns;
        
        setBias <= '1';
        
        wait for 25ns;
        
        setBias <= '0';
        
        wait for 60ns;
        
        startAccumulation <= '1';
        
        wait for 20ns;
        
        startAccumulation <= '0';
        
        wait;
    end process;

end structural;
