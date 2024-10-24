-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/mem.vhd
-- Notes:
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-pull-request-33-from-conneroisu-component-nbit1scomplementor
-- </header>

-------------------------------------------------------------------------
-- author(s): Conner Ohnesorge & Levi Wenck
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains the VHDL code for a single-port RAM
-- with a single read/write address. The RAM is implemented as a 2-D
-- array of std_logic_vectors. The RAM is synchronous and is updated
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity Declaration of mem
entity mem is

    generic
        (
            DATA_WIDTH : natural := 32;
            ADDR_WIDTH : natural := 10
            );

    port
        (
            clk  : in  std_logic;
            addr : in  std_logic_vector((ADDR_WIDTH-1) downto 0);
            data : in  std_logic_vector((DATA_WIDTH-1) downto 0);
            we   : in  std_logic := '1';
            q    : out std_logic_vector((DATA_WIDTH -1) downto 0)
            );

end mem;

-- Architecture Declaration of mem
architecture rtl of mem is

    -- Build a 2-D array type for the RAM
    subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
    type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

    -- Declare the RAM signal and specify a default value.      Quartus Prime
    -- will load the provided memory initialization file (.mif).
    signal ram : memory_t;

begin

    process(clk)
    begin
        if(rising_edge(clk)) then
            if(we = '1') then
                ram(to_integer(unsigned(addr))) <= data;  -- Write to RAM
            end if;
        end if;
    end process;

    q <= ram(to_integer(unsigned(addr)));

end rtl;






