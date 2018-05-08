library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
Entity Decoder is
port (
Clk : in std_logic;
RST : in std_logic;
WB : in std_logic;
readaddr1 : in std_logic_vector (2 downto 0);
readaddr2 : in std_logic_vector  (2 downto 0);
writeaddr : in std_logic_vector  (2 downto 0);
writedata : in std_logic_vector  (15 downto 0);
inport    : in std_logic_vector   (15 downto 0);
insig     : in std_logic;
dataout1 : out std_logic_vector  (15 downto 0);
dataout2 : out std_logic_vector  ( 15 downto 0)
);
end entity Decoder;


architecture mainDecoder of Decoder is
COMPONENT RegisterFile 
port ( Clk : in std_logic;				--Input clock Signal
WB : in std_logic; 					--Write Back Input Signal
RST : in std_logic;  
Readaddr1: in std_logic_vector(2 downto 0);		--Readaddr1 Selector 
Readaddr2: in std_logic_vector(2 downto 0);		--Readaddr2 Selector
Writeaddr : in std_logic_vector(2 downto 0);            --WriteAddr Selector
Writedata : in std_logic_vector(15 downto 0);		--WriteData (Data to be Written)
Data1 : out std_logic_vector(15 downto 0);		--Data1 Output
Data2 : out std_logic_vector(15 downto 0)		--Data2 Output
);
END COMPONENT;

COMPONENT Mux 
port ( inport :in std_logic_vector (15 downto 0); 	-- inport vector
data1 : in std_logic_vector (15 downto 0);		-- data1 vector
insig : in std_logic ;					-- In Signal
DataOutput1 : out std_logic_vector (15 downto 0)	-- Data output vector
);
END COMPONENT;

COMPONENT my_nDFF 
Generic ( n : integer := 16);
port( Clk,Rst : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
END COMPONENT;

signal DataTemp :std_logic_vector (15 downto 0);

BEGIN

regfile : RegisterFile port map (Clk,WB,RST,readaddr1,readaddr2,writeaddr,writedata,DataTemp,dataout2);
multiplexer : Mux port map (inport,DataTemp,insig,dataout1);





end architecture mainDecoder;