library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
    component rom 
        port(
            clk     : in std_logic;
            address : in unsigned(6 downto 0);
            data    : out unsigned(16 downto 0)
        );
    end component;

    constant period_time : time := 100 ns;
    signal finished      : std_logic := '0';
    signal clk           : std_logic;
    signal address       : unsigned(6 downto 0);
    signal data          : unsigned(16 downto 0);

begin
    uut: rom
    port map (
        clk => clk,
        address => address,
        data => data    
    );

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
        wait for 100 ns;
            address <= "0000000";
        wait for 100 ns;
            address <= "0000001";
        wait for 100 ns;
            address <= "0000010";
        wait for 100 ns;
            address <= "0000011";
        wait for 100 ns;
            address <= "0000100";
        wait for 100 ns;
            address <= "0000101";
        wait for 100 ns;
            address <= "0000110"; 
        wait for 100 ns;
            address <= "0000111";
        wait for 100 ns;
            address <= "0001000";
        wait for 100 ns;
            address <= "0001001";
        wait for 100 ns;
            address <= "0001010";
        wait;
    end process;
end architecture a_rom_tb;
