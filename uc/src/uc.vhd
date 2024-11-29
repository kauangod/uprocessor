library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UC is
  port (
    clk         : in std_logic;
    reset       : in std_logic;
    instruction : in unsigned(16 downto 0) := (others => '0');
    pc_wr_en    : out std_logic;
    ir_wr_en    : out std_logic;
    rs          : out unsigned(2 downto 0)  := (others => '0');
    rd          : out unsigned(2 downto 0)  := (others => '0');
    imm         : out unsigned(15 downto 0) := (others => '0');
    ld          : out std_logic;
    jump        : out std_logic;
    mov         : out std_logic;
    ula_op_sel  : out unsigned(1 downto 0) := (others => '0');
    ula_op      : out std_logic;
    state       : out unsigned(1 downto 0) := (others => '0')
  );
end entity;

architecture a_UC of UC is
    component state_machine is
      port (
        clk   : in std_logic;
        reset : in std_logic;
        state : out unsigned(1 downto 0)
      );
    end component;

    signal opcode  : unsigned(3 downto 0) := (others => '0');
    signal funct   : unsigned(2 downto 0) := (others => '0');
    signal state_s : unsigned(1 downto 0) := (others => '0');

begin
    st_mach : state_machine
    port map
    (
      clk   => clk,
      reset => reset,
      state => state_s
    );

    opcode <= instruction(3 downto 0);

    funct <= instruction(9 downto 7) when (opcode = "0010" or opcode = "0100");

    rd <= instruction(6 downto 4);

    rs <= instruction(12 downto 10);

    imm <= (15 downto 10 => instruction(16)) & instruction(16 downto 7) when opcode = "0001" else --LD
        (15 downto 7 => instruction(16)) & instruction(16 downto 10) when opcode = "0011" else --Jump
        "0000000000000000";

    ld <= '1' when opcode = "0001" and state_s = "01" else
      '0';

    jump <= '1' when opcode = "0011" and state_s = "01" else
        '0';

    mov <= '1' when opcode = "0010" and funct = "100" else
        '0';

    ula_op <= '1' when opcode = "0010" else
          '0';

    ula_op_sel <= funct (1 downto 0) when opcode = "0010" else
              "00";

    PC_wr_en <= '1' when state_s = "01" else
            '0';

    ir_wr_en <= '1' when state_s = "00" else
            '0';

    state <= state_s;

end architecture;
