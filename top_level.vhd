library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is 
    port(
        clk          : in std_logic;
        reset_acum   : in std_logic;
        reset_banco  : in std_logic;
        wr_en_acum   : in std_logic;
        wr_en_banco  : in std_logic;
        in_top       : in unsigned(15 downto 0);
        sel_op       : in unsigned(1 downto 0);
        reg_r_banco  : in unsigned(2 downto 0);
        reg_wr_banco : in unsigned(2 downto 0)
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
    component banco_regs is
        port(
            clk       : in std_logic;
            reset     : in std_logic;
            wr_enable : in std_logic;
            reg_r     : in unsigned(2 downto 0);
            reg_wr    : in unsigned(2 downto 0);
            data_wr   : in unsigned(15 downto 0);
            data_out  : out unsigned(15 downto 0) := x"0000"
        );
    end component;
    signal saida_ula, in0_ula, in1_ula : unsigned(15 downto 0) := (others=>'0');

    begin
    ULA0: ULA
        port map(
            in0 => in0_ula,
            in1 => in1_ula,
            sel => sel_op,
            saida => saida_ula
        );
     banco_regs0: banco_regs
        port map(
            clk => clk,
            reset => reset_banco,
            wr_enable => wr_en_banco,
            reg_r => reg_r_banco,
            reg_wr => reg_wr_banco,
            data_wr => in_top,
            data_out => in0_ula
        );
    acumulador0: acumulador
        port map(
            clk => clk,
            reset => reset_acum,
            wr_en => wr_en_acum,
            data_in => saida_ula,
            data_out => in1_ula
        );

end architecture;
