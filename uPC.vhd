library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.all;

entity uPC is
  
  port(
    Clk, reset: in std_logic;
    Q : out std_logic_vector(2 downto 0)
  );
  
end uPC;

architecture behave of uPC is
  signal count : std_logic_vector(2 downto 0) := "000";
  
begin
  process(Clk, reset)
    begin
      if reset = '1' then
        count <= "000";
        
      elsif rising_edge(Clk) then
        if count = "100" then
          count <= "000";
        else count <= count + 1;
        end if;
      end if;
      
    end process;
    
    Q <= count;
  end behave;
      