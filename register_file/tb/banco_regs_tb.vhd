library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_regs_tb is
end entity;

architecture a_banco_regs_tb of banco_regs_tb is
    component banco_regs is
        port(
            clk       : in std_logic;
            reset     : in std_logic;
            wr_enable : in std_logic;
            reg_r     : in unsigned(2 downto 0);
            reg_wr    : in unsigned(2 downto 0);
            data_wr   : in unsigned(15 downto 0);
            data_out   : out unsigned(15 downto 0) := x"0000"
        );
    end component;

    constant period_time             : time        := 100 ns;
    signal   finished                : std_logic := '0';
    signal   clk, reset              : std_logic;
    signal   wr_en                   : std_logic;
    signal   data_in, data_out       : unsigned(15 downto 0);
    signal   reg_r, reg_wr           : unsigned(2 downto 0);

begin
    uut: banco_regs
    port map (
        clk => clk,
        reset => reset,
        wr_enable => wr_en,
        reg_r => reg_r,
        reg_wr => reg_wr,
        data_wr => data_in,
        data_out => data_out
    );

    reset_global: process
    begin
        reset <= '1';
        wait for period_time * 2;
        reset <= '0';
        wait;
    end process;

    sim_time_proc: process
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process;

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time / 2;
            clk <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process;

    process 
    begin 
        -- Inicialização
        wait for 200 ns;
        wr_en <= '0';
        reg_r <= "000";
        reg_wr <= "000";
        data_in <= (others => '0');
        
        -- Teste 1: Escrita no registrador 0
        wait for 100 ns;
        wr_en <= '1';
        reg_wr <= "000";  -- Reg0
        data_in <= x"AA55";  -- 1010101001010101
        
        -- Teste 2: Leitura do registrador 0
        wait for 100 ns;
        wr_en <= '0';
        reg_r <= "000";
        
        -- Teste 3: Escrita no registrador 3 (011)
        wait for 100 ns;
        wr_en <= '1';
        reg_wr <= "011";
        data_in <= x"FF00";  -- 1111111100000000
        
        -- Teste 4: Leitura do registrador 3
        wait for 100 ns;
        wr_en <= '0';
        reg_r <= "011";
        
        -- Teste 5: Escrita no registrador 7 (111)
        wait for 100 ns;
        wr_en <= '1';
        reg_wr <= "111";
        data_in <= x"DEAD";  -- 1101111010101101
        
        -- Teste 6: Leitura do registrador 7
        wait for 100 ns;
        wr_en <= '0';
        reg_r <= "111";
        
        -- Teste 7: Tentativa de escrita com wr_en desabilitado
        wait for 100 ns;
        wr_en <= '0';
        reg_wr <= "001";
        data_in <= x"BEEF";
        
        -- Teste 8: Leitura do registrador 1 (não deve ter mudado)
        wait for 100 ns;
        reg_r <= "001";
        
        wait;
    end process;
end architecture a_banco_regs_tb;