library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAC is
    port(
        clock, reset: in std_logic;
        startAccumulation: in std_logic;
        setBias: in std_logic;
        
        X, Y: in std_logic_vector(31 downto 0);
        bias: in std_logic_vector(31 downto 0);
        
        Z: out std_logic_vector(31 downto 0);
        accumulationCompleted: out std_logic
    );
end MAC;

architecture Behavioral of MAC is

    component MoltiplicatoreBooth is
        port(
            clock, reset, start:    in std_logic;
            X, Y:               in std_logic_vector(31 downto 0);
            
            P:                  out std_logic_vector(63 downto 0);
            productFinished:    out std_logic
        );
    end component;
    
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
    
    component register_generic_ms is
        generic(
            width : integer range 1 to 32 := 8
        );
        port(
            dataInput:                  in std_logic_vector(width-1 downto 0);
            clock, reset, load:         in std_logic;
            dataOutput:                 out std_logic_vector(width-1 downto 0)  
        );
    end component;
    
    component Mux2to1 is
        generic (
            width : integer range 1 to 32 := 8
        );
        port( 
           a, b: in std_logic_vector(width-1 downto 0); 
           sel: in std_logic;
           c: out std_logic_vector(width-1 downto 0)
        );
    end component;
    
    component macControlUnit is
        port(
            clock, reset: in std_logic;
            setBias, startAccumulate, prodFinished: in std_logic;
       
            startProd, accumulateCompleted, selAccRegister, loadAccRegister: out std_logic
        );
    end component;

    signal mulStart, mulFinish, loadAccumulate: std_logic;
    signal mulOutput: std_logic_vector(63 downto 0);
    signal cropMulOutput, sumOutput: std_logic_vector(31 downto 0);
    
    signal accRegisterSelection: std_logic;
    
    signal accRegisterInput, accRegisterValue: std_logic_vector(31 downto 0);

begin

    cu: macControlUnit
    port map(
        clock => clock,
        reset => reset,
        
        setBias => setBias,
        startAccumulate => startAccumulation,
        prodFinished => mulFinish,
        
        startProd => mulStart,
        accumulateCompleted => accumulationCompleted,
        selAccRegister => accRegisterSelection,
        loadAccRegister => loadAccumulate
    );

    mulStep: MoltiplicatoreBooth
    port map(
        clock => clock,
        reset => reset,
        start => mulStart,
        
        X => X,
        Y => Y,
        
        P => mulOutput,
        productFinished => mulFinish
    );
    
    sumStep: RippleCarryAdder
    generic map( length => 32 )
    port map(
        X => accRegisterValue,
        Y => cropMulOutput,
        
        cIn => '0',
        cOut => open,
        
        Z => sumOutput
    );
    
    accRegisterMux: Mux2to1
    generic map( width => 32)
    port map(
        a => sumOutput,
        b => bias,
        
        sel => accRegisterSelection,
        
        c => accRegisterInput
    );
    
    accumulationRegister: register_generic_ms
    generic map( width => 32 )
    port map(
        dataInput => accRegisterInput,
        
        clock => clock,
        reset => reset,
        load => loadAccumulate,
        
        dataOutput => accRegisterValue
    );
    
    cropMulOutput <= mulOutput(31 downto 0);
    Z <= accRegisterValue;

end Behavioral;
