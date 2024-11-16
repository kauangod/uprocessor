library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC_tb is
end entity;

architecture a_UC_tb of UC_tb is
    component UC
        port(
            clk         : in std_logic := '0';
            reset       : in std_logic := '0';
            instruction : in unsigned(16 downto 0) := (others => '0');
            wr_en_pc    : out std_logic := '0';
            jump_en     : out std_logic := '0';
            jump_addr   : out unsigned(6 downto 0) := (others => '0')
        );
    end component;

    signal clk, reset, wr_en_pc, jump_en : std_logic := '0';
    signal jump_addr : unsigned(6 downto 0) := (others => '0');    
    signal instruction : unsigned(16 downto 0) := (others => '0');
    constant period_time                                   : time := 100 ns;
    signal   finished                                      : std_logic := '0';
begin
    UC0: UC
        port map(
            clk => clk,
            reset => reset,
            instruction => instruction,
            wr_en_pc => wr_en_pc,
            jump_en => jump_en,
            jump_addr => jump_addr
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
end architecture;

