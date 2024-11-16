library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
    port(
        clk         : in std_logic;
        reset       : in std_logic;
        instruction : in unsigned(16 downto 0) := (others => '0');
        wr_en_pc    : out std_logic;
        jump_en     : out std_logic;
        jump_addr   : out unsigned(6 downto 0) := (others => '0')
    );
end entity;

architecture a_UC of UC is
    component state_machine is
        port(
            clk   : in std_logic;
            reset : in std_logic;
            state : out std_logic
        );
    end component;

    signal opcode : unsigned(3 downto 0) := (others => '0');
    signal state  : std_logic := '0';

begin 
    st_mach: state_machine
        port map (
            clk   => clk,
            reset => reset,
            state => state
        );
        
    opcode <= instruction(16 downto 13) when state = '0' and reset = '0' else
              "0000";

    jump_en <= '1' when opcode = "1111" and state = '0' and reset = '0' else --jump
               '0'; 
    jump_addr <= instruction(6 downto 0) when opcode = "1111" and reset = '0' else
                 "0000000";

    wr_en_PC <= not state;
    
end architecture;
