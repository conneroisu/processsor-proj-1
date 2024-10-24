-- <header>
-- Author(s): github-actions[bot]
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/xorg2.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	Conner Ohnesorge  <connero@iastate.edu> remove-outdated-comment-headers-in-low_level-components
--	Conner Ohnesorge  <connero@iastate.edu> latest
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








