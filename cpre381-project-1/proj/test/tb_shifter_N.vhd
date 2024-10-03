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
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY tb_shifter_N IS
        GENERIC (
                gCLK_HPER : TIME := 50 ns;
                N : INTEGER := 32);
END tb_shifter_N;
ARCHITECTURE behavior OF tb_shifter_N IS
        -- Calculate the clock period as twice the half-period
        CONSTANT cCLK_HPER : TIME := gCLK_HPER * 2;
        COMPONENT shifter_N IS
                GENERIC (N : INTEGER := 32);
                PORT (
                        i_A : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0); --input data to be shifted
                        i_shamt : IN STD_LOGIC_VECTOR(4 DOWNTO 0); --enough to shift 32 bits to the right
                        i_T : IN STD_LOGIC; --shifting right or left (0 = right | 1 = left)
			i_Arithmetic : IN STD_LOGIC; --logical or arithmetic shift
                        o_O : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)); --new shifted output
        END COMPONENT;
        SIGNAL s_A, s_O : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        SIGNAL s_shamt : STD_LOGIC_VECTOR(4 DOWNTO 0);
        SIGNAL s_T, s_Arithmetic : STD_LOGIC; -- shift type (left or right) & shift lpgical
	SIGNAL s_Expected : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
BEGIN
        shifter_1 : shifter_N
        PORT MAP(
                i_A => s_A,
                i_shamt => s_shamt,
                i_T => s_T,
                i_Arithmetic => s_Arithmetic,
                o_O => s_O);
        P_test : PROCESS
        BEGIN
                s_Arithmetic <= '0'; --logical shift tests firsts
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '0'; --sll
                s_A <= x"70707070";
                s_Expected <= x"70707070";
                s_shamt <= "00000";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '0'; --sll
                s_A <= x"70707070";
		s_Expected <= x"E0E0E0E0";
                s_shamt <= "00001";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '1'; --srl
                s_A <= x"70707070";
		s_Expected <= x"1C1C1C1C";
                s_shamt <= "00010";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '1'; --srl
                s_A <= x"70707070";
		s_Expected <= x"0E0E0E0E";
                s_shamt <= "00011";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '1'; --srl
                s_A <= x"70707070"; -- shift by 4 should mean it becomes 07070707
		s_Expected <= x"07070707";
                s_shamt <= "00100";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '0'; --sll
                s_A <= x"70707070"; -- shift by 4 should mean it becomes 07070700
		s_Expected <= x"07070700";
                s_shamt <= "00100";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '1'; --srl
                s_A <= x"70707070"; -- shift by 8 should mean it becomes 00707070
		s_Expected <= x"00707070";
                s_shamt <= "01000";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '0'; --sll
                s_A <= x"70707070"; -- shift by 8 should mean it becomes 70707000
		s_Expected <= x"70707000";
                s_shamt <= "01000";
                ---------------------------
                s_Arithmetic <= '1'; --arithmetic shift tests second (should start seeing sign extension)
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '0'; --sll
                s_A <= x"E0E0E0E0";
		s_Expected <= x"E0E0E0E0";
                s_shamt <= "00000";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '0'; --sll
                s_A <= x"E0E0E0E0";
		s_Expected <= x"C1C1C1C0";
                s_shamt <= "00001";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '1'; --srl
                s_A <= x"E0E0E0E0";
		s_Expected <= x"F8383838";
                s_shamt <= "00010";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '1'; --srl
                s_A <= x"E0E0E0E0";
		s_Expected <= x"FC1C1C1C";
                s_shamt <= "00011";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '1'; --srl
                s_A <= x"E0E0E0E0"; -- shift by 4 should mean it becomes F7070707
		s_Expected <= x"FE0E0E0E";
                s_shamt <= "00100";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '0'; --sll
                s_A <= x"70707070"; -- shift by 4 should mean it becomes 07070700
		s_Expected <= x"07070700";
                s_shamt <= "00100";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '1'; --srl
                s_A <= x"70707070"; -- shift by 8 should mean it becomes 00707070
		s_Expected <= x"00707070";
                s_shamt <= "01000";
                ---------------------------
                WAIT FOR cCLK_HPER;
                s_T <= '0'; --sll
                s_A <= x"70707070"; -- shift by 8 should mean it becomes 70707000
		s_Expected <= x"70707000";
                s_shamt <= "01000";
                ---------------------------
        END PROCESS;
END behavior;
