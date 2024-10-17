-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/norg32.vhd
-- Notes:
--	connero 88785126+conneroisu@users.noreply.github.com Merge pull request #25 from conneroisu/sign-extend
-- </header>


-------------------------------------------------------------------------
-- author(s): Conner Ohnesorge & Levi Wenck
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- name: norg32.vhd
-------------------------------------------------------------------------
-- Description: This file is the test bench for the ALU. It tests the
-- ALU with different test cases. 
-------------------------------------------------------------------------

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
