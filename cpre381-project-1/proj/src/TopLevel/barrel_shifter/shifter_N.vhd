-- <header>
-- Author(s): Conner Ohnesorge
-- Name: cpre381-project-1/proj/src/TopLevel/barrel_shifter/shifter_N.vhd
-- Notes:
--	Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>











-------------------------------------------------------------------------
-- Levi Wenck
-- Computer Engineering Undergrad
-- Iowa State University
-------------------------------------------------------------------------
-- shifter_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: barrel shifter that can do either left or right shifts
-- as well as an arithmetic shift (sign extending or right shifts)
-- 
--
--
-- NOTES:
-- 02/28/24 by LW:: Design created.
-- 03/23/24 by LW:: Added arithmetic shifting
-- 03/24/24 by CO:: Formatted, Aligned, and commented.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.MIPS_types.all;

entity shifter_N is                     --create inputs and output maps
    generic
        (N : integer := 32);
    port
        (
            i_A          : in  std_logic_vector(N - 1 downto 0);  --input data to be shifted
            i_shamt      : in  std_logic_vector(4 downto 0);  --enough to shift 32 bits to the right
            i_T          : in  std_logic;  -- shifting right or left (1 = right | 0 = left)
            i_Arithmetic : in  std_logic;  -- 1 = arithmetic shift, 0 = logical shift
            o_O          : out std_logic_vector(N - 1 downto 0)  -- new shifted output
            );
end shifter_N;

architecture structure of shifter_N is
    component mux2t1_N is
        generic
            (N : integer := 32);
        port
            (
                i_D0, i_D1 : in  std_logic_vector(N - 1 downto 0);  --inputs
                i_S        : in  std_logic;  --shift or not
                o_O        : out std_logic_vector(N - 1 downto 0)   --output
                );
    end component;

    signal s_mux0, s_mux1, s_mux2, s_mux3, s_mux_unflip                 : std_logic_vector(N - 1 downto 0);  --outputs of shamt muxes
    signal s_mux_0t, s_mux_1t, s_mux_2t, s_mux_3t, s_mux_4t, s_mux_flip : std_logic_vector(N - 1 downto 0);
    signal s_b                                                          : std_logic_vector (15 downto 0);

begin
    -- this a general guidleline where I break up the shifter into its layers
    ---------------------------------------------------------------------------
    -- Level FLIP: this level muxes between the original input and a reversed variant 
    ---------------------------------------------------------------------------

    mux_flip : mux2t1_N
        port map
        (
            i_D0 => i_A,                -- normal signal (sll)
            i_D1 => bit_reverse(i_A),   -- reverse signal (sra/srl)
            i_S  => i_T,                -- right or left shift
            o_O  => s_mux_flip          -- output
            );

    s_b <= (others => i_A(31) and i_T);  --copies the MSB of the input into a vector for the arithmetic shifts

    ---------------------------------------------------------------------------
    -- Level 0: levels 0-4 mux between the orignal signal and the logical or arithmetic shift
    ---------------------------------------------------------------------------
    mux0_t : mux2t1_N  -- this mux either lets the arithmetic or logical shift through
        port
        map(
            i_D0 => s_mux_flip(30 downto 0) & "0",  -- sl 1 (additional)
            i_D1 => s_mux_flip(30 downto 0) & s_b(0 downto 0),  -- sa 1 (additional)
            i_S  => i_Arithmetic,       -- logical or arithmetic shift
            o_O  => s_mux_0t            -- output
            );
    mux0_o : mux2t1_N
        port
        map(
            i_D0 => s_mux_flip,         --non shifted
            i_D1 => s_mux_0t,           --shifted value
            i_S  => i_shamt(0),         --shift or not
            o_O  => s_mux0              --output
            );

    ---------------------------------------------------------------------------
    -- Level 1: 
    ---------------------------------------------------------------------------
    mux1_t : mux2t1_N
        port
        map(
            i_D0 => s_mux0(29 downto 0) & "00",  -- sl 2 (additional, ie if the above also shifted this would be 1 + 2)
            i_D1 => s_mux0(29 downto 0) & s_b(1 downto 0),  -- sa 2 (additional)
            i_S  => i_Arithmetic,       -- logical or arithmetic shift
            o_O  => s_mux_1t            -- output
            );

    mux1_o : mux2t1_N
        port
        map(
            i_D0 => s_mux0,             --non shifted
            i_D1 => s_mux_1t,           --shifted value
            i_S  => i_shamt(1),         --shift or not
            o_O  => s_mux1              --output
            );
    ---------------------------------------------------------------------------
    -- Level 2: 
    ---------------------------------------------------------------------------
    mux2_t : mux2t1_N
        port
        map(
            i_D0 => s_mux1(27 downto 0) & "0000",  -- sl 4 (additional)
            i_D1 => s_mux1(27 downto 0) & s_b(3 downto 0),  --sa 4 (additional)
            i_S  => i_Arithmetic,       -- logical or arithmetic shift
            o_O  => s_mux_2t            -- output
            );
    mux2_o : mux2t1_N
        port
        map(
            i_D0 => s_mux1,             -- non shifted
            i_D1 => s_mux_2t,           -- shifted value
            i_S  => i_shamt(2),         -- shift or not
            o_O  => s_mux2              -- output
            );

    -----------------------------------------------------------------------------------
    -- Level 3: 
    -----------------------------------------------------------------------------------
    mux3_t : mux2t1_N
        port
        map(
            i_D0 => s_mux2(23 downto 0) & "00000000",  -- sl 8 (additional)
            i_D1 => s_mux2(23 downto 0) & s_b(7 downto 0),  -- sa 8 (additional)
            i_S  => i_Arithmetic,       -- logical or arithmetic shift
            o_O  => s_mux_3t            -- output
            );
    mux3_o : mux2t1_N
        port
        map(
            i_D0 => s_mux2,             -- non shifted
            i_D1 => s_mux_3t,           -- shifted value
            i_S  => i_shamt(3),         -- shift or not
            o_O  => s_mux3              -- output
            );

    -----------------------------------------------------------------------------------
    -- Level 4: 
    -----------------------------------------------------------------------------------
    mux4_t : mux2t1_N
        port
        map(
            i_D0 => s_mux3(15 downto 0) & "0000000000000000",  -- sl 16 (additional)
            i_D1 => s_mux3(15 downto 0) & s_b(15 downto 0),  -- sa 16 (additional)
            i_S  => i_Arithmetic,       -- logical or arithmetic shift
            o_O  => s_mux_4t            -- output
            );

    mux4_o : mux2t1_N
        port
        map(
            i_D0 => s_mux3,             -- non shifted
            i_D1 => s_mux_4t,           -- shifted value
            i_S  => i_shamt(4),         -- shift or not
            o_O  => s_mux_unflip        -- output
            );

    ---------------------------------------------------------------------------
    -- Level UNFLIP: this level muxes between unreversing or reversing output
    ---------------------------------------------------------------------------
    mux_unflip : mux2t1_N
        port
        map(
            i_D0 => s_mux_unflip,               -- normal signal (sll)
            i_D1 => bit_reverse(s_mux_unflip),  -- unflip signal (sra/srl)
            i_S  => i_T,                        -- right shift(0) or left(1)
            o_O  => o_O                         -- output/End of circuit
            );
end structure;
