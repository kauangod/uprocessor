library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs is 
    port(
        clk       : in std_logic;
        reset     : in std_logic;
        wr_enable : in std_logic;
        reg_r     : in unsigned(2 downto 0);
        reg_wr    : in unsigned(2 downto 0);
        data_wr   : in unsigned(15 downto 0);
        data_out   : out unsigned(15 downto 0) := x"0000"
    );
end entity;

architecture a_banco_regs of banco_regs is
    component reg16bits is
        port(
            clk      : in std_logic;
            reset    : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
    component mux3bits is
        port(
            entr0 : in unsigned(15 downto 0);
            entr1 : in unsigned(15 downto 0);
            entr2 : in unsigned(15 downto 0);
            entr3 : in unsigned(15 downto 0);
            entr4 : in unsigned(15 downto 0);
            entr5 : in unsigned(15 downto 0);
            entr6 : in unsigned(15 downto 0);
            sel   : in unsigned(2 downto 0);
            saida : out unsigned(15 downto 0)
        );
    end component;
    
    signal saida_reg0, saida_reg1, saida_reg2, saida_reg3, saida_reg4, saida_reg5, saida_reg6, mux0_out : unsigned (15 downto 0);
    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6 : std_logic;

    begin

    wr_en0 <= wr_enable and (not reg_wr(0)) and (not reg_wr(1)) and (not reg_wr(2));
    wr_en1 <= wr_enable and (reg_wr(0)) and (not reg_wr(1)) and (not reg_wr(2));
    wr_en2 <= wr_enable and (not reg_wr(0)) and (reg_wr(1)) and (not reg_wr(2));
    wr_en3 <= wr_enable and (reg_wr(0)) and (reg_wr(1)) and (not reg_wr(2));
    wr_en4 <= wr_enable and (not reg_wr(0)) and (not reg_wr(1)) and (reg_wr(2));
    wr_en5 <= wr_enable and (reg_wr(0)) and (not reg_wr(1)) and (reg_wr(2));
    wr_en6 <= wr_enable and (not reg_wr(0)) and (reg_wr(1)) and (reg_wr(2));

    reg0: reg16bits
        port map (
            clk => clk,
            reset => reset,
            wr_en => wr_en0,
            data_in => data_wr,
            data_out => saida_reg0
        );
    reg1: reg16bits
        port map(
            clk => clk,
            reset => reset,
            wr_en => wr_en1,
            data_in => data_wr,
            data_out => saida_reg1
        );
    reg2: reg16bits
        port map (
            clk => clk,
            reset => reset,
            wr_en => wr_en2,
            data_in => data_wr,
            data_out => saida_reg2
        );
    reg3: reg16bits
        port map (
            clk => clk,
            reset => reset,
            wr_en => wr_en3,
            data_in => data_wr,
            data_out => saida_reg3
        );
    reg4: reg16bits
        port map (
            clk => clk,
            reset => reset,
            wr_en => wr_en4,
            data_in => data_wr,
            data_out => saida_reg4
        );
    reg5: reg16bits
        port map (
            clk => clk,
            reset => reset,
            wr_en => wr_en5,
            data_in => data_wr,
            data_out => saida_reg5
        );
    reg6: reg16bits
        port map (
            clk => clk,
            reset => reset,
            wr_en => wr_en6,
            data_in => data_wr,
            data_out => saida_reg6
        );
    mux0: mux3bits 
        port map (
            entr0 => saida_reg0,
            entr1 => saida_reg1,
            entr2 => saida_reg2,
            entr3 => saida_reg3,
            entr4 => saida_reg4,
            entr5 => saida_reg5,
            entr6 => saida_reg6,
            sel => reg_r,
            saida => mux0_out
        );
    
    data_out <= mux0_out;
end architecture;
    