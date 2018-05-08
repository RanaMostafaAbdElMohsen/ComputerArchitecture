library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


---------------------------------------------NOT TESTED---------------------------------------------------


entity ALU is
  port (
    A,B : in  std_logic_vector(15 downto 0);
    Cin : in std_logic;
    S : in std_logic_vector(3 downto 0);
    F : out std_logic_vector(15 downto 0);
    CCR : out std_logic_vector(3 downto 0)	--	0->Zero		1->Negative	 2->Carry	 3->Overflow
);
end entity ALU;

architecture ALUArch of ALU is

COMPONENT genericAdder is
Generic ( n : integer := 16);
port(
A,B : in std_logic_vector(n-1 downto 0);
Operation : in std_logic;
Sum : out std_logic_vector(n-1 downto 0);
Cout : out std_logic
);
end COMPONENT;


-----------------------------------------------OUTPUT SIGNALS------------------------------------------------------
Signal MovOut : std_logic_vector(15 downto 0);
Signal AddOut : std_logic_vector(15 downto 0);
Signal SubOut : std_logic_vector(15 downto 0);
Signal AndOut : std_logic_vector(15 downto 0);
Signal OrOut : std_logic_vector(15 downto 0);
Signal NotOut : std_logic_vector(15 downto 0);
Signal NegOut : std_logic_vector(15 downto 0);
Signal IncOut : std_logic_vector(15 downto 0);
Signal DecOut : std_logic_vector(15 downto 0);
Signal RlcOut : std_logic_vector(15 downto 0);
Signal RrcOut : std_logic_vector(15 downto 0);
Signal ShlOut : std_logic_vector(15 downto 0);
Signal ShrOut : std_logic_vector(15 downto 0);
Signal SetOut : std_logic_vector(15 downto 0);
Signal ClrOut : std_logic_vector(15 downto 0);

-------------------------------------------------CCR SIGNALS------------------------------------------------------
Signal MovCCR : std_logic_vector(3 downto 0);
Signal AddCCR : std_logic_vector(3 downto 0);
Signal SubCCR : std_logic_vector(3 downto 0);
Signal AndCCR : std_logic_vector(3 downto 0);
Signal OrCCR : std_logic_vector(3 downto 0);
Signal NotCCR : std_logic_vector(3 downto 0);
Signal NegCCR : std_logic_vector(3 downto 0);
Signal IncCCR : std_logic_vector(3 downto 0);
Signal DecCCR : std_logic_vector(3 downto 0);
Signal RlcCCR : std_logic_vector(3 downto 0);
Signal RrcCCR : std_logic_vector(3 downto 0);
Signal ShlCCR : std_logic_vector(3 downto 0);
Signal ShrCCR : std_logic_vector(3 downto 0);
Signal SetCCR : std_logic_vector(3 downto 0);
Signal ClrCCR : std_logic_vector(3 downto 0);

Signal NOTSubCCR  :std_logic;
Signal NOTB  : std_logic_vector(15 downto 0);
Signal Zeros : std_logic_vector(15 downto 0);
begin
Zeros <= "0000000000000000";


MovOut <= B;
MovCCR(0) <=	'1' when B = Zeros else
		'0';
MovCCR(1) <=	'1' when B(15) = '1' else
		'0';
MovCCR(2) <=	'0';
MovCCR(3) <=	'0';


Adder: genericAdder PORT MAP(A,B,'0',AddOut,AddCCR(2));
AddCCR(0) <=	'1' when AddOut = Zeros else
		'0';
AddCCR(1) <=	'1' when AddOut(15) = '1' else
		'0';
AddCCR(3) <=	'1' when (A(15)='1' AND B(15)='1' AND AddOut(15)='0') OR (A(15)='0' AND B(15)='0' AND AddOut(15)='1') else
		'0';

NOTB <= NOT B;
Subtractor: genericAdder PORT MAP(A,NOTB,'1',SubOut,NOTSubCCR);
SubCCR(0) <=	'1' when SubOut = Zeros else
		'0';
SubCCR(1) <=	'1' when SubOut(15) = '1' else
		'0';
--Added Negate of the subtraction carry
SubCCR(2)<= NOT NOTSubCCR;

SubCCR(3) <=	'1' when (A(15)='1' AND B(15)='1' AND AddOut(15)='0') OR (A(15)='0' AND B(15)='0' AND AddOut(15)='1') else
		'0';


AndOut <= A AND B;
AndCCR(0) <=	'1' when AndOut = Zeros else
		'0';
AndCCR(1) <=	'1' when AndOut(15) = '1' else
		'0';
