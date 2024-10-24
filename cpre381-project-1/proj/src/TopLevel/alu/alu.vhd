-- <header>
-- Author(s): conneroisu
-- Name: cpre381-project-1/proj/src/TopLevel/alu/alu.vhd
-- Notes:
--	conneroisu  <88785126+conneroisu@users.noreply.github.com> Format-and-Header
--	conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--	conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	Conner Ohnesorge  <connero@iastate.edu> latest
-- </header>

-------------------------------------------------------------------------
-- author(s): Conner Ohnesorge & Levi Wenck
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- name: alu.vhd
-------------------------------------------------------------------------
-- Description:
-- This file contains the VHDL code for the ALU. The ALU is a 32-bit
-- Arithmetic Logic Unit that can perform addition, subtraction, and
-- shifting operations. The ALU has 3 inputs: i_Data1, i_Data2, and
-- i_ALU_CTRL. The i_Data1 and i_Data2 inputs are the two 32-bit
-- operands that the ALU will perform the operation on. The i_ALU_CTRL
-- input is a 9-bit control signal that determines the operation that
-- the ALU will perform. The ALU has 3 outputs: o_Zero, o_ALURslt, and
-- NOTES:
-- 3/20/24 by CO:: Design created.
-- 3/25/24 by LW:: Added logical and slt instructions.
-- 3/27/24 by LW:: Implemented sltu & changed mux to 16t1
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_Types.all;
-- Entity declaration of the ALU
entity alu is
    port
        (
            CLK        : in  std_logic;  -- Clock signal
            i_Data1    : in  std_logic_vector(31 downto 0);  -- 32-bit input data 1
            i_Data2    : in  std_logic_vector(31 downto 0);  -- 32-bit input data 2
            i_shamt    : in  std_logic_vector(4 downto 0);  -- 5-bit shift amount
            i_aluOp    : in  std_logic_vector(3 downto 0);  -- 4-bit ALU operation code
            o_F        : out std_logic_vector(31 downto 0);  -- 32-bit ALU result
            o_Overflow : out std_logic;  -- Overflow flag
            o_Zero     : out std_logic  -- Zero flag
            );
end alu;
architecture structural of alu is
    component adder_subtractor is
        generic
            (N : integer := 32);
        port
            (
                i_a        : in  std_logic_vector(N - 1 downto 0);
                i_b        : in  std_logic_vector(N - 1 downto 0);
                i_s        : in  std_logic;    -- signed or unsigned operations
                nadd_sub   : in  std_logic;
                o_y        : out std_logic_vector(N - 1 downto 0);
                o_cout     : out std_logic;
                o_overflow : out std_logic
                );
    end component;
    component shifter_N is
        port
            (
                i_A          : in  std_logic_vector(31 downto 0);  -- data to be shifted
                i_shamt      : in  std_logic_vector (4 downto 0);  --shift amount
                i_Arithmetic : in  std_logic;  -- selects type of shift (1 = arithmetic, 0 = logical)
                i_T          : in  std_logic;  -- 0 == left shift and 1 == right shift
                o_O          : out std_logic_vector(31 downto 0));  -- output of the shifter
    end component;
    component mux2t1_N is
        generic
            (N : integer := 16);
        port
            (
                i_S  : in  std_logic;
                i_D0 : in  std_logic_vector(31 downto 0);
                i_D1 : in  std_logic_vector(31 downto 0);
                o_O  : out std_logic_vector(31 downto 0)
                );
    end component;
    component xorg2 is
        port
            (
                i_a : in  std_logic;
                i_b : in  std_logic;
                o_f : out std_logic
                );
    end component;
    component andg32 is
        port
            (
                i_A : in  std_logic_vector(31 downto 0);
                i_B : in  std_logic_vector(31 downto 0);
                o_F : out std_logic_vector(31 downto 0)
                );
    end component;
    component org32 is
        port
            (
                i_A : in  std_logic_vector(31 downto 0);
                i_B : in  std_logic_vector(31 downto 0);
                o_F : out std_logic_vector(31 downto 0)
                );
    end component;
    component xorg32 is
        port
            (
                i_A : in  std_logic_vector(31 downto 0);
                i_B : in  std_logic_vector(31 downto 0);
                o_F : out std_logic_vector(31 downto 0)
                );
    end component;
    component nandg32 is
        port
            (
                i_A : in  std_logic_vector(31 downto 0);
                i_B : in  std_logic_vector(31 downto 0);
                o_F : out std_logic_vector(31 downto 0)
                );
    end component;
    component norg32 is
        port
            (
                i_A : in  std_logic_vector(31 downto 0);
                i_B : in  std_logic_vector(31 downto 0);
                o_F : out std_logic_vector(31 downto 0)
                );
    end component;
    -- TODO (project part 2) ADD NXORG32
    component mux16t1 is
        port
            (
                i_I : in  array_16x32;
                i_S : in  std_logic_vector(3 downto 0);
                o_O : out std_logic_vector(31 downto 0)
                );
    end component;
    signal s_AddSub_res                                                                  : std_logic_vector(31 downto 0);
    signal s_overflow, s_alu_cout                                                        : std_logic;
    signal s_shift_res                                                                   : std_logic_vector(31 downto 0);
    signal s_Mux_res                                                                     : std_logic_vector(31 downto 0);
    signal s_o_andg32, s_o_org32, s_o_xorg32, s_o_nandg32, s_o_norg32, s_o_slt, s_o_sltu : std_logic_vector(31 downto 0);
    signal s_mux_input                                                                   : array_16x32;
