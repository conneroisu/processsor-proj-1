-- <header>
-- Author(s): connero
-- Name: cpre381-project-1/proj/src/TopLevel/MIPS_Processor.vhd
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
-- DESCRIPTION: This file contains a MIPS_Processor implementation.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
entity MIPS_processor is
    generic
        (N : integer := 32);
    port
        (
            iCLK      : in  std_logic;  -- Clock
            iRST      : in  std_logic;  -- Reset
            iInstLd   : in  std_logic;  -- Load instruction
            iInstAddr : in  std_logic_vector(N - 1 downto 0);  -- Instruction address
            iInstExt  : in  std_logic_vector(N - 1 downto 0);  -- Instruction data
            oALUOut   : out std_logic_vector(N - 1 downto 0)  -- ALU output
            );
end MIPS_processor;
architecture structure of MIPS_processor is
    -- Required data memory signals
    signal s_DMemWr                                   : std_logic;  -- Write enable
    signal s_DMemAddr                                 : std_logic_vector(N - 1 downto 0);  -- Address
    signal s_DMemData                                 : std_logic_vector(N - 1 downto 0);  -- Data
    signal s_DMemOut                                  : std_logic_vector(N - 1 downto 0);  -- Data
    -- Required register file signals 
    signal s_RegWr                                    : std_logic;  -- Write enable
    signal s_RegWrAddr                                : std_logic_vector(4 downto 0);  -- Address
    signal s_RegWrData                                : std_logic_vector(N - 1 downto 0);  -- Data
    -- Required instruction memory signals
    signal s_IMemAddr                                 : std_logic_vector(N - 1 downto 0);  -- DO NOT assign this signal, assign to s_NextInstAddr instead
    signal s_NextInstAddr                             : std_logic_vector(N - 1 downto 0);  -- Next instruction address
    signal s_Inst                                     : std_logic_vector(N - 1 downto 0);  -- Instruction
    -- Required halt signal -- for simulation
    signal s_Halt                                     : std_logic;
    -- Required overflow signal -- for overflow exception detection
    signal s_Ovfl                                     : std_logic;
    --Added Signals  
    signal s_RegOutReadData1, s_DMemOut1              : std_logic_vector(N - 1 downto 0);
    --Data2 is named s_DMemData
    signal s_RegInReadData1, s_RegInReadData2, s_RegD : std_logic_vector(4 downto 0);
    --rs(instructions [25-21]), rt(instructions [20-16]),     rd (instructions [15-11])
    signal s_shamt, s_lui_shamt, s_alu_shamt          : std_logic_vector(4 downto 0);
    signal s_imm16                                    : std_logic_vector(15 downto 0);  -- instruction bits [15-0]
    signal s_imm32                                    : std_logic_vector(31 downto 0);  -- after extension
    signal s_imm32x4                                  : std_logic_vector(31 downto 0);  -- after multiplication
    signal s_immMuxOut                                : std_logic_vector(N - 1 downto 0);  -- output of Immediate Mux (ALU 2nd input)
    signal s_opCode                                   : std_logic_vector(5 downto 0);  --instruction bits[31-26] 
    signal s_funcCode                                 : std_logic_vector(5 downto 0);  --instruction bits[5-0]
    signal s_inputPC                                  : std_logic_vector(31 downto 0);  -- wire from the jump mux
    signal s_Ctrl                                     : std_logic_vector(20 downto 0);  -- control brick output, each bit is a different switch
    signal s_ALUSrc                                   : std_logic;  -- alu source
    signal s_jr, s_shamt_s, s_lui                     : std_logic;
    signal s_jal                                      : std_logic;  -- jump and link
    signal s_ALUOp                                    : std_logic_vector(3 downto 0);  -- alu code
    signal s_MemtoReg                                 : std_logic;  -- memory to register
    signal s_RegDst                                   : std_logic;  -- register destination
    signal s_Branch, s_BranchNE                       : std_logic;  -- branch
    signal s_SignExt                                  : std_logic;  -- sign extend
    signal s_jump                                     : std_logic;  -- jump
    --Addressing Signals
    signal s_PCPlusFour                               : std_logic_vector(N - 1 downto 0);  -- pc + 4
    signal s_jumpAddress                              : std_logic_vector(N - 1 downto 0);  -- jump address
    signal s_branchAddress                            : std_logic_vector(N - 1 downto 0);  -- branch address
    signal s_MemToReg0                                : std_logic_vector(31 downto 0);  -- memory to register 0
    signal s_RegDst0                                  : std_logic_vector(4 downto 0);  -- register destination 0
    signal s_normalOrBranch, s_finalJumpAddress       : std_logic_vector(31 downto 0);
    signal s_ALUBranch, s_abnormal, s_HorBExt, s_HorB : std_logic;
    signal s1, s2, s3                                 : std_logic;
    signal s_lb1or0, s_lb3or2, s_lbUorL               : std_logic_vector(7 downto 0);  -- lb and lbu raw signals
    signal s_lhUorL                                   : std_logic_vector(15 downto 0);  -- lh and lhu raw signals
    signal s_bSelect                                  : std_logic_vector(1 downto 0);  --lb & lh selectors
    signal s_lb_word, s_lh_word, s_lbOrlh             : std_logic_vector(31 downto 0);  --extended selected signal
    component mem is
        generic
            (
                ADDR_WIDTH : integer;
                DATA_WIDTH : integer
                );
        port
            (
                clk  : in  std_logic;
                addr : in  std_logic_vector((ADDR_WIDTH - 1) downto 0);
                data : in  std_logic_vector((DATA_WIDTH - 1) downto 0);
                we   : in  std_logic := '1';
                q    : out std_logic_vector((DATA_WIDTH - 1) downto 0)
                );
    end component;
    component control_unit is  --no internal functionality so no need to made independent vhdl?
        port
            (
                i_opcode    : in  std_logic_vector(5 downto 0);  -- in std_logic_vector(5 downto 0);
                i_funct     : in  std_logic_vector(5 downto 0);  -- in std_logic_vector(5 downto 0);
                o_Ctrl_Unit : out std_logic_vector(20 downto 0)  -- out std_logic_vector(14 downto 0)); (all the control signals needed lumped into 1 vector)
                );
    end component;
    component register_file is
        port
            (
                clk   : in  std_logic;
                i_wA  : in  std_logic_vector(4 downto 0);    -- Write Address
                i_wD  : in  std_logic_vector(31 downto 0);   -- Write Data
                i_wC  : in  std_logic;  -- WriteControl aka RegWrite
                i_r1  : in  std_logic_vector(4 downto 0);    -- Read 1
                i_r2  : in  std_logic_vector(4 downto 0);    -- Read 2
                reset : in  std_logic;  --Reset
                o_d1  : out std_logic_vector(31 downto 0);   --Output Data 1
                o_d2  : out std_logic_vector(31 downto 0)    --Output Data 2
                );
    end component;
    component extender16t32 is
        port
            (
                i_I : in  std_logic_vector(15 downto 0);  -- Data value input
                i_C : in  std_logic;    -- 0 for zero, 1 for signextension
                o_O : out std_logic_vector(31 downto 0)   -- Data value output
                );
    end component;
    component extender8t32 is
        port
            (
                i_I : in  std_logic_vector(7 downto 0);   -- Data value input
                i_C : in  std_logic;    -- 0 for zero, 1 for signextension
                o_O : out std_logic_vector(31 downto 0)   -- Data value output
                );
    end component;
    component mux2t1_N is
        generic
            (N : integer := 16);
        port
            (
                i_S  : in  std_logic;   -- Select signal
                i_D0 : in  std_logic_vector(N - 1 downto 0);  -- Data value input 1
                i_D1 : in  std_logic_vector(N - 1 downto 0);  -- Data value input 2
                o_O  : out std_logic_vector(N - 1 downto 0)  -- Data value output
                );
    end component;
    component adder_subtractor is
        generic
            (N : integer := 32);
        port
            (
                i_s      : in  std_logic;
                nadd_sub : in  std_logic;   -- 0 for add, 1 for subtract
                i_a      : in  std_logic_vector(N - 1 downto 0);    -- input a
                i_b      : in  std_logic_vector(N - 1 downto 0);    -- input b
                o_y      : out std_logic_vector(N - 1 downto 0);    -- output y
                o_cout   : out std_logic  -- carry out
                );
    end component;
    component alu is
        port
            (
                CLK        : in  std_logic;
                i_Data1    : in  std_logic_vector(31 downto 0);  -- Data value input 1
                i_Data2    : in  std_logic_vector(31 downto 0);  -- Data value input 2
                i_aluOp    : in  std_logic_vector(3 downto 0);  -- ALU operation code
                i_shamt    : in  std_logic_vector(4 downto 0);  -- Shift amount
                o_F        : out std_logic_vector(31 downto 0);  -- Data value output
                o_Zero     : out std_logic;   -- zero branch signal
                o_OverFlow : out std_logic  -- overflow
                );
    end component;
    component MIPS_pc is
        port
            (
                i_CLK : in  std_logic;  -- clock
                i_RST : in  std_logic;  -- reset
                i_D   : in  std_logic_vector(31 downto 0);   -- data
                o_Q   : out std_logic_vector(31 downto 0)    -- output
                );
    end component;
