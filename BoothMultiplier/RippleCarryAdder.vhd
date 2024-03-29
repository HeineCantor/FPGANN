library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RippleCarryAdder is
    generic(
        length: integer := 8
    );
    port(
        X, Y:   in std_logic_vector(length-1 downto 0);
        cIn:    in std_logic;
        cOut:   out std_logic;
        Z:      out std_logic_vector(length-1 downto 0)
    );
end RippleCarryAdder;

architecture structural of RippleCarryAdder is

    component FullAdder is
        port(
            a, b, cIn:  in std_logic;
            s, cOut:    out std_logic
        );
    end component;

    signal carryLink: std_logic_vector(length-2 downto 0);

begin

    FA0: FullAdder port map(X(0), Y(0), cIn, Z(0), carryLink(0));
    
    FAmiddle: FOR i IN 1 to length-2 GENERATE
                FA: FullAdder port map(X(i), Y(i), carryLink(i-1), Z(i), carryLink(i));
            END GENERATE;
    
    FAlast: FullAdder port map(X(length-1), Y(length-1), carryLink(length-2), Z(length-1) ,cOut);

end structural;
