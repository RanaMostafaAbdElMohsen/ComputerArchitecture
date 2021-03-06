library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
Entity CU is
port ( Opcode : in std_logic_vector (4 downto 0);
BranchRes :in std_logic;
Interrupt : in std_logic;
Reset : in std_logic;
M : out std_logic;
WB : out std_logic;
E : out std_logic;
Rst: out std_logic;
Jflag1 : out std_logic;
Jflag2 :out std_logic;
ShiftSel : out std_logic;
Push : out std_logic;
Pop : out std_logic;
Branch : out std_logic;
SelMem : out std_logic;
DataInSelect : out std_logic;
WB1Select : out std_logic;
WB2Select : out std_logic;
Enable : out std_logic;
ALUSelect : out std_logic_vector (3 downto 0);
SaveEnable : out std_logic;
Insig : out std_logic;
JumpSelect : out std_logic;
JMP: out std_logic;
PC0: out std_logic;
PC1: out std_logic;
CS : out std_logic;
VS : out std_logic;
NS : out std_logic;
ZS : out std_logic;
RTIsig : out std_logic;
MemRead : out std_logic;
MemWrite : out std_logic;
Decode_Bubble : out std_logic;
HDUM  :out std_logic  -- Is this instruction a LOAD instruction?
);
end entity CU;


architecture mainCU of CU is
Signal BranchResult :std_logic;
Signal SaveEnableSig :std_logic;

BEGIN

BranchResult<= '0' when BranchRes= 'U' else
		BranchRes;

-- Hardware Detection Unit
HDUM <= '1' when Opcode="10011" else
	'0';


--Zero flag Selection
ZS<= '1' when Opcode="00010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00100" and Interrupt='0' and Reset='0' and BranchResult='0' else 
     '1' when Opcode="00101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00110" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00111" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01000" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     '1' when Opcode="01001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when OpCode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '0';

-- 
NS<= '1' when Opcode="00010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00100" and Interrupt='0' and Reset='0' and BranchResult='0' else 
     '1' when Opcode="00101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00110" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00111" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01000" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     '1' when Opcode="01001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when OpCode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '0';


-- 
VS<= '1' when Opcode="00010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00100" and Interrupt='0' and Reset='0' and BranchResult='0' else 
     '1' when Opcode="00101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00110" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00111" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01000" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     '1' when Opcode="01001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when OpCode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '0';

-- Carry Select
CS<= '1' when Opcode="00010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00100" and Interrupt='0' and Reset='0' and BranchResult='0' else 
     '1' when Opcode="00101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00110" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00111" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01000" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     '1' when Opcode="01001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="10000" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="10001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when OpCode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '0';

RTIsig <= '1' when OpCode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
	  '0';

Decode_Bubble <= '1' when (OpCode="11101" OR OpCode="11100") and Interrupt='0' and Reset='0' and BranchResult='0' else
		 '0';

MemRead <='1' when Opcode="10011" and Interrupt='0' and Reset='0' and BranchResult='0' else
       	  '1' when Opcode="10110" and Interrupt='0' and Reset='0' and BranchResult='0' else
          '1' when Opcode="11100" and Interrupt='0' and Reset='0' and BranchResult='0' else
          '1' when Opcode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
          '1' when Interrupt='1' and Reset='0'  else
          '1' when Reset='1' else
	  '0';
	
MemWrite <='1' when Opcode="10100" and Interrupt='0' and Reset='0' and BranchResult='0' else
       	   '1' when Opcode="10101" and Interrupt='0' and Reset='0' and BranchResult='0' else
           '1' when Opcode="11011" and Interrupt='0' and Reset='0' and BranchResult='0' else
	   '0';

SelMem <= '1' when Opcode="10011" and Interrupt='0' and Reset='0' and BranchResult='0' else
       	  '1' when Opcode="10100" and Interrupt='0' and Reset='0' and BranchResult='0' else
          '1' when Interrupt='1' and Reset='0'  else
          '1' when Reset='1' else
	  '0';

PC1 <= '1' when Opcode="11011" and Interrupt='0' and Reset='0' and BranchResult='0' else
       '1' when Opcode="11100" and Interrupt='0' and Reset='0' and BranchResult='0' else
       '1' when Opcode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
       '1' when Interrupt='1' and Reset='0'  else
       '1' when Reset='0' and BranchResult ='1' and Interrupt='0' else
       '0';

