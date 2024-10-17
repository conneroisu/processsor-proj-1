-- <header>
-- Author(s): connero
-- Name: proj/src/LowLevel/dffg_n.vhd
-- Notes:
--	connero 88785126+conneroisu@users.noreply.github.com Merge pull request #15 from conneroisu/feature/program_counter
-- </header>



library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration of nbit_register
entity dffg_n is
    generic (
        N : integer := 32                            -- Default width is 8 bits
        );
    port (
        i_CLK : in  std_logic;                       -- Clock input
        i_RST : in  std_logic;                       -- Reset input
        i_WE  : in  std_logic;                       -- Write enable input
        i_D   : in  std_logic_vector(N-1 downto 0);  -- Data value input
        o_Q   : out std_logic_vector(N-1 downto 0)   -- Data value output
        );
end dffg_n;

-- Architecture of nbit_register
architecture structural of dffg_n is
begin
    -- Generate N instances of dffg flip-flop
    gen_dffgs : for i in 0 to N-1 generate
        u_dffg : entity work.dffg
            port map (
                i_CLK => i_CLK,
                i_RST => i_RST,
                i_WE  => i_WE,
                i_D   => i_D(i),
                o_Q   => o_Q(i)
                );
    end generate gen_dffgs;
end structural;
