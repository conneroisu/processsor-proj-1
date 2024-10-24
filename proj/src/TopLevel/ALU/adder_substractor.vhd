
library ieee;
use ieee.std_logic_1164.all;

-- Entity for the adder/subtractor.
entity adder_subtractor is
    generic (
        n : integer := 32  -- Generic for input/output data width. Default is 32.
    );
    port (
        nadd_sub   : in  std_logic; -- Control: 0 for add, 1 for subtract
        i_a        : in  std_logic_vector(n - 1 downto 0);  -- Operand A
        i_b        : in  std_logic_vector(n - 1 downto 0);  -- Operand B
        i_s        : in  std_logic;  -- Select between signed/unsigned operation (signed = 1)
        o_y        : out std_logic_vector(n - 1 downto 0);  -- Result
        o_cout     : out std_logic;  -- Carry-out flag
        o_overflow : out std_logic   -- Overflow flag
    );
end entity adder_subtractor;

-- Architecture for the adder/subtractor.
architecture structural of adder_subtractor is

    component mux2t1_n is generic (
        n : integer := 32
    );
    port (
        i_s  : in  std_logic;
        i_d0 : in  std_logic_vector(N - 1 downto 0);
        i_d1 : in  std_logic_vector(N - 1 downto 0);
        o_o  : out std_logic_vector(N - 1 downto 0)
    );
    end component;

    component comp1_N is generic (
        n : integer := 32
    );
    port (
        i_D0 : in  std_logic_vector(N - 1 downto 0);
        o_O  : out std_logic_vector(N - 1 downto 0)
    );
    end component;

    component fulladder is
        port (
            i_x0   : in  std_logic;
            i_x1   : in  std_logic;
            i_cin  : in  std_logic;
            o_y    : out std_logic;
            o_cout : out std_logic
        );
    end component;

    component andg2 is
        port (
            i_a : in  std_logic;
            i_b : in  std_logic;
            o_f : out std_logic
        );
    end component;

    signal c : std_logic_vector(n downto 0);  -- Carry chain
    signal s1 : std_logic_vector(n - 1 downto 0);  -- Inverted B (for subtraction)
    signal s3 : std_logic_vector(n - 1 downto 0);  -- Selected operand (either B or inverted B)

begin

    -- Invert B for subtraction (two's complement)
    inverter : comp1_N
        port map (
            i_D0 => i_b,
            o_O  => s1
        );

    -- Control whether to invert B for subtraction (mux2t1 for add/sub control)
    mux_addsub : mux2t1_n
        port map (
            i_s  => nadd_sub,   -- Control: 0 for add, 1 for subtract
            i_d0 => i_b,        -- Use B for addition
            i_d1 => s1,         -- Use inverted B for subtraction
            o_o  => s3          -- Output the selected value
        );

    -- Generate the full adder chain
    c(0) <= nadd_sub;  -- Carry-in for subtraction (1 for subtract)
    
    g_fulladder : for i in 0 to n - 1 generate
        fulladderlist : fulladder
            port map (
                i_x0   => i_a(i),       -- Operand A
                i_x1   => s3(i),        -- Operand B or inverted B
                i_cin  => c(i),         -- Carry-in from previous bit
                o_y    => o_y(i),       -- Sum output
                o_cout => c(i + 1)      -- Carry-out to next bit
            );
    end generate g_fulladder;

    o_cout <= c(n);  -- Final carry-out

    -- Overflow detection (check the sign change on MSB carry-in and carry-out)
    process(c)
    begin
        if (c(n) xor c(n-1)) = '1' then
            o_overflow <= '1';  -- Overflow occurred
        else
            o_overflow <= '0';  -- No overflow
        end if;
    end process;

end architecture structural;
