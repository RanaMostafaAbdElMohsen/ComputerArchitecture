library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Processor is
  port (
    Clk : in std_logic;
    Interrupt : in std_logic;
    Reset : in std_logic;
    IN_PORT : in std_logic_vector(15 downto 0);
    OUT_PORT : out std_logic_vector(15 downto 0)
);
end entity Processor;

architecture MainArch of Processor is

Component my_DFF is
port( clk,rst,d : in std_logic;
q : out std_logic);
end Component;



COMPONENT genericRegister is
Generic ( n : integer := 16);
port( Clk,Rst : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
END COMPONENT;

component IFet is
port
(clk,PCenable:in std_logic;
ALUOutput,MemoryOutput,DecodeOutput : in std_logic_vector(15 downto 0);
JMP,JumpSelect : in std_logic;
bubble,decode_bubble,execute_bubble:in std_logic;
bubbleSel:out std_logic;
newPC:in std_logic_vector(1 downto 0);
EA:out std_logic_vector(15 downto 0);
M_0,M_1:in std_logic_vector(15 downto 0);
Instruction_out,ImmL:out std_logic_vector(15 downto 0);
PC_plus_1_out:out std_logic_vector(15 downto 0);
Opcode_F: out std_logic_vector(4 downto 0)
--PC_OUT_test:out std_logic_vector(15 downto 0)
);
end component;

component Decoder is
port (
Clk : in std_logic;
RST : in std_logic;
WB : in std_logic;
readaddr1 : in std_logic_vector (2 downto 0);
readaddr2 : in std_logic_vector  (2 downto 0);
writeaddr : in std_logic_vector  (2 downto 0);
writedata : in std_logic_vector  (15 downto 0);
inport    : in std_logic_vector   (15 downto 0);
insig     : in std_logic;
dataout1 : out std_logic_vector  (15 downto 0);
dataout2 : out std_logic_vector  ( 15 downto 0)
);
end component;

component ExecuteStage is
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
end component;

component memory is
generic (n1:integer:=16; m1:integer:=16);
port ( 
	  clk          : in std_logic; 
	  write_en     : in std_logic; 
	  read_en      : in std_logic; 
	  WBsel1       : in std_logic;
	  WBsel2       : in std_logic;
	  Memsel       : in std_logic;
	  Datainsel    : in std_logic;
	  SaveEnable   : in std_logic;
       	  Znew         : in std_logic;
	  Nnew         : in std_logic;
	  Vnew         : in std_logic;
	  Cnew         : in std_logic;
	  EA           : in std_logic_vector(n1-1 downto 0);
  	  SP           : in std_logic_vector(n1-1 downto 0);
	  ALUoutput    : in std_logic_vector(m1-1 downto 0);
          IMML         : in std_logic_vector(m1-1 downto 0);
          PCplus1      : in std_logic_vector(n1-1 downto 0);
	  Data         : out std_logic_vector(m1-1 downto 0);
	  Mone         : out std_logic_vector(m1-1 downto 0);
	  Mzero        : out std_logic_vector(m1-1 downto 0);
	  Zold         : out std_logic;
	  Nold         : out std_logic;
	  Vold         : out std_logic;
	  Cold         : out std_logic
	 ); 
end component;

component writeback is
generic (n:integer:=3; m:integer:=16);
port ( 
	  BubbleSelect : in std_logic;
 	  WBaddressIN  : in std_logic_vector(n-1 downto 0);
	  datain       : in std_logic_vector(m-1 downto 0);
	  REGwrite     : in std_logic;
	  REGwriteOUT  : out std_logic;
	  dataout      : out std_logic_vector(m-1 downto 0);
	  WBaddressOUT : out std_logic_vector(n-1 downto 0)
	 ); 
end component;

component CU is
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
end component;

component Fetch_Decode_Buffer is
port( clk,reset : in std_logic;
enablef:in std_logic;
--------------Buffer_in------------------
Instruction_in: in std_logic_vector(15 downto 0);
PC_plus_1_in: in std_logic_vector(15 downto 0);
InterruptSignal: in std_logic;
--------------Buffer_out------------------
Opcode_out: out std_logic_vector(4 downto 0);
Reg1_out: out std_logic_vector(2 downto 0);
Reg2_out: out std_logic_vector(2 downto 0);
Immsh_out: out std_logic_vector(3 downto 0);
PC_plus_1_out: out std_logic_vector(15 downto 0);
WriteAddr : out std_logic_vector(2 downto 0);
InterruptSignal_out: out std_logic
);
end component;

------------------------------------------RST/En Signals------------------------------------------
Signal FD_Buffer_Reset,FD_Buffer_Enable : std_logic;
Signal DE_Buffer_Reset,DE_Buffer_Enable : std_logic;
Signal EM_Buffer_Reset,EM_Buffer_Enable : std_logic;
Signal MW_Buffer_Reset,MW_Buffer_Enable : std_logic;

------------------------------------------Port Signals------------------------------------------
Signal OutPortSig : std_logic_vector(15 downto 0);
Signal OutPortEnable : std_logic;

------------------------------------------Fetch Signals--------------------------------------
Signal Fetch_Bubble : std_logic;
Signal Fetch_newPC : std_logic_vector(1 downto 0);
Signal Fetch_M_0,Fetch_M_1,Fetch_Jlocation : std_logic_vector(15 downto 0);
Signal Fetch_EA : std_logic_vector(15 downto 0);
Signal Fetch_Instruction_out,Fetch_ImmL : std_logic_vector(15 downto 0);
Signal Fetch_PC_plus_1_out : std_logic_vector(15 downto 0);
Signal Fetch_Opcode_F : std_logic_vector(4 downto 0);
Signal Fetch_JMP, Fetch_JumpSelect : std_logic;
Signal Fetch_BubbleSelect : std_logic;
Signal Fetch_WriteAddr: std_logic_vector(2 downto 0);

------------------------------------------Decode Signals--------------------------------------
Signal Decode_OpCode : std_logic_vector(4 downto 0);
Signal Decode_WB : std_logic;
Signal Decode_RST : std_logic := '0';
Signal Decode_ReadAddr1, Decode_ReadAddr2 : std_logic_vector(2 downto 0);
Signal Decode_WriteAddr : std_logic_vector(2 downto 0);
Signal Decode_WriteData : std_logic_vector(15 downto 0);
Signal Decode_ImmShift : std_logic_vector(3 downto 0);
Signal Decode_InSig : std_logic;
Signal Decode_DataOut1, Decode_DataOut2 : std_logic_vector(15 downto 0);
Signal Decode_Interrupt : std_logic;						--WTF
Signal Decode_PC_plus_1 : std_logic_vector(15 downto 0);
Signal Decode_E, Decode_M, Decode_W : std_logic;				--WTF

Signal Decode_ALUSelect : std_logic_vector(3 downto 0);
Signal Decode_JFlag0,Decode_JFlag1 : std_logic;
Signal Decode_ShiftSel : std_logic;
Signal Decode_Push,Decode_Pop : std_logic;
Signal Decode_Branch : std_logic;
Signal Decode_OutPortEnable : std_logic;
Signal Decode_CS,Decode_VS,Decode_NS,Decode_ZS : std_logic;
Signal Decode_RTIsig : std_logic;
Signal Decode_Bubble : std_logic;
Signal Decode_BubbleSelect : std_logic;

Signal Decode_SelMem : std_logic;
Signal Decode_DataInSelect : std_logic;
Signal Decode_WB1Select,Decode_WB0Select : std_logic;
Signal Decode_SaveEnable : std_logic;
Signal Decode_MemRead,Decode_MemWrite : std_logic;				--WTF

------------------------------------------Execute Signals--------------------------------------
Signal Execute_Opcode : std_logic_vector(4 downto 0);
Signal Execute_ReadAddr1,Execute_ReadAddr2 : std_logic_vector(2 downto 0);
Signal Execute_WriteAddr : std_logic_vector(2 downto 0);
Signal Execute_ALUSelect : std_logic_vector(3 downto 0);
Signal Execute_ImmShift : std_logic_vector(3 downto 0);
Signal Execute_DataOut1,Execute_DataOut2 : std_logic_vector(15 downto 0);
Signal Execute_PC_plus_1 : std_logic_vector(15 downto 0);
Signal Execute_SP : std_logic_vector(15 downto 0);
Signal Execute_Pop,Execute_Push : std_logic;
Signal Execute_ZS,Execute_NS,Execute_VS,Execute_CS : std_logic;
Signal Execute_Znew,Execute_Nnew,Execute_Vnew,Execute_Cnew : std_logic;
Signal Execute_JFlag1,Execute_JFlag0 : std_logic;
Signal Execute_Output : std_logic_vector(15 downto 0);
Signal Execute_ShiftSel : std_logic;
Signal Execute_Branch : std_logic;
Signal Execute_BranchResult : std_logic;
Signal Execute_OutPortEnable : std_logic;
Signal Execute_SelMem : std_logic;
Signal Execute_DataInSelect : std_logic;
Signal Execute_WB1Select,Execute_WB0Select : std_logic;
Signal Execute_SaveEnable : std_logic;
Signal Execute_MemRead,Execute_MemWrite : std_logic;
Signal Execute_EA : std_logic_vector(15 downto 0);
Signal Execute_ImmL : std_logic_vector(15 downto 0);
Signal Execute_RTIsig : std_logic;
Signal Execute_Bubble : std_logic;
Signal Execute_BubbleSelect : std_logic;
Signal Execute_W : std_logic;

------------------------------------------Memory Signals--------------------------------------
Signal Memory_Opcode : std_logic_vector(4 downto 0);
Signal Memory_WriteAddr : std_logic_vector(2 downto 0);
Signal Memory_Output : std_logic_vector(15 downto 0);
Signal Memory_PC_plus_1 : std_logic_vector(15 downto 0);
Signal Memory_SP : std_logic_vector(15 downto 0);
Signal Memory_Data : std_logic_vector(15 downto 0);
Signal Memory_MemRead, Memory_MemWrite : std_logic;
Signal Memory_SelMem : std_logic;
Signal Memory_DataInSelect : std_logic;
Signal Memory_WB1Select : std_logic;
Signal Memory_WB0Select : std_logic;
Signal Memory_SaveEnable : std_logic;
Signal Memory_EA : std_logic_vector(15 downto 0);
Signal Memory_ImmL : std_logic_vector(15 downto 0);
Signal Memory_Znew,Memory_Nnew,Memory_Vnew,Memory_Cnew : std_logic;
Signal Memory_Zold,Memory_Nold,Memory_Vold,Memory_Cold : std_logic;
Signal Memory_BubbleSelect : std_logic;
Signal Memory_W : std_logic;

------------------------------------------WB Signals--------------------------------------
Signal WB_Opcode : std_logic_vector(4 downto 0);
Signal WB_WriteAddr : std_logic_vector(2 downto 0);
Signal WB_Data : std_logic_vector(15 downto 0);
Signal WB_BubbleSelect : std_logic;
Signal WB_W : std_logic;

------------------------------------------Other Signals--------------------------------------
Signal Fetch_HDUM : std_logic; --Under construction
Signal CU_Rst : std_logic;
  
begin

OUT_PORT <= OutPortSig when OutPortEnable = '1';


myCU : CU PORT MAP (Decode_OPCode,Execute_BranchResult,Interrupt,Reset,Decode_M,Decode_W,Decode_E,CU_Rst,Decode_JFlag0,Decode_JFlag1,Decode_ShiftSel,Decode_Push,Decode_Pop,Decode_Branch,Decode_SelMem,Decode_DataInSelect,Decode_WB0Select,Decode_WB1Select,Decode_OutPortEnable,Decode_ALUSelect,Decode_SaveEnable,Decode_Insig,Fetch_JumpSelect,Fetch_JMP,Fetch_newPC(0),Fetch_newPC(1),Decode_CS,Decode_VS,Decode_NS,Decode_ZS,Decode_RTIsig,Decode_MemRead,Decode_MemWrite,Decode_Bubble,Fetch_HDUM);

-----------------------------------------------------

myFetch : IFet PORT MAP (clk,'1',Execute_Output,Memory_Data,Decode_DataOut1,Fetch_JMP,Fetch_JumpSelect,Fetch_Bubble,Decode_Bubble,Execute_Bubble,Fetch_BubbleSelect,Fetch_newPC,Fetch_EA,Fetch_M_0,Fetch_M_1,Fetch_Instruction_out,Fetch_ImmL,Fetch_PC_plus_1_out,Fetch_Opcode_F);

myFetchBuffer : Fetch_Decode_Buffer PORT MAP (clk,FD_Buffer_Reset,'1',Fetch_Instruction_out,Fetch_PC_plus_1_out,Interrupt,Decode_OpCode,Decode_ReadAddr1,Decode_ReadAddr2,Decode_ImmShift,Decode_PC_plus_1,Fetch_WriteAddr,Decode_Interrupt);
rFetch_BubbleSel : my_DFF port map(Clk,FD_Buffer_Reset,Fetch_BubbleSelect,Decode_BubbleSelect);
------------------------------------------------------

myDecoder : Decoder PORT MAP (clk,'0',Decode_WB,Decode_ReadAddr1,Decode_ReadAddr2,Decode_WriteAddr,Decode_WriteData,IN_PORT,Decode_InSig,Decode_DataOut1,Decode_DataOut2);

rDecode_Opcode: genericRegister generic map (n => 5) port map(clk,DE_Buffer_Reset,Decode_Opcode,Execute_Opcode);

rDecode_BubbleSel : my_DFF port map(Clk,DE_Buffer_Reset,Decode_BubbleSelect,Execute_BubbleSelect);
rDecode_ImmShift: genericRegister generic map (n => 4) port map(Clk,DE_Buffer_Reset,Decode_ImmShift,Execute_ImmShift);
--rDecode_Data1: genericRegister generic map (n => 16) port map(Clk,DE_Buffer_Reset,Decode_DataOut1,Execute_DataOut1);
--rDecode_Data2: genericRegister generic map (n => 16) port map(Clk,DE_Buffer_Reset,Decode_DataOut2,Execute_DataOut2);
rDecode_ReadAddr1: genericRegister generic map (n => 3) port map(Clk,DE_Buffer_Reset,Decode_ReadAddr1,Execute_ReadAddr1);
rDecode_ReadAddr2: genericRegister generic map (n => 3) port map(Clk,DE_Buffer_Reset,Decode_ReadAddr2,Execute_ReadAddr2);
rDecode_ALUSelect: genericRegister generic map (n => 4) port map(Clk,DE_Buffer_Reset,Decode_ALUSelect,Execute_ALUSelect);
rDecode_ShiftSel : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_ShiftSel,Execute_ShiftSel);
rDecode_JFlag0 : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_JFlag0,Execute_JFlag0);
rDecode_JFlag1 : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_JFlag1,Execute_JFlag1);
rDecode_Push : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_Push,Execute_Push);
rDecode_Pop : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_Pop,Execute_Pop);
rDecode_Branch : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_Branch,Execute_Branch);
rDecode_OutPortEnable : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_OutPortEnable,Execute_OutPortEnable);
rDecode_CS : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_CS,Execute_CS);
rDecode_NS : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_NS,Execute_NS);
rDecode_VS : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_VS,Execute_VS);
rDecode_ZS : my_DFF  port map(Clk,DE_Buffer_Reset,Decode_ZS,Execute_ZS);
rDecode_RTI : my_DFF port map(Clk,DE_Buffer_Reset,Decode_RTIsig,Execute_RTIsig);
rDecode_Bubble : my_DFF port map(Clk,DE_Buffer_Reset,Decode_Bubble,Execute_Bubble);

