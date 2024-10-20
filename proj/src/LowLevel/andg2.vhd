-- <header>
-- Author(s): connero
-- Name: proj/src/LowLevel/andg2.vhd
-- Notes:
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-pull-request-28-from-conneroisu-feature-control_unit
-- </header>

library IEEE;
use IEEE.std_logic_1164.all;
entity andg2 is
    port (
        i_A : in  std_logic;            -- input 1 to the AND gate
        i_B : in  std_logic;            -- input 2 to the AND gate
        o_F : out std_logic);           -- output of the AND gate
end andg2;
architecture dataflow of andg2 is
begin
    o_F <= i_A and i_B;        -- simple dataflow implementation of an AND gate
end dataflow;