begin
    with iInstLd select
        s_IMemAddr <= s_NextInstAddr when '0',
        iInstAddr                    when others;
    IMem : mem
        generic
        map(
            ADDR_WIDTH => 10,           -- 1024 words
            DATA_WIDTH => N             -- 32 bits
            )
        port map
        (
            clk  => iCLK,               -- clock
            addr => s_IMemAddr(11 downto 2),  -- address
            data => iInstExt,           -- data
            we   => iInstLd,            -- write enable
            q    => s_Inst              -- output
            );
    DMem : mem
        generic
        map(
            ADDR_WIDTH => 10,           -- 1024 words
            DATA_WIDTH => N             -- 32 bits
            )
        port
        map(
            clk  => iCLK,               -- clock
            addr => s_DMemAddr(11 downto 2),  -- address
            data => s_DMemData,         -- data
            we   => s_DMemWr,           -- write enable
            q    => s_DMemOut           -- output
            );
    instructionSlice : process (s_Inst)  -- snip the Instruction data into smaller parts
    begin
        s_imm16(15 downto 0)         <= s_Inst(15 downto 0);  -- bits[15-0] into Sign Extender
        s_funcCode(5 downto 0)       <= s_Inst(5 downto 0);  -- bits[5-0] into ALU Control 
        s_shamt(4 downto 0)          <= s_Inst(10 downto 6);  -- bits[1--6] into ALU (for Barrel Shifter) 
        s_regD(4 downto 0)           <= s_Inst(15 downto 11);  -- bits[11-15] into RegDstMux bits[4-0]
        s_RegInReadData2(4 downto 0) <= s_Inst(20 downto 16);  -- bits[16-20] into RegDstMux and Register (bits[4-0])
        s_RegInReadData1(4 downto 0) <= s_Inst(25 downto 21);  -- bits[25-21] into Register (bits[4-0])
        s_opCode(5 downto 0)         <= s_Inst(31 downto 26);  -- bits[26-31] into Control Brick (bits[5-0)
        s_jumpAddress(0)             <= '0';
        s_jumpAddress(1)             <= '0';  -- Set first two bits to zero
        s_jumpAddress(27 downto 2)   <= s_Inst(25 downto 0);  -- Instruction bits[25-0] into bits[27-2] of jumpAddr
    end process;
    oALUOut <= s_DMemAddr;              -- oALU is for synthesis
    control : control_unit  -- grabs the fields from the instruction after decoding that translate to control signals
        port
        map(
            i_opcode    => s_opCode,    -- in std_logic_vector(5 downto 0);
            i_funct     => s_funcCode,  -- in std_logic_vector(5 downto 0);
            o_Ctrl_Unit => s_Ctrl  -- out std_logic_vector(14 downto 0)); (all the control signals needed lumped into 1 vector)
            );
    controlSlice : process (s_Ctrl)  -- action of cutting up the lumped up control signals into other wires
    begin
        --Control Signals
        s_abnormal          <= s_Ctrl(20);  -- selects between either loading a word or a half/byte from memory
        s_HorBExt           <= s_Ctrl(19);
        s_HorB              <= s_Ctrl(18);
        s_BranchNE          <= s_Ctrl(17);
        s_shamt_s           <= s_Ctrl(16);
        s_lui               <= s_Ctrl(15);
        s_jr                <= s_Ctrl(14);
        s_jal               <= s_Ctrl(13);
        s_ALUSrc            <= s_Ctrl(12);
        s_ALUOp(3 downto 0) <= s_Ctrl(11 downto 8);  --opcode for the mainALU
        s_MemtoReg          <= s_Ctrl(7);
        s_DMemWr            <= s_Ctrl(6);
        s_RegWr             <= s_Ctrl(5);
        s_RegDst            <= s_Ctrl(4);
        s_Branch            <= s_Ctrl(3);
        s_SignExt           <= s_Ctrl(2);
        s_jump              <= s_Ctrl(1);
        s_Halt              <= s_Ctrl(0);
    end process;
    addFour : adder_subtractor          -- iterates the program counter by 4
        generic
        map(N => 32)
        port
        map(
            i_s      => '1',            -- signed?
            nadd_sub => '0',            -- in std_logic;
            i_a      => s_IMemAddr,     -- in std_logic_vector(N-1 downto 0);
            i_b      => x"00000004",    -- in std_logic_vector(N-1 downto 0);
            o_y      => s_PCPlusFour,   -- out std_logic_vector(N-1 downto 0);
            o_cout   => s1              -- out std_logic
            );
    signExtender : extender16t32  -- extends the immediate signal before it goes into the mainALU
        port
        map(
            i_I => s_imm16,  -- in std_logic_vector(15 downto 0);     -- Data value input
            i_C => s_SignExt,  -- in std_logic; --0 for zero, 1 for sign-extension
            o_O => s_imm32);  -- out std_logic_vector(31 downto 0));   -- Data value output);
    jumpAddresses : process (s_PCPlusFour, s_imm32)  -- process for converting address arguments into actual 32 bit addresses
    begin
        s_jumpAddress(31 downto 28) <= s_PCPlusFour(31 downto 28);  -- PC+4 bits[31-28] into bits[31-28] of jumpAddr
        s_imm32x4(0)                <= '0';
        s_imm32x4(1)                <= '0';
        s_imm32x4(31 downto 2)      <= s_imm32(29 downto 0);  -- imm32 bits[29-0] into bits[31-2] of jumpAddr
    end process;
    pcReg : MIPS_pc  -- 32 bit register that stores the value of the program counter
        port
        map(
            i_CLK => iClk,              -- in std_logic;
            i_RST => iRST,              -- in std_logic;
            i_D   => s_inputPC,         -- in std_logic_vector(31 downto 0);
            o_Q   => s_NextInstAddr     -- out std_logic_vector(31 downto 0)
            );
    --RegFile: --
    registers : register_file
        port
        map(
            clk   => iCLK,              -- std_logic;
            i_wA  => s_RegWrAddr,       -- std_logic_vector(4 downto 0);
            i_wD  => s_RegWrData,       -- std_logic_vector(31 downto 0);
            i_wC  => s_RegWr,           -- std_logic;
            i_r1  => s_RegInReadData1,  -- std_logic_vector(4 downto 0);
            i_r2  => s_RegInReadData2,  -- std_logic_vector(4 downto 0);
            reset => iRST,              -- std_logic;
            o_d1  => s_RegOutReadData1,  -- std_logic_vector(31 downto 0);
            o_d2  => s_DMemData         -- std_logic_vector(31 downto 0));
            );
    branchAdder : adder_subtractor  -- branch adder that supplies the modified address to adjust the program counter on branches
        generic
        map(N => 32)
        port
        map(
            i_s      => '1',
            nAdd_Sub => '0',            -- in std_logic;
            i_A      => s_PCPlusFour,   -- in std_logic_vector(31 downto 0);
            i_B      => s_imm32x4,      -- immediate value
            o_Y      => s_branchAddress,  -- out std_logic_vector(31 downto 0);
            o_Cout   => s2              -- carry out
            );
    luiShamt : mux2t1_N  -- Determines if ALU gets hardcoded lui shamt immediate or normal immediate value
        generic
        map(N => 5)  -- Generic of type integer for input/output data width. Default value is 32.
        port
        map(
            i_S  => s_lui,  -- selects either v or normal operations
            i_D0 => s_shamt,            -- used for sll, srl, sra
            i_D1 => "10000",  -- 16 (hardcoded for lui, lui implemented as sll with 16 shift)
            o_O  => s_lui_shamt
            );
    ALUShamt : mux2t1_N  -- Determines if ALU gets normal shamt value or lower 5 bits of Data1 (for sllv etc)
        generic
        map(N => 5)  -- Generic of type integer for input/output data width. Default value is 32.
        port
        map(
            i_S  => s_shamt_s,    -- selects either v or normal operations
            i_D0 => s_lui_shamt,        -- used for sll, srl, sra
            i_D1 => s_RegOutReadData1(4 downto 0),   -- used for sllv srlv srav
            o_O  => s_alu_shamt);
    mainALU : alu  -- does all the arithmetic operations and interfaces with memory
        port
        map(
            CLK        => iCLK,
            i_Data1    => s_RegOutReadData1,
            i_Data2    => s_immMuxOut,
            i_aluOp    => s_ALUOp,
            i_shamt    => s_alu_shamt,
            o_F        => s_DMemAddr,
            o_OverFlow => s_Ovfl,
            o_Zero     => s_ALUBranch
            );
    ALUSrc : mux2t1_N  -- Determines if ALU gets an immediate value or a register value
        generic
        map(N => 32)  -- Generic of type integer for input/output data width. Default value is 32.
        port
        map(
            i_S  => s_ALUSrc,
            i_D0 => s_DMemData,
            i_D1 => s_imm32,
            o_O  => s_immMuxOut);
    jumpMux : mux2t1_N  -- used specifically for the jr instruction, mux to potential replace normal jump address with value coming from $31
        generic
        map(N => 32)
        port
        map(
            i_S  => s_jr,
            i_D0 => s_jumpAddress,
            i_D1 => s_RegOutReadData1,
            o_O  => s_finalJumpAddress
            );
    jalData : mux2t1_N  -- used specifically for the jal instruction, forces PC+4 into $31 (link pt2)
        generic
        map(N => 32)
        port
        map(
            i_S  => s_jal,              -- in std_logic;
            i_D0 => s_DMemAddr,         -- this is the ALU Output
            i_D1 => s_PCPlusFour,       -- linked return address
            o_O  => s_MemToReg0         -- out std_logic_vector(31 downto 0)
            );
    jalAddr : mux2t1_N  -- used specifically for the jal instruction, changes the destination to be hardcoded as $31 (link pt1)
        generic
        map(N => 5)
        port
        map(
            i_S  => s_jal,
            i_D0 => s_RegInReadData2,   --rt is taking the place of rd,
            i_D1 => "11111",            -- register 31
            o_O  => s_RegDst0           -- out std_logic_vector(4 downto 0)
            );
    RegDst : mux2t1_N
        generic
        map(N => 5)  -- Generic of type integer for input/output data width. Default value is 32.
        port
        map(
            i_S  => s_RegDst,           -- in std_logic;
            i_D0 => s_RegDst0,          -- output of jalAddr mux
            i_D1 => s_RegD,             -- rd
            o_O  => s_RegWrAddr         -- out std_logic_vector(4 downto 0)
            );
    Branch : mux2t1_N  -- 1st mux selects between either PC+4 (normal instruction) or branch address (branch)
        generic
        map(N => 32)
        port
        map(
            i_S  => ((s_Branch and s_ALUBranch) or (s_BranchNE and not s_ALUBranch)),  -- in std_logic;
            i_D0 => s_PCPlusFour,       -- in std_logic_vector(31 downto 0);
            i_D1 => s_branchAddress,    -- in std_logic_vector(31 downto 0);
            o_O  => s_normalOrBranch    -- out std_logic_vector(31 downto 0)
            );
    Jump : mux2t1_N  -- 2nd & final mux that selects the signal that goes back to PC (computed jump address or (PC + 4 or branch address))
        generic
        map(N => 32)
        port
        map(
            i_S  => s_jump,             -- in std_logic;
            i_D0 => s_normalOrBranch,   -- output of Branch mux
            i_D1 => s_finalJumpAddress,  -- output of jumpMux
            o_O  => s_inputPC           -- out std_logic_vector(31 downto 0)
            );
    MemtoReg : mux2t1_N  -- selects either output of memory or alu to go back to regfile
        generic
        map(N => 32)
        port
        map(
            i_S  => s_MemtoReg,         -- in std_logic;
            i_D0 => s_MemToReg0,        -- in std_logic_vector(31 downto 0);
            i_D1 => s_DMemOut1,         -- in std_logic_vector(31 downto 0);
            o_O  => s_RegWrData         -- out std_logic_vector(31 downto 0)
            );
