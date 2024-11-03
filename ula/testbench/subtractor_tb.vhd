library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor_tb is
end entity;

architecture a_subtractor_tb of subtractor_tb is
    component subtractor
        port(
            in0,in1 : in unsigned(15 downto 0);
            sub     : out unsigned(15 downto 0)
        );
    end component;
    signal in0, in1, sub : unsigned(15 downto 0);

    begin
    uut: subtractor port map(
        in0=>in0,
        in1=>in1,
        sub=>sub
    );

    process
    begin
        in0<="0000000001111111";
        in1<="0001100000011111";
        wait for 50 ns;
        in0<="0001100000011111";
        in1<="0000000001111111";
        wait for 50 ns;
        in0<="1000000001111111";
        in1<="1011000000011111";
        wait for 50 ns;
        in0<="1011000000011111";
        in1<="0111011111111111";
        wait for 50 ns;
        wait;
    end process;
end architecture;