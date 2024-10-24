-- <header>
-- Author(s): github-actions[bot]
-- Name: cpre381-project-1/proj/src/TopLevel/Sign-Extend/Sign-Extend.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	dmvp01  <dmvp01@linuxvdi-34.ece.iastate.edu> Added-new-Sign-Extender-and-test-bench
-- </header>

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity SignExtend is
    port (
        in_signal  : in  std_logic_vector(15 downto 0);       -- 16-bit input
        out_signal : out std_logic_vector(31 downto 0)        -- 32-bit output
        );
end SignExtend;
architecture Behavioral of SignExtend is
begin
    process(in_signal)
    begin
        if in_signal(15) = '1' then  -- //Check MSB of the input (in_signal(15))
            out_signal <= (31 downto 16 => '1') & in_signal;  -- //Sign extend with 1 for negative numbers
        else
            out_signal <= (31 downto 16 => '0') & in_signal;  -- //Sign extend with 0 for positive numbers
        end if;
    end process;
end Behavioral;
