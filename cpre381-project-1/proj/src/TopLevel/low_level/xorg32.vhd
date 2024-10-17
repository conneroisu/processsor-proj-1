-- <header>
-- Author(s): github-actions[bot]
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/xorg32.vhd
-- Notes:
--	github-actions[bot] github-actions[bot]@users.noreply.github.com Format and Header
-- </header>




-------------------------------------------------------------------------
-- author(s): Conner Ohnesorge & Levi Wenck
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- name: xorg32.vhd
-------------------------------------------------------------------------
-- Description: This file is the test bench for the ALU. It tests the
-- ALU with different test cases. 
-------------------------------------------------------------------------

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
