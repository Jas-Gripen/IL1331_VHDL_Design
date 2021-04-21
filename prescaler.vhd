library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.all;

entity prescaler is
  
  -- internal ports
  port (
   Clk_In : in std_logic;
   Clk_Out : out std_logic
   );
end prescaler;


architecture behavioral of prescaler is
    signal Clk_temp : std_logic :='0';
    signal counter : integer := 1;
begin
  
  process(Clk_In)
    begin
      
		if rising_edge(Clk_In) then
      if counter = 10 then --5000000 then
        Clk_temp <= not(Clk_temp);
        counter <= 1;
      
      else
        counter <= counter + 1;
      end if;
		end if;
    end process;
  Clk_Out <= Clk_temp;
end architecture;