-- lb lbu lh lhu gates & extenders
    s_bSelect <= s_DMemAddr(1 downto 0);  --specific byte of interest
    lb2or3 : mux2t1_N  -- selects between loading either byte 2 or 3
        generic map(N => 8)
        port map(
            i_S  => s_bSelect(0),
            i_D0 => s_DMemOut(23 downto 16),
            i_D1 => s_DMemOut(31 downto 24),
            o_O  => s_lb3or2
            );
    lb0or1 : mux2t1_N  -- selects between loading either byte 0 or 1
        generic map(N => 8)
        port map(
            i_S  => s_bSelect(0),
            i_D0 => s_DMemOut(7 downto 0),
            i_D1 => s_DMemOut(15 downto 8),
            o_O  => s_lb1or0
            );
    lbUorL : mux2t1_N  -- selects between loading an upper or lower byte
        generic map(N => 8)
        port map(
            i_S  => s_bSelect(1),
            i_D0 => s_lb1or0,
            i_D1 => s_lb3or2,
            o_O  => s_lbUorL
            );
    lhUorL : mux2t1_N  -- selects between loading either upper or lower bytes
        generic map(N => 16)
        port map(
            i_S  => s_bSelect(1),  -- the actual selector that select wether we are loading the upper or lower half
            i_D0 => s_DMemOut(15 downto 0),
            i_D1 => s_DMemOut(31 downto 16),
            o_O  => s_lhUorL
            );
-- raw signals selected
    byteExtender : extender8t32         -- extends the byte to a word width
        port map(
            i_I => s_lbUorL,            -- holds upper or lower byte
            i_C => s_HorBExt,
            o_O => s_lb_word);
    halfExtender : extender16t32        -- extends the half to a word width
        port map(
            i_I => s_lhUorL,            -- holds upper or lower half
            i_C => s_HorBExt,
            o_O => s_lh_word);
    byteOrHalf : mux2t1_N   -- selects between loading a byte or a half signal
        generic map(N => 32)
        port map(
            i_S  => s_HorB,
            i_D0 => s_lb_word,
            i_D1 => s_lh_word,
            o_O  => s_lbOrlh
            );
    loadByteOrHalf : mux2t1_N  -- selects between loading normally or a byte/half signal
        generic map(N => 32)
        port map(
            i_S  => s_abnormal,
            i_D0 => s_DMemOut,
            i_D1 => s_lbOrlh,
            o_O  => s_DMemOut1          -- final signal to choose from
            );
end structure;
