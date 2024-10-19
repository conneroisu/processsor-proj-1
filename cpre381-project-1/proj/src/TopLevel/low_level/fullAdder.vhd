-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/fullAdder.vhd
-- Notes:
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-pull-request-28-from-conneroisu-feature-control_unit
-- </header>

-------------------------------------------------------------------------
-- Conner Ohnesorge
-- DEPARTMENT OF ELECTRICAL ENGINEERING
-- IOWA STATE UNIVERSITY
-------------------------------------------------------------------------
-- name :FullAdder.vhd
-------------------------------------------------------------------------
-- Description: This is a structural description of a full adder. It is
-- made up of 2 xor gates, 2 and gates, and 1 or gate.
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


entity fulladder is
    -- generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port (
        i_x0   : in  std_logic;         -- Input 0 to be added.
        i_x1   : in  std_logic;         -- Input 1 to be added.
        i_cin  : in  std_logic;         -- Carry in.
        o_y    : out std_logic;         -- Sum output.
        o_cout : out std_logic          -- Carry out.
        );
end entity fulladder;

architecture structural of fulladder is

    component xorg2 is
        port (
            i_a : in  std_logic;
            i_b : in  std_logic;
            o_f : out std_logic
            );
    end component;

    component andg2 is
        port (
            i_a : in  std_logic;
            i_b : in  std_logic;
            o_f : out std_logic
            );
    end component;

    component org2 is
        port (
            i_a : in  std_logic;
            i_b : in  std_logic;
            o_f : out std_logic
            );
    end component;

    signal s1 : std_logic;
    signal s2 : std_logic;
    signal s3 : std_logic;

begin

    xor1 : component xorg2
        port map (
            i_a => i_x0,
            i_b => i_x1,
            o_f => s1
            );

    xor2 : component xorg2
        port map (
            i_a => s1,
            i_b => i_cin,
            o_f => o_y
            );

    and1 : component andg2
        port map (
            i_a => s1,
            i_b => i_cin,
            o_f => s2
            );

    and2 : component andg2
        port map (
            i_a => i_x0,
            i_b => i_x1,
            o_f => s3
            );

    or1 : component org2
        port map (
            i_a => s2,
            i_b => s3,
            o_f => o_cout
            );

    -- Instantiate N mux instances.
    -- G_OnesComp: for i in 0 to N-1 generate
    -- idk: invg port map(
    --  i_A    =>    i_I(i),
    --  o_F    =>    o_O(i));
    -- end generate G_OnesComp;

end architecture structural;



