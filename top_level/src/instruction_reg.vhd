library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_reg is
  port (
    clk      : in std_logic;
    wr_en    : in std_logic;
    reset    : in std_logic;
    data_in  : in unsigned(16 downto 0) := (others => '0');
    data_out : out unsigned(16 downto 0) := (others => '0')
  );
end entity;

architecture a_instruction_reg of instruction_reg is
    signal register_s : unsigned(16 downto 0) := "00000000000000000";
begin
    process (clk, reset, wr_en)
    begin
      if reset = '1' then
        register_s <= "00000000000000000";
      elsif wr_en = '1' then
        if rising_edge(clk) then
          register_s <= data_in;
        end if;
      end if;
    end process;
    data_out <= register_s;
end architecture;