LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Clock IS PORT 
	(Clk, Rst : IN STD_LOGIC;
    Clk_out : OUT STD_LOGIC);
    END Clock;
	 
--description comportementale
ARCHITECTURE diviseur_frequence OF Clock  IS	
        SIGNAL count : INTEGER := 1; 
        SIGNAL tmp : STD_LOGIC := '0';
BEGIN
    PROCESS ( Clk, Rst)
		BEGIN
			IF(Rst = '1') THEN 
				--initialisation
				tmp<='0';
			ELSIF rising_edge(Clk)		--(Clk'event and Clk = '1') 
			THEN 
				--évolution synchrone
				count<= count+1;
			   --pour voir le fonctionnement du diviseur on modifie count (ex: 2)
            IF(count=25000000) THEN tmp <= NOT tmp; count <=1; END IF;
         END IF;
			Clk_out <= tmp;
    END PROCESS;
END diviseur_frequence;
