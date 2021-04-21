library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.all;

package assembly_instructions is  
  
  type RAM_bits is array(natural range <>) of std_logic_vector(15 downto 0);
  subtype instruction is std_logic_vector(3 downto 0);  -- Bits 15-12, indicate CPU instruction
  
  constant ADD_instr    : instruction := "0000";
  constant SUB_instr    : instruction := "0001";
  constant AND_instr    : instruction := "0010";
  constant OR_instr     : instruction := "0011";
  constant XOR_instr    : instruction := "0100";
  constant NOT_instr    : instruction := "0101";
  constant MOV_instr    : instruction := "0110";
  constant NOP_instr    : instruction := "0111";
  constant LD_instr     : instruction := "1000";
  constant ST_instr     : instruction := "1001";
  constant LDI_instr    : instruction := "1010";
  constant NU_instr     : instruction := "1011";
  constant BRZ_instr    : instruction := "1100";
  constant BRN_instr    : instruction := "1101";
  constant BRO_instr    : instruction := "1110";
  constant BRA_instr    : instruction := "1111";
  
  subtype reg is std_logic_vector(2 downto 0);   -- Register

  constant R0 : reg := "000";
  constant R1 : reg := "001";
  constant R2 : reg := "010";
  constant R3 : reg := "011";
  constant R4 : reg := "100";
  constant R5 : reg := "101";
  constant R6 : reg := "110";
  constant R7 : reg := "111";
  
  subtype NU is std_logic_vector(2 downto 0);   -- Unused bits
  
  constant nu3 : NU := "000";  
  
End assembly_instructions;