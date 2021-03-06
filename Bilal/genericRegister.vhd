Library ieee;
Use ieee.std_logic_1164.all;

Entity genericRegister is
Generic ( n : integer := 16);
port( Clk,Rst : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end genericRegister;

Architecture registerArch of genericRegister is
begin
Process (Clk,Rst)
begin
if Rst = '1' then
q <= (others=>'0');
elsif rising_edge(Clk) then
q <= d;
end if;
end process;
end registerArch;