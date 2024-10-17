-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/org2.vhd
-- Notes:
--	connero 88785126+conneroisu@users.noreply.github.com Merge 4f34c422cf72d5fd2b8d20c7eec5f97b5864e12b into 7f8dd730b40cf8f2dce4e781c792d9e15bafdab1
-- </header>




library IEEE;
use IEEE.std_logic_1164.all;

entity org2 is

    port (
        i_A : in  std_logic;            -- Inputs A to the OR gate
        i_B : in  std_logic;            -- Inputs A to the OR gate
        o_F : out std_logic             -- Output F
        );

end org2;

architecture dataflow of org2 is
begin

    o_F <= i_A or i_B;  -- Output F is the logical OR of inputs A and B

end dataflow;
