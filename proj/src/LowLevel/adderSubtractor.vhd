-- <header>
-- Author(s): conneroisu
-- Name: proj/src/LowLevel/adderSubtractor.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> added-adder-subtractor-and-instantiated-the-program-counter-and-others
-- </header>

library IEEE;
use IEEE.std_logic_1164.all;
entity adderSubtractor is
    generic (
        N : integer := 32
        );
    port (
        nAdd_Sub : in  std_logic;
        i_A      : in  std_logic_vector(N - 1 downto 0);  -- Input A
        i_B      : in  std_logic_vector(N - 1 downto 0);  -- Input B
        o_Y      : out std_logic_vector(N - 1 downto 0);  -- Output Y
        o_Cout   : out std_logic                          -- Carry out
        );
end adderSubtractor;
architecture structural of adderSubtractor is
    component mux2t1_N is generic (N : integer := 32);
                          port (
                              i_S  : in  std_logic;  -- Select input
                              i_D0 : in  std_logic_vector(N - 1 downto 0);  -- Data input 0
                              i_D1 : in  std_logic_vector(N - 1 downto 0);  -- Data input 1
                              o_O  : out std_logic_vector(N - 1 downto 0)  -- Output
                              );
    end component;
    component complementor1_N is generic (N : integer := 32);
                                 port (
                                     i_D0 : in  std_logic_vector(N - 1 downto 0);  -- Input data 0.
                                     o_O  : out std_logic_vector(N - 1 downto 0)  -- Output data.
                                     );
    end component;
    component fullAdder is
        port (
            i_X0   : in  std_logic;     -- Input 0
            i_X1   : in  std_logic;     -- Input 1
            i_Cin  : in  std_logic;     -- Carry in
            o_Y    : out std_logic;     -- Output
            o_Cout : out std_logic);    -- Carry out
    end component;
    signal c      : std_logic_vector(N downto 0);      -- Carry
    signal s1, s2 : std_logic_vector(N - 1 downto 0);  -- Signals for the 2nd input and the output of the 2nd input.
begin
    -- Invert the 2nd input and output it in wire s1.
    inverter : complementor1_N
        port map(
            i_D0 => i_B,                -- map the input to the 2nd input
            o_O  => s1                  -- map the output to s1
            );
    -- Choose whether to use the original X1 or the inverted X1
    addsubctrl : mux2t1_N
        port map(
            i_S  => nAdd_sub,  -- map the control signal to the select input
            i_D0 => i_B,       -- map the original input to the 1st input
            i_D1 => s1,        -- map the inverted input to the 2nd input
            o_O  => s2                  -- map the output to s2
            );
    c(0) <= nAdd_Sub;
    G_fullAdder : for i in 0 to N - 1 generate
        fullAdderlist : fullAdder port map(
            i_X0   => i_A(i),           -- 1st input
            i_X1   => s2(i),            -- 2nd input
            i_Cin  => c(i),             -- Carry in
            o_Y    => o_Y(i),           -- Output
            o_Cout => c(i + 1)          -- Carry out
            );
    end generate G_fullAdder;
    o_Cout <= c(N);
end structural;
