-- <header>
-- Author(s): connero
-- Name: proj/src/LowLevel/andg2.vhd
-- Notes:
--	connero 88785126+conneroisu@users.noreply.github.com Merge 4f34c422cf72d5fd2b8d20c7eec5f97b5864e12b into 7f8dd730b40cf8f2dce4e781c792d9e15bafdab1
-- </header>




library IEEE;
use IEEE.std_logic_1164.all;

entity andg2 is

    port (
        i_A : in  std_logic;            -- input 1 to the AND gate
        i_B : in  std_logic;            -- input 2 to the AND gate
        o_F : out std_logic);           -- output of the AND gate

end andg2;

architecture dataflow of andg2 is
begin

    o_F <= i_A and i_B;  -- simple dataflow implementation of an AND gate

end dataflow;