rDecode_MemRead: my_DFF  port map(Clk,DE_Buffer_Reset,Decode_MemRead,Execute_MemRead);
rDecode_MemWrite: my_DFF  port map(Clk,DE_Buffer_Reset,Decode_MemWrite,Execute_MemWrite);
rDecode_PC: genericRegister generic map (n => 16) port map(Clk,DE_Buffer_Reset,Decode_PC_plus_1,Execute_PC_plus_1);
rDecode_EA: genericRegister generic map (n => 16) port map(Clk,DE_Buffer_Reset,Fetch_EA,Execute_EA);
rDecode_SelMem: my_DFF  port map(Clk,DE_Buffer_Reset,Decode_SelMem,Execute_SelMem);
rDecode_DataInSelect: my_DFF  port map(Clk,DE_Buffer_Reset,Decode_DataInSelect,Execute_DataInSelect);
rDecode_WB0Select: my_DFF  port map(Clk,DE_Buffer_Reset,Decode_WB0Select,Execute_WB0Select);
rDecode_WB1Select: my_DFF  port map(Clk,DE_Buffer_Reset,Decode_WB1Select,Execute_WB1Select);
rDecode_SaveEnable: my_DFF  port map(Clk,DE_Buffer_Reset,Decode_SaveEnable,Execute_SaveEnable);

