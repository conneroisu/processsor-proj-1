-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/norg32.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> renamed-proj-src-LowLevel-1Comp_N.vhd-proj-src-LowLevel-complementor1_N.vhd
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
