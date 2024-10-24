-- <header>
-- Author(s): connero
-- Name: proj/src/TopLevel/MIPS_Processor.vhd
-- Notes:
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-branch-main-into-component-addersub
--	conneroisu  <conneroisu@outlook.com> added-adder-subtractor-and-instantiated-the-program-counter-and-others
--	conneroisu  <88785126+conneroisu@users.noreply.github.com> Format-and-Header
--	conneroisu  <conneroisu@outlook.com> manually-ran-the-header-update-script
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-pull-request-30-from-conneroisu-control
--	conneroisu  <conneroisu@outlook.com> fix-do-files-duplciated-comments-for-test-benches
--	conneroisu  <conneroisu@outlook.com> even-better-file-header-program
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	Conner Ohnesorge  <connero@iastate.edu> formatted-MIPS_Processor
--	Conner Ohnesorge  <connero@iastate.edu> added-register-file-component-to-the-MIPS-processor
--	Conner Ohnesorge  <connero@iastate.edu> formatted-MIPS_Processor
--	Conner Ohnesorge  <connero@iastate.edu> added-register-file-component-to-the-MIPS-processor
--	conneroisu  <conneroisu@outlook.com> added-toolflow-generated-project-layout
-- </header>

library IEEE;
use IEEE.std_logic_1164.all;
library work;
use work.MIPS_types.all;
entity MIPS_Processor is
    generic(N : integer := DATA_WIDTH);
    port(iCLK      : in  std_logic;
         iRST      : in  std_logic;
         iInstLd   : in  std_logic;
         iInstAddr : in  std_logic_vector(N-1 downto 0);
         iInstExt  : in  std_logic_vector(N-1 downto 0);
         oALUOut   : out std_logic_vector(N-1 downto 0));  -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.
end MIPS_Processor;
architecture structure of MIPS_Processor is
    -- Required data memory signals
    signal s_DMemWr       : std_logic;  -- TODO: use this signal as the final active high data memory write enable signal
    signal s_DMemAddr     : std_logic_vector(N-1 downto 0);  -- TODO: use this signal as the final data memory address input
    signal s_DMemData     : std_logic_vector(N-1 downto 0);  -- TODO: use this signal as the final data memory data input
    signal s_DMemOut      : std_logic_vector(N-1 downto 0);  -- TODO: use this signal as the data memory output
    -- Required register file signals 
    signal s_RegWr        : std_logic;  -- TODO: use this signal as the final active high write enable input to the register file
    signal s_RegWrAddr    : std_logic_vector(4 downto 0);  -- TODO: use this signal as the final destination register address input
    signal s_RegWrData    : std_logic_vector(N-1 downto 0);  -- TODO: use this signal as the final data memory data input
    -- Required instruction memory signals
    signal s_IMemAddr     : std_logic_vector(N-1 downto 0);  -- Do not assign this signal, assign to s_NextInstAddr instead
    signal s_NextInstAddr : std_logic_vector(N-1 downto 0);  -- TODO: use this signal as your intended final instruction memory address input.
    signal s_Inst         : std_logic_vector(N-1 downto 0);  -- TODO: use this signal as the instruction signal 
    -- Required halt signal -- for simulation
    signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)
    -- Required overflow signal -- for overflow exception detection
    signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated
    component mem is
        generic(ADDR_WIDTH : integer;
                DATA_WIDTH : integer);
        port(
            clk  : in  std_logic;
            addr : in  std_logic_vector((ADDR_WIDTH-1) downto 0);
            data : in  std_logic_vector((DATA_WIDTH-1) downto 0);
            we   : in  std_logic := '1';
            q    : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;
    component register_file is
        port(
            clk   : in  std_logic;
            i_wA  : in  std_logic_vector(4 downto 0);
            i_wD  : in  std_logic_vector(31 downto 0);
            i_wC  : in  std_logic;
            i_r1  : in  std_logic_vector(4 downto 0);
            i_r2  : in  std_logic_vector(4 downto 0);
            reset : in  std_logic;
            o_d1  : out std_logic_vector(31 downto 0);
            o_d2  : out std_logic_vector(31 downto 0)
            );
    end component;
    component program_counter is
        port
            (
                i_CLK : in  std_logic;                      -- clock
                i_RST : in  std_logic;                      -- reset
                i_D   : in  std_logic_vector(31 downto 0);  -- data
                o_Q   : out std_logic_vector(31 downto 0)   -- output
                );
    end component;
-- TODO: You may add any additional signals or components your implementation 
--       requires below this comment
begin
    -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
    with iInstLd select
        s_IMemAddr <= s_NextInstAddr when '0',
        iInstAddr                    when others;
    IMem : mem
        generic map(ADDR_WIDTH => ADDR_WIDTH,
                    DATA_WIDTH => N)
        port map(clk  => iCLK,
                 addr => s_IMemAddr(11 downto 2),
                 data => iInstExt,
                 we   => iInstLd,
                 q    => s_Inst);
    DMem : mem
        generic
        map(
            ADDR_WIDTH => 10,                               -- 1024 words
            DATA_WIDTH => N                                 -- 32 bits
            )
        port
        map(
            clk  => iCLK,                                   -- clock
            addr => s_DMemAddr(11 downto 2),                -- address
            data => s_DMemData,                             -- data
            we   => s_DMemWr,                               -- write enable
            q    => s_DMemOut                               -- output
            );
-- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
-- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU
-- TODO: Implement the rest of your processor below this comment! 
end structure;
