library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.all;


entity datapath_tb is
  -- default value generic map
  generic (M: integer:= 3;
           N: integer:= 12
          );
end datapath_tb;


architecture behavioral of datapath_tb is
  
  component datapath is
  -- default value generic map
  generic (M: integer:= 3;
           N: integer:= 12
          );
  
  -- internal ports
  port (
    Input : in std_logic_vector (N-1 downto 0);
    reset_datapath, Clk, IE : in std_logic;
    WAddr, RA, RB : in std_logic_vector (M-1 downto 0);
    Write, ReadA, ReadB: in std_logic;
    OE : in std_logic;
    OP : in std_logic_vector (2 downto 0);
    EN : in std_logic;
    Output_datapath : out std_logic_vector (N-1 downto 0);
    Z_Flag : out bit;
    N_Flag : out bit;
    O_Flag : out bit;
    Offset : in std_logic_vector (11 downto 0);  -- Branch instructions uses a 12 bit offset
    Bypass : in std_logic_vector (1 downto 0) -- Bypass A, Bypass B
  );
  end component;

  
  -- signals for DUT
  -- inputs  
  signal Input : std_logic_vector (N-1 downto 0) := (others => '0');
  signal reset, Clk, IE : std_logic;
  signal WAddr, RA, RB : std_logic_vector (M-1 downto 0);
  signal Write, ReadA, ReadB: std_logic;
  signal OE : std_logic;
  signal OP : std_logic_vector (2 downto 0);
  signal EN : std_logic;
  signal Offset_signal : std_logic_vector (N-1 downto 0);  -- Branch instructions uses a 12 bit offset
  signal Bypass_signal : std_logic_vector (1 downto 0); -- Bypass A, Bypass B
  
  -- outputs
  signal Output_dataSignal : std_logic_vector (N-1 downto 0);
  signal Z_Flag : bit;
  signal N_Flag : bit;
  signal O_Flag : bit;
  
  -- Clk
  constant Clk_period : time := 20 ns;
  
  -- temporary signals
  signal QA_temp, QB_temp, zero : std_logic_vector(N-1 downto 0) := (others => '0');
  
  
begin
  
  -- instantiate comopnent
  DUT: datapath
  generic map (M => M,
               N => N)
  port map(
    Input => Input,
    reset_datapath => reset,
    Clk => Clk,
    IE => IE,
    WAddr => WAddr,
    RA => RA,
    RB => RB,
    Write => Write,
    ReadA => ReadA,
    ReadB => ReadB,
    OE => OE,
    OP => OP,
    EN => EN,
    Output_datapath => Output_dataSignal,
    Z_Flag => Z_Flag,
    N_Flag => N_Flag,
    O_Flag => O_Flag,
    
    Offset => Offset_signal,
    Bypass => Bypass_signal    
   );
    
    
  -- Clk process
		Clk_process : process
		begin
		  Clk <= '0';
			wait for Clk_period/2;
			Clk <= '1';
			wait for Clk_period/2;
		end process;
		
		-- Start testing process
    tb_datapath : process
    begin
         
      -- Write values to rf
      reset <= '0';
      RA <= "000";
      RB <= "000";
      OE <= '1';
      OP <= "000";
      EN <= '1'; 
      IE <= '1';
      Input <= "000000000000";
      WAddr <= "000";
      Write <= '1';
      ReadA <= '0';
      ReadB <= '0';
      Bypass_signal <= "00";
      Offset_signal <= "111100001111";
      EN <= '1'; 
      
      for i in 1 to 8 loop
        wait until rising_edge(Clk);
        Input <= Input + 1;
        WAddr <= WAddr + 1;
        wait until rising_edge(Clk);
      end loop;
      
      wait until rising_edge(Clk);
      Write <= '0';
      ReadA <= '1';
      ReadB <= '1';
      RA <= "000";
      RB <= "001";
      EN <= '1';
      
      wait until rising_edge(Clk);
      wait until rising_edge(Clk);
      Bypass_signal <= "01";
      wait until rising_edge(Clk);
      wait until rising_edge(Clk);
      Bypass_signal <= "10";
      wait until rising_edge(Clk);
      wait until rising_edge(Clk);
      Bypass_signal <= "11";
wait until rising_edge(Clk);
      wait until rising_edge(Clk);
    end process;
    
end architecture;