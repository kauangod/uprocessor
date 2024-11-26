library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port(
        clk     : in std_logic;
        address : in unsigned(6 downto 0) := (others => '0');
        data    : out unsigned(16 downto 0) := (others => '0')
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant rom_content : mem := (
        0  => B"0000011_000000_0011", --jump
        1  => B"0000000000000_0000", --nop
        2  => B"0000000000000_0000", --nop
        3  => B"0000000000000_0000", --nop
        4  => B"0000001111_000_0001", --ld
        5  => B"0000000001_111_0001", --ld
        6  => B"0000_000_100_010_0010", --mov
        7  => B"0000_111_100_001_0010", --mov
        8  => B"0000001111_110_0001", --ld
        9  => B"0000_110_100_111_0010", --mov
        10 => B"0000000000000_0000", --nop
        11 => B"0000000000000_0000", --nop
        12 => B"0001010_000000_0011", --jump
        13 => B"0000000000000_0000", --nop
        14 => B"0000000000000_0000", --nop
        15 => B"0000000000000_0000", --nop
        others => (others => '0')
    );

begin
    process (clk)
    begin
        if(rising_edge(clk)) then
            data <= rom_content(to_integer(address));
        end if;
    end process;
end architecture;