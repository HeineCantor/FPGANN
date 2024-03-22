library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_signed.all;

entity neuron is
    generic(
        inputWidth: natural := 1
    );
    port(
        input: in std_logic_vector((inputWidth*16-1) downto 0);
        weights: in std_logic_vector(((inputWidth+1)*8-1) downto 0);
        
        output: out std_logic_vector(15 downto 0)
    );
end neuron;

architecture Behavioral of neuron is
    
    signal internalOutput: std_logic_vector(15 downto 0);
    signal products: std_logic_vector((inputWidth*16-1) downto 0);
    
begin

    -- Sommatore ----> CS o RCA
    
    -- Prodotto per ogni input e peso
    process (input, weights)
    begin
        L1: for i in 0 to inputWidth-1 loop
                    products((16*(i+1)-1) downto (16*i)) <= to_stdlogicvector(to_bitvector(std_logic_vector(signed(input(15 downto 0))*signed(weights(7 downto 0)))))(23 downto 8);
                end loop L1;    
    end process;     
    
    -- Calcolo somma + bias
    
      
    output <= internalOutput;
    
end Behavioral;
