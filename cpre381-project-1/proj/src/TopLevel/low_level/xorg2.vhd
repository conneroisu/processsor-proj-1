-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/xorg2.vhd
-- Notes:
--	connero 88785126+conneroisu@users.noreply.github.com Merge pull request #15 from conneroisu/feature/program_counter
-- </header>



-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- xorg2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input XOR
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus
--         primitives.
-- 3/25/24 by CO::Formatted, aligned, and commented.
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity xorg2 is
    port (
        i_a : in  std_logic;            -- First input
        i_b : in  std_logic;            -- Second input
        o_f : out std_logic             -- Output
        );
end entity xorg2;

architecture dataflow of xorg2 is

begin

    o_f <= i_a xor i_b;                 -- XOR the two inputs

end architecture dataflow;
