-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/dffg_tb.vhd
-- Notes:
--      conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--      conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--      conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--      Conner Ohnesorge  <connero@iastate.edu> fix-remove-remaining-old-comment-headers-in-low_level
--      Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

library ieee;
use ieee.std_logic_1164.all;

-- Entity declaration of dffg_tb

entity dffg_tb is
    generic (
        gclk_hper : time := 50 ns
        );
end entity dffg_tb;

-- Architecture declaration of dffg_tb

architecture behavior of dffg_tb is

    -- Calculate the clock period as twice the half-period
    constant cclk_per : time := gclk_hper * 2;

    component dffg is
        port (
            i_clk : in  std_logic;
            i_rst : in  std_logic;
            i_we  : in  std_logic;
            i_d   : in  std_logic;
            o_q   : out std_logic
            );
    end component;

    -- Temporary signals to connect to the dff component.
    signal s_clk    : std_logic;
    signal s_rst    : std_logic;
    signal s_we     : std_logic;
    signal s_d, s_q : std_logic;

begin

    dut : component dffg
        port map(
            i_clk => s_clk,
            i_rst => s_rst,
            i_we  => s_we,
            i_d   => s_d,
            o_q   => s_q
            );

    -- This process sets the clock value (low for gCLK_HPER, then high
    -- for gCLK_HPER). Absent a "wait" command, processes restart
    -- at the beginning once they have reached the final statement.
    p_clk : process is
    begin

        s_clk <= '0';
        wait for gclk_hper;
        s_clk <= '1';
        wait for gclk_hper;

    end process p_clk;

    -- Testbench process
    p_tb : process is
    begin

        -- Reset the FF
        s_rst <= '1';
        s_we  <= '0';
        s_d   <= '0';
        wait for cclk_per;

        -- Store '1'
        s_rst <= '0';
        s_we  <= '1';
        s_d   <= '1';
        wait for cclk_per;

        -- Keep '1'
        s_rst <= '0';
        s_we  <= '0';
        s_d   <= '0';
        wait for cclk_per;

        -- Store '0'
        s_rst <= '0';
        s_we  <= '1';
        s_d   <= '0';
        wait for cclk_per;

        -- Keep '0'
        s_rst <= '0';
        s_we  <= '0';
        s_d   <= '1';
        wait for cclk_per;

        wait;

    end process p_tb;

end architecture behavior;














