-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/norg32.vhd
-- Notes:
--      conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--      conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--      conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--      Conner Ohnesorge  <connero@iastate.edu> remove-outdated-comment-headers-in-low_level-components
--      Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

library IEEE;
use IEEE.std_logic_1164.all;
entity norg32 is
    port (
        i_A : in  std_logic_vector(31 downto 0);
        i_B : in  std_logic_vector(31 downto 0);
        o_F : out std_logic_vector(31 downto 0));
end norg32;
architecture dataflow of norg32 is
begin
    G1 : for i in 0 to 31 generate
        o_F(i) <= i_A(i) nor i_B(i);
    end generate;
end dataflow;
