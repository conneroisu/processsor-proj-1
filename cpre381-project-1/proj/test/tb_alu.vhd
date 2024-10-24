-- <header>
-- Author(s): github-actions[bot]
-- Name: cpre381-project-1/proj/test/tb_alu.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	Conner Ohnesorge  <connero@iastate.edu> latest
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
entity tb_alu is
    generic (gCLK_HPER : time := 10 ns);  -- Generic for half of the clock cycle period
end tb_alu;
-- The architecture for the ALU test bench
architecture arch of tb_alu is
    --define the total clock period time
    constant cCLK_PER : time := gCLK_HPER * 2;
    component alu is
        port (
            CLK     : in  std_logic;
            i_Data1 : in  std_logic_vector(31 downto 0);
            i_Data2 : in  std_logic_vector(31 downto 0);
            i_shamt : in  std_logic_vector(4 downto 0);
            i_aluOp : in  std_logic_vector(3 downto 0);
            o_Zero  : out std_logic;
            o_F     : out std_logic_vector(31 downto 0));
    end component;
    -- Create signals for all of the inputs and outputs of the file that you are testing
    signal iCLK, reset : std_logic := '0';
    signal s_Data1     : std_logic_vector(31 downto 0);
    signal s_Data2     : std_logic_vector(31 downto 0);
    signal s_shamt     : std_logic_vector(4 downto 0);
    signal s_ALUOp     : std_logic_vector(3 downto 0);
    signal s_Zero      : std_logic;
    signal s_ALURslt   : std_logic_vector(31 downto 0);
    signal s_Expected  : std_logic_vector(31 downto 0);
