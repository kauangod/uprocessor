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
        2  => B"0000_001_100_111_0010", --mov r1 pro a
        3  => B"0000_111_111_011_0010", --sw a no endereço do r3 
        4  => B"0000000001_111_0001", --ld 1 no a
        5  => B"0000001000_001_0001", --ld 8 no r1
        6  => B"0000_111_111_001_0010", --sw a no endereço do r1 
        7  => B"0000_011_110_111_0010",  --lw do dado no endereço guardado no r3 pro a
        8  => B"0000_001_110_111_0010",  --lw do dado no endereço guardado no r1 pro a
        -- 0  => B"0000000000_011_0001", --ld 0 no R3
        -- 1  => B"0000000000_100_0001", --ld 0 no R4
        -- 2  => B"0000_011_100_111_0010", --mov R3 para A
        -- 3  => B"0000_100_000_111_0010", --add R4 com A
        -- 4  => B"0000_111_100_100_0010", --mov A para R4
        -- 5  => B"0000000001_111_0001",  -- ld 1 no A
        -- 6  => B"0000_011_000_111_0010", -- add R3 com A(1)
        -- 7  => B"0000_111_100_011_0010", --mov A para R3
        -- 8  => B"0011101_001_000_0011", --CMPI 29
        -- 9  => B"1111001_010_000_0011", --BLE -7
        -- 10 => B"0000_100_100_111_0010", --mov R4 para A
        -- 11 => B"0000_111_100_101_0010", --mov A para R5
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