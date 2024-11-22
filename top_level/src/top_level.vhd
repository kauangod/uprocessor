library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        clk          : in std_logic;
        reset        : in std_logic;
        wr_en_acum   : in std_logic;
        wr_en_banco  : in std_logic;
        in_top       : in unsigned(15 downto 0) := (others => '0');
        sel_op       : in unsigned(1 downto 0) := (others => '0');
        reg_r_banco  : in unsigned(2 downto 0) := (others => '0');
        reg_wr_banco : in unsigned(2 downto 0) := (others => '0')
    );
end entity;

architecture a_top_level of top_level is
    component ULA
        port(
            in0, in1                 : in unsigned(15 downto 0) := (others => '0');
            sel                      : in unsigned(1 downto 0) := (others => '0');
            saida                    : out unsigned(15 downto 0) := (others => '0');
            overflow, negative, zero : out std_logic
        );
    end component;
    component acumulador
        port(
            clk      : in std_logic;
            reset    : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0) := (others => '0');
            data_out : out unsigned(15 downto 0) := (others => '0')
        );
    end component;
    component banco_regs is
        port(
            clk       : in std_logic;
            reset     : in std_logic;
            wr_enable : in std_logic;
            reg_r     : in unsigned(2 downto 0) := (others => '0');
            reg_wr    : in unsigned(2 downto 0) := (others => '0');
            data_wr   : in unsigned(15 downto 0) := (others => '0');
            data_out  : out unsigned(15 downto 0) := (others => '0')
        );
    end component;
    component PC
        port(
            clk      : in std_logic;
            reset    : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0) := (others => '0');
            data_out : out unsigned(6 downto 0) := (others => '0')
        );
    end component;
    component rom
        port(
            clk     : in std_logic;
            address : in unsigned(6 downto 0) := (others => '0');
            data    : out unsigned(16 downto 0) := (others => '0')
        );
    end component;
    component UC
        port(
            clk         : in std_logic;
            reset       : in std_logic;
            ir_wr_en    : out std_logic;
            wr_en_PC    : out std_logic;
            jump_en     : out std_logic;
            jump_addr   : out unsigned(6 downto 0) := (others => '0');
            instruction : in unsigned(16 downto 0) := (others => '0')
        );
    end component;
    component instruction_reg
        port(
            clk         : in std_logic;
            reset       : in std_logic;
            wr_en       : in std_logic;
            data_in     : in unsigned(16 downto 0)  := (others => '0');
            data_out    : out unsigned(16 downto 0) := (others => '0')
        );
    end component;

    signal out_ula, in0_ula, in1_ula     : unsigned(15 downto 0) := (others=>'0');
    signal in_PC, out_PC, out_add1       : unsigned(6 downto 0)  := (others=>'0');
    signal jump_en, wr_en_PC_s, ir_write : std_logic := '0';
    signal jump_addr                     : unsigned(6 downto 0) := (others=>'0');
    signal out_rom, out_inst_reg         : unsigned(16 downto 0) := (others=>'0');

    begin
    ULA0: ULA
        port map(
            in0 => in0_ula,
            in1 => in1_ula,
            sel => sel_op,
            saida => out_ula
        );
     banco_regs0: banco_regs
        port map(
            clk => clk,
            reset => reset,
            wr_enable => wr_en_banco,
            reg_r => reg_r_banco,
            reg_wr => reg_wr_banco,
            data_wr => in_top,
            data_out => in0_ula
        );
    acumulador0: acumulador
        port map(
            clk => clk,
            reset => reset,
            wr_en => wr_en_acum,
            data_in => out_ula,
            data_out => in1_ula
        );
    PC0: PC
        port map(
            clk => clk,
            reset => reset,
            wr_en => wr_en_PC_s,
            data_in => in_PC,
            data_out => out_PC
        );
    rom0: rom
        port map(
            clk => clk,
            address => out_PC,
            data => out_rom
        );
    UC0: UC
        port map(
            clk         => clk,
            reset       => reset,
            instruction => out_inst_reg,
            wr_en_PC    => wr_en_PC_s,
            jump_en     => jump_en,
            jump_addr   => jump_addr,
            ir_wr_en    => ir_write
        );
    inst_reg0 : instruction_reg
        port map (
            clk      => clk,
            reset    => reset,
            wr_en    => ir_write,
            data_in  => out_rom,
            data_out => out_inst_reg
        );

    in_PC <= jump_addr when jump_en = '1' else out_PC + 1;

end architecture;
