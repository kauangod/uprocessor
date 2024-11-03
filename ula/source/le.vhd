library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity le is
    port(
        in0, in1 : in unsigned(15 downto 0);
        is_less_or_equal    : out unsigned(15 downto 0)
    );
end entity;

architecture a_le of le is
begin
    is_less_or_equal <= "0000000000000001" when (in0 <= in1) else
                        "0000000000000000";
end architecture;