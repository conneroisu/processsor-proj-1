-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/org2.vhd
-- Notes:
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-pull-request-28-from-conneroisu-feature-control_unit
-- </header>

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
    o_F <= i_A or i_B;        -- Output F is the logical OR of inputs A and B
end dataflow;
