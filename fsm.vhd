library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

use work.all;
use work.microcode.all;


entity fsm is  

  port (
    -- fsm control inputs
    IR : in std_logic_vector (3 downto 0);  --IR (15-12)
    Din : in std_logic_vector (3 downto 0); -- Din (15-12)
    Clk : in std_logic;
    uPC : in std_logic_vector (2 downto 0);
    Z_Flag, N_Flag, O_Flag : in bit;
    
    -- fsm control outputs
    Dout_EN, Address_EN, IE, IR_EN, ALU_EN, NOT_OP, PC, ReadA, ReadB, Write, OE, R_Wn: out std_logic;
    RA, RB, WAddr: out std_logic_vector (2 downto 0);
    Op_Code: out OP_Code;
    Bypass : out std_logic_vector (1 downto 0)    
    );
   
end fsm;

architecture behavioral of fsm is

-- Appendix C?
  type fsm_state is (LI,FO,EX,LM,NO);
  signal state_signal : fsm_state;
  
  signal instr : datapath_bits;
  signal Z_temp, N_temp, O_temp : bit := '0'; --Flags
  
  
  begin
    
    process(Clk)
	-- variable Z_tmp : bit;
    begin
      
      if rising_edge(Clk) then
        
        case state_signal is
          when LI =>
            instr <= ROM(0);
            
            if (Din = "1001") then
              instr <= ROM(13);
            end if;
            if (Din = "0000")then --ADD
             instr <= ROM(1);
           end if;
             
             if (Din = "0001") then --SUB
             instr <= ROM(2);
           end if;
            
            
          
          when FO =>
            case IR is
           when "0000" => --ADD
             instr <= ROM(17);
             Z_temp <= Z_Flag;
             
           when "0001" => --SUB
             instr <= ROM(17);
             Z_temp <= Z_Flag;
             
           when "0010" => --AND
             instr <= ROM(3);
             
           when "0011" => --OR
             instr <= ROM(4);
             
           when "0100" => --XOR
             instr <= ROM(5);
             
           when "0101" =>  --NOT
             instr <= ROM(6);
             
           when "0110" => --MOVA
             instr <= ROM(7);
             
          when "0111" =>  --NOP
            instr <= ROM(17);
             
           when "1001" => -- ST
             --instr <= ROM(13);
             instr <= ROM(14);
             
           when "1010" =>   -- LDI
             instr <= ROM(12);  
             
             when "1111" => -- BRA
             instr <= ROM(16);           
             
           when others => 
             instr <= ROM(8);
           end case;
           
           
            
          when EX => 
            case IR is
           when "1000" => --LD
             instr <= ROM(9);
             
           when "1001" => -- ST
             instr <= ROM(17);
             
           when "1010"  =>  --LDI
             instr <= ROM(17);
             
           when "0000"  =>  --ADD
             --Z_temp <= Z_Flag;
             --O_temp <= O_Flag;
             --N_temp <= N_Flag;
             instr <= ROM(8);
             
           when "0001"  =>  --SUB
             --Z_temp <= Z_Flag;
             --O_temp <= O_Flag;
             --N_temp <= N_Flag;
             instr <= ROM(8);
             
             when "0110" => --MOVA
             instr <= ROM(17);
             
           -- when "0000" => --ADD
             --instr <= ROM(17);
				 when "1100" => -- BRZ
             --if Z_temp = '1' then
				 if Z_temp = '1' then
             instr <= ROM(16);
           else
             instr <= ROM(17);
          end if;
			 when "1111" => -- BRA
             instr <= ROM(8);
             
             when "0111" =>  --NOP
            instr <= ROM(8);
             
             when others =>
               instr <= ROM(8);
           end case;
           
           
           
            
          when LM => 
            case IR is
           when "1001" => -- ST
             instr <= ROM(8);
             
           when "1100" => -- BRZ
             if Z_temp = '1' then
				 --if Z_Flag = '1' then
             instr <= ROM(8);
           else
             instr <= ROM(8);
          end if;
          
          when "1101" => -- BRN
             if N_temp = '1' then
             instr <= ROM(16);
           else
             instr <= ROM(17);
          end if;
             
          when "1110" => -- BRO
             if O_temp = '1' then
             instr <= ROM(16);
           else
             instr <= ROM(17);
          end if;
          
          when "1111" => -- BRA
             --instr <= ROM(16);
				 instr <= ROM(8);
             
          --when "0000" => --ADD
            -- instr <= ROM(8);
            when "0000"  =>  --ADD
             Z_temp <= Z_Flag;
             O_temp <= O_Flag;
             N_temp <= N_Flag;
             instr <= ROM(8);
             
             when "0001"  =>  --SUB
             --Z_temp <= Z_Flag;
             O_temp <= O_Flag;
             N_temp <= N_Flag;
             instr <= ROM(8);
             
             when "0110" => --MOVA
             instr <= ROM(8);
          
          when "1010"  =>  --LDI
             instr <= ROM(8);  
             
             when "0111" =>  --NOP
            instr <= ROM(8);      
             
             when others =>
               instr <= ROM(17);  -- PC = PC + 1
           end case;
           
        when NO =>
          case IR is
          when "1001" => --ST
            instr <= ROM(8);
            
          when others =>
          instr <= ROM(0);
        end case;
        
         end case;  --Case signal
       end if;  --Clk
     end process; --Clk
     
     
     
     --Set all the bits
     Dout_EN  <= instr.Dout_EN;
     Address_EN<= instr.Address_EN;
     IR_EN    <= instr.IR_EN;
     ALU_EN   <= instr.ALU_EN;
     NOT_OP    <= instr.NOT_OP;
     PC       <= instr.PC;
     OP_Code  <= instr.OP_Code;
     ReadA    <= instr.ReadA;
     ReadB    <= instr.ReadB;
     Write    <= instr.Write;
   --  WAddr    <= instr.WAddr;
     OE       <= instr.OE;
     IE       <= instr.IE;
     Bypass   <= instr.Bypass;
     R_Wn     <= instr.R_Wn;
    
       
     
     stateProcess : process(uPC)
     begin
       case uPC is
       when "000" =>
         state_signal <= LI;
         
       when "001" =>
         state_signal <= FO;
         
       when "010" =>
         state_signal <= EX;
        
      when "011" =>
        state_signal <= LM;
         
       when others => 
         state_signal <= NO;
        
       end case;
     end process; --uPC
   end behavioral;