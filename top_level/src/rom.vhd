library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
  port (
    clk     : in std_logic;
    address : in unsigned(6 downto 0)   := (others => '0');
    data    : out unsigned(16 downto 0) := (others => '0')
  );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant rom_content : mem := (
      0  => B"0000000001_111_0001", --ld 1 A
      1  => B"0000000001_000_0001", --ld 1 r0
      2  => B"0000000001_001_0001", --ld 1 r1
      3  => B"0000000101_010_0001", --ld 5 r2

      4  => B"0000_000_100_111_0010", --mov r0 A                       
      5  => B"0000_111_111_000_0010", --sw A, r0 - insert
      6  => B"0000_001_000_111_0010", --add A, r1
      7  => B"0000_111_100_000_0010", --mov A r0
      8  => B"0000_010_011_111_0010", --slr r2
      9  => B"0000000_001_000_0011", --cmpi 0 
      10 => B"1111010_010_000_0011", --ble -6 (insert)

      others => (others => '0')
    );

begin
    process (clk)
    begin
      if (rising_edge(clk)) then
        data <= rom_content(to_integer(address));
      end if;
    end process;
end architecture;