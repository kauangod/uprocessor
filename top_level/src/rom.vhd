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
        0  => B"0000000111_011_0001", --ld 7 no r3
        1  => B"0001111111_001_0001", --ld 127 no r1
        2  => B"0001110101_010_0001", --ld 117 no r2
        3  => B"0001100100_100_0001", --ld 100 no r4
        4  => B"0000000110_110_0001", --ld 6 no r6
        5  => B"0000010001_000_0001", --ld 17 no r0
        6  => B"0000010110_101_0001", --ld 22 no r5
        7  => B"0000_001_100_111_0010", --mov r1 pro a
        8  => B"0000_111_111_011_0010", --sw a no endereço do r3
        9  => B"0000_011_100_111_0010", --mov r3 pro a
        10 => B"0000_111_111_001_0010", --sw a no endereço do r1
        11 => B"0000_010_100_111_0010", --mov r2 pro a
        12 => B"0000_111_111_100_0010", --sw a no endereço do r4
        13 => B"0000_100_100_111_0010", --mov r4 pro a
        14 => B"0000_111_111_010_0010", --sw a no endereço do r2
        15 => B"0000_110_100_111_0010", --mov r6 pro a
        16 => B"0000_111_111_000_0010", --sw a no endereço do r0
        17 => B"0000_000_100_111_0010", --mov r0 pro a
        18 => B"0000_111_111_110_0010", --sw a no endereço do r6
        19 => B"0000_101_100_111_0010", --mov r5 pro a
        20 => B"0000_111_111_101_0010", --sw a no endereço do r5
        21 => B"0_0000_0000_0000_0000", --nop
        22 => B"0000_000_110_111_0010",  --lw do dado no endereço guardado no r0 pro a
        23 => B"0000_001_110_111_0010",  --lw do dado no endereço guardado no r1 pro a
        24 => B"0000_010_110_111_0010",  --lw do dado no endereço guardado no r2 pro a
        25 => B"0000_011_110_111_0010",  --lw do dado no endereço guardado no r3 pro a
        26 => B"0000_100_110_111_0010",  --lw do dado no endereço guardado no r4 pro a
        27 => B"0000_101_110_111_0010",  --lw do dado no endereço guardado no r5 pro a
        28 => B"0000_110_110_111_0010",  --lw do dado no endereço guardado no r6 pro a
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