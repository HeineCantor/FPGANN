library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ReLU is
    generic(
        width : integer range 1 to 32 := 8
    );
    port(
        inData: in std_logic_vector(width-1 downto 0);
        
        outData: out std_logic_vector(width-1 downto 0)
    );
end ReLU;

architecture dataflow of ReLU is
    
begin

    outData <=  (others => '0')    when inData(width-1) = '1' else
                inData             when inData(width-1) = '0' else
                (others => 'U'); 

end dataflow;
