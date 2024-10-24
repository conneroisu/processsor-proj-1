-- <header>
-- Author(s): conneroisu
-- Name: proj/src/LowLevel/xorg32.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--	conneroisu  <conneroisu@outlook.com> added-xorg32-component-to-the-low-level-components-a-32-bit-xor-gate
-- </header>

library IEEE;
use IEEE.std_logic_1164.all;
entity xorg32 is
    port (
        i_A : in  std_logic_vector(31 downto 0);  -- input A
        i_B : in  std_logic_vector(31 downto 0);  -- input B
        o_F : out std_logic_vector(31 downto 0)   -- output F
        );
end xorg32;
architecture dataflow of xorg32 is
begin
    G1 : for i in 0 to 31 generate
        o_F(i) <= i_A(i) xor i_B(i);
    end generate;
end dataflow;
