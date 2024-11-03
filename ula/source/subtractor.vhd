library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity subtractor is
    port(
        in0, in1 : in unsigned(15 downto 0);
        sub      : out unsigned(15 downto 0)
    );
end entity;

architecture a_subtractor of subtractor is
begin
    sub <= in0 - in1;
end architecture;