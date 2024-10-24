-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/test/tb_adder_subtractor.vhd
-- Notes:
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-pull-request-33-from-conneroisu-component-nbit1scomplementor
-- </header>

-------------------------------------------------------------------------
-- author(s): Conner Ohnesorge & Levi Wenck
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- name: tb_alu.vhd
-------------------------------------------------------------------------
-- Description: This file is the test bench for the ALU. It tests the
-- ALU with different test cases. 
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;          -- For logic types I/O
library std;
use std.env.all;                        -- For hierarchical/external signals
use std.textio.all;                     -- For basic I/O
-- The entity for the ALU test bench
entity tb_adder_subtractor is
    generic (gCLK_HPER : time := 10 ns);  -- Generic for half of the clock cycle period
end tb_adder_subtractor;
-- The architecture for the ALU test bench
architecture arch of tb_adder_subtractor is
    --define the total clock period time
    constant cCLK_PER : time := gCLK_HPER * 2;
    component adder_subtractor is
        port (
            nadd_sub   : in  std_logic;
            i_a        : in  std_logic_vector(31 downto 0);  -- Input A
            i_b        : in  std_logic_vector(31 downto 0);  -- Input B
            i_s        : in  std_logic;  -- selects between signed or unsigned operations (signed = 1)
            o_y        : out std_logic_vector(31 downto 0);  -- Output Y
            o_cout     : out std_logic;  -- Carry out
            o_overflow : out std_logic  -- Overflow Indicator
            );
    end component;
    -- Create signals for all of the inputs and outputs of the file that you are testing
    signal iCLK, reset, carry, s_S, s_addsub, overflow : std_logic := '0';
    signal s_Data1, s_Data2                            : std_logic_vector(31 downto 0);
    signal s_ADDSUBRslt                                : std_logic_vector(31 downto 0);
    signal s_Expected                                  : std_logic_vector(31 downto 0);
begin
    DUT0 : adder_subtractor
        port map(
            nadd_sub   => s_addsub,
            i_a        => s_Data1,
            i_b        => s_Data2,
            i_s        => s_S,
            o_y        => s_ADDSUBRslt,
            o_cout     => carry,
            o_overflow => overflow
            );
    --This first process is to setup the clock for the test bench
    P_CLK : process
    begin
        iCLK <= '1';                    -- clock starts at 1
        wait for gCLK_HPER;             -- after half a cycle
        iCLK <= '0';                    -- clock becomes a 0 (negative edge)
        wait for gCLK_HPER;  -- after half a cycle, process begins evaluation again
    end process;
    P_RST : process
    begin
        reset <= '0';
        wait for gCLK_HPER/2;
        reset <= '1';
        wait for gCLK_HPER * 2;
        reset <= '0';
        wait;
    end process;
    -- Assign inputs for each test case.
    P_TEST_CASES : process
    begin
        wait for gCLK_HPER/2;
        --Test case 1: subtraction (theoretical outcome?)
        s_Data1    <= x"00000000";
        s_Data2    <= x"80000000";
        s_Expected <= x"7FFFFFFF";
        s_S        <= '1';
        s_addsub   <= '1';
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
    end process;
end arch;
