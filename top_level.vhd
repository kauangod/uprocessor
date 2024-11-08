library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is 
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        wr_en_acum  : in std_logic;
        wr_en_banco : in std_logic;
        in_top      : in unsigned(15 downto 0);
        sel         : in unsigned(1 downto 0);
        saida       : out unsigned(15 downto 0)
    );
end entity;

architecture a_top_level of top_level is
    component ULA
        port(
            in0, in1                 : in unsigned(15 downto 0);
            sel                      : in unsigned(1 downto 0);
            saida                    : out unsigned(15 downto 0);
            overflow, negative, zero : out std_logic
        );
    end component;
    component acumulador
        port(
            clk      : in std_logic;
            reset    : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    -- banco
    signal saida_ula, in0_ula, in1_ula : unsigned(15 downto 0) := (others=>'0');

    begin
    ULA0: ULA
        port map(
            in0 => in0_ula,
            in1 => in1_ula,
            sel => sel,
            saida => saida_ula
        );
    acumulador0: acumulador
        port map(
            clk => clk,
            reset => reset,
            wr_en => wr_en_acum,
            data_in => saida_ula,
            data_out => in1_ula
        );

    end architecture;
