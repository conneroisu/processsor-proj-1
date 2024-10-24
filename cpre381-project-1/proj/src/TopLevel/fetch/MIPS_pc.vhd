-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/fetch/MIPS_pc.vhd
-- Notes:
--	conneroisu  <88785126+conneroisu@users.noreply.github.com> Format-and-Header
--	conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--	conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

-------------------------------------------------------------------------
-- author(s): Conner Ohnesorge & Levi Wenck
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- MIPS_pc.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file describes the PC module. The PC module is
-- responsible for keeping track of the current instruction address
-- and the next instruction address. The PC module is a register
-- that is updated on the rising edge of the clock signal.
-- 
-- NOTES:
-- 3/1/24 by CO:: Design Created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
entity MIPS_pc is
    --generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
    port(
        i_CLK : in  std_logic;          -- Clock input
        i_RST : in  std_logic;          -- Reset input
        --i_WE         : in std_logic;                       -- Write enable input
        i_D   : in  std_logic_vector(31 downto 0);   -- Data value input
        o_Q   : out std_logic_vector(31 downto 0));  -- Data value output
end MIPS_pc;
architecture structural of MIPS_pc is
    component MIPS_pc_dffg is
        port(
            i_CLK      : in  std_logic;              -- Clock input
            i_RST      : in  std_logic;              -- Reset input
            i_RST_data : in  std_logic;              -- Write enable input
            i_D        : in  std_logic;              -- Data value input
            o_Q        : out std_logic);             -- Data value output
    end component;
    signal s_RST_data : std_logic_vector(31 downto 0) := X"00400000";
begin
    -- Instantiate N dff instances.
    G_NBit_DFFG : for i in 0 to 31 generate
        ONESCOMPI : MIPS_pc_dffg port map(
            i_CLK      => i_CLK,        -- every dff has the same clock
            i_RST      => i_RST,        -- parallel rst
            i_RST_data => s_RST_data(i),             -- parallel write enable
            i_D        => i_D(i),       -- N bit long dff reg input
            o_Q        => o_Q(i));      -- N bit long dff reg output
    end generate G_NBit_DFFG;
end structural;
