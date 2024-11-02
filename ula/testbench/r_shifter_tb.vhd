library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity r_shifter_tb is
end entity r_shifter_tb;

architecture a_r_shifter_tb of r_shifter_tb is
    component r_shifter is
        port(
            in0 : in unsigned (15 downto 0);
            msb_shifted : out unsigned (15 downto 0)
        );
    end component;

    signal in0         : unsigned (15 downto 0);
    signal msb_shifted : unsigned (15 downto 0);

begin 
    uut: r_shifter
        port map(
            in0 => in0,
            msb_shifted => msb_shifted
        );
    process
    begin
        in0 <= "1111111111111111"; wait for 50 ns;
        in0 <= "1000000000000000"; wait for 50 ns;
        in0 <= "0000000000000000"; wait for 50 ns;
        wait;
    end process;
end architecture;

