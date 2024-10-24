-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/extender8t32.vhd
-- Notes:
--      conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--      conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--      conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--      Conner Ohnesorge  <connero@iastate.edu> fix-remove-remaining-old-comment-headers-in-low_level
--      Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

library ieee;
use ieee.std_logic_1164.all;

entity extender8t32 is
    port(
        i_I : in  std_logic_vector(7 downto 0);  -- byte value
        i_C : in  std_logic;                     -- signed extender or unsigned
        o_O : out std_logic_vector(31 downto 0)  -- 32 bit extended value
        );
end extender8t32;

architecture dataflow of extender8t32 is
    signal ext_bit  : std_logic;                      -- sign extension bit
    signal extended : std_logic_vector(31 downto 0);  -- extended immediate
begin

    o_O(7 downto 0) <= i_I(7 downto 0);  --copy bits we already have

    with i_C select  --determined if signed extension or unsigned
    ext_bit <= '0' when '0',
               i_I(7) when others;

    G2 : for i in 8 to 31 generate      -- add on our extension
        o_O(i) <= ext_bit;
    end generate;


end dataflow;














