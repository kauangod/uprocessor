library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux16b is
	port(
		entr0 : in unsigned(15 downto 0);
		entr1 : in unsigned(15 downto 0);
		entr2 : in unsigned(15 downto 0);
		entr3 : in unsigned(15 downto 0);
		sel   : in unsigned(1 downto 0);
		saida : out unsigned (15 downto 0) := (others => '0')
	);
	end entity;
	
architecture a_mux16b of mux16b is
begin
	saida <= entr0 when sel = "00" else
	         entr1 when sel = "01" else
	         entr2 when sel = "10" else
	         entr3 when sel = "11" else
			 "0000000000000000";
end architecture;