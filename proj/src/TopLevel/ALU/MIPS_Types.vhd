library IEEE;
use IEEE.std_logic_1164.all;

package MIPS_Types is
    subtype word is std_logic_vector(31 downto 0);
    type array_16x32 is array(0 to 15) of word;
end package MIPS_Types;
