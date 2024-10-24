-- <header>
-- Author(s): awfoss
-- Name: proj/test/tb_barrelShifter.vhd
-- Notes:
--      awfoss  <awfoss@co2050-01.ece.iastate.edu> move-test-to-test-folder
-- </header>

--Aidan Foss
library IEEE;
use IEEE.std_logic_1164.all;
entity tb_barrelShifter is
    generic (
        halfClk : time    := 50 ns;
        N       : integer := 32);
end tb_barrelShifter;
architecture behavior of tb_barrelShifter is
    constant ClkHelper : time := halfClk * 2;
    component barrelShifter is
        generic (N : integer := 32);
        port (
            i_data        : in  std_logic_vector(N - 1 downto 0);
            i_shamt       : in  std_logic_vector(4 downto 0);  --01001 would do shift 3 and shift 0, mux each bit to decide how much to shift
            i_leftOrRight : in  std_logic;  --0=right, 1=left
            i_shiftType   : in  std_logic;  --0 for logicical shift, 1 for arithmetic shift
            o_O           : out std_logic_vector(N - 1 downto 0)  --shifted output
            );
    end component;
    signal s_data, s_O                : std_logic_vector(N-1 downto 0);
    signal s_shamt                    : std_logic_vector(4 downto 0);
    signal s_leftOrRight, s_shiftType : std_logic;
    signal s_debug                    : std_logic_vector(N-1 downto 0);  --debug value is genius
begin
    shifter1 : barrelShifter
        port map(
            i_data        => s_data,
            i_shamt       => s_shamt,
            i_leftOrRight => s_leftOrRight,
            i_shiftType   => s_shiftType,
            o_O           => s_O);
    shiftTest : process
    begin
        s_shiftType   <= '0';           --logical shift tests firsts
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '0';           --sll
        s_data        <= x"70707070";
        s_debug       <= x"70707070";
        s_shamt       <= "00000";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '0';           --sll
        s_data        <= x"70707070";
        s_debug       <= x"E0E0E0E0";
        s_shamt       <= "00001";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '1';           --srl
        s_data        <= x"70707070";
        s_debug       <= x"1C1C1C1C";
        s_shamt       <= "00010";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '1';           --srl
        s_data        <= x"70707070";
        s_debug       <= x"0E0E0E0E";
        s_shamt       <= "00011";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '1';           --srl
        s_data        <= x"70707070";  -- shift by 4 should mean it becomes 07070707
        s_debug       <= x"07070707";
        s_shamt       <= "00100";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '0';           --sll
        s_data        <= x"70707070";  -- shift by 4 should mean it becomes 07070700
        s_debug       <= x"07070700";
        s_shamt       <= "00100";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '1';           --srl
        s_data        <= x"70707070";  -- shift by 8 should mean it becomes 00707070
        s_debug       <= x"00707070";
        s_shamt       <= "01000";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '0';           --sll
        s_data        <= x"70707070";  -- shift by 8 should mean it becomes 70707000
        s_debug       <= x"70707000";
        s_shamt       <= "01000";
        ---------------------------
        s_shiftType   <= '1';  --arithmetic shift tests second (should start seeing sign extension)
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '0';           --sll
        s_data        <= x"E0E0E0E0";
        s_debug       <= x"E0E0E0E0";
        s_shamt       <= "00000";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '0';           --sll
        s_data        <= x"E0E0E0E0";
        s_debug       <= x"C1C1C1C0";
        s_shamt       <= "00001";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '1';           --srl
        s_data        <= x"E0E0E0E0";
        s_debug       <= x"F8383838";
        s_shamt       <= "00010";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '1';           --srl
        s_data        <= x"E0E0E0E0";
        s_debug       <= x"FC1C1C1C";
        s_shamt       <= "00011";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '1';           --srl
        s_data        <= x"E0E0E0E0";  -- shift by 4 should mean it becomes F7070707
        s_debug       <= x"FE0E0E0E";
        s_shamt       <= "00100";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '0';           --sll
        s_data        <= x"70707070";  -- shift by 4 should mean it becomes 07070700
        s_debug       <= x"07070700";
        s_shamt       <= "00100";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '1';           --srl
        s_data        <= x"70707070";  -- shift by 8 should mean it becomes 00707070
        s_debug       <= x"00707070";
        s_shamt       <= "01000";
        ---------------------------
        wait for ClkHelper;
        s_leftOrRight <= '0';           --sll
        s_data        <= x"70707070";  -- shift by 8 should mean it becomes 70707000
        s_debug       <= x"70707000";
        s_shamt       <= "01000";
    ---------------------------
    end process;
end behavior;

