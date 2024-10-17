-- <header>
-- Author(s): connero
-- Name: proj/src/LowLevel/org2.vhd
-- Notes:
--	connero 88785126+conneroisu@users.noreply.github.com Merge 4f34c422cf72d5fd2b8d20c7eec5f97b5864e12b into 7f8dd730b40cf8f2dce4e781c792d9e15bafdab1
-- </header>




library ieee;
use ieee.std_logic_1164.all;

entity org2 is
    port (
        i_a : in  std_logic;
        i_b : in  std_logic;
        o_f : out std_logic
        );
end entity org2;

architecture dataflow of org2 is

begin

    o_f <= i_a or i_b;

end architecture dataflow;
