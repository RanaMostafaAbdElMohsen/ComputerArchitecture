library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

Entity memory is
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
	  --WBaddress    : in std_logic_vector(z1-1 downto 0);
	  Data         : out std_logic_vector(m1-1 downto 0);
	  Mone         : out std_logic_vector(m1-1 downto 0);
	  Mzero        : out std_logic_vector(m1-1 downto 0);
	 -- WBaddressout : out std_logic_vector(z1-1 downto 0);
	  Zold         : out std_logic;
	  Nold         : out std_logic;
	  Vold         : out std_logic;
	  Cold         : out std_logic
	 ); 
end entity memory;


architecture memory of memory is 
component ram is
generic (n:integer:=16; m:integer:=16);
port ( 
	  clk      : in std_logic; 
	  write_en : in std_logic; 
 	  address  : in std_logic_vector(n-1 downto 0);
	  datain   : in std_logic_vector(m-1 downto 0);
	  dataout  : out std_logic_vector(m-1 downto 0);
	  M1       : out std_logic_vector(m-1 downto 0);
	  M0       : out std_logic_vector(m-1 downto 0)
	 ); 
end component ram;

signal ZBuffer,Nbuffer,Vbuffer,Cbuffer   : std_logic;
signal Memoryunitadress                  : std_logic_vector(n1-1 downto 0); 
signal Memoryunitinput,Memoryunitoutput  : std_logic_vector(m1-1 downto 0); 
Begin
memoryunit  : ram generic map(n=>n1,m=>m1) port map (clk,write_en,Memoryunitadress,Memoryunitinput,Memoryunitoutput,Mone,Mzero);

Data               <=  ALUoutput        when WBsel2 ='0' and WBsel1='0' else
		       Memoryunitoutput when WBsel2 ='0' and WBsel1='1' else
		       IMML;  
           
Memoryunitinput    <= ALUoutput         when Datainsel = '0' else
                      PCplus1;

Memoryunitadress   <= SP                when Memsel ='0' else 
		      EA;

--WBaddressout     <=  WBaddress ;

ZBuffer            <= Znew              when saveEnable ='0';
NBuffer            <= Nnew              when saveEnable ='0';
vBuffer            <= vnew              when saveEnable ='0';
CBuffer            <= Cnew              when saveEnable ='0';

zold               <= zBuffer ;
Nold               <= nBuffer ;
Vold               <= vBuffer ;
Cold               <= cBuffer ;
	 
end architecture memory;