library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity xor_op is
    port(
        in0, in1       : in unsigned(15 downto 0);
        out_xor        : out unsigned(15 downto 0)
    );
end entity;

architecture a_xor_op of xor_op is
begin 
    out_xor <= in0 xor in1;
end architecture;