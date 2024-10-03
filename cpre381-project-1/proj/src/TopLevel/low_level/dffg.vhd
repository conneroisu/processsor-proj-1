-------------------------------------------------------------------------
-- Conner Ohnesorge
-- DEPARTMENT OF ELECTRICAL ENGINEERING
-- IOWA STATE UNIVERSITY
-------------------------------------------------------------------------
-- dffg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an edge-triggered
-- flip-flop with parallel access and reset.
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity dffg is
  port (
    i_clk : in STD_LOGIC; -- Clock input
    i_rst : in STD_LOGIC; -- Reset input
    i_we : in STD_LOGIC;  -- Write enable input
    i_d : in STD_LOGIC;   -- Data value input
    o_q : out STD_LOGIC   -- Data value output
  );
end entity dffg;


architecture mixed of dffg is

  signal s_d : STD_LOGIC; -- Multiplexed input to the FF
  signal s_q : STD_LOGIC; -- Output of the FF

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

    if (i_rst = '1') then -- if the reset is active
      s_q <= '0'; -- Use "(others => '0')" for N-bit values
    elsif (rising_edge(i_clk)) then -- else if the clock is rising edge
      s_q <= s_d; -- then set the output to the input
    end if;

  end process;
end architecture mixed;
