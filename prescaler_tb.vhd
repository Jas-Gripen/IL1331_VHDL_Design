library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- can't use + operation (OP+1 is NOT okey)
use ieee.std_logic_unsigned.all;  -- can use + operation (OP+1 is okey)

use work.all;

entity prescaler_tb is
end prescaler_tb;


architecture behavioral of prescaler_tb is

component prescaler is
  
  -- inputs and outputs of the ALU
 port (
   Clk_In : in std_logic;
   Clk_Out : out std_logic
   );
 end component;
   
   signal Clk_In, Clk_Out : std_logic := '0';
   -- Clk
  constant Clk_period : time := 20 ns;
   
   begin
     
DUT: prescaler
	port map(
	  Clk_In => Clk_In,
		Clk_Out => Clk_Out
		);	

 -- Clk process
		Clk_process : process
		begin
		  Clk_In <= '0';
			wait for Clk_period/2;
			Clk_In <= '1';
			wait for Clk_period/2;
		end process;
end architecture;