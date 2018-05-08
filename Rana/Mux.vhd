library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
-- Multiplexer for decoder

Entity Mux is
port ( inport :in std_logic_vector (15 downto 0); 	-- inport vector
data1 : in std_logic_vector (15 downto 0);		-- data1 vector
insig : in std_logic ;					-- In Signal
DataOutput1 : out std_logic_vector (15 downto 0)	-- Data output vector
);
end entity Mux;


architecture mainMux of Mux is
BEGIN

DataOutput1<= inport when insig='1' else
	      data1;

end architecture mainMux;
