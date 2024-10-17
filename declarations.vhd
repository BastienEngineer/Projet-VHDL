library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
USE WORK.ALL;

ENTITY declarations IS
PORT (
	SW : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	MAX10_Clk : IN STD_LOGIC;
	HEX : OUT STD_LOGIC_VECTOR (6 DOWNTO 0); -- 56 pour tous les afficheurs segments
	GPIO : OUT STD_LOGIC_VECTOR (9 DOWNTO 0));
END;

ARCHITECTURE structural OF declarations IS

BEGIN
  decl : ENTITY VHDL
	  PORT MAP
		(
		-- entrée
		Clk => MAX10_Clk,
		stby => SW(0),
		test => SW(1),
		-- sortie
		-- afficheur 7 seg
		affiche0 => HEX(0),
		affiche1 => HEX(1),
		affiche2 => HEX(2),
		affiche3 => HEX(3),
		affiche4 => HEX(4),
		affiche5 => HEX(5),
		affiche6 => HEX(6),
		-- leds pour feux tricolores
		-- indice p signifie pieton
		r1 => GPIO(0),
		o1 => GPIO(1),
		v1 => GPIO(2),
		rp1 => GPIO(3),
		vp1 => GPIO(4),
		r2 => GPIO(5),
		o2 => GPIO(6),
		v2 => GPIO(7),
		rp2 => GPIO(8),
		vp2 => GPIO(9)
		);
END structural;