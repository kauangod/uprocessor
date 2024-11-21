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
            state : out unsigned(1 downto 0)
        );
    end component;

    signal opcode         : unsigned(3 downto 0) := (others => '0');
    signal state          : unsigned(1 downto 0) := (others => '0');
    signal jump_en_s, nop : std_logic := '0';

begin
    st_mach: state_machine
        port map (
            clk   => clk,
            reset => reset,
            state => state
        );

    opcode <= instruction(16 downto 13) when state = "00" else
              "0000";

    nop <= '1' when opcode = "0001" and state = "00" else
           '0';

    jump_en_s <= '1' when opcode = "1111" and state = "00" else --jump
               '0';

    jump_addr <= instruction(6 downto 0) when opcode = "1111" else
                 "0000000";

    jump_en <= jump_en_s;

    wr_en_PC <= '1' when state = "00" and (jump_en_s = '1' or nop = '1') else
                '0';

end architecture;
