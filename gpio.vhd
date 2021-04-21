library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.all;

entity gpio is  

  generic (N: integer
          );

  port(
    Din: in std_logic_vector (N-1 downto 0);
    IE, OE : in std_logic;
    Clk, Reset : in std_logic;
  
    Dout : out std_logic_vector(N-1 downto 0)
  ); 
end gpio;

architecture behavioral of gpio is
  signal in_reg, out_reg, Dout_tmp : std_logic_vector (N-1 downto 0);
  
  begin
    in_reg <= Din when IE='1' else Dout_tmp;      --  mux
    
    process(Clk, Reset) -- Register
    begin 
      if Reset = '1' then
        out_reg <= (others => '0');
      elsif rising_edge(Clk) then
        out_reg <= in_reg;
      end if;
    end process;
    
    Dout_tmp <= out_reg; --when OE='1' else (others => 'Z'); -- tri-state buffer
    Dout <= Dout_tmp;       

end behavioral;