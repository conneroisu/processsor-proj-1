-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/fetch/nbitregister.vhd
-- Notes:
--      conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--      conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--      conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--      Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

-------------------------------------------------------------------------
-- author: Conner Ohnesorge
-- DEPARTMENT OF ELECTRICAL ENGINEERING
-- IOWA STATE UNIVERSITY
-------------------------------------------------------------------------
-- name: nbitregister.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: An n-bit register with a synchronous reset and write
-- enable. The register is implemented using a process with a clock
-- and reset input.
--
-- NOTES:
-- 1/25/24 by CO:: Design created.
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity nbitregister is
    generic (
        n : integer := 32
        );
    port (
        i_clk : in  std_logic;                         -- Clock input
        i_rst : in  std_logic;                         -- Reset input
        i_we  : in  std_logic;                         -- Write enable input
        i_d   : in  std_logic_vector(n - 1 downto 0);  -- Data value input
        o_q   : out std_logic_vector(n - 1 downto 0)   -- Data value output
        );
end entity nbitregister;

architecture mixed of nbitregister is

    signal s_d : std_logic_vector(n - 1 downto 0);  -- Multiplexed input to the Flip-Flop of the register
    signal s_q : std_logic_vector(n - 1 downto 0);  -- Output of the Flip-Flop of the register

begin

    -- The output of the FF is fixed to s_Q
    o_q <= s_q;

    -- Create a multiplexed input to the FF based on i_WE
    with i_WE select s_d <=
        i_D when '1',
        s_q when others;

    process (i_clk, i_rst) is
    begin

        if (i_rst = '1') then
            s_q <= (others => '0');  -- Use "(others => '0')" for N-bit values
        elsif (rising_edge(i_clk)) then
            s_q <= s_d;
        end if;

    end process;

end architecture mixed;














