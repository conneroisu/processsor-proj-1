-- <header>
-- Author(s): conneroisu
-- Name: proj/src/LowLevel/org2.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> even-better-file-header-program
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


