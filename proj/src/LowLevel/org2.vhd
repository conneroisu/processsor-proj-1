-- <header>
-- Author(s): conneroisu
-- Name: proj/src/LowLevel/org2.vhd
-- Notes:
--      conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--      conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--      conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--      conneroisu  <conneroisu@outlook.com> add-lowlevel-components-and-testbenches
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













