Library ieee;
Use ieee.std_logic_1164.all;
Entity fullAdder is        
port( 
A,B,Cin : in std_logic;
Sum,Cout : out std_logic
); 
end fullAdder;


Architecture adderArch of fullAdder is
begin

Sum <= A XOR B XOR Cin;
Cout <= (A AND B) OR (Cin AND (A XOR B));

end adderArch;