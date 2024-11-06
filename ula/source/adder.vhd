library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
    port(
        in0, in1 : in unsigned(15 downto 0);
        sum      : out unsigned(15 downto 0) := (others => '0')
    );
end entity;

architecture a_adder of adder is 
begin
    sum <= in0 + in1;
end architecture;

