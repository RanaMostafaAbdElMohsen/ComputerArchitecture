Library ieee;
Use ieee.std_logic_1164.all;

Entity genericAdder is
Generic ( n : integer := 16);
port(
A,B : in std_logic_vector(n-1 downto 0);
Operation : in std_logic;
Sum : out std_logic_vector(n-1 downto 0);
Cout : out std_logic
);
end genericAdder;

Architecture gAdderArch of genericAdder is

component fullAdder is        
port( 
A,B,Cin : in std_logic;
Sum,Cout : out std_logic
); 
end component;
Signal carryTemp : std_logic_vector(n-1 downto 0);
begin
adder0: fullAdder port map(A(0),B(0),Operation,Sum(0),carryTemp(0));

myLoop: for i in 1 to n-1 GENERATE
adderi: fullAdder port map(A(i),B(i),carryTemp(i-1),Sum(i),carryTemp(i));
end GENERATE;

Cout <= carryTemp(n-1);

end gAdderArch;