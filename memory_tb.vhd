library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.all;

entity memory_tb is
  generic (
           N: integer := 16 -- IR (register length)
            
          );
end memory_tb;

architecture behavioral of memory_tb is
  
  component memory is
  generic (
           N: integer  -- bits in registersIR (register length)
           );
          
  PORT(
  Din, Address : in std_logic_vector (N-1 downto 0);
  Clk, R_Wn : in std_logic;
  
  Q : out std_logic_vector(N-1 downto 0)
  ); 
  end component;
  
  signal Din : std_logic_vector (N-1 downto 0) := (others => '0');
  signal Clk : std_logic := '0';

  -- outputs
  signal Q, Address : std_logic_vector (N-1 downto 0);
  signal R_Wn : std_logic;

  constant clk_period : time := 10 ns;
  
  begin
  DUT: memory
  generic map (
               N => N
               )
  port map(
    Din => Din,
    Clk => Clk,
    Q => Q,
    Address => Address,
    R_Wn => R_Wn 
    );
  
  Clk_process : process
		begin
		  Clk <= '0';
			wait for Clk_period/2;
			Clk <= '1';
			wait for Clk_period/2;
		end process;
		
    memory_test : process
    begin  
    
      R_Wn <= '1';
      address <= (others => '0');
      Din <= (others => '0');
      
      wait for 3 ns;
      
      for i in 0 to 15 loop
        
        address <= address + 1;
        wait for 3 ns;
      end loop;
      
    end process;
  end architecture;