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
        0  => B"0000011_000000_0011", --Jump
        1  => B"0000000000000_0000", --NOP
        2  => B"0000000000000_0000", --NOP
        3  => B"0000000000000_0000", --NOP
        4  => B"0000001111_000_0001", --LD
        5  => B"0000000001_001_0001", --LD
        6  => B"0000000001_111_0001", --LD
        7  => B"0000000000000_0000", --NOP
        8  => B"0000000000000_0000", --NOP
        9  => B"0000111_000000_0011", --Jump
        10 => B"0000000000000_0000", --NOP
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