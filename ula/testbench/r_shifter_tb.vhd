library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity r_shifter_tb is
end entity;

architecture a_r_shifter_tb of r_shifter_tb is
    component r_shifter is
        port(
            i_n         : in unsigned (15 downto 0);
            msb_shifted : out unsigned (15 downto 0)
        );
    end component;

    signal i_n         : unsigned (15 downto 0);
    signal msb_shifted : unsigned (15 downto 0);

begin 
    uut: r_shifter
        port map(
            i_n => i_n,
            msb_shifted => msb_shifted
        );
    process
    begin
        i_n <= "1111111111111111"; wait for 50 ns;
        i_n <= "1000000000000000"; wait for 50 ns;
        
        wait;
    end process;
end architecture;

