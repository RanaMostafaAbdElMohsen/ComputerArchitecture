library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


---------------------------------------------NOT TESTED---------------------------------------------------
entity branchCalc is
  port (
    Z, N, C : in std_logic;
    JFlag1, JFlag0 : in std_logic;
    Branch : in std_logic;
    BranchResult : out std_logic
);
end entity branchCalc;


architecture branchArch of branchCalc is
Signal MuxOut : std_logic;
begin

MuxOut <=	Z when JFlag1 = '0' AND JFlag0 = '0' else
		C when JFlag1 = '0' AND JFlag0 = '1' else
		N when JFlag1 = '1' AND JFlag0 = '0';

BranchResult <= MuxOut AND Branch;

end branchArch;