PC0 <= '1' when Opcode="11011" and Interrupt='0' and Reset='0' and BranchResult='0' else
       '1' when Opcode="11100" and Interrupt='0' and Reset='0' and BranchResult='0' else
       '1' when Opcode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
       '1' when Reset='1'  else
       '1' when Reset='0' and BranchResult ='1' and Interrupt='0' else
       '0';

JumpSelect <= '1' when Opcode="11100" and Interrupt='0' and Reset='0' and BranchResult='0' else
       	      '1' when Opcode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
	      '0';

Insig <= '1' when Opcode="01110" and Interrupt='0' and Reset='0' and BranchResult='0' else
	 '0';

Enable <= '1' when Opcode="01111" and Interrupt='0' and Reset='0' and BranchResult='0' else
	  '0';

SaveEnableSig<= '1' when  Interrupt='1' and Reset='0'  else
	        '0' when OpCode="11101";

With SaveEnableSig select SaveEnable <= '0' when 'U',
                          SaveEnableSig when others; 


--ImmValue = '10'
--Memory = '01'
--Output = '00'
WB2Select <= '1' when Opcode="10010" and Interrupt='0' and Reset='0' and BranchResult='0' else
	     '0';

WB1Select <= '1' when Opcode="10011" and Interrupt='0' and Reset='0' and BranchResult='0' else
	     '1' when Opcode="10110" and Interrupt='0' and Reset='0' and BranchResult='0' else
	     '0';

DataInSelect <='1' when Opcode="11011" and Interrupt='0' and Reset='0' and BranchResult='0' else
	     '1' when Interrupt='1' and Reset='0'  else
	     '0';

Pop <= '1' when Opcode="10110" and Interrupt='0' and Reset='0' and BranchResult='0' else
	'1' when Opcode="11100" and Interrupt='0' and Reset='0' and BranchResult='0' else
	'1' when Opcode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
	'0';

Push <= '1' when Opcode="10101" and Interrupt='0' and Reset='0' and BranchResult='0' else
	'1' when Opcode="11011" and Interrupt='0' and Reset='0' and BranchResult='0' else
	'1' when Interrupt='1' and Reset='0' and BranchResult='0' else
	'0';


ShiftSel <= '1' when Opcode="01100" and Interrupt='0' and Reset='0' and BranchResult='0' else
	    '1' when Opcode="01101" and Interrupt='0' and Reset='0' and BranchResult='0' else
	    '0';

JMP <=  '1' when Opcode="10111" and Interrupt='0' and Reset='0' and BranchResult='0' else
	'0';

Jflag1<= '1' when Opcode="11001" and Interrupt='0' and Reset='0' and BranchResult='0' else
	 '0';


Jflag2<= '1' when Opcode="11010" and Interrupt='0' and Reset='0' and BranchResult='0' else
	 '0';

Branch<= '1' when Opcode="11010" OR Opcode="11001" OR Opcode="11000" else
	 '0';

M<=  '1' when Opcode="11101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="11100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="11011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="10110" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="10101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="10100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="10011" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     '1' when Interrupt='1' and Reset='0'  else
     '0';

Rst <= '1' when BranchResult='1' else
       '0';

E<=  '1' when Opcode="00001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00110" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00111" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     '1' when Opcode="01000" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     '1' when Opcode="01001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     
     '1' when Opcode="10001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="10000" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="11000" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="11001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="11010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '0';


WB<=  '1' when Opcode="00001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00110" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="00111" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     '1' when Opcode="01000" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     '1' when Opcode="01001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="01110" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="10010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="10011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '1' when Opcode="10110" and Interrupt='0' and Reset='0' and BranchResult='0' else
     '0';

ALUSelect <= "0000" when Opcode="00001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     	     "0001" when Opcode="00010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "0010" when Opcode="00011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "0011" when Opcode="00100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "0100" when Opcode="00101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "0101" when Opcode="00110" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "0110" when Opcode="00111" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     "0111" when Opcode="01000" and Interrupt='0' and Reset='0' and BranchResult='0' else	
     "1000" when Opcode="01001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "1001" when Opcode="01010" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "1010" when Opcode="01011" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "1011" when Opcode="01100" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "1100" when Opcode="01101" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "1101" when Opcode="10000" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "1110" when Opcode="10001" and Interrupt='0' and Reset='0' and BranchResult='0' else
     "1111";


end architecture mainCU;

