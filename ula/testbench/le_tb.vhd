library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity le_tb is
end entity;

architecture a_le_tb of le_tb is
    component le
        port(
            in0, in1            : in unsigned(15 downto 0);
            is_less_or_equal    : out unsigned(15 downto 0)
        );
    end component;
    
    signal in0, in1 : unsigned(15 downto 0);
    signal is_less_or_equal : unsigned(15 downto 0);

    begin
        uut: le
            port map(
                in0 => in0,
                in1 => in1,
                is_less_or_equal => is_less_or_equal
            );

    process
    begin
        in0 <= "1111111111111111"; in1 <= "1111111111111111"; wait for 50 ns;
        in0 <= "0000000000000001"; in1 <= "0000000000000010"; wait for 50 ns;
        in0 <= "0000000000000011"; in1 <= "0000000000000010"; wait for 50 ns;
        wait;
    end process;
end architecture;
