library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ULA is
    port(
        in0, in1                  : in unsigned(15 downto 0);
        sel                       : in unsigned(1 downto 0);
        saida                     : out unsigned(15 downto 0);
        overflow, negative, zero  : out std_logic
    );
end entity;

architecture a_ULA of ULA is
    component subtractor is
        port(
            in0, in1 : in unsigned(15 downto 0);
            sub      : out unsigned(15 downto 0)
        );
    end component;
    component adder is
        port(
            in0, in1 : in unsigned(15 downto 0);
            sum      : out unsigned(15 downto 0)
        );
    end component;
    component mux16b is
        port(
            entr0, entr1 : in unsigned(15 downto 0);
            sel          : in unsigned(1 downto 0);
            saida        : out unsigned(15 downto 0)
        );
    end component;
    signal sum, sub, mux_out : unsigned(15 downto 0);
    signal of_sum, of_sub    : std_logic;

    begin
    adder0: adder 
        port map(
            in0 => in0,
            in1 => in1,
            sum => sum
        );
    subtractor0: subtractor 
        port map(
            in0 => in0,
            in1 => in1,
            sub => sub
        ); 
    mux0: mux16b 
        port map(
            entr0 => sum,
            entr1 => sub,
            sel => sel,
            saida => mux_out
        );

    saida <= mux_out;

    negative <= mux_out(15);

    zero <= '1' when mux_out = "0000000000000000" else
            '0';

    of_sum <= '1' when (in0(15) = in1(15) and mux_out(15) /= in0(15)) else 
              '0';
    of_sub <= '1' when (in0(15) /= in1(15) and mux_out(15) = in0(15)) else 
              '0';

    overflow <= of_sum when sel = "00" else
                of_sub when sel = "01" else
                '0';
end architecture;