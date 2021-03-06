library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
Entity instruction_memory is
port(clk: in std_logic;
address : in std_logic_vector(9 downto 0);
dataout : out std_logic_vector(15 downto 0)
);
end entity instruction_memory ;

architecture archinstruction_memory of instruction_memory is
  type ram_type is array (0 to 1024) of std_logic_vector(15 downto 0);
  signal instructionRAM : ram_type;
begin
  dataout <= instructionRAM(to_integer(unsigned(address))) when address/="XXXXXXXXXX" else
             "XXXXXXXXXXXXXXXX";
end architecture archinstruction_memory;

