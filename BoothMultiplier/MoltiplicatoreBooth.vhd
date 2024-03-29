library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MoltiplicatoreBooth is
    port(
        clock, reset, start:    in std_logic;
        X, Y:               in std_logic_vector(31 downto 0);
        
        P:                  out std_logic_vector(63 downto 0);
        productFinished:    out std_logic
    );
end MoltiplicatoreBooth;

architecture structural of MoltiplicatoreBooth is

    component UnitaControllo
        port(
            clock, reset, start: in std_logic;
            count: in std_logic_vector(4 downto 0);
            
            q0, q_1: in std_logic;
            
            loadM, loadAQ, countIn, shiftAQ: out std_logic;
            selAQ, subSignal: out std_logic;
            
            productFinished: out std_logic
        );
    end component;
    
    component UnitaOperativa
        port(
            X, Y:           in std_logic_vector(31 downto 0);
            clock, reset:   in std_logic;
            
            subSignal, countIn,
            loadAQ, loadM, shiftAQ, selAQ:  in std_logic;
            
            outputProduct:  out std_logic_vector(63 downto 0);
            qPadding:       out std_logic;
            count:          out std_logic_vector(4 downto 0)   
        );
    end component;

    signal countLink: std_logic_vector(4 downto 0);
    signal qPaddingLink: std_logic;

    signal outputProduct: std_logic_vector(63 downto 0);
    
    signal loadMlink, loadAQlink, countInlink, shiftAQlink, selAQlink, subSignallink: std_logic;

begin

    controlUnit: UnitaControllo
    port map(
        clock => clock,
        reset => reset,
        start => start,
        
        count => countLink,
        
        q0 => outputProduct(0),
        q_1 => qPaddingLink,
        
        loadM => loadMlink,
        loadAQ => loadAQlink,
        countIn => countInlink,
        shiftAQ => shiftAQlink,
        selAQ => selAQlink,
        subSignal => subSignallink,
        productFinished => productFinished
    );
    
    operationUnit: UnitaOperativa
    port map(
        X => X,
        Y => Y,
        
        clock => clock,
        reset => reset,
        
        subSignal => subSignallink,
        countIn => countInlink,
        loadAQ => loadAQlink,
        loadM => loadMlink,
        shiftAQ => shiftAQlink,
        selAQ => selAQlink,
        
        outputProduct => outputProduct,
        qPadding => qPaddingLink,
        count => countLink
    );
    
    P <= outputProduct;

end structural;