AndCCR(2) <=	'0';
AndCCR(3) <=	'0';



OrOut <= A OR B;
OrCCR(0) <=	'1' when OrOut = Zeros else
		'0';
OrCCR(1) <=	'1' when OrOut(15) = '1' else
		'0';
OrCCR(2) <=	'0';
OrCCR(3) <=	'0';



NotOut <= NOT A;
NotCCR(0) <=	'1' when NotOut = Zeros else
		'0';
NotCCR(1) <=	'1' when NotOut(15) = '1' else
		'0';
NotCCR(2) <=	'0';
NotCCR(3) <=	'0';



NegOut <= std_logic_vector(signed(Zeros) - signed(A));
NegCCR(0) <=	'1' when NegOut = Zeros else
		'0';
NegCCR(1) <=	'1' when NegOut(15) = '1' else
		'0';
NegCCR(2) <=	'0';
NegCCR(3) <=	'0';



IncOut <= std_logic_vector(signed(A) + 1);
IncCCR(0) <=	'1' when IncOut = Zeros else
		'0';
IncCCR(1) <=	'1' when IncOut(15) = '1' else
		'0';
IncCCR(2) <=	'0';
IncCCR(3) <=	'0';



DecOut <= std_logic_vector(signed(A) - 1);
DecCCR(0) <=	'1' when DecOut = Zeros else
		'0';
DecCCR(1) <=	'1' when DecOut(15) = '1' else
		'0';
DecCCR(2) <=	'0';
DecCCR(3) <=	'0';



RlcOut <= A(14 downto 0)&Cin;
RlcCCR(0) <=	'1' when RlcOut = Zeros else
		'0';
RlcCCR(1) <=	'1' when RlcOut(15) = '1' else
		'0';
RlcCCR(2) <=	A(15);
RlcCCR(3) <=	'0';



RrcOut <= Cin&A(15 downto 1);
RrcCCR(0) <=	'1' when RrcOut = Zeros else
		'0';
RrcCCR(1) <=	'1' when RrcOut(15) = '1' else
		'0';
RrcCCR(2) <=	A(0);
RrcCCR(3) <=	'0';



ShlOut <= std_logic_vector(shift_left(signed(A),TO_INTEGER(unsigned(B))));
ShlCCR(0) <=	'1' when ShlOut = Zeros else
		'0';
ShlCCR(1) <=	'1' when ShlOut(15) = '1' else
		'0';
ShlCCR(2) <=	'0';
ShlCCR(3) <=	'0';



ShrOut <= std_logic_vector(shift_right(signed(A),TO_INTEGER(unsigned(B))));
ShrCCR(0) <=	'1' when ShrOut = Zeros else
		'0';
ShrCCR(1) <=	'1' when ShrOut(15) = '1' else
		'0';
ShrCCR(2) <=	'0';
ShrCCR(3) <=	'0';



SetOut <= Zeros;
SetCCR(0) <=	'0';
SetCCR(1) <=	'0';
SetCCR(2) <=	'1';
SetCCR(3) <=	'0';


ClrOut <= Zeros;
ClrCCR(0) <=	'0';
ClrCCR(1) <=	'0';
ClrCCR(2) <=	'0';
ClrCCR(3) <=	'0';


F	<=	MovOut	when	S = "0000"	else
		AddOut	when	S = "0001"	else
		SubOut	when	S = "0010"	else
		AndOut	when	S = "0011"	else
		OrOut	when	S = "0100"	else
		NotOut	when	S = "0101"	else
		NegOut	when	S = "0110"	else
		IncOut	when	S = "0111"	else
		DecOut	when	S = "1000"	else
		RlcOut	when	S = "1001"	else
		RrcOut	when	S = "1010"	else
		ShlOut	when	S = "1011"	else
		ShrOut	when	S = "1100"	else
		SetOut	when	S = "1101"	else
		ClrOut	when	S = "1110"	;


CCR	<=	MovCCR	when	S = "0000"	else
		AddCCR	when	S = "0001"	else
		SubCCR	when	S = "0010"	else
		AndCCR	when	S = "0011"	else
		OrCCR	when	S = "0100"	else
		NotCCR	when	S = "0101"	else
		NegCCR	when	S = "0110"	else
		IncCCR	when	S = "0111"	else
		DecCCR	when	S = "1000"	else
		RlcCCR	when	S = "1001"	else
		RrcCCR	when	S = "1010"	else
		ShlCCR	when	S = "1011"	else
		ShrCCR	when	S = "1100"	else
		SetCCR	when	S = "1101"	else
		ClrCCR	when	S = "1110"	;


end ALUArch;