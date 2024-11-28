library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
  port (
    clk       : in std_logic;
    reset     : in std_logic;
    state_now : out unsigned (1 downto 0) := (others => '0')
    -- wr_en_acum   : in std_logic;
    -- wr_en_banco  : in std_logic;
    -- in_top       : in unsigned(15 downto 0) := (others => '0');
    -- sel_op       : in unsigned(1 downto 0) := (others => '0');
    -- reg_r_banco  : in unsigned(2 downto 0) := (others => '0');
    -- reg_wr_banco : in unsigned(2 downto 0) := (others => '0')
  );
end entity;

architecture a_processador of processador is
  component ULA
    port (
      in0, in1                 : in unsigned(15 downto 0)  := (others => '0');
      sel                      : in unsigned(1 downto 0)   := (others => '0');
      saida                    : out unsigned(15 downto 0) := (others => '0');
      overflow, negative, zero : out std_logic
    );
  end component;
  component acumulador
    port (
      clk      : in std_logic;
      reset    : in std_logic;
      wr_en    : in std_logic;
      data_in  : in unsigned(15 downto 0)  := (others => '0');
      data_out : out unsigned(15 downto 0) := (others => '0')
    );
  end component;
  component banco_regs is
    port (
      clk       : in std_logic;
      reset     : in std_logic;
      wr_enable : in std_logic;
      reg_r     : in unsigned(2 downto 0)   := (others => '0');
      reg_wr    : in unsigned(2 downto 0)   := (others => '0');
      data_wr   : in unsigned(15 downto 0)  := (others => '0');
      data_out  : out unsigned(15 downto 0) := (others => '0')
    );
  end component;
  component PC
    port (
      clk      : in std_logic;
      reset    : in std_logic;
      wr_en    : in std_logic;
      data_in  : in unsigned(6 downto 0)  := (others => '0');
      data_out : out unsigned(6 downto 0) := (others => '0')
    );
  end component;
  component rom
    port (
      clk     : in std_logic;
      address : in unsigned(6 downto 0)   := (others => '0');
      data    : out unsigned(16 downto 0) := (others => '0')
    );
  end component;
  component UC
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
      state       : out unsigned(1 downto 0)
    );
  end component;
  component instruction_reg
    port (
      clk      : in std_logic;
      reset    : in std_logic;
      wr_en    : in std_logic;
      data_in  : in unsigned(16 downto 0)  := (others => '0');
      data_out : out unsigned(16 downto 0) := (others => '0')
    );
  end component;

  signal out_ula, imm, in_acum, banco_data_in, banco_data_out, out_acum     : unsigned(15 downto 0) := (others => '0');
  signal in_pc, out_pc, out_add1                                            : unsigned(6 downto 0)  := (others => '0');
  signal jump, ld, pc_wr_en, ir_wr_en, acum_wr_en, mov, banco_wr_en, ula_op : std_logic             := '0';
  signal out_rom, out_inst_reg                                              : unsigned(16 downto 0) := (others => '0');
  signal rd, rs, banco_reg_r, banco_reg_wr                                  : unsigned(2 downto 0)  := (others => '0');
  signal ula_op_s                                                           : unsigned(1 downto 0)  := (others => '0');
  signal state                                                              : unsigned(1 downto 0)  := (others => '0');
begin
  ULA0 : ULA
  port map
  (
    in0   => banco_data_out,
    in1   => out_acum,
    sel   => ula_op_s,
    saida => out_ula
  );
  banco_regs0 : banco_regs
  port map
  (
    clk       => clk,
    reset     => reset,
    wr_enable => banco_wr_en,
    reg_r     => banco_reg_r,
    reg_wr    => banco_reg_wr,
    data_wr   => banco_data_in,
    data_out  => banco_data_out
  );
  acumulador0 : acumulador
  port map
  (
    clk      => clk,
    reset    => reset,
    wr_en    => acum_wr_en,
    data_in  => in_acum,
    data_out => out_acum
  );
  PC0 : PC
  port map
  (
    clk      => clk,
    reset    => reset,
    wr_en    => pc_wr_en,
    data_in  => in_pc,
    data_out => out_pc
  );
  rom0 : rom
  port map
  (
    clk     => clk,
    address => out_PC,
    data    => out_rom
  );
  UC0 : UC
  port map
  (
    clk         => clk,
    reset       => reset,
    instruction => out_inst_reg,
    pc_wr_en    => pc_wr_en,
    ir_wr_en    => ir_wr_en,
    rs          => rs,
    rd          => rd,
    imm         => imm,
    ld          => ld,
    jump        => jump,
    mov         => mov,
    ula_op      => ula_op,
    ula_op_sel  => ula_op_s,
    state       => state
  );
  inst_reg0 : instruction_reg
  port map
  (
    clk      => clk,
    reset    => reset,
    wr_en    => ir_wr_en,
    data_in  => out_rom,
    data_out => out_inst_reg
  );

  in_pc <= imm(6 downto 0) when jump = '1' else
    out_pc + 1;

  in_acum <= imm when ld = '1' and rd = "111" else
    banco_data_out when mov = '1' and rd = "111" else
    out_ula;

  acum_wr_en <= '1' when (ld = '1' or mov = '1' or ula_op = '1') and rd = "111" else
    '0';

  banco_wr_en <= '1' when (ld = '1' or mov = '1') and rd /= "111" else
    '0';

  banco_data_in <= imm when ld = '1' and rd /= "111" else
    out_acum when mov = '1' and rs = "111" else
    banco_data_out when mov = '1' and rs /= "111" else
    (others => '0');

  banco_reg_wr <= rd when (ld = '1' or mov = '1') and rd /= "111" else
    (others => '0');

  banco_reg_r <= rs when (mov = '1' or ula_op = '1') and rs /= "111" else
    (others => '0');

  state_now <= state;
end architecture;
