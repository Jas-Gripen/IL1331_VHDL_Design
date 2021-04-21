library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.microcode.all;

use work.all;

entity CPU is
  
   generic (M: integer := 3;  --Number of registers
           N: integer := 16  --Bits in registers
           );
           
port (
  Din : in std_logic_vector(15 downto 0);  --IR bits
  reset_CPU, Clk : in std_logic; 
  
  Dout, Address : out std_logic_vector (N-1 downto 0);
  R_Wn  : out std_logic -- indicate read or write
  
);
end CPU;

architecture behave of CPU is
  
  component fsm is
    port (
    -- microcode control inputs
    IR : in std_logic_vector (3 downto 0);  --IR (15-12)
    Din : in std_logic_vector (3 downto 0); --Din (15-12)
    Clk : in std_logic;
    uPC : in std_logic_vector (2 downto 0);
    Z_Flag, N_Flag, O_Flag : in bit;
    
    -- microcode control outputs
    R_Wn, Dout_EN, Address_EN, IR_EN, IE, ALU_EN, NOT_OP, PC, ReadA, ReadB, Write, OE: out std_logic;
    RA, RB: out std_logic_vector (2 downto 0);
    Op_Code: out OP_Code;
    Bypass : out std_logic_vector (1 downto 0)    
    );
  end component;
  
  component datapath is
    generic (M: integer;
           N: integer
          );
          
    port (
   Input : in std_logic_vector (N-1 downto 0);
   reset_datapath, Clk : in std_logic;
   IE : in std_logic := '0';
   WAddr, RA, RB : in std_logic_vector (M-1 downto 0) := "000";
  -- RB : in std_logic_vector (M-1 downto 0) := "001";
   Write, ReadA, ReadB, NOT_OP, PC: in std_logic;
   
   OE : in std_logic;  
   OP : in std_logic_vector (2 downto 0);
   EN : in std_logic;
   Offset : in std_logic_vector (11 downto 0);  -- Branch instructions uses a 12 bit offset
   Bypass : in std_logic_vector (1 downto 0); -- Bypass A, Bypass B

   Output_datapath : out std_logic_vector (N-1 downto 0);
   Z_Flag : out bit;
   N_Flag : out bit;
   O_Flag : out bit
   );
 end component;
 
 component uPC is
   port(
    Clk, reset: in std_logic;
    Q : out std_logic_vector(2 downto 0)
  );
end component;

--component prescaler is
--  port (
--   Clk_In : in std_logic;
--   Clk_Out : out std_logic
--   );
-- end component;
 
 signal IR_signal : std_logic_vector(15 downto 0);
 signal Clk_prescale : std_logic;
 signal uPC_signal : std_logic_vector(2 downto 0);
 signal Z_flag_signal, N_flag_signal, O_flag_signal : bit; 
 signal IE_signal, Dout_EN_signal, IR_EN_signal, Address_EN_signal, ALU_EN_signal, NOT_OP_signal, PC_signal, ReadA_signal, ReadB_signal, Write_signal, OE_signal: std_logic;
 signal RA_signal, RB_signal, WAddr_signal : std_logic_vector (2 downto 0);
 signal Op_Code_signal : OP_Code;
 signal Bypass_signal : std_logic_vector (1 downto 0); 
 signal reset_signal : std_logic;
 signal Output_datapath_signal : std_logic_vector (N - 1 downto 0);
 signal Offset_signal : std_logic_vector (11 downto 0);
 signal Address_tmp, Dout_tmp : std_logic_vector (N - 1 downto 0) := (others => '0');
 begin
   
   U1_FSM: fsm 
    port map (
       -- fsm control inputs
    IR  => IR_signal(15 downto 12),
    Din => Din(15 downto 12),
    Clk => Clk,
    uPC => uPC_signal,
    
    Z_Flag => Z_flag_signal,
    N_Flag => N_flag_signal,
    O_Flag => O_flag_signal,
    
    -- fsm control outputs
    R_Wn        => R_Wn,
    Dout_EN     => Dout_EN_signal,
    Address_EN  => Address_EN_signal,
    IR_EN       => IR_EN_signal,
    IE          => IE_signal,
    ALU_EN      => ALU_EN_signal,
    NOT_OP       => NOT_OP_signal,
    PC          => PC_signal,
    ReadA       => ReadA_signal,
    ReadB       => ReadB_signal,
    Write       => Write_signal,
    OE          => OE_signal,
    RA          => RA_signal,
    RB          => RB_signal,
    --WAddr       => WAddr_signal,
    Op_Code     => Op_Code_signal,
    Bypass      => Bypass_signal
    );
    
	-- IR_signal <= Din when IR_EN_signal = '1' else IR_
