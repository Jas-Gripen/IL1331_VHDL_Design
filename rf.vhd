library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.all;


entity rf is
  -- default value for generic map
  generic (M: integer;
           N: integer
          );
  -- internal ports for the rf
  port (
   WD : in std_logic_vector (N-1 downto 0);
   WAddr, RA, RB : in std_logic_vector (M-1 downto 0);
   Write, ReadA, ReadB, reset, Clk : in std_logic;

   QA, QB : out std_logic_vector (N-1 downto 0)
   );
end rf;

architecture behavioral of rf is
  
  type t_Memory is array (0 to (2**M-1)) of std_logic_vector (N-1 downto 0); -- creates an array with 2^M registers with N bits with
  signal RF_memory : t_Memory; -- rf memory of M memory slots with 2 bits with
                                
  signal zero : std_logic_vector(N-1 downto 0) := (others => '0'); -- used to set output to zero
  
  begin
  
  write_procc: process(WD, WAddr, Write, reset, Clk, RF_memory, zero)
    begin
      
      if reset='1' then
        RF_memory <= (others => (others => '0')); -- set to 0
        
      elsif rising_edge(Clk) then
        if Write = '1' then
          RF_memory(to_integer(unsigned(WAddr))) <= WD; -- write WD (write data) to index WAddr of the memory (write address)
        end if;
      end if;
    end process;
    
    read_procc: process(RA, RB, ReadA, ReadB, RF_memory, zero)
     begin
        if ReadA = '1' then
          QA <= RF_memory(to_integer(unsigned(RA))); -- read the data on index RA and output it to QA
        else
          QA <= zero;
        end if;
        
        if ReadB = '1' then
          QB <= RF_memory(to_integer(unsigned(RB)));  --  read the data on index RB and output it to QB
        else
          QB <= zero;
        end if;
      end process;
  
end architecture;