library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FullAdder is
    port(
        a, b, cIn:  in std_logic;
        s, cOut:    out std_logic
    );
end FullAdder;

architecture Behavioral of FullAdder is

begin

    s <= a xor b xor cIn;
    cOut <= (a and b) or (cIn and (a xor b));

end Behavioral;
