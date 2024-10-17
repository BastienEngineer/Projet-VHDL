LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_STD.ALL;


ENTITY VHDL IS 
PORT( Clk, stby, test: IN STD_LOGIC; -- Entrees
affiche0,affiche1,affiche2,affiche3,affiche4,affiche5,affiche6 : OUT STD_LOGIC; -- Sorties
r1,r2,o1,o2,v1,v2, rp1,rp2,vp1,vp2 : OUT STD_LOGIC);
END VHDL; 

ARCHITECTURE behavioral OF VHDL IS 
-- Temps de chaque cas FEUX
	CONSTANT timeMAX: INTEGER:= 45; 
	CONSTANT timeRV: INTEGER:= 30; 
	CONSTANT timeRO: INTEGER:= 5; 
	CONSTANT timeVR: INTEGER:= 45; 
	CONSTANT timeORe: INTEGER:= 5; 
	CONSTANT timeTEST: INTEGER:= 1; 

-- Variables de compteur et du temps 	
	SIGNAL count : STD_LOGIC_VECTOR(25 DOWNTO 0); 
   SIGNAL tmp : STD_LOGIC;
	SIGNAL tps_aff : INTEGER range 0 to 10;
	SIGNAL afficheur : INTEGER range 0 to 10;

	TYPE state IS(RV, RO, VR, ORe, OO); 
	SIGNAL pr_state, nx_state: state;
	 
	SIGNAL temps : INTEGER RANGE 0 TO timeMAX;
 
-- CLOCK
BEGIN
    PROCESS (Clk)
    BEGIN
            IF (Clk'event and Clk = '1') THEN
                IF(count > 25000000) THEN
                    count <= (others => '0');
            ELSE
						count <= count + '1';
				END IF;
				IF(count < 25000000) THEN
					tmp <= '0';
				ELSE
					tmp <= '1';
				END IF;
            END IF;
    END PROCESS;

-- Mode STAND-BY
PROCESS(Clk, stby)
VARIABLE count : INTEGER RANGE 0 TO timeMAX;
BEGIN 
	IF(stby= '1') THEN
		pr_state<= OO;
		count := 0;
	ELSIF(Clk'EVENT AND Clk='1') THEN 
		count := count + 1; 
		IF (count = temps) THEN 
			pr_state<= nx_state; 
			count := 0; 
		END IF; 
	END IF; 
END PROCESS;

-- Compteur

PROCESS(tmp)
VARIABLE cpt : INTEGER := 0;

BEGIN 
	IF(tmp'EVENT AND tmp = '1') THEN
		cpt := cpt + 1;
		tps_aff <= tps_aff - 1;
		IF(cpt = temps) THEN
			pr_state <= pr_state;
			cpt := 0;
	END IF;
	END IF;
	IF(pr_state = VR) THEN
		afficheur <= timeVR + timeORe - cpt;
		tps_aff <= 10;
	ELSIF(pr_state = ORe) THEN
		afficheur <= timeORe - cpt;
		tps_aff <= 10;
	ELSIF(pr_state = RV) THEN
		tps_aff <= 10;
		afficheur <= timeRV + timeRO - cpt;
	ELSIF(pr_state = RO) THEN
		tps_aff <= 10;
		afficheur <= timeRO - cpt;
	END IF;
END PROCESS;

-- Passage d'un FEU à l'autre + afficheurs Seg	 
PROCESS(pr_state, test) 
BEGIN 
CASE pr_state IS
	WHEN RV => 
					r1<='1'; r2<='0'; o1<='0'; o2<='0'; v1<='0'; v2<='1';
					affiche0<='0';affiche1<='0';affiche2<='0';affiche3<='0';affiche4<='0';affiche5<='0';affiche6<='1';
					nx_state<= RO; 
					IF(test='0') THEN
						temps <= timeRV; 
					ELSE
						temps <= timeTEST; 
					END IF; 
	WHEN RO => 
					r1<='1'; r2<='0'; o1<='0'; o2<='1'; v1<='0'; v2<='0';
					affiche0<='1';affiche1<='0';affiche2<='0';affiche3<='1';affiche4<='1';affiche5<='1';affiche6<='1';
					nx_state<= VR; 
					IF(test='0') THEN
						temps <= timeRO; 
					ELSE
						temps <= timeTEST; 
					END IF;
	WHEN VR => 
					r1<='1'; r2<='1'; o1<='0'; o2<='0'; v1<='1'; v2<='0';
					affiche0<='0';affiche1<='0';affiche2<='1';affiche3<='0';affiche4<='0';affiche5<='1';affiche6<='0';
					nx_state<= ORe; 
					IF (test='0') THEN
						temps <= timeVR; 
					ELSE
						temps <= timeTEST; 
					END IF; 
	WHEN ORe => 
					r1<='0'; r2<='1'; o1<='1'; o2<='0'; v1<='0'; v2<='0'; 					
					affiche0<='0';affiche1<='0';affiche2<='0';affiche3<='0';affiche4<='1';affiche5<='1';affiche6<='0';
					nx_state<= RV; 
					IF (test='0') THEN 
						temps <= timeORe; 
					ELSE 
						temps <= timeTEST; 
					END IF; 
	WHEN OO => 
					r1<='0'; r2<='0'; o1<='1'; o2<='1'; v1<='0'; v2<='0';					
					affiche0<='1';affiche1<='1';affiche2<='1';affiche3<='1';affiche4<='1';affiche5<='1';affiche6<='0';
					nx_state<= RO; 
	END CASE; 
END PROCESS; 
END behavioral;