-- <header>
-- Author(s): github-actions[bot]
-- Name: cpre381-project-1/proj/test/tb_shifter_N.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

-------------------------------------------------------------------------
-- Levi Wenck
-- Computer Engineering Undergrad
-- Iowa State University
-------------------------------------------------------------------------
-- shifter_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: testbench for barrel shifter
-- 
--
--
-- NOTES:
-- 02/29/24 by LW::Design created.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
entity tb_shifter_N is
    generic (
        gCLK_HPER : time    := 50 ns;
        N         : integer := 32);
end tb_shifter_N;
architecture behavior of tb_shifter_N is
    -- Calculate the clock period as twice the half-period
    constant cCLK_HPER : time := gCLK_HPER * 2;
    component shifter_N is
        generic (N : integer := 32);
        port (
            i_A          : in  std_logic_vector(N - 1 downto 0);  --input data to be shifted
            i_shamt      : in  std_logic_vector(4 downto 0);  --enough to shift 32 bits to the right
            i_T          : in  std_logic;  --shifting right or left (0 = right | 1 = left)
            i_Arithmetic : in  std_logic;  --logical or arithmetic shift
            o_O          : out std_logic_vector(N - 1 downto 0));  --new shifted output
    end component;
    signal s_A, s_O          : std_logic_vector(N - 1 downto 0);
    signal s_shamt           : std_logic_vector(4 downto 0);
    signal s_T, s_Arithmetic : std_logic;  -- shift type (left or right) & shift lpgical
    signal s_Expected        : std_logic_vector(N-1 downto 0);
begin
    shifter_1 : shifter_N
        port map(
            i_A          => s_A,
            i_shamt      => s_shamt,
            i_T          => s_T,
            i_Arithmetic => s_Arithmetic,
            o_O          => s_O);
    P_test : process
    begin
        s_Arithmetic <= '0';            --logical shift tests firsts
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '0';            --sll
        s_A          <= x"70707070";
        s_Expected   <= x"70707070";
        s_shamt      <= "00000";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '0';            --sll
        s_A          <= x"70707070";
        s_Expected   <= x"E0E0E0E0";
        s_shamt      <= "00001";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '1';            --srl
        s_A          <= x"70707070";
        s_Expected   <= x"1C1C1C1C";
        s_shamt      <= "00010";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '1';            --srl
        s_A          <= x"70707070";
        s_Expected   <= x"0E0E0E0E";
        s_shamt      <= "00011";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '1';            --srl
        s_A          <= x"70707070";  -- shift by 4 should mean it becomes 07070707
        s_Expected   <= x"07070707";
        s_shamt      <= "00100";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '0';            --sll
        s_A          <= x"70707070";  -- shift by 4 should mean it becomes 07070700
        s_Expected   <= x"07070700";
        s_shamt      <= "00100";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '1';            --srl
        s_A          <= x"70707070";  -- shift by 8 should mean it becomes 00707070
        s_Expected   <= x"00707070";
        s_shamt      <= "01000";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '0';            --sll
        s_A          <= x"70707070";  -- shift by 8 should mean it becomes 70707000
        s_Expected   <= x"70707000";
        s_shamt      <= "01000";
        ---------------------------
        s_Arithmetic <= '1';  --arithmetic shift tests second (should start seeing sign extension)
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '0';            --sll
        s_A          <= x"E0E0E0E0";
        s_Expected   <= x"E0E0E0E0";
        s_shamt      <= "00000";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '0';            --sll
        s_A          <= x"E0E0E0E0";
        s_Expected   <= x"C1C1C1C0";
        s_shamt      <= "00001";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '1';            --srl
        s_A          <= x"E0E0E0E0";
        s_Expected   <= x"F8383838";
        s_shamt      <= "00010";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '1';            --srl
        s_A          <= x"E0E0E0E0";
        s_Expected   <= x"FC1C1C1C";
        s_shamt      <= "00011";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '1';            --srl
        s_A          <= x"E0E0E0E0";  -- shift by 4 should mean it becomes F7070707
        s_Expected   <= x"FE0E0E0E";
        s_shamt      <= "00100";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '0';            --sll
        s_A          <= x"70707070";  -- shift by 4 should mean it becomes 07070700
        s_Expected   <= x"07070700";
        s_shamt      <= "00100";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '1';            --srl
        s_A          <= x"70707070";  -- shift by 8 should mean it becomes 00707070
        s_Expected   <= x"00707070";
        s_shamt      <= "01000";
        ---------------------------
        wait for cCLK_HPER;
        s_T          <= '0';            --sll
        s_A          <= x"70707070";  -- shift by 8 should mean it becomes 70707000
        s_Expected   <= x"70707000";
        s_shamt      <= "01000";
    ---------------------------
    end process;
end behavior;
