library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
    port(
        clk          : in std_logic;
        reset        : in std_logic
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
            clk           : in std_logic;
            reset         : in std_logic;
            instruction   : in unsigned(16 downto 0) := (others => '0');
            pc_wr_en      : out std_logic;
            ir_wr_en      : out std_logic;
            rd            : out unsigned(2 downto 0) := (others => '0');
            imm           : out unsigned(15 downto 0) := (others => '0');
            ld            : out std_logic;
            jump          : out std_logic
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

    signal out_ula, in0_ula, in1_ula, imm, in_acum  : unsigned(15 downto 0) := (others=>'0');
    signal in_pc, out_pc, out_add1                  : unsigned(6 downto 0)  := (others=>'0');
    signal jump, ld, pc_wr_en, ir_wr_en, acum_wr_en : std_logic := '0';
    signal out_rom, out_inst_reg                                 : unsigned(16 downto 0) := (others=>'0');
    signal rd, rs                                                : unsigned(2 downto 0)  := (others=>'0');
    signal ula_op                                                : unsigned(1 downto 0) := (others => '0');

    begin
    ULA0: ULA
        port map(
            in0 => in0_ula,
            in1 => in1_ula,
            sel => ula_op,
            saida => out_ula
        );
    banco_regs0: banco_regs
        port map(
            clk => clk,
            reset => reset,
            wr_enable => ld,
            reg_r => rs,
            reg_wr => rd,
            data_wr => imm,
            data_out => in0_ula
        );
    acumulador0: acumulador
        port map(
            clk => clk,
            reset => reset,
            wr_en => acum_wr_en,
            data_in => in_acum,
            data_out => in1_ula
        );
    PC0: PC
        port map(
            clk => clk,
            reset => reset,
            wr_en => pc_wr_en,
            data_in => in_pc,
            data_out => out_pc
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
            pc_wr_en    => pc_wr_en,
            ir_wr_en    => ir_wr_en,
            rd          => rd,
            imm         => imm,
            ld          => ld,
            jump        => jump
        );
    inst_reg0 : instruction_reg
        port map (
            clk      => clk,
            reset    => reset,
            wr_en    => ir_wr_en,
            data_in  => out_rom,
            data_out => out_inst_reg
        );

    in_pc <= imm(6 downto 0) when jump = '1' else out_pc + 1;

    in_acum <= imm when ld = '1' and rd = "111" else
               out_ula;
    
    acum_wr_en <= '1' when ld = '1' and rd = "111" else
                  '0';

end architecture;
