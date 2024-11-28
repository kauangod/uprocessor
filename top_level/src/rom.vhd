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
  0  => B"0000000101_011_0001", --ld 5 no R3
  1  => B"0000001000_100_0001", --ld 8 no R4
  2  => B"0000_011_100_111_0010", --mov R3 para A
  3  => B"0000_100_000_111_0100", --add R4 com A
  4  => B"0000_111_100_101_0010", --mov A para R5
  5  => B"0000000001_111_0001", --ld 1 no A
  6  => B"0000_101_001_111_0100", --sub R5 com A
  7  => B"0000_111_100_101_0010", --mov A para R5
  8  => B"0010100_000000_0011", --jump para o end 20
  9  => B"0000000000_101_0001", --ld zero no R5
  10 => B"0000000000000_0000", --nop
  11 => B"0000000000000_0000", --nop
  12 => B"0000000000000_0000", --nop
  13 => B"0000000000000_0000", --nop
  14 => B"0000000000000_0000", --nop
  15 => B"0000000000000_0000", --nop
  16 => B"0000000000000_0000", --nop
  17 => B"0000000000000_0000", --nop
  18 => B"0000000000000_0000", --nop
  19 => B"0000000000000_0000", --nop
  20 => B"0000_101_100_011_0010", --mov R5 para R3
  21 => B"0000010_000000_0011", --jump para o end 2
  22 => B"0000000000_011_0001", --ld zero no R3
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