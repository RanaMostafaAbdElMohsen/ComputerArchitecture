library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


---------------------------------------------NOT TESTED---------------------------------------------------


entity ForwUnit is
  port (
    EMopcode : in std_logic_vector(4 downto 0);
    Addr1,Addr2 : in std_logic_vector(2 downto 0);
    WAddrEM, WAddrMW : in std_logic_vector(2 downto 0);
    DFU1Sel1, DFU1Sel0, DFU2Sel, DFU3Sel1, DFU3Sel0, DFU4Sel : out std_logic
	--1:For Op1, which buffer to take data from
	--2:For Op1, am I forwarding in the first place?
	--3:For Op2, Same as 1
	--4:For Op2, Same as 2
);
end entity ForwUnit;

architecture FUArch of ForwUnit is
begin

DFU2Sel <= 	'1' when Addr1=WAddrEM OR Addr1=WAddrMW else
		'0';

DFU4Sel <= 	'1' when Addr2=WAddrEM OR Addr2=WAddrMW else
		'0';

DFU1Sel0 <= 	'0' when Addr1=WAddrEM else			--0:ALU-To-ALU	1:Memory-To-ALU
		'1';
DFU1Sel1 <=	'1' when EMOpCode="10010" else
		'0';
		
DFU3Sel0 <= 	'0' when Addr2=WAddrEM else
		'1';
DFU3Sel1 <=	'1' when EMOpCode="10010" else
		'0';

end FUArch;