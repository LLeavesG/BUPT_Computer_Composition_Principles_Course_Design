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
	SWCBA <= SWC&SWB&SWA;
	IR7TO4 <= IR7&IR6&IR5&IR4;
	
	process(CLR,SWCBA,IR7TO4,W1,W2,W3,ST0,C,T3,Z,T3)
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
			
			case SWCBA is
				when "100" =>
					SBUS <= W1 OR W2;
					SEL3 <= ST0;
					SEL2 <= W2;
					SEL1 <= ((NOT ST0) AND W1) OR (ST0 AND W2);
					SEL0 <= W1;
					SST0 <= W2;
					SELCTL <= '1';
					DRW <= W1 OR W2;
					STOP <= '1';
				when "011" =>
					SEL3 <= W2;
					SEL2 <= '0';
					SEL1 <= W2;
					SEL0 <= W1 OR W2;
					SELCTL <= '1';
					STOP <= W1 OR W2;
				when "010" =>
					SBUS <= W1 AND (NOT ST0);
					LAR <= W1 AND (NOT ST0);
					MBUS <= W1 AND ST0;
					ARINC <= W1 AND ST0;
					SELCTL <= W1;
					SST0 <= W1;
					SHORT <= W1;
					STOP <= W1;
				when "001" =>
					SBUS <= W1;
					LAR <= W1 AND (NOT ST0);
					MEMW <= W1 AND ST0;
					ARINC <= W1 AND ST0;
					STOP <= W1;
					SST0 <= W1;
					SHORT <= W1;
					SELCTL <= W1;
				when "000" =>
					if(ST0 = '0') then
						SBUS <= W1;
						LPC <= W1;
						STOP <= W1;
						SELCTL <= W1;
						SHORT <= W1;
						SST0 <= W1;
					else
						case IR7TO4 is
							when "0000" => 
							--NOP
								LIR <= W1;
								PCINC <= W1;
								SHORT <= W1;
							when "0001" => 
							--ADD
								S3 <= '1';
								S2 <= '0';
								S1 <= '0';
								S0 <= '1';
								CIN <= W1;
								ABUS <= W1;
								DRW <= W1;
								LDZ <= W1;
								LDC <= W1;
								LIR <= W1;
								PCINC <= W1;
								SHORT <= W1;
							when "0010" => 
							--SUB
								S3 <= '0';
								S2 <= '1';
								S1 <= '1';
								S0 <= '0';
								ABUS <= W1;
								DRW <= W1;
								LDZ <= W1;
								LDC <= W1;
								LIR <= W1;
								PCINC <= W1;
								SHORT <= W1;
							when "0011" => 
							--AND
								S3 <= '1';
								S2 <= '0';
								S1 <= '1';
								S0 <= '1';
								M <= W1;
								ABUS <= W1;
								DRW <= W1;
								LDZ <= W1;
								LIR <= W1;
								PCINC <= W1;
								SHORT <= W1;
							when "0100" => 
							--INC
								S3 <= '0';
								S2 <= '0';
								S1 <= '0';
								S0 <= '0';
								ABUS <= W1;
								DRW <= W1;
								LDZ <= W1;
								LDC <= W1;
								LONG <= W2;
								LIR <= W3;
								PCINC <= W3;
							when "0101" => 
							--LD
								S3 <= '1';
								S2 <= '0';
								S1 <= '1';
								S0 <= '0';
								M <= W1;
								ABUS <= W1;
								LAR <= W1;
								DRW <= W2;
								MBUS <= W2;
								LIR <= W3;
								LONG <= W2;
								PCINC <= W3;
							when "0110" => 
							--ST
								S3 <= '1';
								S2 <= W1;
								S1 <= '1';
								S0 <= W1;
								M <= W1 OR W2;
								ABUS <= W1 OR W2;
								LAR <= W1;
								MEMW <= W2;
								LIR <= W2;
								PCINC <= W2;
							when "0111" => 
							--JC
								LIR <= ((NOT C) AND W1) OR (C AND W2);
								PCINC <= ((NOT C) AND W1) OR (C AND W2);
								PCADD <= C AND W1;
								SHORT <= (NOT C) AND W1;
							when "1000" => 
							--JZ
								LIR <= ((NOT Z) AND W1) OR (Z AND W2);
								PCINC <= ((NOT Z) AND W1) OR (Z AND W2);
								PCADD <= Z AND W1;
								SHORT <= (NOT Z) AND W1;
							when "1001" => 
							--JMP
								S3 <= '1';
								S2 <= '1';
								S1 <= '1';
								S0 <= '1';
								M <= W1;
								ABUS <= W1;
								LPC <= W1;  
								LIR <= W2;
								PCINC <= W2;
							when "1010" => 
							--OUT
								S3 <= '1';
								S2 <= '0';
								S1 <= '1';
								S0 <= '0';
								M <= W1;
								ABUS <= W1;
								SHORT <= W1;
								LIR <= W1;
								PCINC <= W1;
							when "1011" => 
							--OR
								S3 <= '1';
								S2 <= '1';
								S1 <= '1';
								S0 <= '0';
								M <= W1;
								ABUS <= W1;
								DRW <= W1;
								LDZ <= W1;
								LIR <= W1;
								PCINC <= W1;
								SHORT <= W1;
							when "1100" => 
							--XOR
								S3 <= '0';
								S2 <= '1';
								S1 <= '1';
								S0 <= '0';
								M <= W1;
								ABUS <= W1;
								DRW <= W1;
								LDZ <= W1;
								LIR <= W1;
								PCINC <= W1;
								SHORT <= W1;
							when "1101" => 
							--DEC
								S3 <= '1';
								S2 <= '1';
								S1 <= '1';
								S0 <= '1';
								CIN <= W1;
								ABUS <= W1;
								DRW <= W1;
								LDZ <= W1;
								LDC <= W1;
								LONG <= W2;
								LIR <= W3;
								PCINC <= W3;
							when "1110" => 
							--STP
								STOP <= W1;
							when others => 
								LIR <= W1;
								PCINC <= W1;
								SHORT <= W1;
						end case;
					end if;
				when others =>
					
			end case;	
		end if;
	end process;
end architecture;