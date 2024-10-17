-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/org2.vhd
-- Notes:
--	connero 88785126+conneroisu@users.noreply.github.com Merge pull request #25 from conneroisu/sign-extend
-- </header>


-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- org2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input OR 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-- 3/24/24 by CO::Formatted, Aligned, and added comments.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity org2 is

    port (
        i_A : in  std_logic;            -- Inputs A to the OR gate
        i_B : in  std_logic;            -- Inputs A to the OR gate
        o_F : out std_logic             -- Output F
        );

end org2;

architecture dataflow of org2 is
begin

    o_F <= i_A or i_B;  -- Output F is the logical OR of inputs A and B

end dataflow;
