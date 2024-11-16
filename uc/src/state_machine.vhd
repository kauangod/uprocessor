library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is 
    port(
        clk      : in std_logic;
        reset    : in std_logic;
        data_out : out std_logic := '0'
    );
end entity;

architecture a_state_machine of state_machine is
    signal state : std_logic := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= '0';
        elsif reset = '0' then
            if rising_edge(clk) then
                state <= not state;
            end if;
        end if;
    end process;
    
    data_out <= state;
end architecture;