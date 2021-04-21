library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.all;

entity datapath is
  -- default value generic map
  generic (M: integer;
           N: integer
          );
  
  -- internal ports
  port (
   Input : in std_logic_vector (N-1 downto 0);
   reset_datapath, Clk : in std_logic;
   IE : in std_logic := '0';
   WAddr, RA, RB : in std_logic_vector (M-1 downto 0);
  -- RB : in std_logic_vector (M-1 downto 0) := "001";
   Write, ReadA, ReadB: in std_logic;
   
   OE : in std_logic;  
   OP : in std_logic_vector (2 downto 0);
   EN : in std_logic;
   NOT_OP : in std_logic;
   PC     : in std_logic;
   Offset : in std_logic_vector (11 downto 0);  -- Branch instructions uses a 12 bit offset
   Bypass : in std_logic_vector (1 downto 0); -- Bypass A, Bypass B

   Output_datapath : out std_logic_vector (N-1 downto 0);
   Z_Flag : out bit;
   N_Flag : out bit;
   O_Flag : out bit
   );
end datapath;




architecture behavioral of datapath is
  
--  -- component declarations
--  component mux is
--  -- default value generic map
--  generic (N: integer);
--  
--  -- internal ports
--  port (
--   Input, Sum : in std_logic_vector (N-1 downto 0);
--   IE : in std_logic;
--   Output_mux : out std_logic_vector (N-1 downto 0)
--   );
--end component;



component rf is
  -- default value generic map
  generic (M: integer;
           N: integer
          );
  
  -- internal ports
  port (
   WD : in std_logic_vector (N-1 downto 0);
   WAddr, RA, RB : in std_logic_vector (M-1 downto 0);
   Write, ReadA, ReadB, reset, Clk : in std_logic;
   QA, QB : out std_logic_vector (N-1 downto 0)
   );
end component;


component ALU is
  -- default value generic map
  generic (N: integer);
  
  -- internal ports
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
end component;


component tri_buffer is
  -- default value generic map
  generic (N: integer);
  
  -- internal ports
  port (
   tri_in : in std_logic_vector (N-1 downto 0);
   OE : in std_logic;
   --Clk : in std_logic;
   tri_out : out std_logic_vector (N-1 downto 0)
   );
end component;

--component prescaler is
  
  
  -- internal ports
 -- port (
 --  Clk_In : in std_logic;
 --  Clk_Out : out std_logic
 --  );
--end component;


  -- signals
  signal WD_signal, rfA_signal, rfB_signal, A_signal, B_signal, Sum_signal, RA_temp, A_signal_tmp : std_logic_vector (N-1 downto 0);
  signal RA_signal, WAddr_signal: std_logic_vector(M-1 downto 0);
  signal Clk_Out, reset_signal, ReadA_temp, ReadA_signal : std_logic;
  signal Offset_ext: std_logic_vector(N-1 downto 0);

  
begin
  
  -- for synthesis
  --reset_signal <= not reset_datapath;
  
  -- for simulation
    reset_signal <= reset_datapath;
  
  -- port maps
  --  U1_MUX: mux
  --  generic map (N => N)
  --  port map (
  --    Input => Input,
  --    SUM => Sum_signal,
  --    IE => IE,
  --    Output_mux => WD_signal
  --  );
      
    U2_RF: rf
    generic map(
      M => M,
      N => N
		)
    port map(
      WD => WD_signal,
      WAddr => WAddr_signal,
      RA => RA_signal,
      RB => RB,
      Write => Write,
      ReadA => ReadA_signal,
      ReadB => ReadB,
      reset => reset_signal,
      Clk => Clk,
      QA => rfA_signal,
      QB => rfB_signal
    );
    
    U3_ALU: ALU
    generic map(
      N => N
		)
    port map(
      OP => OP,
      A => A_signal,
      B => B_signal,
      EN => EN,
      --Clk => Clk_Out,
      reset => reset_signal,
      Sum => Sum_signal,
      Z_Flag => Z_Flag,
      N_Flag => N_Flag,
      O_Flag => O_Flag
      );
      
    U4_Buffer: tri_buffer
    generic map(
      N => N
		)
    port map(
      tri_in => Sum_signal,
      OE => OE,
     -- Clk => Clk_Out,
      tri_out => Output_datapath
      );
      
--      U5_Prescaler: prescaler
--      port map(
--        Clk_In => Clk,
--        Clk_Out => Clk_Out
--      );
      
  --  U5_Bypass_MUX_A: mux
  --  generic map (N => N)
  --  port map (
  --    Input => Offset,
  --    SUM => rfA_signal,  -- QA from rf
  --    IE => Bypass(0),  -- Bypass A
  --    Output_mux => A_signal  -- To ALU input A
  --  );
    
  --  U6_Bypass_MUX_B: mux
  --  generic map (N => N)
  --  port map (
  --    Input => Offset,
  --    SUM => rfB_signal,  -- QB from rf
  --    IE => Bypass(1),  -- Bypass B
  --    Output_mux => B_signal  -- To ALU input B
  --  );
  Offset_ext <= std_logic_vector(resize(signed(Offset), Offset_Ext'length));
    
    with IE select WD_signal <=   -- Input mux
      Input       when '1',
      Sum_signal  when others;
      
    with Bypass(0) select A_signal_tmp <=   -- QA mux
      Offset_ext      when '1',
      rfa_signal  when others;
      
    with Bypass(1) select B_signal <=   -- QB mux
      Offset_ext      when '1',
      rfb_signal  when others;
      
    with PC select ReadA_signal <=   -- ReadA if PC
      '1'      when '1',
      ReadA  when others;
      
    with PC select RA_signal <=    -- RA "111" if PC
      (others => '1')   when '1',
      RA                when others;
      
    with PC select WAddr_signal <=    -- WAddr "111" if PC
      (others => '1')   when '1',
      WAddr      when others;
      
    with NOT_OP select A_signal <=   -- Move B to A, for ST instruction in EX state
      NOT(rfA_signal)  when '1',
      A_signal_tmp  when others;
      
    
end architecture;