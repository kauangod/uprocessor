library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PSW is
    port(
        clk   : in std_logic;
        reset : in std_logic;
        wr_en : in std_logic;
        V_in  : in std_logic;
        Z_in  : in std_logic;
        N_in  : in std_logic;
        V_out : out std_logic;
        Z_out : out std_logic;
        N_out : out std_logic
    );
end entity;

architecture a_PSW of PSW is 
begin
    process(clk, reset, wr_en)
    begin
        if reset = '1' then
            V_out <= '0';
            Z_out <= '0';
            N_out <= '0';
        elsif wr_en = '1' then
            if rising_edge(clk) then
                V_out <= V_in;
                Z_out <= Z_in;
                N_out <= N_in;
            end if;
        end if;
    end process;
end architecture;

