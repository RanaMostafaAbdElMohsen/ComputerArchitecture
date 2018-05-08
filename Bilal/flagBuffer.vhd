library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


---------------------------------------------NOT TESTED---------------------------------------------------
entity flagBuffer is
  port (
    ZS, NS, VS, CS : in std_logic;
    Znew, Nnew, Vnew, Cnew : in std_logic;
    Zold, Nold, Vold, Cold : out std_logic
);
end entity flagBuffer;


architecture flagArch of flagBuffer is

Signal Zflag,Nflag,Vflag,Cflag : std_logic;

begin

Zflag <= Znew when ZS = '1';
Zold  <= Zflag;

Nflag <= Nnew when NS = '1';
Nold  <= Nflag;

Vflag <= Vnew when VS = '1';
Vold  <= Vflag;

Cflag <= Cnew when CS = '1';
Cold  <= Cflag;

end flagArch;
