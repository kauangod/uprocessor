library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port(
        clk     : in std_logic;
        reset   : in std_logic;
        pc_in   : in unsigned(15 downto 0);
        jump_en : out std_logic
    );
end entity;

architecture a_uc of uc is
    component state_machine is
        port(
            clk : in std_logic;
            reset : in std_logic;
            data_out : out std_logic
        );
    end component;
    component rom is
        port(
            clk     : in std_logic;
            address : in unsigned(6 downto 0);
            data    : out unsigned(16 downto 0)
        );
    end component;

    signal opcode   : unsigned(3 downto 0);
    signal state    : std_logic;
    signal instruction : unsigned(16 downto 0);
begin 
    st_mach: state_machine
        port map (
            clk      => clk,
            reset    => reset,
            data_out => state
        );
    rom0: rom 
        port map (
            clk     => clk,
            address => pc_in(6 downto 0),
            data    => instruction         
        );
        
    opcode <= instruction(16 downto 13) when state = '0' else
              "0000";
    jump_en <= '1' when opcode = "1111" else
               '0';
end architecture;
