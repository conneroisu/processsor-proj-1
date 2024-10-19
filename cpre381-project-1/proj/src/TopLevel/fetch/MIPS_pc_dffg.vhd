-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/fetch/MIPS_pc_dffg.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

-------------------------------------------------------------------------
-- author(s): Conner Ohnesorge & Levi Wenck
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- MIPS_pc_dffg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file describes the PC module. The PC module is
-- responsible for keeping track of the current instruction address
-- and the next instruction address. The PC module is a register
-- that is updated on the rising edge of the clock signal.
-- 
-- NOTES:
-- 3/23/24 by CO:: Design Created
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
entity MIPS_pc_dffg is
    port(
        i_CLK      : in  std_logic;     -- Clock input
        i_RST      : in  std_logic;     -- Reset input
        i_RST_data : in  std_logic;     -- Write enable input
        i_D        : in  std_logic;     -- Data value input
        o_Q        : out std_logic      -- Data value output
        );
end MIPS_pc_dffg;
architecture mixed of MIPS_pc_dffg is
    --signal s_D    : std_logic;    -- Multiplexed input to the FF
    signal s_Q : std_logic;             -- Output of the FF
begin
    -- The output of the FF is fixed to s_Q
    o_Q <= s_Q;
    -- Create a multiplexed input to the FF based on i_WE
    -- This process handles the asyncrhonous reset and
    -- synchronous write. We want to be able to reset 
    -- our processor's registers so that we minimize
    -- glitchy behavior on startup.
    process (i_CLK, i_RST)
    begin
        if (i_RST = '1') then
            s_Q <= i_RST_data;  -- Use "(others => '0')" for N-bit values
        elsif (rising_edge(i_CLK)) then
            s_Q <= i_D;
        end if;
    end process;
end mixed;
