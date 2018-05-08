library ieee;
use ieee.std_logic_1164.all;

entity PC_reg is
port(clk,wenable:in std_logic;
d:in std_logic_vector(15 downto 0);
q:out std_logic_vector(15 downto 0)
);
end entity PC_reg;

architecture archPC_reg of PC_reg is
begin
  Process (Clk)
  begin
    if (rising_edge(Clk) and wenable='1') then
      q <=d;
    end if;
  end process;
end architecture archPC_reg;

