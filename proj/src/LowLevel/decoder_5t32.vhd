-- <header>
-- Author(s): connero
-- Name: proj/src/LowLevel/decoder_5t32.vhd
-- Notes:
--	connero  <88785126+conneroisu@users.noreply.github.com> Merge-pull-request-28-from-conneroisu-feature-control_unit
-- </header>

library ieee;
use ieee.std_logic_1164.all;

entity decoder_2to4 is
    port (
        i_input  : in  std_logic_vector(1 downto 0);
        i_enable : in  std_logic;
        o_output : out std_logic_vector(3 downto 0)
        );
end entity decoder_2to4;

architecture structural of decoder_2to4 is
begin
    process(i_input, i_enable)
    begin
        if i_enable = '1' then
            case i_input is
                when "00"   => o_output <= "0001";
                when "01"   => o_output <= "0010";
                when "10"   => o_output <= "0100";
                when "11"   => o_output <= "1000";
                when others => o_output <= "0000";
            end case;
        else
            o_output <= "0000";
        end if;
    end process;
end architecture structural;

entity decoder_3to8 is
    port (
        i_input  : in  std_logic_vector(2 downto 0);
        i_enable : in  std_logic;
        o_output : out std_logic_vector(7 downto 0)
        );
end entity decoder_3to8;

architecture structural of decoder_3to8 is
begin
    process(i_input, i_enable)
    begin
        if i_enable = '1' then
            case i_input is
                when "000"  => o_output <= "00000001";
                when "001"  => o_output <= "00000010";
                when "010"  => o_output <= "00000100";
                when "011"  => o_output <= "00001000";
                when "100"  => o_output <= "00010000";
                when "101"  => o_output <= "00100000";
                when "110"  => o_output <= "01000000";
                when "111"  => o_output <= "10000000";
                when others => o_output <= "00000000";
            end case;
        else
            o_output <= "00000000";
        end if;
    end process;
end architecture structural;

entity decoder_5to32 is
    port (
        i_input  : in  std_logic_vector(4 downto 0);
        o_output : out std_logic_vector(31 downto 0)
        );
end entity decoder_5to32;

architecture structural of decoder_5to32 is
    signal enable_2to4 : std_logic_vector(3 downto 0);

    component decoder_2to4
        port (
            i_input  : in  std_logic_vector(1 downto 0);
            i_enable : in  std_logic;
            o_output : out std_logic_vector(3 downto 0)
            );
    end component;

    component decoder_3to8
        port (
            i_input  : in  std_logic_vector(2 downto 0);
            i_enable : in  std_logic;
            o_output : out std_logic_vector(7 downto 0)
            );
    end component;

begin
    -- Decode the upper 2 bits using 2-to-4 decoder
    u1 : decoder_2to4
        port map (
            i_input  => i_input(4 downto 3),
            i_enable => '1',
            o_output => enable_2to4
            );

    -- Decode the lower 3 bits using 3-to-8 decoder, repeated for each i_enable
    gen_3to8 : for i in 0 to 3 generate
        signal output_3to8 : std_logic_vector(7 downto 0);
        u2                 : decoder_3to8
            port map (
                i_input  => i_input(2 downto 0),
                i_enable => enable_2to4(i),
                o_output => output_3to8
                );
        o_output((i*8+7) downto i*8) <= output_3to8;
    end generate;

end architecture structural;



