library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MoltiplicatoreBooth_tb is
end MoltiplicatoreBooth_tb;

architecture structural of MoltiplicatoreBooth_tb is

    component MoltiplicatoreBooth is
        port(
            clock, reset, start:    in std_logic;
            X, Y:               in std_logic_vector(15 downto 0);
            
            P:                  out std_logic_vector(31 downto 0);
            productFinished:    out std_logic
        );
    end component;

    signal X, Y: std_logic_vector(15 downto 0);
    signal clock, reset, start: std_logic;
    
    signal result: std_logic_vector(31 downto 0);
    signal outputReady: std_logic;

    constant CLK_period : time := 10 ns;
begin

    simClock: process    
    begin
        clock <= '0';
        wait for CLK_period;
        clock <= '1';
        wait for CLK_period;
    end process;

    uut: MoltiplicatoreBooth
    port map(
        X => X,
        Y => Y,
        
        clock => clock,
        reset => reset,
        start => start,
        
        P => result,
        productFinished => outputReady
    );

    simProcess: process
    begin
        wait for 100ns;
        
        X <= std_logic_vector(to_signed(10922, 16));
        Y <= std_logic_vector(to_signed(-10923, 16));
        
        wait for 10ns;
        
        start <= '1';
        wait for 30ns;
        start <= '0';
        
        wait for 30ns;
        
        wait;
    
    end process;
end structural;
