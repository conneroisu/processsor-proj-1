-- <header>
-- Author(s): github-actions[bot]
-- Name: proj/src/LowLevel/mux2t1.vhd
-- Notes:
--	github-actions[bot] github-actions[bot]@users.noreply.github.com Format and Header
-- </header>




library ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration of mux2t1

entity mux2t1 is
    port (
        i_s  : in  std_logic;           -- Select input
        i_d0 : in  std_logic;           -- Data input 0
        i_d1 : in  std_logic;           -- Data input 1
        o_o  : out std_logic            -- Output
        );
end entity mux2t1;

-- Architecture Declaration of mux2t1

architecture dataflow of mux2t1 is

begin

    o_o <= i_d0 when (i_s = '0') else
           i_d1 when (i_s = '1');  -- Output is i_D0 when i_S is '0' and i_D1 when i_S is '1'

end architecture dataflow;
