library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity;

architecture a_top_level_tb of top_level_tb is
    component top_level is
        port(
            clk          : in std_logic;
            reset        : in std_logic;
            wr_en_acum   : in std_logic;
            wr_en_banco  : in std_logic;
            wr_en_PC     : in std_logic;
            in_top       : in unsigned(15 downto 0) := (others => '0');
            sel_op       : in unsigned(1 downto 0) := (others => '0');
            reg_r_banco  : in unsigned(2 downto 0) := (others => '0');
            reg_wr_banco : in unsigned(2 downto 0) := (others => '0')
        ); 
    end component;

    constant period_time                                   : time := 100 ns;
    signal   finished                                      : std_logic := '0';
    signal   clk, reset, wr_en_acum, wr_en_banco, wr_en_PC : std_logic := '0';   
    signal   in_top                                        : unsigned(15 downto 0) := (others => '0');
    signal   sel_op                                        : unsigned(1 downto 0)  := (others => '0');
    signal   reg_r_banco, reg_wr_banco                     : unsigned(2 downto 0)  := (others => '0');
    signal   out_rom                                       : unsigned(16 downto 0) := (others => '0');
    
    begin
        uut: top_level
        port map(
            clk => clk,
            reset => reset,
            wr_en_acum => wr_en_acum,
            wr_en_banco => wr_en_banco,
            wr_en_PC => wr_en_PC,
            in_top => in_top,
            sel_op => sel_op,
            reg_r_banco => reg_r_banco,
            reg_wr_banco => reg_wr_banco
        );

    reset_global: process
    begin
        reset <= '1';
        wait for period_time * 2;
        reset <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process;
    
    process
    begin
        wait for 200 ns;
        wr_en_PC <= '1';
        wait for 100 ns;
        wait;
    end process;
end architecture;