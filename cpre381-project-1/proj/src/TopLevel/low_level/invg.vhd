-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- invg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 1-input NOT 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-- 1/16/19 by H3::Changed name to avoid name conflict with Quartus 
--         primitives.
-- 3/25/24 by CO::Formatted, added comments.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity invg is
  port (
    i_A : in STD_LOGIC;  -- Input to the NOT gate
    o_F : out STD_LOGIC  -- Output from the NOT gate
  );
end invg;

architecture dataflow of invg is
begin
  o_F <= not i_A; -- Output is the inverse of the input
end dataflow;
