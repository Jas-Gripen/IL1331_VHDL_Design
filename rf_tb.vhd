library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.all;


entity rf_tb is
  -- default value generic map
  generic (M: integer:= 3;
           N: integer:= 4
          );
end rf_tb;


architecture behavioral of rf_tb is
  
  component rf is
  -- default value generic map
  generic (M: integer:= 3;
           N: integer:= 4
          );
  
  -- internal ports
  port (
   WD : in std_logic_vector (N-1 downto 0);
   WAddr, RA, RB : in std_logic_vector (M-1 downto 0);
   Write, ReadA, ReadB, reset, Clk : in std_logic;
   QA, QB : out std_logic_vector (N-1 downto 0)
   );
  end component;

  
  -- inputs for DUT
  signal WD : std_logic_vector (N-1 downto 0) := (others => '0');
  signal WAddr, RA, RB : std_logic_vector (M-1 downto 0) := (others => '0');
  signal Write, ReadA, ReadB, reset, Clk : std_logic := '0';
  -- outputs for DUT
  signal QA, QB : std_logic_vector (N-1 downto 0);

  -- clock period
  constant clk_period : time := 20 ns;
  
  -- temporary signals
  signal QA_temp, QB_temp, zero : std_logic_vector(N-1 downto 0) := (others => '0');
  
  
begin
  
  -- instantiate comopnent
  DUT: rf
  generic map (M => M,
               N => N)
  port map(
    WD => WD,
    WAddr => WAddr,
    RA => RA,
    RB => RB,
    Write => Write,
    ReadA => ReadA,
    ReadB => ReadB,
    reset => reset,
    Clk => Clk,
    QA => QA,
    QB => QB
   );
    
    
  -- Clock process definition
		Clk_process : process
		begin
		  Clk <= '0';
			wait for Clk_period/2;
			Clk <= '1';
			wait for Clk_period/2;
		end process;
		
		-- Start testing process
    tb_rf : process
    begin
      
    reset <= '0';  
    ReadB <= '0';    
    Write <= '1';
    WD <= "1111";
    WAddr <= "000";
    
    -- Write 8 times to different adresses
    for i in 1 to 8 loop
      wait until rising_edge(Clk);
        WD <= WD -1;
        WAddr <= WAddr + 1;
    end loop;
    
    Write <= '0';
      
    wait for 50 ns;
    
    ReadA <= '1';
    ReadB <= '0';
    RA <= "000";
    RB <= "000";
    
    -- Read 8 times from A and B
    for i in 1 to 8 loop
      wait until rising_edge(Clk);
        RA <= RA + 1;
        ReadA <= NOT(ReadA);
        RB <= RB +1;
        ReadB <= NOT(ReadB);
    end loop;
    
    reset <= '1';
    
    wait for 50 ns; 
      
    end process;
end architecture;