begin
    -- ARITHMETIC UNIT, used for arithmetic instructions(adding and subtracting)
    --Instantiante add_Sub unit
    G_ADD_SUB : adder_subtractor
        port map
        (
            i_a        => i_Data1,
            i_b        => i_Data2,
            i_s        => i_aluOp(1),  -- selects between signed/unsigned arithmetic (doubles as selector for shift operations)
            nadd_sub   => i_aluOp(0),   -- selects add or sub
            o_y        => s_AddSub_res,
            o_cout     => s_alu_cout,
            o_overflow => s_overflow);
    o_Overflow <= s_overflow;           --assign overflow for output
    -- loop through the output of the mux and check if all bits are 0
    o_Zero     <= '1' when s_AddSub_res = x"00000000" else
              '0';
    -- END OF ARITHMETIC UNIT (adding and subtracting)
    -- BARREL SHIFTING UNIT (does sll and srl and sra instructions)
    --Instantiate barrel shifter
    G_SHIFTER : shifter_N               -- does shifting and lui
        port
        map(
            i_A          => i_Data2,
            i_shamt      => i_shamt,
            i_Arithmetic => i_aluOp(1),  -- selects type of shift (1 = arithmetic, 0 = logical)
            i_T          => i_aluOp(3),  -- 0 == left shift and 1 == right shift (this bit also dictates signed/unsigned arithmetic)
            o_O          => s_shift_res
            );
    -- END OF BARREL SHIFTING UNIT
    -- LOGIC UNIT, used for logic instructions (basic 32bit OR, AND, XOR, NOR, NAND, and NXOR operations)
    G_AND32 : andg32
        port
        map(
            i_A => i_Data1,
            i_B => i_Data2,
            o_F => s_o_andg32
            );
    G_OR32 : org32
        port
        map(
            i_A => i_Data1,
            i_B => i_Data2,
            o_F => s_o_org32
            );
    G_XOR32 : xorg32
        port
        map(
            i_A => i_Data1,
            i_B => i_Data2,
            o_F => s_o_xorg32
            );
    -- SLT signal generation    
    s_o_slt(0) <= s_AddSub_res(31);
    G2 : for i in 1 to 31 generate  --generate rest of output bits of s_o_slt result
        s_o_slt(i) <= '0';
    end generate;
    -- SLTU signal generation (this might just be the same as above)
    s_o_sltu(0) <= (not s_alu_cout);    --used for sltu
    G3 : for i in 1 to 31 generate  --generate rest of output bits of s_o_sltu result
        s_o_sltu(i) <= '0';
    end generate;
    G_NAND32 : nandg32
        port
        map(
            i_A => i_Data1,
            i_B => i_Data2,
            o_F => s_o_nandg32
            );
    G_NOR32 : norg32
        port
        map(
            i_A => i_Data1,
            i_B => i_Data2,
            o_F => s_o_norg32
            );
    -- END OF LOGIC UNIT
    -- SELECT OUTPUT (what instruction was done)
    G_MUX_RES : mux16t1
        port
        map(
            i_I(0)  => s_AddSub_res,    -- adding (unsigned)
            i_I(1)  => s_AddSub_res,    -- subtraction (unsigned)
            i_I(2)  => s_AddSub_res,    -- adding (signed)
            i_I(3)  => s_AddSub_res,    -- subtraction (signed)
            i_I(4)  => s_shift_res,     -- sll 0(left) 1 0(logical) 0
            i_I(5)  => s_o_andg32,
            i_I(6)  => s_o_nandg32,
            i_I(7)  => s_o_slt,         -- slt signed
            i_I(8)  => s_o_norg32,
            i_I(9)  => s_o_org32,
            i_I(10) => s_o_xorg32,
            i_I(11) => x"00000000",
            i_I(12) => s_shift_res,  -- srl (right logical) 1(right) 1 0(logical) 0
            i_I(13) => s_o_sltu,        -- unsigned slt
            i_I(14) => s_shift_res,  -- sra (right arithmetic) 1(right) 1 1(arithmetic) 0
            i_I(15) => x"00000000",
            i_S     => i_aluOp(3 downto 0),
            o_O     => o_F              -- FINAL OUTPUT OF ALU
            );
-- END OF SELECTING OUTPUT
end structural;
