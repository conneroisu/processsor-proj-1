-- <header>
-- Author(s): conneroisu
-- Name: proj/src/TopLevel/Fetch/program_counter.vhd
-- Notes:
--	conneroisu  <conneroisu@outlook.com> fixed-and-added-back-the-git-cdocumentor-for-the-vhdl-files-to-have
--	Conner Ohnesorge  <connero@iastate.edu> fix-generic-width-instantiation-of-the-program-counter
--	Conner Ohnesorge  <connero@iastate.edu> fix-component-name-instantiation-of-the-program_counter_dff-in
--	conneroisu  <conneroisu@outlook.com> add-starting-place-for-program-counter
-- </header>

library IEEE;
use IEEE.std_logic_1164.all;
entity program_counter is
    generic(
        N : integer := 32
        );
    port(
        i_CLK : in  std_logic;                        -- Clock input
        i_RST : in  std_logic;                        -- Reset input
        i_D   : in  std_logic_vector(N-1 downto 0);   -- Data value input
        o_Q   : out std_logic_vector(N-1 downto 0));  -- Data value output
end program_counter;
architecture structural of program_counter is
    component program_counter_dff is
        port(
            i_CLK      : in  std_logic;   -- Clock input
            i_RST      : in  std_logic;   -- Reset input
            i_RST_data : in  std_logic;   -- Write enable input
            i_D        : in  std_logic;   -- Data value input
            o_Q        : out std_logic);  -- Data value output
    end component;
    signal s_RST_data : std_logic_vector(31 downto 0) := X"00400000";
begin
    -- Instantiate N dff instances.
    G_NBit_DFFG : for i in 0 to (N-1) generate
        ONESCOMPI : program_counter_dff port map(
            i_CLK      => i_CLK,          -- every dff has the same clock
            i_RST      => i_RST,          -- parallel rst
            i_RST_data => s_RST_data(i),  -- parallel write enable
            i_D        => i_D(i),         -- N bit long dff reg input
            o_Q        => o_Q(i));        -- N bit long dff reg output
    end generate G_NBit_DFFG;
end structural;
