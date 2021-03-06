library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

Entity ram is
generic (n:integer:=16; m:integer:=16);
port ( 
	  clk      : in std_logic; 
	  write_en : in std_logic; 
 	  address : in std_logic_vector(n-1 downto 0);
	  datain   : in std_logic_vector(m-1 downto 0);
	  dataout : out std_logic_vector(m-1 downto 0);
	  M1       : out std_logic_vector(m-1 downto 0);
	  M0       : out std_logic_vector(m-1 downto 0)
	 ); 
end entity ram;

architecture ram of ram is 
type ram_type is array (0 to (2**10)-1) of std_logic_vector(m-1 downto 0); 

signal ram : ram_type;
begin
process(clk) is
begin 
	if rising_edge(clk) then 
		if write_en = '1' then 
			ram(to_integer(unsigned(address))) <= datain;    
		end if;  
	end if; 
end process; 
dataout <= ram(to_integer(unsigned(address)));
M1<=ram(1);
M0<=ram(0);
end architecture ram;