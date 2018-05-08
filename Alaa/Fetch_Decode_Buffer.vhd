Library ieee;
Use ieee.std_logic_1164.all;

Entity Fetch_Decode_Buffer is
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
end entity Fetch_Decode_Buffer;

Architecture archFetch_Decode_Buffer of Fetch_Decode_Buffer is
begin
  process(clk,reset) begin
    if(rising_edge(clk) and reset='1')then
      PC_plus_1_out<=PC_plus_1_in;
      Opcode_out<=(others=>'0');
      Reg1_out<=Instruction_in(10 downto 8);
      Reg2_out<=Instruction_in(7 downto 5);
      Immsh_out<=Instruction_in(7 downto 4);
      WriteAddr<= Instruction_in(10 downto 8);
      InterruptSignal_out<='0';
    elsif (rising_edge(clk) and enablef = '1')then
      PC_plus_1_out<=PC_plus_1_in;
      Opcode_out<=Instruction_in(15 downto 11);
      Reg1_out<=Instruction_in(10 downto 8);
      Reg2_out<=Instruction_in(7 downto 5);
      Immsh_out<=Instruction_in(7 downto 4);
      WriteAddr<= Instruction_in(10 downto 8);
      InterruptSignal_out<=InterruptSignal;
    end if;
end process;
end architecture archFetch_Decode_Buffer;

