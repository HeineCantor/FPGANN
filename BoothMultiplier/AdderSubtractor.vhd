library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AdderSubtractor is
    generic(
        length: integer := 8
    );
    port(
        X, Y:   in std_logic_vector(length-1 downto 0);
        cIn:    in std_logic;
        cOut:   out std_logic;
        Z:      out std_logic_vector(length-1 downto 0)
    );
end AdderSubtractor;

architecture structural of AdderSubtractor is

    component RippleCarryAdder is
        generic(
            length: integer := 8
        );
        port(
            X, Y:   in std_logic_vector(length-1 downto 0);
            cIn:    in std_logic;
            cOut:   out std_logic;
            Z:      out std_logic_vector(length-1 downto 0)
        );
    end component;

    signal complementaryInput: std_logic_vector(length-1 downto 0);

begin

    complementLoop: FOR i IN 0 TO length-1 GENERATE
                        complementaryInput(i) <= Y(i) xor cin;
                    END GENERATE;

    RCA: RippleCarryAdder
    generic map(
        length => length
    )
    port map(
        X => X,
        Y => complementaryInput,
        cIn => cIn,
        cOut => cOut,
        Z => Z
    );        
end structural;
