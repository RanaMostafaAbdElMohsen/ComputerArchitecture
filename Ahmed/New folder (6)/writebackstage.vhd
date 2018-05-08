library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity writeback is
generic (n:integer:=3; m:integer:=16);
port (  
	  BubbleSelect : in std_logic;
 	  WBaddressIN  : in std_logic_vector(n-1 downto 0);
	  datain       : in std_logic_vector(m-1 downto 0);
	  REGwrite     : in std_logic;
	  REGwriteOUT  : out std_logic; -- WB signal to decoder
	  dataout      : out std_logic_vector(m-1 downto 0);
	  WBaddressOUT : out std_logic_vector(n-1 downto 0)
	 ); 
end entity writeback;

architecture writeback of writeback is 

begin
	dataout      <= datain;
	WBaddressOUT <= WBaddressIN; 
	REGwriteOUT  <= REGwrite;
	--WBaddressOUT  <= WBaddressIN;
	--REGwriteOUT   <= REGwrite;
end architecture writeback;
