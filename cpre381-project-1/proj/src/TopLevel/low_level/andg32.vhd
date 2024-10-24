-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/andg32.vhd
-- Notes:
--	conneroisu  <88785126+conneroisu@users.noreply.github.com> Format-and-Header
--	conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--	conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	Conner Ohnesorge  <connero@iastate.edu> fix-remove-remaining-old-comment-headers-in-low_level
--	Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

library IEEE;
use IEEE.std_logic_1164.all;
entity andg32 is
    port
        (
            i_A : in  std_logic_vector(31 downto 0);  -- input A 
            i_B : in  std_logic_vector(31 downto 0);  -- input B
            o_F : out std_logic_vector(31 downto 0)   -- output F
            );
end andg32;
architecture dataflow of andg32 is
begin
    G1 : for i in 0 to 31 generate
        o_F(i) <= i_A(i) and i_B(i);
    end generate;
end dataflow;
