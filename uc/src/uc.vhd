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
      ble         : out std_logic;
      bmi         : out std_logic;
      jump        : out std_logic;
      mov         : out std_logic;
      cmpr        : out std_logic;
      cmpi        : out std_logic;
      lw          : out std_logic;
      sw          : out std_logic;
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

    signal opcode         : unsigned(3 downto 0) := (others => '0');
    signal funct          : unsigned(2 downto 0) := (others => '0');
    signal state_s        : unsigned(1 downto 0) := (others => '0');
    signal cmpr_s, cmpi_s : std_logic := '0';

begin
    st_mach : state_machine
    port map
    (
      clk   => clk,
      reset => reset,
      state => state_s
    );


    PC_wr_en <= '1' when state_s = "01" else
                '0';

    ir_wr_en <= '1' when state_s = "00" else
                '0';

    state <= state_s;

    opcode <= instruction(3 downto 0);

    funct <= instruction(9 downto 7);

    rd <= instruction(6 downto 4);

    rs <= instruction(12 downto 10);

    imm <= (15 downto 10 => instruction(16)) & instruction(16 downto 7) when opcode = "0001" else --LD
           (15 downto 7 => instruction(16)) & instruction(16 downto 10) when opcode = "0011" else --jump, cmpi, ble, bmi
           "0000000000000000";

    ld <= '1' when opcode = "0001" and state_s = "01" else
          '0';

    ula_op <= '1' when opcode = "0010" and (funct = "000" or funct = "001" or funct = "010" or funct = "011") and state_s = "01" else
              '0';

    ula_op_sel <= funct (1 downto 0) when opcode = "0010" and state_s = "01" else
                  "01" when cmpr_s = '1' or cmpi_s = '1' else
                  "00";

    mov <= '1' when opcode = "0010" and funct = "100" and state_s = "01" else
           '0';

    cmpr_s <= '1' when opcode = "0010" and funct = "101" and state_s = "01" else
              '0';

    cmpr <= cmpr_s;

    lw <= '1' when opcode = "0010" and funct = "110" and state_s = "01" else
          '0';

    sw <= '1' when opcode = "0010" and funct = "111" and state_s = "01" else
          '0';

    jump <= '1' when opcode = "0011" and funct = "000" and state_s = "01" else
            '0';

    ble <= '1' when opcode = "0011" and funct = "010" and state_s = "01" else
           '0';

    bmi <= '1' when opcode = "0011" and funct = "011" and state_s = "01" else
           '0';

    cmpi_s <= '1' when opcode = "0011" and funct = "001" and state_s = "01" else
              '0';

    cmpi <= cmpi_s;

end architecture;
