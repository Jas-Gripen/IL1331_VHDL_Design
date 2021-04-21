library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.all;


entity tri_buffer is
  -- default value generic map
  generic (N: integer);
  
  -- internal ports
  port (
   tri_in : in std_logic_vector (N-1 downto 0);
   OE : in std_logic;
   tri_out : out std_logic_vector (N-1 downto 0)
   );
end tri_buffer;


architecture behavioral of tri_buffer is
    
    signal out_signal: std_logic_vector (N-1 downto 0); 
    
begin
  
  process(tri_in, OE)
    begin
      
        out_signal <= tri_in;

    end process;
    
    -- Update output if OE is '1'
    tri_out <= out_signal when OE = '1' 
    else (others => 'Z');
  
end architecture;