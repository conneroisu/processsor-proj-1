-- <header>
-- Author(s): conneroisu
-- Name: proj/src/TopLevel/barrelShifter.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	awfoss  <awfoss@co2050-07.ece.iastate.edu> inital-creation-of-barrelShifter-very-little-done
-- </header>

--Aidan Foss
--CPRE 381, Fall 2024
--ISU
--barrelShifter.vhd
--DESC: Barrel Shifter
library IEEE;
use IEEE.std_logic_1164.all;
use work.MIPS_types.all;
entity barrelShifter is
    generic
        (N : integer := 32);
    port
        (
            i_data        : in  std_logic(N - 1 downto 0);
            i_shamt       : in  std_logic(4 downto 0);  --01001 would do shift 3 and shift 0, mux each bit to decide how much to shift
            i_leftOrRight : in  std_logic;  --0 or 1
            i_shiftType   : in  std_logic;  --0 for logicical shift, 1 for arithmetic shift
            o_O           : out std_logic (N - 1 downto 0)  --shifted output
            );
end barrelShifter;
architecture structure of barrelShifter is
    component mux
    --implement mux here
    end component;
-- mux signals (i think i need 5 or 6 for outputs, 5 or 6 for r/l, and 1 for carrying 16 bits)
    signal s_b : std_logic (15 downto 0);
begin
