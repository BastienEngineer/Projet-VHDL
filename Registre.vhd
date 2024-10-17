LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
use IEEE.NUMERIC_STD.ALL;


ENTITY Registre IS 
PORT( Clk, stby, test: IN STD_LOGIC;
SW9,SW8,SW7,SW6,SW5,SW4,SW3 : in std_logic;
		HEX00 : out std_logic;
		HEX01 : out std_logic;
		HEX02 : out std_logic;
		HEX03 : out std_logic;
		HEX04 : out std_logic;
		HEX05 : out std_logic;
		HEX06 : out std_logic;
		HEX10,HEX11,HEX12,HEX13,HEX14,HEX15,HEX16 : out std_logic;
		HEX20,HEX21,HEX22,HEX23,HEX24,HEX25,HEX26 : out std_logic;
		HEX30,HEX31,HEX32,HEX33,HEX34,HEX35,HEX36 : out std_logic;
		HEX40,HEX41,HEX42,HEX43,HEX44,HEX45,HEX46 : out std_logic;
		HEX50,HEX51,HEX52,HEX53,HEX54,HEX55,HEX56 : out std_logic;
r1,r2,o1,o2,v1,v2, rp1,rp2,vp1,vp2 : OUT STD_LOGIC);
END Registre; 

ARCHITECTURE behavior OF Registre IS 
	CONSTANT timeMAX: INTEGER:= 2700; 
	CONSTANT timeRV: INTEGER:= 1800; 
	CONSTANT timeRO: INTEGER:= 300; 
	CONSTANT timeVR: INTEGER:= 2700; 
	CONSTANT timeORe: INTEGER:= 300; 
	CONSTANT timeTEST: INTEGER:= 60; 
	
	SIGNAL count : STD_LOGIC_VECTOR(25 DOWNTO 0); 
   SIGNAL tmp : STD_LOGIC;

	TYPE state IS(RV, RO, VR, ORe, OO); 
	SIGNAL pr_state, nx_state: state;
	 
	SIGNAL temps : INTEGER RANGE 0 TO timeMAX;
 
 
BEGIN
    PROCESS (Clk)
    BEGIN
            IF (Clk'event and Clk = '1') THEN
                IF(count > 25000000) then
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

PROCESS(pr_state, test) 
BEGIN 
CASE pr_state IS
	WHEN RV => 
					r1<='1'; r2<='0'; o1<='0'; o2<='0'; v1<='0'; v2<='1'; 
					nx_state<= RO; 
					IF(test='0') THEN
						temps <= timeRV; 
					ELSE
						temps <= timeTEST; 
					END IF; 
	WHEN RO => 
					r1<='1'; r2<='0'; o1<='0'; o2<='1'; v1<='0'; v2<='0'; 
					nx_state<= VR; 
					IF(test='0') THEN
						temps <= timeRO; 
					ELSE
						temps <= timeTEST; 
					END IF;
	WHEN VR => 
					r1<='0'; r2<='1'; o1<='0'; o2<='0'; v1<='1'; v2<='0'; 
					nx_state<= ORe; 
					IF (test='0') THEN
						temps <= timeVR; 
					ELSE
						temps <= timeTEST; 
					END IF; 
	WHEN ORe => 
					r1<='0'; r2<='1'; o1<='1'; o2<='0'; v1<='0'; v2<='0'; 
					nx_state<= RV; 
					IF (test='0') THEN 
						temps <= timeORe; 
					ELSE 
						temps <= timeTEST; 
					END IF; 
	WHEN OO => 
					r1<='0'; r2<='0'; o1<='1'; o2<='1'; v1<='0'; v2<='0'; 
					nx_state<= RO; 
	END CASE; 
END PROCESS; 
END behavior;