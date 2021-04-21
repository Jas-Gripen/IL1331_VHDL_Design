library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;

entity  ALU is
  generic (N: integer); -- Detarmines the number of A, B and sum bits
  
  -- Inputs and outputs of the ALU
  port (
   OP : in std_logic_vector (2 downto 0);
   A : in std_logic_vector (N-1 downto 0);
   B : in std_logic_vector (N-1 downto 0);
   EN : in std_logic;
   --Clk : in std_logic;
   reset : in std_logic;
   Sum : out std_logic_vector (N-1 downto 0);
   Z_Flag : out bit;
   N_Flag : out bit;
   O_Flag : out bit  
   );
end ALU;

architecture behavioral of ALU is
  
  -- internal signals
  signal zero :  std_logic_vector (N-1 downto 0) := (others => '0'); -- set all bits to 0
  signal Z_Flag_temp, N_Flag_temp, O_Flag_temp : bit := '0';
  begin
    process (OP, A, B, EN, reset) -- begin process if any of these changes
      variable Sum_temp : std_logic_vector (N-1 downto 0);
      begin
		--Sum_temp := zero;
		--if reset = '1' then
          Sum_temp := (Sum_temp'range => '0'); -- set all bits of Sum_temp to 0
          Z_Flag_temp <= '0';
          O_Flag_temp <= '0';
          N_Flag_temp <= '0';  
      
          
        if EN='1' then       
        case (OP) is  -- determines which operation the ALU should perform
      when "000" => Sum_temp := std_logic_vector(signed(A) + signed(B)); -- add A and B
        
        -- in case of overflow
        if ((A(n-1) = '0' and B(n-1) = '0' and Sum_temp(n-1) = '1') -- a positive number plus a positiv number can't be negative (last bit is sign bit)
        or (A(n-1) = '1' and B(n-1) = '1' and Sum_temp(n-1) = '0')) -- a negative number plus a negative number can't be positive (last bit is sign bit)
        then O_Flag_temp <= '1';
        else O_Flag_temp <= '0';
        end if;
        
      when "001" => Sum_temp := std_logic_vector(signed(A) - signed(B));
        
        -- in case of overflow
        if ((A(n-1) = '0' and B(n-1) = '1' and Sum_temp(n-1) = '1') -- a positive number minues a negative number can't be negative
        or (A(n-1) = '1' and B(n-1) = '0' and Sum_temp(n-1) = '0'))   -- a negative number minus a positive number can't be positive
        then O_Flag_temp <= '1';
        else O_Flag_temp <= '0';
        end if;
        
      when "010" => Sum_temp := A and B;
        
      when "011" => Sum_temp := A or B;
      
      when "100" => Sum_temp := A xor B;
      
      when "101" => Sum_temp := B;
        
      when "110" => Sum_temp := A;
       
      -- OP = 111 however this gives compiling error due to more cases existing, "when others" solves this 
      when others => Sum_temp :=(std_logic_vector(signed(A) + 1)); -- increment A by 1 and output the signal
      end case;
      
      if (Sum_temp = zero) then Z_Flag_temp <= '1';
      else Z_Flag_temp <= '0';
      end if;
      
      if (Sum_temp(n-1) = '1') then N_Flag_temp <= '1';
      else N_Flag_temp <= '0';
      end if;
   
      
    end if; -- EN if statemant
    Sum <= Sum_temp(n-1 downto 0);
    end process;
    --Sum <= Sum_temp(n-1 downto 0);
    Z_Flag <= Z_Flag_temp;
    N_Flag <= N_Flag_temp;
    O_Flag <= O_Flag_temp;
    
    
  end architecture;
    
          