begin
    DUT0 : alu
        port map(
            CLK     => iCLK,
            i_Data1 => s_Data1,
            i_Data2 => s_Data2,
            i_shamt => s_shamt,
            i_aluOp => s_ALUOp,
            o_Zero  => s_Zero,
            o_F     => s_ALURslt);
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
--add, addi, addiu, addu, and, andi, lui, lw, nor, xor, xori, or,
--ori, slt, slti, sll, srl, sra, sw, sub, subu, beq, bne, j, jal,
--jr, lb, lh, lbu, lhu, sllv, srlv, srav
-- add, sub, and, or, nor, xor, slt, 
        --Test case 1: or operation
        s_Data1    <= x"0000a000";
        s_Data2    <= x"000000a0";
        s_Expected <= x"0000a0a0";
        s_shamt    <= "00000";  --should be able to make this anything I want during non shift operations
        s_ALUOp    <= "1001";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 2: nor operation
        s_Data1    <= x"0000F00F";
        s_Data2    <= x"000000FF";
        s_Expected <= x"FFFF0F00";
        s_shamt    <= "11111";
        s_ALUOp    <= "1000";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 3: and operation
        s_Data1    <= x"0000a00F";
        s_Data2    <= x"000000aF";
        s_Expected <= x"0000000F";
        s_shamt    <= "11111";
        s_ALUOp    <= "0101";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 4: xor operation
        s_Data1    <= x"0000a00F";
        s_Data2    <= x"000000aF";
        s_Expected <= x"0000a0a0";
        s_shamt    <= "01111";
        s_ALUOp    <= "1010";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        -- Test case 4.1: xor operation of two negative numbers
        s_Data1    <= x"FFFFFFFF";
        s_Data2    <= x"FFFFFFFF";
        s_Expected <= x"00000000";
        s_shamt    <= "01111";
        s_ALUOp    <= "1010";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        -- Test case 4.2: xor operation of two zero numbers
        s_Data1    <= x"00000000";
        s_Data2    <= x"00000000";
        s_Expected <= x"00000000";
        s_shamt    <= "01111";
        s_ALUOp    <= "1010";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 5 :shift left logical (sll) of data2 by 5
        s_Data1    <= x"0000a000";
        s_Data2    <= x"000000a0";
        s_Expected <= x"FFFFFFFF";
        s_shamt    <= "00101";
        s_ALUOp    <= "0110";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 5.1 :shift left logical (sll) of data2 by 0
        s_Data1    <= x"0000a000";
        s_Data2    <= x"000000a0";
        s_Expected <= x"FFFFFFFF";
        s_shamt    <= "00000";
        s_ALUOp    <= "0110";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 5.2 :shift left logical (sll) of data2 by 1
        s_Data1    <= x"0000a000";
        s_Data2    <= x"000000a0";
        s_Expected <= x"FFFFFFFF";
        s_shamt    <= "00001";
        s_ALUOp    <= "0110";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 6 :shift right logical (srl) of data2 by 1
        s_Data1    <= x"0000a000";
        s_Data2    <= x"000000a0";
        s_Expected <= x"00000050";
        s_shamt    <= "00001";
        s_ALUOp    <= "1110";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 6.1 :shift right arithmetic (srl) of data2 by 1
        s_Data1    <= x"0000a000";
        s_Data2    <= x"FFFFFFFF";
        s_Expected <= x"FFFFFFFF";
        s_shamt    <= "00001";
        s_ALUOp    <= "1110";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 6.5 :shift right arithmetic (sra) of data2 by 1 (negative)
        s_Data1    <= x"0000a000";
        s_Data2    <= x"FFFFFFFF";
        s_Expected <= x"00000000";
        s_shamt    <= "00001";
        s_ALUOp    <= "1111";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 6.5 :shift right arithmetic (sra) of data2 by 2 (positive)
        s_Data1    <= x"0000a000";
        s_Data2    <= x"0000000F";
        s_Expected <= x"00000000";
        s_shamt    <= "00010";
        s_ALUOp    <= "1111";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 7: lw operation (either unsigned add or sll by 0)
        s_Data1    <= x"0000a000";
        s_Data2    <= x"000000a0";
        s_Expected <= x"0000a0a0";
        s_shamt    <= "00000";
        s_ALUOp    <= "0000";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 14: slt operation (if 1 is less than 2)
        s_Data1    <= x"00000000";
        s_Data2    <= x"80000000";
        s_Expected <= x"00000001";      -- will not be set because 1 is larger
        s_shamt    <= "00000";
        s_ALUOp    <= "0111";  --alu will do subtraction (LSB) and then choose the SLT status output
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 14: slt operation (if 1 is less than 2)
        s_Data1    <= x"000000a0";
        s_Data2    <= x"0000a000";
        s_Expected <= x"00000001";      -- will be set because 1 is smaller
        s_shamt    <= "00000";
        s_ALUOp    <= "0111";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 14: sltu operation (if 1 is less than 2)
        s_Data1    <= x"0000a000";
        s_Data2    <= x"000000a0";
        s_Expected <= x"00000000";      -- will not be set because 1 is larger
        s_shamt    <= "00000";
        s_ALUOp    <= "1101";  --alu will do subtraction (LSB) and then choose the SLT status output
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 14: sltu operation (if 1 is less than 2)
        s_Data1    <= x"000000a0";
        s_Data2    <= x"FFFFFFFF";
        s_Expected <= x"00000001";      -- will be set because 2 is larger
        s_shamt    <= "00000";
        s_ALUOp    <= "1101";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 8: lui instruction (takes the data2 and puts it into the upper 16 bits)
        s_Data1    <= x"12345678";
        s_Data2    <= x"00069420";
        s_Expected <= x"94200000";
        s_shamt    <= "10000";
        s_ALUOp    <= "0110";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 8: add the two values from data1 and data2 (add)
        s_Data1    <= x"0000a000";
        s_Data2    <= x"000000a0";
        s_Expected <= x"0000a0a0";
        s_shamt    <= "00000";
        s_ALUOp    <= "0010";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 9: add the two values from data1 and data2 (add) (negative number)
        s_Data1    <= x"00000002";
        s_Data2    <= x"FFFFFFFF";
        s_Expected <= x"00000001";
        s_shamt    <= "00000";
        s_ALUOp    <= "0010";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 9: add the two values from data1 and data2 (add) (2 negative numbers)
        s_Data1    <= x"FFFFFFFF";
        s_Data2    <= x"FFFFFFFF";
        s_Expected <= x"FFFFFFFE";
        s_shamt    <= "00000";
        s_ALUOp    <= "0010";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 10: add the two values from data1 and data2 (addu)
        s_Data1    <= x"FFFFFFFF";
        s_Data2    <= x"80000000";
        s_Expected <= x"7FFFFFFF";
        s_shamt    <= "00000";
        s_ALUOp    <= "0000";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 11: add the two values from data1 and data2 (addu) ("negative" number)
        s_Data1    <= x"00000008";
        s_Data2    <= x"80000000";
        s_Expected <= x"80000008";
        s_shamt    <= "00000";
        s_ALUOp    <= "0000";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 11.5: add the two values from data1 and data2 (addu) ("negative" number)
        s_Data1    <= x"00000006";
        s_Data2    <= x"90000000";
        s_Expected <= x"90000006";
        s_shamt    <= "00000";
        s_ALUOp    <= "0000";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 12: subtract value 2 from value 1 (sub)
        s_Data1    <= x"0000a000";
        s_Data2    <= x"000000a0";
        s_Expected <= x"00009F60";
        s_shamt    <= "00000";
        s_ALUOp    <= "0011";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 13: subtract value 2 from value 1 (sub) (negative result)
        s_Data1    <= x"000000a0";
        s_Data2    <= x"0000a000";
        s_Expected <= x"FFFF60A0";
        s_shamt    <= "00000";
        s_ALUOp    <= "0001";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 14: subtract value 2 from value 1 (sub) (negative number)
        s_Data1    <= x"0000a000";
        s_Data2    <= x"FFFFFFFF";
        s_Expected <= x"0000a001";
        s_shamt    <= "00000";
        s_ALUOp    <= "0001";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 12: subtract value 2 from value 1 (subu)
        s_Data1    <= x"00000000";
        s_Data2    <= x"00000002";
        s_Expected <= x"FFFFFFFE";
        s_shamt    <= "00000";
        s_ALUOp    <= "0001";           -- binary subtraction is not a thing
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 14: subtract value 2 from value 1 (subu) (negative number)
        s_Data1    <= x"FFFFFFFF";
        s_Data2    <= x"FFFFFFF0";
        s_Expected <= x"0000000F";
        s_shamt    <= "00000";
        s_ALUOp    <= "0001";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 14: subtract value 2 from value 1 (subu) (negative number)
        s_Data1    <= x"000000a0";
        s_Data2    <= x"FFFFFFFF";
        s_Expected <= x"000000a1";
        s_shamt    <= "00000";
        s_ALUOp    <= "0001";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 14: subtract value 2 from value 1 (subu) (negative number)
        s_Data1    <= x"0000a000";
        s_Data2    <= x"000000a0";
        s_Expected <= x"00009F60";
        s_shamt    <= "00000";
        s_ALUOp    <= "0001";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 14: subtract value 2 from value 1 (subu) (negative number)
        s_Data1    <= x"00000000";
        s_Data2    <= x"00000000";
        s_Expected <= x"00000000";
        s_shamt    <= "00000";
        s_ALUOp    <= "1101";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 18: add value 2 from to 1 (addi) (negative number)
        s_Data1    <= x"00000000";
        s_Data2    <= x"FFFFFFF6";
        s_Expected <= x"00000000";
        s_shamt    <= "00000";
        s_ALUOp    <= "0010";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
        --Test case 18.1: add value 2 from to 1 (addi) (negative number)
        s_Data1    <= x"FFFFFFFF";
        s_Data2    <= x"00000006";
        s_Expected <= x"FFFFFFF5";
        s_shamt    <= "00000";
        s_ALUOp    <= "0010";
        wait for gCLK_HPER * 2;
        wait for gCLK_HPER * 2;
    end process;
end arch;
