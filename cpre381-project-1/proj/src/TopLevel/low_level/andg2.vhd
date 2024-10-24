-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/andg2.vhd
-- Notes:
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-pull-request-31-from-conneroisu-control
-- </header>

-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- andg2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input AND 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-- 3/25/24 by CO::Formatted and added comments.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
entity andg2 is
    port (
        i_A : in  std_logic;            -- First input
        i_B : in  std_logic;            -- Second input
        o_F : out std_logic             -- Output
        );
end andg2;
architecture dataflow of andg2 is
begin
    o_F <= i_A and i_B;       -- Output is the logical AND of the two inputs
end dataflow;
