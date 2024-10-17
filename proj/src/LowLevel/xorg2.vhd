-- <header>
-- Author(s): connero
-- Name: proj/src/LowLevel/xorg2.vhd
-- Notes:
--	connero 88785126+conneroisu@users.noreply.github.com Merge 4f34c422cf72d5fd2b8d20c7eec5f97b5864e12b into 7f8dd730b40cf8f2dce4e781c792d9e15bafdab1
-- </header>




library IEEE;
use IEEE.std_logic_1164.all;

entity xorg2 is

    port (
        i_A : in  std_logic;
        i_B : in  std_logic;
        o_F : out std_logic
        );

end xorg2;

architecture dataflow of xorg2 is
begin

    o_F <= i_A xor i_B;

end dataflow;
