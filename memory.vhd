library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.assembly_instructions.all;

entity memory is
  
  generic (N: integer :=12
          );

  PORT(
  Din, Address : in std_logic_vector (N-1 downto 0);
  Clk, R_Wn : in std_logic;
  
  Q : out std_logic_vector(N-1 downto 0)
  ); 
end memory;

architecture fake of memory is
  signal RAM : RAM_bits (0 to 255) :=(
    (LDI_instr    & R5  & B"1_1111_0000"),
    (ADD_instr    & R5  & R5  & R5  & nu3),
    (ADD_instr    & R5  & R5  & R5  & nu3),
    (ADD_instr    & R5  & R5  & R5  & nu3),
    (ADD_instr    & R5  & R5  & R5  & nu3),
    (LDI_instr    & R6  & B"0_0010_0000"),
    (LDI_instr    & R3  & B"0_0000_0011"),
    (ST_instr     & nu3 & R6  & R3  & nu3),
    (LDI_instr    & R1  & B"0_0000_0001"),
    (LDI_instr    & R0  & B"0_0000_1110"),
    (MOV_instr    & R2  & R0  & nu3 & nu3),
    (ADD_instr    & R2  & R2  & R1  & nu3),
    (SUB_instr    & R0  & R0  & R1  & nu3),
    (BRZ_instr    & B"0000_0000_0011"),
    (NOP_instr    & nu3 & nu3 & nu3 & nu3),
    (BRA_instr    & B"0000_1111_1100"),
    (ST_instr     & nu3 & R6  & R2  & nu3),
    (ST_instr     & nu3 & R5  & R2  & nu3),
    (BRA_instr    & B"0000_0000_0000"),
    (NOP_instr    & nu3 & nu3 & nu3 & nu3),
    (NOP_instr    & nu3 & nu3 & nu3 & nu3),
    others=>(NOP_instr  & nu3 & nu3 & nu3 & nu3));
    
    begin    
    Read: process (R_Wn, Address)
      begin
        if R_Wn = '0' then
           Q <= RAM (to_integer(unsigned(Address)));  -- Send instruction from fake memory
        end if;      
      end process;
      
    Write: process (Clk, R_Wn, Address) 
      begin
        if rising_edge(Clk) then
          if R_Wn = '1' then            
            RAM (to_integer(unsigned(Address))) <= Din;            
          end if;       
        end if;
    end process;
    
end fake;