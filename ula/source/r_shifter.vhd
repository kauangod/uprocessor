library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity r_shifter is
    port(
        i_n        : in unsigned(15 downto 0);
        msb_shifted : out unsigned(15 downto 0)
    );
end entity;

architecture a_r_shifter of r_shifter is
begin 
    msb_shifted <= "000000000000000" & i_n(15);
end architecture;