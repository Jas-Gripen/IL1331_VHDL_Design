library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.all;

entity One_Chip_Computer is
  generic (M: integer := 3;   -- number of registers
           N: integer := 16  -- register length (number of bits)
           );
          
  port (
        reset_in, Clk : in std_logic;
        
        gpio_out : out std_logic_vector(7 downto 0)
    );
end One_Chip_Computer;

architecture behavioral of One_Chip_Computer is
  
component CPU is
  -- default value generic map
  generic (M: integer;  -- number of registers
           N: integer  -- IR bits
           );
          
  port (
    Din : in std_logic_vector (N-1 downto 0); -- IR bits, in
    reset_CPU, Clk : in std_logic;
    
    Dout, Address : out std_logic_vector (N-1 downto 0); -- bits in registers / IR (16)
    R_Wn : out std_logic       
    );
end component;

--component memory is 
--  generic (N: integer
--          );
--
--  port(
--  Din, Address : in std_logic_vector (N-1 downto 0);
--  Clk, R_Wn : in std_logic;
--  
--  Q : out std_logic_vector(N-1 downto 0)
--  ); 
--end component;

component memory_Q IS
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END component memory_Q;

component prescaler is
  port (
   Clk_in  : in std_logic;
   Clk_out : out std_logic
   );
end component;

component gpio is  
  generic (N: integer
          );

  port(
    Din: in std_logic_vector (N-1 downto 0);
    IE, OE : in std_logic;
    Clk, Reset : in std_logic;
  
    Dout : out std_logic_vector(N-1 downto 0)
  ); 
end component;

  signal CPU_Dout_signal, CPU_Addr_signal, Dout_mem_signal, mem_Addr_signal : std_logic_vector (N-1 downto 0);
  signal memQ_Addr_signal : std_logic_vector (7 downto 0);
  signal Clk_prescale, R_Wn_signal, IE_signal : std_logic;
  signal reset : std_logic; 
  
  
begin
  
  reset <= reset_in;
    
    U1_CPU : CPU
    generic map (M => M,
                 N => N)
                 
    port map (
      Din       => Dout_mem_signal,
      reset_CPU  => reset_in,
      Clk       => Clk,
      Dout      => CPU_Dout_signal,
      Address   => CPU_Addr_signal,
      R_Wn      => R_Wn_signal
    );
    
--    U2_Memory : memory
--    generic map (N => N)
--    
--    port map (
--      Din   	 => CPU_Dout_signal,
--      Address => mem_Addr_signal,
--      Clk     => Clk_prescale,
--      R_Wn    => R_Wn_signal,
--      Q       => Dout_mem_signal
--    );
	 --mem_Addr_signal <= "00000000" & CPU_Addr_signal(7 downto 0); -- Use only 7 bits from the "real" address
	 --mem_Addr_signal <= CPU_Addr_signal(7 downto 0); -- Use only 7 bits from the "real" address (DOES NOT WORK)
    memQ_Addr_signal <= CPU_Addr_signal(7 downto 0); -- Use only 7 bits from the "real" address

	U2_Memory : memory_Q
	PORT MAP (
		address => memQ_Addr_signal,
		clock => Clk,
		data => CPU_Dout_signal,
		wren => R_Wn_signal,
		q => Dout_mem_signal
	);
	
    U3_GPIO : gpio
    generic map (N => 8)
    
    port map (
      Din   => CPU_Dout_signal (7 downto 0),
      IE    => IE_signal,
      OE    => R_Wn_signal,
      Clk   => Clk,
      reset => reset_in,
      Dout  => gpio_out
    );
      
--    U4_Prescaler : prescaler
--    port map (
--      Clk_in  => Clk,
--      Clk_out => Clk_prescale
--    );
  
  IE_signal <= '1' when Dout_mem_signal = X"F000" else '0'; -- IE 1 is din, out-GPIO takes input at adress 0xF000  
          
end behavioral;