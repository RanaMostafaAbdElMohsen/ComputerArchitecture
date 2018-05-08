


--WTF

Library ieee;
Use ieee.std_logic_1164.all;

Entity my_nDFF is
Generic ( n : integer := 16);
port( Clk,Rst,Enable : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
end my_nDFF;

Architecture a_my_nDFF of my_nDFF is
Signal myData : std_logic_vector(n-1 downto 0);

begin
Process (Clk,Rst)
begin
if Rst = '1' then
q <= (others=>'0');
elsif rising_edge(Clk) then
if Enable = '1' then
q <= myData;
end if;
elsif falling_edge(Clk) then
myData <= d;
end if;
end process;
end a_my_nDFF;
