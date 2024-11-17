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
        0  => "11110000000001010",
        1  => "11110100000001001",
        2  => "11110000000001000",
        3  => "11110000000000111",
        4  => "00000000000000000",
        5  => "11110000000000101",
        6  => "00000000000000000",
        7  => "11110000000000100",
        8  => "11110000000000011",
        9  => "11110000000000010",
        10 => "11110000000000001",
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