-------------------------------------------------------------------------
-- author(s): Conner Ohnesorge & Levi Wenck
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- MIPS_pc_dffg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file describes the PC module. The PC module is
-- responsible for keeping track of the current instruction address
-- and the next instruction address. The PC module is a register
-- that is updated on the rising edge of the clock signal.
-- 
-- NOTES:
-- 3/23/24 by CO:: Design Created
-------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY MIPS_pc_dffg IS
  port(
    i_CLK        : in std_logic;     -- Clock input
    i_RST        : in std_logic;     -- Reset input
    i_RST_data   : in std_logic;     -- Write enable input
    i_D          : in std_logic;     -- Data value input
    o_Q          : out std_logic     -- Data value output
  );

END MIPS_pc_dffg;

ARCHITECTURE mixed OF MIPS_pc_dffg IS
  --signal s_D    : std_logic;    -- Multiplexed input to the FF
  SIGNAL s_Q : STD_LOGIC; -- Output of the FF

BEGIN

  -- The output of the FF is fixed to s_Q
  o_Q <= s_Q;

  -- Create a multiplexed input to the FF based on i_WE

  -- This process handles the asyncrhonous reset and
  -- synchronous write. We want to be able to reset 
  -- our processor's registers so that we minimize
  -- glitchy behavior on startup.
  PROCESS (i_CLK, i_RST)
  BEGIN
    IF (i_RST = '1') THEN
      s_Q <= i_RST_data; -- Use "(others => '0')" for N-bit values
    ELSIF (rising_edge(i_CLK)) THEN
      s_Q <= i_D;
    END IF;
  end process;

end mixed;
