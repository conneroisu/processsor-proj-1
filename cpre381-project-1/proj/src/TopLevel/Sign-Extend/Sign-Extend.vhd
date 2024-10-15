library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity SignExtend is
    Port (
        in_signal : in  STD_LOGIC_VECTOR(15 downto 0); -- 16-bit input
        out_signal : out STD_LOGIC_VECTOR(31 downto 0) -- 32-bit output
    );
end SignExtend;


architecture Behavioral of SignExtend is
begin
    process(in_signal)
    begin
                if in_signal(15) = '1' then   -- //Check MSB of the input (in_signal(15))

            
            out_signal <= (31 downto 16 => '1') & in_signal;-- //Sign extend with 1 for negative numbers
        else
           
            out_signal <= (31 downto 16 => '0') & in_signal; -- //Sign extend with 0 for positive numbers
        end if;
    end process;
end Behavioral;

