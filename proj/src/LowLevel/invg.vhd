-- <header>
-- Author(s): connero
-- Name: proj/src/LowLevel/invg.vhd
-- Notes:
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-pull-request-55-from-conneroisu-test-branch
-- </header>

library IEEE;
use IEEE.std_logic_1164.all;
entity invg is
    port (
        i_A : in  std_logic;            -- Input to the NOT gate
        o_F : out std_logic             -- Output from the NOT gate
        );
end invg;
architecture dataflow of invg is
begin
    o_F <= not i_A;                     -- Output is the inverse of the input
end dataflow;
