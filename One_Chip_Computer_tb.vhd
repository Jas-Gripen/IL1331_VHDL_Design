library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.all;

entity One_Chip_Computer_tb is
  -- default value generic map
  generic (
           N: integer := 16; -- bits in registers / IR
           M: integer := 3
          );
end One_Chip_Computer_tb;

architecture behavioral of One_Chip_Computer_tb is
  
  component One_Chip_Computer is
  generic (
           N: integer;  -- number of bits in regs
           M: integer
          );
          
  port(
    Clk, reset_in : in std_logic;
    gpio_out : out std_logic_vector (7 downto 0)
  ); 
  end component;
  
  signal Clk : std_logic ;
  signal reset_in : std_logic := '0';
  signal gpio_out : std_logic_vector (7 downto 0);
 
  constant clk_period : time := 2 ns;
  
  
begin
  
  DUT: One_Chip_Computer
  generic map (
               N => N,
               M => M
               )
  port map(
    reset_in  => reset_in,
    Clk       => Clk,
    gpio_out  => gpio_out
    );
        
		Clk_process : process
		begin
		  Clk <= '0';
			wait for Clk_period/2;
			Clk <= '1';
			wait for Clk_period/2;
		end process;
		
		test_process : process
		begin
		  reset_in <= '1';
		  wait for 10 ns;
		  reset_in <= '0';
		  wait for 1000 us;
		 end process; 
end architecture;