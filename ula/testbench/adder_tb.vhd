library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder_tb is
end entity adder_tb;

architecture a_adder_tb of adder_tb is
    component adder is
        port(
            in0, in1 : in unsigned (15 downto 0);
            sum      : out unsigned (15 downto 0)
        );
        end component;
    
    signal in0, in1  : unsigned (15 downto 0);
    signal sum       : unsigned (15 downto 0);

begin
    uut: adder
        port map(
            in0 => in0,
            in1 => in1,
            sum => sum
        );
    
    process
    begin
        in0 <= "1111111111111111"; in1 <= "0000000000000001"; wait for 50 ns;
        in0 <= "1111111111111110"; in1 <= "0000000000000001"; wait for 50 ns;
        wait;
    end process;
end architecture;