rDecode_WriteAddr: genericRegister generic map (n => 3) port map(Clk,DE_Buffer_Reset,Fetch_WriteAddr,Execute_WriteAddr);--Modified
rDecode_Imml: genericRegister generic map (n => 16 ) port map(Clk,DE_Buffer_Reset,Fetch_ImmL,Execute_ImmL);

rDecode_W: my_DFF  port map(Clk,DE_Buffer_Reset,Decode_W,Execute_W);

-------------------------------------------------------

myExecuter: ExecuteStage PORT MAP (Execute_OPCode,Memory_OPCode,Decode_DataOut1,Decode_DataOut2,Execute_ImmShift,Execute_ALUSelect,Execute_ShiftSel,Execute_ReadAddr1,Execute_ReadAddr2,Memory_WriteAddr,WB_WriteAddr,Memory_Output,WB_Data,Memory_Imml,Execute_Pop,Execute_Push,Execute_JFlag1,Execute_JFlag0,Execute_Branch,Execute_BranchResult,Execute_Output,Execute_RTIsig,Memory_Zold,Memory_Nold,Memory_Vold,Memory_Cold,Execute_ZS,Execute_NS,Execute_VS,Execute_CS,Execute_Znew,Execute_Nnew,Execute_Vnew,Execute_Cnew,Execute_SP,Memory_SP,OutPortSig);

