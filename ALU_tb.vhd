library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- can't use + operation (OP+1 is NOT okey)
use ieee.std_logic_unsigned.all;  -- can use + operation (OP+1 is okey)

use work.all;

entity alu_tb is
	generic (n: integer:=4);   -- Change number of bits for A, B and Sum
end alu_tb;


architecture behavioral of alu_tb is

component ALU is
  -- default value generic map
  generic (N: integer:= 4);
  
  -- inputs and outputs of the ALU
  port (
   OP : in std_logic_vector (2 downto 0);
   A : in std_logic_vector (N-1 downto 0);
   B : in std_logic_vector (N-1 downto 0);
   EN : in std_logic;
   Clk : in std_logic;
   reset : in std_logic;
   Sum : out std_logic_vector (N-1 downto 0);
   Z_Flag : out bit;
   N_Flag : out bit;
   O_Flag : out bit  
   );
end component;


  -- Inputs, all set to 0
   signal OP : std_logic_vector(2 downto 0) := (others => '0');
   signal A : std_logic_vector(N-1 downto 0) := (others => '0');
   signal B : std_logic_vector(N-1 downto 0) := (others => '0');
   signal EN : std_logic := '0';
   signal Clk : std_logic := '0';
   signal reset : std_logic :='0';
   
  -- Outputs, all set to 1
   signal Sum : std_logic_vector(N-1 downto 0);
   signal Sum_test : std_logic_vector(N-1 downto 0);
   signal Z_Flag : bit := '1';
   signal N_Flag : bit := '1';
   signal O_Flag : bit := '1';
   
   constant Clk_period : time := 20 ns; -- The clock period, time between clock rises
   
   signal wait_signal : integer;

begin

-- design under test
DUT: alu
	generic map (n => n) -- maps values to the generics of the component
	port map(
	  OP => OP,
		A => A,
		B => B,
		EN => EN,
		Clk => Clk,
		reset => reset,
		Sum => Sum,
		Z_Flag => Z_Flag,
		N_Flag => N_Flag,
		O_Flag => O_Flag
		);	
		
		-- Process for the Clk signal
		Clk_proc: process
		begin
		  Clk <= '0';
			wait for Clk_period/2;
			Clk <= '1';
			if (O_Flag = '0') then
			assert ((Sum = std_logic_vector(unsigned(A) + unsigned(B)))) report "Addition failed";
			end if;
			wait for Clk_period/2;
			
			
			assert (O_Flag = '0') report "Overflow";
			if Sum(n - 1) = '1' then
			  assert (N_Flag = '1') report "N_Flag error";
			  end if;
		  end process;
		  
		-- start the test
   tb_proc: process
   begin  
    
    -- simple testing with A = 0110 and B = 0100 where OP will loop through all operations once
    A <= "0101";
    B <= "0101";
    OP <= "000";
    Sum_test <= "0000";
    reset <= '0'; -- reset <= '1' will reset
    EN <= '1';
    wait_signal <= 10;
    wait for 30 ns;
   -- EN <= not EN;
   wait for 20 ns;
    B <= B + 1;
    wait for 20 ns;
    
    A <= "0000";
    wait for 20 ns;
    B <= "0000";
    wait for 7 ns;
   -- EN <= not EN; 
  for i in 0 to 7 loop  -- do one of each operation
    wait for 10 ns;
    OP <= OP +1;
    for i in 0 to 7 loop
      wait for 20 ns;
  A <= A +1;
end loop;
B <= B + 1;
  --assert (Sum = std_logic_vector(unsigned(A) + unsigned(B))) report "Addition failed";
  --wait_signal <= wait_signal + 7;
end loop;  
  
  end process;

end architecture;

	