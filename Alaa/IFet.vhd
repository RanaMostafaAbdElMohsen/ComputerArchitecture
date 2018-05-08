library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFet is
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
end entity IFet;

Architecture archIFet of IFet is

component mux2x1 is
Generic (n:integer);
port(
d1:in std_logic_vector(n-1 downto 0);
d2:in std_logic_vector(n-1 downto 0);
s:in std_logic;
q:out std_logic_vector(n-1 downto 0)
);
end component mux2x1;

component Mux4x1 is
Generic (n:integer);
port(
d1:in std_logic_vector(n-1 downto 0);
d2:in std_logic_vector(n-1 downto 0);
d3:in std_logic_vector(n-1 downto 0);
d4:in std_logic_vector(n-1 downto 0);
s:in std_logic_vector(1 downto 0);
q:out std_logic_vector(n-1 downto 0));
end component Mux4x1;

component PC_reg is
port(clk,wenable:in std_logic;
d:in std_logic_vector(15 downto 0);
q:out std_logic_vector(15 downto 0)
);
end component PC_reg;

component instruction_memory is
port(clk: in std_logic;
address : in std_logic_vector(9 downto 0);
dataout : out std_logic_vector(15 downto 0)
);
end component instruction_memory ;


signal stall:std_logic_vector(15 downto 0);
signal PC_plus_1,PC_out,Instruction:std_logic_vector(15 downto 0);
signal instruction_memory_address: std_logic_vector(15 downto 0) ; 
signal address: std_logic_vector(15 downto 0) ;
signal Jselect : std_logic_vector(1 downto 0);
signal JLocation : std_logic_vector(15 downto 0);
signal bubbleSelect : std_logic;
--PC_OUT_test<=PC_out;
begin
 bubbleSelect <= bubble OR decode_bubble OR execute_bubble;
bubbleSel <= bubbleSelect;
  PC_plus_1<=std_logic_vector(unsigned(instruction_memory_address)+1);
  PC_plus_1_out<=PC_plus_1;
  mux2:Mux2x1 generic map(n=>16) port map (instruction_memory_address,PC_out,bubbleSelect,stall); --stall is pc or pc+1

  With stall select address <= M_0 when "UUUUUUUUUUUUUUUU",
                               stall when others;
  Jselect <= JMP&JumpSelect;
  Mux41:Mux4x1 generic map(n=>16) port map(ALUOutput, MemoryOutput, DecodeOutput, DecodeOutput ,Jselect , JLocation);
  Mux4:Mux4x1 generic map(n=>16) port map(address,M_0,M_1,Jlocation , newPC, instruction_memory_address);
  Reg:PC_reg port map(clk,PCenable,PC_plus_1,PC_out);
  --Reg:PC_reg port map(clk,PCenable,instruction_memory_address,PC_out);
  Instruction_mem:instruction_Memory port map(clk,instruction_memory_address(9 downto 0),Instruction);
  ImmL<=Instruction;
  EA<=Instruction(15 downto 0);
  Instruction_out<=Instruction;
  Opcode_F<=Instruction(15 downto 11);
end architecture archIFet;