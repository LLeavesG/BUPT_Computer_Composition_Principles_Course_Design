library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity controller is
	port(
		CLR,SWA,SWB,SWC,IR4,IR5,IR6,IR7,W1,W2,W3,C,T3,Z:IN STD_LOGIC;
		DRW,PCINC,LPC,LAR,PCADD,ARINC,MEMW,STOP,LIR,LDZ,LDC,CIN,S0,S1,S2,S3,M,ABUS,SBUS,MBUS,SHORT,LONG,SEL0,SEL1,SEL2,SEL3,SELCTL:OUT STD_LOGIC
	);
end controller;

architecture controller_arc of controller is
	signal SWCBA:std_logic_vector(2 downto 0);
	signal IR7TO4:std_logic_vector(3 downto 0);
	signal ST0:std_logic;
	signal SST0:std_logic;
begin
	process(CLR,SWCBA,IR7TO4,W1,W2,W3,ST0,C,T3,Z,T3)
	variable WR:std_logic;
	variable RR:std_logic;
	variable RM:std_logic;
	variable WM:std_logic;
	variable EX:std_logic;
	variable CPC:std_logic;
	variable ADD_V:std_logic;
	variable SUB_V:std_logic;
	variable AND_V:std_logic;
	variable INC_V:std_logic;
	variable LD_V:std_logic;
	variable ST_V:std_logic;
	variable JC_V:std_logic;
	variable JZ_V:std_logic;
	variable JMP_V:std_logic;
	variable OUT_V:std_logic;
	variable OR_V:std_logic;
	variable XOR_V:std_logic;
	variable DEC_V:std_logic;
	variable STP_V:std_logic;
	variable NOP_V:std_logic;
	begin
		DRW <= '0';
		PCINC <= '0';
		LPC <= '0';
		LAR <= '0';
		PCADD <= '0';
		ARINC <= '0';
		MEMW <= '0';
		STOP <= '0';
		LIR <= '0';
		LDZ <= '0';
		LDC <= '0';
		CIN <= '0';
		S0 <= '0';
		S1 <= '0';
		S2 <= '0';
		S3 <= '0';
		M <= '0';
		ABUS <= '0';
		SBUS <= '0';
		MBUS <= '0';
		SHORT <= '0';
		LONG <= '0';
		SEL0 <= '0';
		SEL1 <= '0';
		SEL2 <= '0';
		SEL3 <= '0';
		SELCTL  <= '0';
		
		if(CLR = '0') then
			ST0 <= '0';
		else
			if(T3'EVENT AND T3 = '0') then
				if(SST0 = '1') then
					ST0 <= '1';
				end if;
			end if;
		end if;
		WR := SWC AND (NOT SWB) AND (NOT SWA);
		RR := (NOT SWC) AND SWB AND SWA;
		EX := (NOT SWC) AND (NOT SWB) AND (NOT SWA) AND (ST0);
		CPC := (NOT SWC) AND (NOT SWB) AND (NOT SWA) AND (NOT ST0);
		RM := (NOT SWC) AND SWB AND (NOT SWA);
		WM := (NOT SWC) AND (NOT SWB) AND SWA;
		
		ADD_V := (NOT IR7) AND (NOT IR6) AND (NOT IR5) AND IR4;
		SUB_V := (NOT IR7) AND (NOT IR6) AND IR5 AND (NOT IR4);
		AND_V := (NOT IR7) AND (NOT IR6) AND IR5 AND IR4;
		INC_V := (NOT IR7) AND IR6 AND (NOT IR5) AND (NOT IR4);
		LD_V  := (NOT IR7) AND IR6 AND (NOT IR5) AND IR4;
		ST_V  := (NOT IR7) AND IR6 AND IR5 AND (NOT IR4);
		JC_V  := (NOT IR7) AND IR6 AND IR5 AND IR4;
		JZ_V  := IR7 AND (NOT IR6) AND (NOT IR5) AND (NOT IR4);
		JMP_V := IR7 AND (NOT IR6) AND (NOT IR5) AND IR4;
		OUT_V := IR7 AND (NOT IR6) AND IR5 AND (NOT IR4);
		OR_V := IR7 AND (NOT IR6) AND IR5 AND IR4;
		XOR_V := IR7 AND IR6 AND (NOT IR5) AND (NOT IR4);
		DEC_V := IR7 AND IR6 AND (NOT IR5) AND IR4;
		STP_V := IR7 AND IR6 AND IR5 AND (NOT IR4);
		NOP_V := (NOT IR7) AND (NOT IR6) AND (NOT IR5) AND (NOT IR4);
		
		LIR <= (EX OR CPC) AND ((ADD_V AND W1) OR (SUB_V AND W1) OR (AND_V AND W1) OR (INC_V AND W3) OR (LD_V AND W3) OR (ST_V AND W2) OR (JC_V AND ((NOT C AND W1) OR (C AND W2))) OR (JZ_V AND ((NOT Z AND W1) OR (Z AND W2))) OR (JMP_V AND W2) OR (OUT_V AND W1) OR (OR_V AND W1) OR (XOR_V AND W1) OR (DEC_V AND W3) OR (NOP_V AND W1)); 
		PCINC <= (EX OR CPC) AND ((ADD_V AND W1) OR (SUB_V AND W1) OR (AND_V AND W1) OR (INC_V AND W3) OR (LD_V AND W3) OR (ST_V AND W2) OR (JC_V AND ((NOT C AND W1) OR (C AND W2))) OR (JZ_V AND ((NOT Z AND W1) OR (Z AND W2))) OR (JMP_V AND W2) OR (OUT_V AND W1) OR (OR_V AND W1) OR (XOR_V AND W1) OR (DEC_V AND W3) OR (NOP_V AND W1)); 
		S3 <= (EX OR CPC) AND (ADD_V OR AND_V OR LD_V OR ST_V OR JMP_V OR OUT_V OR OR_V OR DEC_V);
		S2 <= (EX OR CPC) AND (SUB_V OR (W1 AND ST_V) OR JMP_V OR OR_V OR XOR_V OR DEC_V);
		S1 <= (EX OR CPC) AND (SUB_V OR AND_V OR LD_V OR ST_V OR JMP_V OR OUT_V OR OR_V OR XOR_V);
		S0 <= (EX OR CPC) AND (ADD_V OR AND_V OR (ST_V AND W1) OR JMP_V OR DEC_V);
		CIN <= (EX OR CPC) AND ((ADD_V AND W1) OR (DEC_V AND W1));
		ABUS <= (EX OR CPC) AND ((ADD_V AND W1) OR (SUB_V AND W1) OR (AND_V AND W1) OR (INC_V AND W1) OR (LD_V AND W1) OR (ST_V AND (W1 OR W2)) OR (JMP_V AND W1) OR (OUT_V AND W1) OR (OR_V AND W1) OR (XOR_V AND W1) OR (DEC_V AND W1));
		M <= (EX OR CPC) AND ((AND_V AND W1) OR (LD_V AND W1) OR (ST_V AND (W1 OR W2)) OR (JMP_V AND W1) OR (OUT_V AND W1) OR (OR_V AND W1) OR (XOR_V AND W1));
		DRW <= ((EX OR CPC) AND ((ADD_V AND W1) OR (SUB_V AND W1) OR (AND_V AND W1) OR (INC_V AND W1) OR (LD_V AND W2) OR (OR_V AND W1) OR (XOR_V AND W1) OR (DEC_V AND W1))) OR (WR AND (W1 OR W2));
		LDZ <= (EX OR CPC) AND ((ADD_V AND W1) OR (SUB_V AND W1) OR (AND_V AND W1) OR (INC_V AND W1) OR (OR_V AND W1) OR (XOR_V AND W1) OR (DEC_V AND W1));
		LDC <= (EX OR CPC) AND ((ADD_V AND W1) OR (SUB_V AND W1) OR (INC_V AND W1) OR (DEC_V AND W1));
		LAR <= (((EX OR CPC) AND (W1 AND LD_V)) OR (W1 AND ST_V)) OR (RM AND W1 AND (NOT ST0)) OR (WM AND W1 AND (NOT ST0));
		MBUS <= (LD_V AND W2) OR (RM AND W1 AND ST0);
		MEMW <= ((EX OR CPC) AND (ST_V AND W2)) OR (WM AND W1 AND ST0);
		PCADD <= (EX OR CPC) AND ((C AND JC_V AND W1) OR (Z AND JZ_V AND W1));
		STOP <= ((EX OR CPC) AND (STP_V AND W1)) OR WR OR ((W1 OR W2) AND RR) OR (EX AND (NOT ST0) AND W1) OR (W1 AND RM) OR (W1 AND WM);
		SHORT <= ((EX OR CPC) AND ((ADD_V AND W1) OR (SUB_V AND W1) OR (AND_V AND W1) OR (JC_V AND (NOT C) AND W1) OR (JZ_V AND (NOT Z) AND W1) OR (OUT_V AND W1) OR (OR_V AND W1) OR (XOR_V AND W1) OR (NOP_V AND W1))) OR((EX OR CPC) AND (NOT ST0) AND W1) OR (W1 AND RM) OR (WM AND W1);
		SBUS <= ((WR)AND(W1 OR W2)) OR ((CPC OR EX)AND(NOT ST0 AND W1)) OR ((RM)AND(W1 AND NOT ST0)) OR ((WM)AND(W1));
		SEL3 <= ((WR)AND(ST0)) OR ((RR)AND(W2)) ;
		SEL2 <= ((WR)AND(W2));
		SEL1 <= ((WR)AND(((NOT ST0) AND W1) OR (ST0 AND W2))) OR (RR AND W2);
		SEL0 <=	((WR)AND W1) OR ((W1 OR W2) AND RR) ;
		SELCTL <= (WR) OR (RR) OR (CPC AND((NOT ST0) AND W1)) OR ((RM)AND(W1)) OR ( (WM) AND (W1));
		SST0 <= ((WR) AND W2) OR (CPC AND(NOT ST0 AND W1)) OR ((RM)AND(W1)) OR (((WM)AND(W1)));
		LONG <= (EX OR CPC) AND ((INC_V AND W2) OR (DEC_V AND W2) OR (LD_V AND W2));
		ARINC <= ((RM) AND (W1 AND ST0)) OR ((WM) AND (W1 AND ST0));
		LPC <= ((CPC OR EX) AND (JMP_V AND W1)) OR (CPC AND (NOT ST0) AND W1);
	end process;
end architecture;