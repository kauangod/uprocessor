library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk      : in std_logic;
        reset    : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(6 downto 0) := (others => '0');
        data_out : out unsigned(6 downto 0) := (others => '0')
    );
end entity;

architecture a_PC of PC is
    signal registro : unsigned(6 downto 0) := "0000000";
begin
    process(clk, reset, wr_en)
    begin
        if reset = '1' then
            registro <= "0000000";
        elsif wr_en = '1' then
            if rising_edge(clk) then
                registro <= data_in;
            end if;
        end if;
    end process;
    data_out <= registro;
end architecture;