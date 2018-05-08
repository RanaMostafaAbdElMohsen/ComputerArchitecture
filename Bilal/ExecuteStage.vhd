library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ExecuteStage is
  port (
    OPCode : in std_logic_vector(4 downto 0);
    EMopcode : in std_logic_vector(4 downto 0);
    Data1 ,Data2 : in std_logic_vector(15 downto 0);
    ImmShift : in std_logic_vector(3 downto 0);
    ALUSelect : in std_logic_vector(3 downto 0);
    ShiftSel : in std_logic;
    Addr1, Addr2 : in std_logic_vector(2 downto 0);
    WAddrEM, WAddrMW : in std_logic_vector(2 downto 0);
    PrevALU, PrevMem : in std_logic_vector(15 downto 0);
    PrevALUImm : in std_logic_vector(15 downto 0);
    Pop,Push : in std_logic;
    JFlag1,JFlag0 : in std_logic;
    Branch : in std_logic;
    BranchResult : out std_logic;
    Output : out std_logic_vector(15 downto 0);
    RTIsig : in std_logic;
    Zsaved, Nsaved, Vsaved, Csaved : in std_logic;
    ZS, NS, VS, CS : in std_logic;
    Znew, Nnew, Vnew, Cnew : out std_logic;
    SP : out std_logic_vector(15 downto 0);
    SPold : in std_logic_vector(15 downto 0);
    OUT_PORT : out std_logic_vector(15 downto 0)
);
end entity ExecuteStage;

architecture ExeArch of ExecuteStage is

Signal Op1,Op2 : std_logic_vector(15 downto 0);
Signal CCR : std_logic_vector(3 downto 0);
Signal CCRnew : std_logic_vector(3 downto 0);
Signal PoppedSP,PushedSP : std_logic_vector(15 downto 0);
Signal DFU1Sel1, DFU1Sel0, DFU2Sel, DFU3Sel1, DFU3Sel0, DFU4Sel : std_logic;
Signal Mux1OP1,Mux2OP1,Mux1OP2,Mux2OP2,Mux3OP2 : std_logic_vector(15 downto 0);
Signal Zflag,Nflag,Vflag,Cflag	: std_logic;
Signal Zin,Nin,Vin,Cin : std_logic;

COMPONENT genericAdder is
Generic ( n : integer := 16);
port(
A,B : in std_logic_vector(n-1 downto 0);
Operation : in std_logic;
Sum : out std_logic_vector(n-1 downto 0);
Cout : out std_logic
);
end COMPONENT;

Component ALU is
  port (
    A,B : in  std_logic_vector(15 downto 0);
    Cin : in std_logic;
    S : in std_logic_vector(3 downto 0);
    F : out std_logic_vector(15 downto 0);
    CCR : out std_logic_vector(3 downto 0)	--	0->Zero		1->Negative	 2->Carry	 3->Overflow
);
end component;

component ForwUnit is
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
end component;

component flagBuffer is
  port (
    ZS, NS, VS, CS : in std_logic;
    Znew, Nnew, Vnew, Cnew : in std_logic;
    Zold, Nold, Vold, Cold : out std_logic
);
end component;

component branchCalc is
  port (
    Z, N, C : in std_logic;
    JFlag1, JFlag0 : in std_logic;
    Branch : in std_logic;
    BranchResult : out std_logic
);
end component;

begin

-------------------------------------------------OP1 Determining----------------------------------------------------
Mux1OP1 <=	PrevMem when DFU1Sel1 = '0' AND DFU1Sel0 = '1' else
		PrevALU when DFU1Sel1 = '0' AND DFU1Sel0 = '0' else
		PrevALUImm when DFU1Sel1 = '1' AND DFU1Sel0 = '0';
Mux2OP1 <=	Mux1OP1 when DFU2Sel = '1' else
		Data1;
Op1	<=	Mux2OP1;-- testing


-------------------------------------------------OP2 Determining----------------------------------------------------

Mux1OP2 <=	"000000000000" & ImmShift when ShiftSel = '1' else
		Data2;
Mux2OP2 <=	PrevMem when DFU3Sel1 = '0' AND DFU3Sel0 = '1' else
		PrevALU when DFU3Sel1 = '0' AND DFU3Sel0 = '0' else
		PrevALUImm when DFU3Sel1 = '1' AND DFU3Sel0 = '0';
Mux3OP2 <=	Mux2OP2 when DFU4Sel = '1' else
		Mux1OP2;
Op2	<=	Mux3OP2;--testing


-------------------------------------------------SP Determining----------------------------------------------------
myPopper : genericAdder GENERIC MAP(n=>16) PORT MAP(SPold,"0000000000000001",'0',PoppedSP);

myPusher : genericAdder GENERIC MAP(n=>16) PORT MAP(SPold,"0000000000000001",'1',PushedSP);

SP	<= 	PoppedSP when POP = '1' else
		PushedSP when PUSH = '1' else
		SPold;


-------------------------------------------------Components----------------------------------------------------
myALU : ALU PORT MAP(Op1,Op2,CCR(2),ALUSelect,Output,CCRnew);

myDFU : ForwUnit PORT MAP(EMopcode,Addr1,Addr2,WAddrEM,WAddrMW,DFU1Sel1, DFU1Sel0, DFU2Sel, DFU3Sel1, DFU3Sel0, DFU4Sel);

Zin <= 	Zsaved when RTIsig='1' else
	CCRnew(0);

Nin <= 	Nsaved when RTIsig='1' else
	CCRnew(1);

Vin <= 	Vsaved when RTIsig='1' else
	CCRnew(3);

Cin <= 	Csaved when RTIsig='1' else
	CCRnew(2);

myCCR : flagBuffer PORT MAP(ZS, NS, VS, CS, Zin, Nin, Vin, Cin, Zflag, Nflag, Vflag, Cflag);
Znew <= Zflag;
Nnew <= Nflag;
Vnew <= Vflag;
Cnew <= Cflag;

myBranchCalc : branchCalc PORT MAP(Zflag,Nflag,Cflag,JFlag1,JFlag0,Branch,BranchResult);

end ExeArch;