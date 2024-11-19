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
        0  => "00010000000000011",
        1  => "00010000000000000",
        2  => "00010000000000000",
        3  => "11110000000000111",
        4  => "00010000000000000",
        5  => "00010000000000000",
        6  => "00010111100000011",
        7  => "00010000000000000",
        8  => "00010000000000000",
        9  => "11110000000000111",
        10 => "00010000000000000",
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