library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity r_shifter is
    port(
        in0 : in unsigned(15 downto 0);
        msb_shifted : out unsigned(15 downto 0)
    );
end entity;

architecture a_r_shifter of r_shifter is
begin 
    msb_shifted <= "000000000000000" & in0(15);
end architecture;