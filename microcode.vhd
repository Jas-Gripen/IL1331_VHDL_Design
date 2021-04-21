library ieee;
use ieee.std_logic_1164.all;

use work.all;

package microcode is
subtype OP_Code is std_logic_vector(2 downto 0); -- OP codes for the ALU

type datapath_bits is record -- record is simular to structures in C
    R_Wn  : std_logic;  -- Indicate if external components are beeing read (active high) or written (active low)
    Dout_EN : std_logic;  -- When to change Dout
    Address_EN : std_logic; -- When to change Address
    IR_EN : std_logic;  -- Enable the instruction register
    --ST_Flags : std_logic; -- appendix c?
    IE : std_logic; -- input mux
    Bypass : std_logic_vector (1 downto 0); -- Bypass signal datapath
    ALU_EN : std_logic; -- EN for ALU
    NOT_OP  : std_logic; -- Move B to A
    PC     : std_logic; -- PC, set RA and WAddr to all 1
    OP_code : OP_Code; -- OP code for ALU
    ReadA : std_logic;  -- Readrf
   -- RA : REG_NR; --RA rf
    ReadB : std_logic;  --ReadB rf
   -- RB : REG_NR; -- RB rf
    Write : std_logic;  --Write rf
   -- WAddr : REG_NR;  -- WAddr rf
    OE : std_logic;  -- OE     
  end record datapath_bits;
  
  -- OP codes for the ALU
  constant ADD_OP  : OP_Code := "000";
  constant SUB_OP  : OP_Code := "001";
  constant AND_OP  : OP_Code := "010";
  constant OR_OP   : OP_Code := "011";
  constant XOR_OP  : OP_code := "100";
  constant MOVB_OP  : OP_Code := "101";
  constant MOVA_OP  : OP_Code := "110";
  constant INC_OP : OP_Code := "111";
  
  type bit_instruction is array(natural range <>) of datapath_bits; --Create an array with microcode_bits to contain the instructions from appendix B
  
  constant ROM: bit_instruction:= (
  
    --     R_Wn    Dout_EN  Address_EN  IR_EN    IE   Bypass    ALU_EN   NOT_OP  PC     OP_CODE   ReadA   ReadB    Write   OE
  --17 =>(   '1',       '0',     '1',      '0',    '0',  "00",     '1',     '0',   '1',    INC_OP,   '1',    '0',     '1',   '1')  -- PC = PC + 1 
  0 => (   '0',       '0',     '0',      '1',    '0',  "00",     '0',     '0',   '0',    ADD_OP,   '0',    '0',     '0',   '0'), -- Load instruction
 -- 0 => (   '1',       '0',     '1',      '1',    '0',  "00",     '1',     '0',   '1',    INC_OP,   '1',    '0',     '1',   '1'), -- New Load instruction
  1 => (   '0',       '0',     '0',      '0',    '0',  "00",     '1',     '0',   '0',    ADD_OP,   '1',    '1',     '1',   '1'), -- ADD
  2 => (   '0',       '0',     '0',      '0',    '0',  "00",     '1',     '0',   '0',    SUB_OP,   '1',    '1',     '1',   '1'), -- SUB
  3 => (   '0',       '0',     '0',      '0',    '0',  "00",     '1',     '0',   '0',    AND_OP,   '1',    '1',     '1',   '1'), -- AND
  4 => (   '0',       '0',     '0',      '0',    '0',  "00",     '1',     '0',   '0',    OR_OP,    '1',    '1',     '1',   '1'), -- OR
  5 => (   '0',       '0',     '0',      '0',    '0',  "00",     '1',     '0',   '0',    XOR_OP,   '1',    '1',     '1',   '1'), -- XOR
  6 => (   '0',       '0',     '0',      '0',    '0',  "00",     '1',     '1',   '0',    MOVA_OP,  '1',    '0',     '1',   '1'), -- NOT A
  7 => (   '0',       '0',     '0',      '0',    '0',  "00",     '1',     '0',   '0',    MOVA_OP,  '1',    '0',     '1',   '1'), -- MOV
  8 => (   '0',       '0',     '0',      '1',    '0',  "00",     '0',     '0',   '0',    ADD_OP,   '0',    '0',     '0',   '1'), -- NOP
  9 => (   '0',       '0',     '1',      '0',    '0',  "00",     '1',     '0',   '0',    MOVA_OP,  '1',    '0',     '0',   '1'), -- LD FO
  10 =>(   '0',       '0',     '0',      '0',    '0',  "00",     '1',     '0',   '0',    MOVA_OP,  '0',    '0',     '1',   '1'), -- LD EX
 -- 11 =>(   '1',       '0',     '1',      '0',    '0',  "01",     '1',     '0',   '0',    MOVA_OP,  '0',    '0',     '1',   '1'), -- NEW LDI FO
  --12 =>(   '1',       '0',     '0',      '0',    '0',  "01",     '1',     '0',   '0',    MOVA_OP,  '0',    '0',     '1',   '1'), -- NEW LDI EX
  11 =>(   '0',       '0',     '0',      '0',    '0',  "01",     '1',     '0',   '0',    MOVA_OP,  '0',    '0',     '0',   '1'), -- LDI FO
  12 =>(   '0',       '0',     '0',      '0',    '0',  "01",     '1',     '0',   '0',    MOVA_OP,  '0',    '0',     '1',   '1'), -- LDI EX
  13 =>(   '0',       '0',     '1',      '0',    '0',  "00",     '1',     '0',   '0',    MOVA_OP,  '1',    '0',     '0',   '1'), -- ST FO
  14 =>(   '1',       '1',     '0',      '0',    '0',  "00",     '1',     '0',   '0',    MOVB_OP,  '0',    '1',     '0',   '1'), -- ST EX
  15 =>(   '0',       '0',     '1',      '0',    '0',  "00",     '1',     '0',   '1',    INC_OP,   '1',    '0',     '1',   '1'), -- ST LM
  16 =>(   '0',       '0',     '1',      '0',    '0',  "10",     '1',     '0',   '1',    ADD_OP,   '1',    '0',     '1',   '1'), -- BRZ, BRN, BRO
  17 =>(   '0',       '0',     '1',      '0',    '0',  "00",     '1',     '0',   '1',    INC_OP,   '1',    '0',     '1',   '1'),  -- PC = PC + 1
  18 =>(   '0',       '0',     '1',      '0',    '0',  "00",     '0',     '0',   '0',    INC_OP,   '0',    '0',     '0',   '0')  --    
  );  
end microcode;   