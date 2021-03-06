library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
Entity RegisterFile is
port ( Clk : in std_logic;	                --Input clock Signal
WB : in std_logic; 				--Write Back Input Signal
RST : in std_logic;                             -- Reset Signal 
Readaddr1: in std_logic_vector(2 downto 0);	--Readaddr1 Selector 
Readaddr2: in std_logic_vector(2 downto 0);      --Readaddr2 Selector
Writeaddr : in std_logic_vector(2 downto 0);     --WriteAddr Selector
Writedata : in std_logic_vector(15 downto 0);    --WriteData (Data to be Written)
Data1 : out std_logic_vector(15 downto 0);       --Data1 Output
Data2 : out std_logic_vector(15 downto 0)        --Data2 Output
);
end entity RegisterFile;


architecture MainRegisterFile of RegisterFile is

COMPONENT my_nDFF 
Generic ( n : integer := 16);
port( Clk,Rst,Enable : in std_logic;
d : in std_logic_vector(n-1 downto 0);
q : out std_logic_vector(n-1 downto 0));
END COMPONENT;

 
signal R0Out,R1Out,R2Out,R3Out,R4Out,R5Out :std_logic_vector (15 downto 0);
signal WB0,WB1,WB2,WB3,WB4,WB5: std_logic;
BEGIN



WB0 <= '1' when Writeaddr= "000" else
       '0';

WB1 <= '1' when Writeaddr= "001" else
       '0';

WB2 <= '1' when Writeaddr= "010" else
       '0';

WB3 <= '1' when Writeaddr= "011" else
       '0';

WB4 <= '1' when Writeaddr= "100" else
       '0';

WB5 <= '1' when Writeaddr= "101" else
       '0';
process(Clk)
	
	begin

	if RST='1' then
	                R0Out<="0000000000000000";
			R1Out<="0000000000000000";
			R2Out<="0000000000000000";
			R3Out<="0000000000000000";
			R4Out<="0000000000000000";
			R5Out<="0000000000000000";

	

       else 
   	
	if rising_edge(Clk) then
	     
		if  Readaddr1 = "000" then
			Data1<=R0Out;
                elsif  Readaddr1="001" then
			Data1<=R1Out;
                elsif  Readaddr1="010" then
			Data1<=R2Out;
                elsif  Readaddr1="011" then
			Data1<=R3Out;
                elsif  Readaddr1="100" then
			Data1<=R4Out;
		elsif  Readaddr1="101" then
			Data1<=R5Out;
		end if;
		if  Readaddr2 = "000" then
			Data2<=R0Out;
                elsif  Readaddr2="001" then
			Data2<=R1Out;
                elsif  Readaddr2="010" then
			Data2<=R2Out;
                elsif  Readaddr2="011" then
			Data2<=R3Out;
                elsif  Readaddr2="100" then
			Data2<=R4Out;
		elsif  Readaddr2="101" then
			Data2<=R5Out;
		 
		end if;
 	end if;  
 
	if falling_edge(Clk) then
             if WB='1' then
		
		if  Writeaddr= "000" then
			R0Out<=Writedata;

		elsif  Writeaddr= "001" then
			R1Out<=Writedata;
			
	        elsif  Writeaddr= "010" then

			R2Out<=Writedata;

		elsif  Writeaddr= "011"  then

			R3Out<=Writedata;

		elsif  Writeaddr= "100" then
			R4Out<=Writedata;

		elsif  Writeaddr= "101"then
			R5Out<=Writedata;

		end if;	

	     end if;

	
	end if;

 end if; 
    end process;


end architecture MainRegisterFile;

