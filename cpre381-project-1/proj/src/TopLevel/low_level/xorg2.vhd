-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/xorg2.vhd
-- Notes:
--	connero 88785126+conneroisu@users.noreply.github.com Merge 4f34c422cf72d5fd2b8d20c7eec5f97b5864e12b into 7f8dd730b40cf8f2dce4e781c792d9e15bafdab1
-- </header>




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
