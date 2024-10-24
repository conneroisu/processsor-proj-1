-- <header>
-- Author(s): Daniel Vergara & Aidan Foss & Conner Ohnesorge
-- Project: MIPS ALU Design (32-bit)
-- Notes:
--  This ALU performs addition, subtraction, logical operations, shifting, SLT, SLTU,
--  and includes the replicate instruction (repl.qb). Overflow, carryout, and zero flags are implemented.
-- </header>

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.MIPS_Types.all;

-- Entity declaration of the ALU
entity alu is
    port (
        CLK        : in  std_logic;  -- Clock signal
        i_Data1    : in  std_logic_vector(31 downto 0);  -- 32-bit input data 1 (operand A)
        i_Data2    : in  std_logic_vector(31 downto 0);  -- 32-bit input data 2 (operand B)
        i_shamt    : in  std_logic_vector(4 downto 0);   -- 5-bit shift amount (used for shifting)
        i_aluOp    : in  std_logic_vector(3 downto 0);   -- 4-bit ALU operation code
        o_F        : out std_logic_vector(31 downto 0);  -- 32-bit ALU result
        o_Overflow : out std_logic;  -- Overflow flag
        o_Zero     : out std_logic   -- Zero flag (set when the result is zero)
    );
end alu;

architecture structural of alu is
    -- Components for arithmetic, shifting, and logical operations
    component adder_subtractor is
        generic (N : integer := 32);
        port (
            i_a        : in  std_logic_vector(N - 1 downto 0);  -- Operand A
            i_b        : in  std_logic_vector(N - 1 downto 0);  -- Operand B
            i_s        : in  std_logic;    -- Signed or unsigned operation
            nadd_sub   : in  std_logic;    -- Add/Subtract selection (0 for add, 1 for subtract)
            o_y        : out std_logic_vector(N - 1 downto 0);  -- Result of addition or subtraction
            o_cout     : out std_logic;    -- Carry-out flag
            o_overflow : out std_logic     -- Overflow flag
        );
    end component;

    component shifter_N is
        port (
            i_A          : in  std_logic_vector(31 downto 0);  -- Data to be shifted
            i_shamt      : in  std_logic_vector (4 downto 0);  -- Shift amount
            i_Arithmetic : in  std_logic;  -- Selects type of shift (1 = arithmetic, 0 = logical)
            i_T          : in  std_logic;  -- 0 = left shift, 1 = right shift
            o_O          : out std_logic_vector(31 downto 0)   -- Output of the shifter
        );
    end component;

    -- Logic operation components (AND, OR, XOR, NAND, NOR)
    component andg32 is
        port (
            i_A : in  std_logic_vector(31 downto 0);
            i_B : in  std_logic_vector(31 downto 0);
            o_F : out std_logic_vector(31 downto 0)
        );
    end component;

    component org32 is
        port (
            i_A : in  std_logic_vector(31 downto 0);
            i_B : in  std_logic_vector(31 downto 0);
            o_F : out std_logic_vector(31 downto 0)
        );
    end component;

    component xorg32 is
        port (
            i_A : in  std_logic_vector(31 downto 0);
            i_B : in  std_logic_vector(31 downto 0);
            o_F : out std_logic_vector(31 downto 0)
        );
    end component;

    component nandg32 is
        port (
            i_A : in  std_logic_vector(31 downto 0);
            i_B : in  std_logic_vector(31 downto 0);
            o_F : out std_logic_vector(31 downto 0)
        );
    end component;

    component norg32 is
        port (
            i_A : in  std_logic_vector(31 downto 0);
            i_B : in  std_logic_vector(31 downto 0);
            o_F : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Multiplexer for ALU result selection
    component mux16t1 is
        port (
            i_I : in  array_16x32;  -- 16 inputs of 32-bit each
            i_S : in  std_logic_vector(3 downto 0);  -- 4-bit selection signal
            o_O : out std_logic_vector(31 downto 0)  -- Output result
        );
    end component;

    -- Internal signals for operations
    signal s_AddSub_res : std_logic_vector(31 downto 0);  -- Result of addition or subtraction
    signal s_overflow, s_alu_cout : std_logic;  -- Overflow and carry-out flags
    signal s_shift_res : std_logic_vector(31 downto 0);   -- Shift result
    signal s_o_andg32, s_o_org32, s_o_xorg32, s_o_nandg32, s_o_norg32 : std_logic_vector(31 downto 0);
    signal s_o_slt, s_o_sltu : std_logic_vector(31 downto 0);  -- SLT and SLTU signals
    signal s_mux_input : array_16x32;  -- Input array for multiplexer

begin
    -- ARITHMETIC UNIT: Handles addition and subtraction
    G_ADD_SUB : adder_subtractor
        port map (
            i_a        => i_Data1,
            i_b        => i_Data2,
            i_s        => i_aluOp(1),  -- Select signed/unsigned
            nadd_sub   => i_aluOp(0),  -- Select add or subtract
            o_y        => s_AddSub_res,
            o_cout     => s_alu_cout,
            o_overflow => s_overflow
        );
    
    -- Assign overflow and zero flags
    o_Overflow <= s_overflow;
    o_Zero <= '1' when s_AddSub_res = x"00000000" else '0';

    -- SHIFTER UNIT: Handles logical and arithmetic shifts (SLL, SRL, SRA)
    G_SHIFTER : shifter_N
        port map (
            i_A          => i_Data2,
            i_shamt      => i_shamt,
            i_Arithmetic => i_aluOp(1),  -- 1 for arithmetic, 0 for logical
            i_T          => i_aluOp(3),  -- 0 for left shift, 1 for right shift
            o_O          => s_shift_res
        );

    -- LOGIC UNIT: Handles logical operations (AND, OR, XOR, NAND, NOR)
    G_AND32 : andg32
        port map (
            i_A => i_Data1,
            i_B => i_Data2,
            o_F => s_o_andg32
        );

    G_OR32 : org32
        port map (
            i_A => i_Data1,
            i_B => i_Data2,
            o_F => s_o_org32
        );

    G_XOR32 : xorg32
        port map (
            i_A => i_Data1,
            i_B => i_Data2,
            o_F => s_o_xorg32
        );

    G_NAND32 : nandg32
        port map (
            i_A => i_Data1,
            i_B => i_Data2,
            o_F => s_o_nandg32
        );

    G_NOR32 : norg32
        port map (
            i_A => i_Data1,
            i_B => i_Data2,
            o_F => s_o_norg32
        );

    -- SLT (Set on Less Than) and SLTU (Unsigned SLT)
    s_o_slt(0) <= s_AddSub_res(31);  -- Set on less than (signed)
    G2 : for i in 1 to 31 generate
        s_o_slt(i) <= '0';
    end generate;

    s_o_sltu(0) <= not s_alu_cout;  -- Set on less than (unsigned)
    G3 : for i in 1 to 31 generate
        s_o_sltu(i) <= '0';
    end generate;

    -- MULTIPLEXER: Selects the final output based on ALU operation code (i_aluOp)
    G_MUX_RES : mux16t1
        port map (
            i_I(0)  => s_AddSub_res,   -- ADD
            i_I(1)  => s_AddSub_res,   -- SUB
            i_I(2)  => s_AddSub_res,   -- Signed ADD
            i_I(3)  => s_AddSub_res,   -- Signed SUB
            i_I(4)  => s_shift_res,    -- SLL (Shift Left Logical)
            i_I(5)  => s_o_andg32,     -- AND
            i_I(6)  => s_o_nandg32,    -- NAND
            i_I(7)  => s_o_slt,        -- SLT (Set on Less Than, signed)
            i_I(8)  => s_o_norg32,     -- NOR
            i_I(9)  => s_o_org32,      -- OR
            i_I(10) => s_o_xorg32,     -- XOR
            i_I(11) => x"00000000",    -- Reserved (optional for future extensions)
            i_I(12) => s_shift_res,    -- SRL (Shift Right Logical)
            i_I(13) => s_o_sltu,       -- SLTU (Unsigned SLT)
            i_I(14) => s_shift_res,    -- SRA (Shift Right Arithmetic)
            i_I(15) => x"00000000",    -- Reserved (optional)
            i_S     => i_aluOp,        -- ALU operation code (selects operation)
            o_O     => o_F             -- Final ALU output
        );

end structural;
