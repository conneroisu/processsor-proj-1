-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/low_level/mux2t1_N.vhd
-- Notes:
--	connero 88785126+conneroisu@users.noreply.github.com Merge pull request #25 from conneroisu/sign-extend
-- </header>


-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- mux2t1_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity mux2t1_n is
    generic (
        n : integer := 32  -- Generic of type integer for input/output data width. Default value is 32.
        );
    port (
        i_s  : in  std_logic;           -- Select input.
        i_d0 : in  std_logic_vector(n - 1 downto 0);  -- Input data width is N.
        i_d1 : in  std_logic_vector(n - 1 downto 0);  -- Input data width is N.
        o_o  : out std_logic_vector(n - 1 downto 0)  -- Output data width is N.
        );
end entity mux2t1_n;

architecture structural of mux2t1_n is

    component mux2t1 is
        port (
            i_s  : in  std_logic;
            i_d0 : in  std_logic;
            i_d1 : in  std_logic;
            o_o  : out std_logic
            );
    end component;

begin
    -- Instantiate N mux instances.
    g_nbit_mux : for i in 0 to n - 1 generate

        muxi : component mux2t1
            port map (
                i_s  => i_s,            -- Select input.
                i_d0 => i_d0(i),        -- Select bit i from input data.
                i_d1 => i_d1(i),        -- Select bit i from input data.
                o_o  => o_o(i)          -- Output bit i.
                );

    end generate g_nbit_mux;
end architecture structural;