rExecute_BubbleSel : my_DFF port map(Clk,EM_Buffer_Reset,Execute_BubbleSelect,Memory_BubbleSelect); 
rExecute_Output : genericRegister generic map (n => 16) port map(Clk,EM_Buffer_Reset,Execute_Output,Memory_Output);
rExecute_Znew: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_Znew,Memory_Znew);
rExecute_Nnew: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_Nnew,Memory_Nnew);
rExecute_Vnew: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_Vnew,Memory_Vnew);
rExecute_Cnew: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_Cnew,Memory_Cnew);
rExecute_SP : genericRegister generic map (n => 16) port map(Clk,EM_Buffer_Reset,Execute_SP,Memory_SP);
rExecute_Opcode: genericRegister generic map (n => 5) port map(clk,EM_Buffer_Reset,Execute_Opcode,Memory_Opcode);
rExecute_WriteAddr: genericRegister generic map (n => 3) port map(Clk,EM_Buffer_Reset,Execute_WriteAddr, Memory_WriteAddr);
rExecute_MemRead: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_MemRead,Memory_MemRead);
rExecute_MemWrite: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_MemWrite,Memory_MemWrite);
rExecute_PC: genericRegister generic map (n => 16) port map(Clk,EM_Buffer_Reset,Execute_PC_plus_1,Memory_PC_plus_1);
rExecute_EA: genericRegister generic map (n => 16) port map(Clk,EM_Buffer_Reset,Execute_EA,Memory_EA);
rExecute_SelMem: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_SelMem,Memory_SelMem);
rExecute_DataInSelect: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_DataInSelect,Memory_DataInSelect);
rExecute_WB0Select: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_WB0Select,Memory_WB0Select);
rExecute_WB1Select: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_WB1Select,Memory_WB1Select);
rExecute_SaveEnable: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_SaveEnable,Memory_SaveEnable);
rExecute_Imml: genericRegister generic map (n => 16) port map(Clk,EM_Buffer_Reset,Execute_ImmL,Memory_ImmL);