--    with IR_EN_signal select IR_signal <=   -- Get new instruction only in LI state
--      Din         when '1',
--      IR_signal   when others;
      
--    with Address_EN_signal select Address_tmp <=   -- Change Address if Address_EN
--      Output_datapath_signal   when '1',
--      Address_tmp  when others;
--      
--      Address <= Address_tmp;
    
--    with Dout_EN_signal select Dout_tmp <=    -- Change Dout if Dout_EN
--      Output_datapath_signal  when '1',
--      Dout_tmp                when others;
--		
--		Dout_tmp <= Dout_tmp;
--		if (Dout_EN_snal = '1') then
--			igDout_tmp <= Output_datapath_signal;
--		end if;
		
		process(Clk)
		begin
		if(rising_edge(Clk)) then
--		with Dout_EN_signal select Dout_tmp <=    -- Change Dout if Dout_EN
--      Output_datapath_signal  when '1',
--      Dout_tmp                when others;
	
		if (Dout_EN_signal = '1') then
			Dout_tmp <= Output_datapath_signal;
			end if;
			
		if (Din(15 downto 12) = "1001") then
		  if (uPC_signal = "000") then
		 
   end if;
     
		  if (uPC_signal = "001") then
		    Address_tmp <= Output_datapath_signal;
		    --Dout_tmp <= Output_datapath_signal;
			end if;
			end if;
		  
			if (Address_EN_signal = '1') then
			Address_tmp <= Output_datapath_signal;
			end if;
			
			if (uPC_signal = "000") then
			IR_signal <= Din;
			end if;
		
--			if (IR_EN_signal = '1') then
--			IR_signal <= Din;
--			end if;
		end if;
		end process;
		
      Address <= Address_tmp;
      Dout <= Dout_tmp;  
    
    with IR_signal(15 downto 12) select Offset_signal <=
       std_logic_vector(resize(signed(IR_signal(8 downto 0)), Offset_signal'length)) when "1010", -- LDI instruction
       IR_signal(11 downto 0)   when others;  -- Branch instructions

      
      
    U2_Datapath: datapath
    generic map(
      M => M,
      N => N
		)
		 
    port map (
    Input           => Din,
    reset_datapath  => reset_CPU,
    Clk             => Clk,
    IE              => IE_signal,         
    WAddr           => IR_signal(11 downto 9),
    RA              => IR_signal(8 downto 6),
    RB              => IR_signal(5 downto 3),
    ReadA           => ReadA_signal,
    ReadB           => ReadB_signal,
    Write           => Write_signal,
    
    Bypass          => Bypass_signal,
    Offset          => Offset_signal,
   
    OE => OE_signal,
    OP => OP_Code_signal,
    EN => ALU_EN_signal,
    NOT_OP => NOT_OP_signal,
    PC    => PC_signal,

    Output_datapath => Output_datapath_signal,
    
    Z_Flag => Z_flag_signal,
    N_Flag => N_flag_signal,
    O_Flag => O_flag_signal
    );
    
    
    U3_uPC: uPC 
    port map (
      reset => reset_CPU,
      Clk => Clk,
      Q => uPC_signal
    );
    
--    U4_Prescaler: prescaler 
--    port map (
--      Clk_In => Clk,
--      Clk_Out => Clk_prescale
--    );
--    
  end behave;