-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/alu/adder_subtractor.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--	conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

-------------------------------------------------------------------------
-- Conner Ohnesorge
-- DEPARTMENT OF ELECTRICAL ENGINEERING
-- IOWA STATE UNIVERSITY
-------------------------------------------------------------------------
-- name: adder_subtractor.vhd
-------------------------------------------------------------------------
-- Description: This file contains the VHDL code for a 32-bit adder/subtractor.
-- The adder/subtractor is implemented using a full adder, a 2-to-1 multiplexer,
-- and a 32-bit 1's complementer. The adder/subtractor has a control signal
-- that determines whether the operation is addition or subtraction.
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

-- Entity for the adder/subtractor.
entity adder_subtractor is
    generic (
        n : integer := 32  -- Generic of type integer for input/output data width. Default value is 32.
        );
    port (
        nadd_sub   : in  std_logic;
        i_a        : in  std_logic_vector(n - 1 downto 0);  -- Input A
        i_b        : in  std_logic_vector(n - 1 downto 0);  -- Input B
        i_s        : in  std_logic;  -- selects between signed or unsigned operations (signed = 1)
        o_y        : out std_logic_vector(n - 1 downto 0);  -- Output Y
        o_cout     : out std_logic;     -- Carry out
        o_overflow : out std_logic      -- Overflow Indicator
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

-- Overflow occurs when:  
    -- Two negative numbers are added and an answer comes positive or 
    -- Two positive numbers are added and an answer comes as negative. 

-- used for overflow detection (if carry value into MSB doesn't match the carry out value, then overflow occured)
    component xorg2 is
        port (i_a : in  std_logic;
              i_b : in  std_logic;
              o_f : out std_logic
              );
    end component;

    component andg2 is
        port (i_a : in  std_logic;
              i_b : in  std_logic;
              o_f : out std_logic
              );
    end component;

    component mux2t1 is
        port (
            i_s  : in  std_logic;       -- selector
            i_d0 : in  std_logic;       -- data inputs
            i_d1 : in  std_logic;       -- data inputs
            o_o  : out std_logic        -- output
            );
    end component;

    signal s_overflow     : std_logic;
    signal c              : std_logic_vector(n downto 0);      -- Carry
    signal s1, s2, s3, s4 : std_logic_vector(n - 1 downto 0);  -- Signals for the 2nd input and the output of the 2nd input.

begin

    -- Invert the 2nd input and output it in wire s1. (used for signed operations)
    inverter : component comp1_N
        port map(
            i_D0 => i_b,
            o_O  => s1
            );

-- TODO  replace addsubctrl 1/2 and operationsigned with 4t1 mux

    addsubctrl1 : component mux2t1_n  --wtf is this meant to do, what was I thinking
        port map(
            i_s  => nadd_sub,
            i_d0 => i_b,
            i_d1 => i_b,
            o_o  => s2
            );

    -- Forward either subtraction signal or addition signal
    addsubctrl2 : component mux2t1_n
        port map(
            i_s  => nadd_sub,
            i_d0 => i_b,
            i_d1 => s1,
            o_o  => s3
            );

    -- Let through either signed/unsigned addition signal, or subtraction signal (inverted)
    -- forward either current signal or inverted (for unsigned subtraction)
    OperationSigned : component mux2t1_n
        port map(
            i_s  => nadd_sub,
            i_d0 => s2,
            i_d1 => s3,
            o_o  => s4
            );

    c(0) <= nadd_sub;  --does 2s complement for signed subtraction only

    g_fulladder : for i in 0 to n - 1 generate  -- create 32 full adders in parallel

        fulladderlist : component fulladder
            port map(
                i_x0   => i_a(i),
                i_x1   => s3(i),
                i_cin  => c(i),
                o_y    => o_y(i),
                o_cout => c(i + 1)
                );

    end generate g_fulladder;

    o_cout <= c(n);

    --overflow_detection : COMPONENT xorg2 (TODO REIMPLEMENT IN FINAL ITERATION)
    --PORT MAP(
    --i_a => c(n), -- carry out of MSB
    --i_b => c(n-1), -- carry in of MSB
    --o_f => s_overflow
    --);
    s_overflow <= c(n) xor c(n-1);

    overflow_suppression : component andg2
        port map(
            i_a => s_overflow,          -- carry out of MSB
            i_b => i_s,                 -- no overflow on unsigned operations
            o_f => o_overflow
            );

end architecture structural;