rExecute_W: my_DFF  port map(Clk,EM_Buffer_Reset,Execute_W,Memory_W);

-----------------------------------------------------

myMemory : memory PORT MAP (clk,Memory_MemWrite,Memory_MemRead,Memory_WB0Select,Memory_WB1Select,Memory_SelMem,Memory_DataInSelect,Memory_SaveEnable,Memory_Znew,Memory_Nnew,Memory_Vnew,Memory_Cnew,Memory_EA,Memory_SP,Memory_Output,Memory_Imml,Memory_PC_plus_1,Memory_Data,Fetch_M_1,Fetch_M_0,Memory_Zold,Memory_Nold,Memory_Vold,Memory_Cold);

rMemory_BubbleSel : my_DFF port map(Clk,MW_Buffer_Reset,Memory_BubbleSelect,WB_BubbleSelect);
rMemory_OpCode : genericRegister generic map (n => 5) port map(Clk,MW_Buffer_Reset,Memory_OpCode,WB_OpCode);
rMemory_WriteAddr : genericRegister generic map (n => 3) port map(Clk,MW_Buffer_Reset,Memory_WriteAddr,WB_WriteAddr);
rMemory_Data : genericRegister generic map (n => 16) port map(Clk,MW_Buffer_Reset,Memory_Data,WB_Data);
rMemory_W: my_DFF  port map(Clk,MW_Buffer_Reset,Memory_W,WB_W);

----------------------------------------------------

myWriteBack : writeback PORT MAP(WB_BubbleSelect,WB_WriteAddr,WB_Data,WB_W,Decode_WB,Decode_WriteData,Decode_WriteAddr);

end MainArch;