library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity r_shifter is
    port(
        i_n        : in unsigned(15 downto 0);
        shift_n    : in unsigned(4 downto 0);
        shifted    : out unsigned(15 downto 0)
    );
end entity;

architecture a_r_shifter of r_shifter is
begin
    shifted <= i_n when to_integer(unsigned(shift_n)) = 0 else
               (15 downto (16 - to_integer(unsigned(shift_n))) => '0') & i_n(15 downto to_integer(unsigned(shift_n))) when (to_integer(unsigned(shift_n)) > 0 and to_integer(unsigned(shift_n)) < 16) else
               (others => '0');
end architecture;