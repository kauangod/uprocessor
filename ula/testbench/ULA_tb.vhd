library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA_tb is
end entity;

architecture a_ULA_tb of ULA_tb is
    component ULA
        port(
            in0,in1                  : in unsigned(15 downto 0);
            sel                      : in unsigned(1 downto 0);
            saida                    : out unsigned(15 downto 0);
            overflow, negative, zero : out std_logic
        );
    end component;
    signal in0, in1, saida  : unsigned(15 downto 0);
    signal sel              : unsigned(1 downto 0);
    signal V, N, Z          : std_logic;

    begin
        uut: ULA port map(
            in0=>in0,
            in1=>in1,
            saida=>saida,
            sel=>sel,
            overflow=>V,
            negative=>N,
            zero=>Z
        );
    
    process
    begin
        in0<="0000000001111111";
        in1<="0001100000011111";
        sel<="00";
        wait for 50 ns;
        in0<="0000000001111111";
        in1<="0001100000011111";
        sel<="01";
        wait for 50 ns;
        in0<="0001100000011111";
        in1<="0001100000011111";
        sel<="01";
        wait for 50 ns;
        in0<="0111111111111111";
        in1<="0111111111111111";
        sel<="00";
        wait for 50 ns;
        in0<="1111111111111000";
        in1<="0011111111111111";
        sel<="01";
        wait for 50 ns;
        wait;
    end process;
end architecture;