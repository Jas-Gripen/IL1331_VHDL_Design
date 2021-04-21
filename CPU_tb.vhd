library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.all;

entity CPU_tb is
  -- default value generic map
  generic (M: integer := 3;  --Number of registers
           N: integer := 16 --Bits in registers
          );
end CPU_tb;


architecture behave of CPU_tb is
  
  component CPU is
  -- default value generic map
  generic (M: integer;  --Number of registers
           N: integer  --Bits in registers
          );
          
  -- internal ports
  port (
    Din : in std_logic_vector (15 downto 0);
    reset_CPU, Clk : in std_logic;
    
    Dout, Address : out std_logic_vector (N-1 downto 0);
    R_Wn  : out std_logic
    
    );
  end component;

  
  --Inputs for tb 
  signal Din : std_logic_vector (15 downto 0) := (others => '0');
  signal reset_CPU, Clk : std_logic := '0';

  --Outputs for tb
  signal Dout, Address : std_logic_vector (N-1 downto 0);
  signal R_Wn : std_logic;
  
  constant clk_period : time := 10 ns;
   
begin
  
  --Instantiate comopnent
  DUT: CPU
  generic map (M => M,
               N => N
               )
  port map(
    Din => Din,
    reset_CPU => reset_CPU,
    Clk => Clk,
    Dout => Dout,
    Address => Address,
    R_Wn    => R_Wn
     );
        
  --Clock process 
  Clk_process : process
		begin
		  Clk <= '0';
			wait for Clk_period/2;
			Clk <= '1';
			wait for Clk_period/2;
		end process;
		
		--Test proccess
    CPU_tb : process
    begin
      
      reset_CPU <= '0';
      --Input_CPU <= "0000000000000";
      wait for 40 ns;
      
      reset_CPU <= '1';
      wait for 40 ns;
      reset_CPU <= '0';
      
      
      wait for 80 ns;
      -- LDI R5, 0xFF00
      Din <= "1010101100000000";
      wait for 80 ns;
      
      
      -- NOT R6, R5
      --Din <= "0101110101000000";
      --wait for 80 ns;
      
      
      -- ADD R5, R5, R5
      Din <= "0000101101101000";
      wait for 80 ns;
      
      -- ADD R5, R5, R5
      Din <= "0000101101101000";
      wait for 80 ns;
      
      -- ADD R5, R5, R5
      Din <= "0000101101101000";
      wait for 80 ns;
      
      -- LDI R6, 0x0020
      Din <= "1010110000100000";
      wait for 80 ns;
      
      -- LDI R3, 0x3
      Din <= "1010011000000011";
      wait for 80 ns;  

      -- ST R6, R3
      Din <= "1001000110011000";
      wait for 80 ns;
      
      -- LDI R1, 0x1
      Din <= "1010001000000001";
      wait for 80 ns;
      
      -- LDI R0, 0xE
      Din <= "1010000000001110";
      wait for 80 ns;
      
    
 -- MOV R2, R0
      Din <= "0110010000000000";
      wait for 80 ns;
      
      -- ADD R2, R2, R1
      Din <= "0000010010001000";
      wait for 80 ns;
      
      -- SUB R0, R0, R1
      Din <= "0001000000001000";
      wait for 80 ns;
      
      -- BRZ 0x03
      Din <= "1100000000000011";
      wait for 80 ns;
      
      -- NOP
      Din <= "0111000000000000";
      wait for 80 ns;
      
      -- BRA 0xFC
      Din <= "1111000011111100";
      wait for 80 ns;
      
      -- ST R6, R2
      Din <= "1001000110010000";
      wait for 80 ns;
      
      -- ST R5, R2
      Din <= "1001000101010000";
      wait for 80 ns;
      
      -- BRA 0x00
      Din <= "1111000000000000";
      wait for 80 ns;
      
      -- NOP
      Din <= "0111000000000000";
      wait for 80 ns;
      
      -- NOP
      Din <= "0111000000000000";
      wait for 80 ns;

    end process;
    
end architecture;