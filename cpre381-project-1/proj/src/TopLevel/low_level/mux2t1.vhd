-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/mux2t1.vhd
-- Notes:
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-pull-request-55-from-conneroisu-test-branch
-- </header>

-------------------------------------------------------------------------
-- Levi Wenck
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input Mux
--
--
-- NOTES:
-- 1/18/24 by LAW::Design created.
-- 3/25/24 by CO::Formatted, aligned, and commented.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
entity mux2t1 is
    port (
        i_s  : in  std_logic;           -- selector
        i_d0 : in  std_logic;           -- data inputs
        i_d1 : in  std_logic;           -- data inputs
        o_o  : out std_logic            -- output
        );
end mux2t1;
architecture structure of mux2t1 is
    component andg2 is
        port (
            i_A : in  std_logic;        -- input A to AND gate
            i_B : in  std_logic;        -- input B to AND gate
            o_F : out std_logic         -- output of AND gate
            );
    end component;
    component org2 is
        port (
            i_A : in  std_logic;        -- input A to OR gate
            i_B : in  std_logic;        -- input B to OR gate
            o_F : out std_logic         -- output of OR gate
            );
    end component;
    component invg is
        port (
            i_A : in  std_logic;        -- input to NOT gate
            o_F : out std_logic         -- output of NOT gate
            );
    end component;
    -- Signal to hold invert of the selector bit
    signal s_inv_S1   : std_logic;
    -- Signals to hold output valeus from 'AND' gates (needed to wire component to component?)
    signal s_oX, s_oY : std_logic;
begin
    ---------------------------------------------------------------------------
    -- Level 0: signals go through NOT stage
    ---------------------------------------------------------------------------
    invg1 : invg
        port map(
            i_A => i_s,                 -- input to NOT gate
            o_F => s_inv_S1             -- output of NOT gate
            );
    ---------------------------------------------------------------------------
    -- Level 1: signals go through AND stage
    ---------------------------------------------------------------------------
    and1 : andg2
        port map(
            i_A => i_d0,                -- input to AND gate
            i_B => s_inv_S1,            -- input to AND gate
            o_F => s_oX                 -- output of AND gate
            );
    and2 : andg2
        port map(
            i_A => i_d1,                -- input to AND gate
            i_B => i_s,                 -- input to AND gate
            o_F => s_oY                 -- output of AND gate
            );
    ---------------------------------------------------------------------------
    -- Level 1: signals go through OR stage (and then output)
    ---------------------------------------------------------------------------
    org1 : org2
        port map(
            i_A => s_oX,                -- input to OR gate
            i_B => s_oY,                -- input to OR gate
            o_F => o_o                  -- output of OR gate
            );
end structure;
