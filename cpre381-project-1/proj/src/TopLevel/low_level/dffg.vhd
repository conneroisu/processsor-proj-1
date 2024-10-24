-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/dffg.vhd
-- Notes:
--      conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--      conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--      conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--      Conner Ohnesorge  <connero@iastate.edu> fix-remove-remaining-old-comment-headers-in-low_level
--      Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

library ieee;
use ieee.std_logic_1164.all;

entity dffg is
    port (
        i_clk : in  std_logic;          -- Clock input
        i_rst : in  std_logic;          -- Reset input
        i_we  : in  std_logic;          -- Write enable input
        i_d   : in  std_logic;          -- Data value input
        o_q   : out std_logic           -- Data value output
        );
end entity dffg;


architecture mixed of dffg is

    signal s_d : std_logic;             -- Multiplexed input to the FF
    signal s_q : std_logic;             -- Output of the FF

begin
    -- The output of the FF is fixed to s_Q
    o_q <= s_q;

    -- Create a multiplexed input to the FF based on i_WE
    with i_WE select s_d <=
        i_D when '1',
        s_q when others;

    -- This process handles the asyncrhonous reset and synchronous write. 
    -- We want to reset our processor's registers to minimize glitchy behavior on startup.
    process (i_clk, i_rst) is
    begin

        if (i_rst = '1') then           -- if the reset is active
            s_q <= '0';  -- Use "(others => '0')" for N-bit values
        elsif (rising_edge(i_clk)) then  -- else if the clock is rising edge
            s_q <= s_d;                 -- then set the output to the input
        end if;

    end process;
end architecture mixed;













