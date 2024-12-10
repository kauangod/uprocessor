library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is
    component processador is
      port (
        clk       : in std_logic;
        reset     : in std_logic;
        state_now : out unsigned(1 downto 0) := (others => '0')
      );
    end component;

    constant period_time : time                 := 100 ns;
    signal finished      : std_logic            := '0';
    signal clk, reset    : std_logic            := '0';
    signal state         : unsigned(1 downto 0) := (others => '0');

begin
    uut : processador
    port map
    (
      clk       => clk,
      reset     => reset,
      state_now => state
    );

    reset_global : process
    begin
      reset <= '1';
      wait for period_time * 2;
      reset <= '0';
      wait;
    end process;

    sim_time_proc : process
    begin
      wait for 80 us;
      finished <= '1';
      wait;
    end process;

    clk_proc : process
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
      wait;
    end process;
end architecture;