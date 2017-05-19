INCLUDE Irvine32.inc

.data
	T	DWORD 9 DUP (?)

	P1	BYTE	'Player1', 0
	P2	BYTE	'Player2', 0
	BOT1	BYTE	'CPU', 0

	MODE1	BYTE	?
	
	szovegBEGIN	BYTE	'A Player1 kezd, es Ove az: - 1 - karakter, a Player2 vagy CPU pedig a: - 2 - karakter!', 0

	szovegMODE1	BYTE	'Jatek mod kivalasztasa:', 0
	szovegMODE2	BYTE	'Player vs Player: 1!', 0
	szovegMODE3	BYTE	'Player vs CPU: 2!', 0

	szovegMODEPVP	BYTE	'A kivalasztott mode: Player versus Player!', 0
	szovegMODEPVE	BYTE	'A kivalasztott mode: Player versus CPU!', 0

	szovegRULE1 BYTE 'A mezovalasztas a kovetkezo:', 0
	szovegRULE2	BYTE 'Eloszor a sor betujet kell beirni: a, b, c, majd ENTER!', 0
	szovegRULE3 BYTE 'Utana pedig az oszlop szamot: 1, 2, 3 es ismet ENTER!', 0

	szovegBeBetuHiba	BYTE	'Sorvalasztasnal: a, b, c!', 0
	szovegBeKovetkezo	BYTE	'Es most kerem az oszlop szamot: 1, 2, 3!', 0
	szovegBeSzamHiba	BYTE	'Oszlopvalasztasnal: 1, 2, 3!', 0
	szovegKiJeloltOszlop1	BYTE	'A kovetkezo sort jelolte ki: a.', 0
	szovegKiJeloltOszlop2	BYTE	'A kovetkezo sort jelolte ki: b.', 0
	szovegKiJeloltOszlop3	BYTE	'A kovetkezo sort jelolte ki: c.', 0
	szovegKiJeloltSor	BYTE	'A kovetkezo oszlopot jelolte ki: ', 0
	szovegKiJeloltSor2	BYTE	'.', 0
	szovegMezoKivalasztva	BYTE	'A mezo kivalasztva.', 0
	szovegMezoKivalasztva2	BYTE	'A mezo mar ki van valasztva.', 0
	szovegMezoKivalasztva3	BYTE	'Kerem valasszon ujat!', 0

	szovegALLAS BYTE 'Jelenlegi allas:', 0
	szovegKovetkezoJatekos	BYTE	'Soron kovetkezo jatekos:', 0

	szovegNyert	BYTE	' nyert!', 0

	caption db "Amoba sys msg", 0
	HelloMsg BYTE "Vege a jateknak.", 0dh,0ah 
		BYTE "Kattints az OK-ra a kilepeshez!", 0

.code
main PROC

	Call Start1

	Call SETMODE1
	
	;---------------------------------------------
	; ! GAMEPLAY !
	;---------------------------------------------

	MOV EAX, 0
	MOV EBX, 0
	MOV ECX, 0
	MOV EDX, 0

	gameplay:

		PUSH EDX
		Call Crlf
		Call Crlf
		MOV EDX, OFFSET szovegALLAS
		Call CallWSaNL
		MOV EDX, 0
		POP EDX
	
		CMP EDX, 9
		JE gameplayDONE
		PUSH EDX

		MOV ESI, OFFSET T
		MOV EAX, 0
		MOV EBX, 1
		MOV ECX, 3
		MOV EDX, 0

		kiir:
			CMP EDX, 9
			JE kiirDONE

			MOV EAX, [ESI]
			Call WriteInt

			CMP EBX, ECX
			JNE semmi
				Call Crlf
				ADD ECX, 3
			semmi:

			ADD EBX, 1
			ADD ESI, 4

			INC EDX
			JMP kiir

		kiirDONE:
			Call Crlf
			MOV EDX, 0
			POP EDX
			INC EDX
			
			PUSH EDX

			MOVSX EAX, MODE1
			CMP EAX, 1
				JE PVPMOVES
			CMP EAX, 2
				JE PVEMOVES

			PVPMOVES:
			Call Mezobeiras1
			JMP MOVEEND

			PVEMOVES:
			Call Mezobeiras2
			JMP MOVEEND

			MOVEEND:

			POP EDX

			PUSH EDX

			;---------------------------------------------
			; ! ELLENORZES !
			;---------------------------------------------
			Call Check1

			CMP EAX, 1
			JE egyesNyert

			CMP EAX, 2
			JE kettesNyert

			JMP stillGoing

			egyesNyert:
				MOV EDX, OFFSET P1
				Call WriteString
				MOV EDX, OFFSET szovegNyert
				Call CallWSaNL
				JMP gameplayDONE

			kettesNyert:
				MOVSX EAX, MODE1
				CMP EAX, 1
					JE PWIN
				CMP EAX, 2
					JE CPUWIN

				PWIN:
					MOV EDX, OFFSET P2
					Call WriteString
					MOV EDX, OFFSET szovegNyert
					Call CallWSaNL
					JMP gameplayDONE

				CPUWIN:
					MOV EDX, OFFSET BOT1
					Call WriteString
					MOV EDX, OFFSET szovegNyert
					Call CallWSaNL
					JMP gameplayDONE


			stillGoing:

			POP EDX

			JMP gameplay

	gameplayDONE:
	
	Call End1

	invoke ExitProcess,0

main ENDP

	;---------------------------------------------------------------------------
	;---------------------------------------------------------------------------
	;-------------------------- !   M E T H O D Z   ! --------------------------
	;---------------------------------------------------------------------------
	;---------------------------------------------------------------------------

CallWSaNL PROC NEAR
	Call WriteString
	Call Crlf
	ret
CallWSaNL ENDP



SETMODE1 PROC NEAR
	MOV EDX, OFFSET szovegMODE1
	Call CallWSaNL
	MOV EDX, OFFSET szovegMODE2
	Call CallWSaNL
	MOV EDX, OFFSET szovegMODE3
	Call CallWSaNL
	Call Crlf

	modeKivalasztas:
	Call ReadChar
	CMP AL, 49
		JE pvp
	CMP AL, 50
		JE pve

	JMP modeKivalasztas

	pvp:
		MOV MODE1, 1
		MOV EDX, OFFSET szovegMODEPVP
		Call CallWSaNL
		JMP modeKivalasztasEND
	pve:
		MOV MODE1, 2
		MOV EDX, OFFSET szovegMODEPVE
		Call CallWSaNL
		JMP modeKivalasztasEND

	modeKivalasztasEND:

	ret
SETMODE1 ENDP



Start1 PROC NEAR
	MOV EDX, OFFSET szovegBEGIN
	Call CallWSaNL
	Call Crlf
	MOV EDX, OFFSET szovegRULE1
	Call CallWSaNL
	MOV EDX, OFFSET szovegRULE2
	Call CallWSaNL
	MOV EDX, OFFSET szovegRULE3
	Call CallWSaNL
	Call Crlf

	ret
Start1 ENDP



Mezobeiras1 PROC NEAR
	;---------------------------------------------
	; ! Sor bekeres !
	;---------------------------------------------

	MOV EDX, OFFSET szovegKovetkezoJatekos
	Call CallWSaNL

	mezobekeres1:
		MOV EAX, 0
		MOV EBX, 0

		Call ReadChar

		CMP AL, 97
		JE helyesA
		CMP AL, 98
		JE helyesB
		CMP AL, 99
		JE helyesC
			MOV EDX, OFFSET szovegBeBetuHiba
			Call CallWSaNL
			JMP mezobekeres1

	helyesA:
		ADD EBX, 10
		MOV EDX, OFFSET szovegKiJeloltOszlop1
		JMP helyesBetuEND
	helyesB:
		ADD EBX, 20
		MOV EDX, OFFSET szovegKiJeloltOszlop2
		JMP helyesBetuEND
	helyesC:
		ADD EBX, 30
		MOV EDX, OFFSET szovegKiJeloltOszlop3
		JMP helyesBetuEND

	helyesBetuEND:

	Call CallWSaNL
	MOV EDX, OFFSET szovegBeKovetkezo
	Call CallWSaNL

	;---------------------------------------------
	; ! Oszlop bekeres !
	;---------------------------------------------

	mezobekeres2:
		MOV AL, 0
		Call ReadChar

		CMP AL, 49
		JE helyes1
		CMP AL, 50
		JE helyes2
		CMP AL, 51
		JE helyes3
			MOV EDX, OFFSET szovegBeSzamHiba
			Call CallWSaNL
			JMP mezobekeres2

	helyes1:
		ADD EBX, 1
		JMP helyesSzamEND
	helyes2:
		ADD EBX, 2
		JMP helyesSzamEND
	helyes3:
		ADD EBX, 3
		JMP helyesSzamEND

	helyesSzamEND:
	
	MOV EDX, OFFSET szovegKiJeloltSor
	Call WriteString
	SUB AL, 48
	MOVSX EAX, AL
	Call WriteInt
	MOV EDX, OFFSET szovegKiJeloltSor2
	Call CallWSaNL

	PUSH EBX

	POP EAX
	PUSH EAX

	;---------------------------------------------
	; ! Tabla elokeszitese !
	;---------------------------------------------

	MOV ESI, OFFSET T
	MOV EBX, 0
	MOV ECX, 0
		
	;---------------------------------------------
	; ! Foglalt-e a mezo !
	;---------------------------------------------

	foglaltE:
		
		MOV ESI, OFFSET T

		CMP EAX, 11
		JE foglaltEKereses
			ADD ESI, 4

		CMP EAX, 12
		JE foglaltEKereses
			ADD ESI, 4

		CMP EAX, 13
		JE foglaltEKereses
			ADD ESI, 4

		CMP EAX, 21
		JE foglaltEKereses
			ADD ESI, 4

		CMP EAX, 22
		JE foglaltEKereses
			ADD ESI, 4

		CMP EAX, 23
		JE foglaltEKereses
			ADD ESI, 4

		CMP EAX, 31
		JE foglaltEKereses
			ADD ESI, 4

		CMP EAX, 32
		JE foglaltEKereses
			ADD ESI, 4

		CMP EAX, 33
		JE foglaltEKereses

		foglaltEKereses:
		MOV EAX, [ESI]

		CMP EAX, 1
		JE nemValid

		CMP EAX, 2
		JE nemValid

		JMP valid

	nemValid:
	MOV EDX, OFFSET szovegMezoKivalasztva2
	Call CallWSaNL
	MOV EDX, OFFSET szovegMezoKivalasztva3
	Call CallWSaNL
	POP EAX
	MOV EAX, 0
	JMP mezobekeres1

	valid:
	MOV EDX, OFFSET szovegMezoKivalasztva
	Call CallWSaNL

	;---------------------------------------------
	; ! Mezo megjelolese !
	;---------------------------------------------

	POP EBX
	MOV EAX, 0
	MOV ESI, OFFSET T

	CMP EBX, 11
	JE talalt
		ADD ESI, 4

	CMP EBX, 12
	JE talalt
		ADD ESI, 4

	CMP EBX, 13
	JE talalt
		ADD ESI, 4

	CMP EBX, 21
	JE talalt
		ADD ESI, 4

	CMP EBX, 22
	JE talalt
		ADD ESI, 4

	CMP EBX, 23
	JE talalt
		ADD ESI, 4

	CMP EBX, 31
	JE talalt
		ADD ESI, 4

	CMP EBX, 32
	JE talalt
		ADD ESI, 4

	CMP EBX, 33
	JE talalt

	talalt:
	PUSH ESI

	;---------------------------------------------
	; ! Jatekos kitalasa !
	;---------------------------------------------

	MOV ESI, OFFSET T
	MOV EAX, 0
	MOV EBX, 0
	MOV ECX, 1
	MOV EDX, 0

	seta1:
		CMP ECX, 10
		JE setaVeg


		MOV EBX, [ESI]
		CMP EBX, 1
		JE EgyplusszEgy

		CMP EBX, 2
		JE KettoplusszEgy

		INC ECX
		ADD ESI, 4
		JMP seta1


		EgyplusszEgy:
		ADD EAX, 1
		INC ECX
		ADD ESI, 4
		JMP seta1

		KettoplusszEgy:
		ADD EDX, 1
		INC ECX
		ADD ESI, 4
		JMP seta1

	setaVeg:

	POP ESI

	CMP EAX, EDX
	JNE nemAMasodikJatekosLepett
	MOV EAX, 1
	MOV [ESI], EAX
	JMP setaVeg2

	nemAMasodikJatekosLepett:
	MOV EAX, 2
	MOV [ESI], EAX

	setaVeg2:

	ret
Mezobeiras1 ENDP



Mezobeiras2 PROC NEAR
;PVE
	
	;---------------------------------------------
	; ! Jatekos kitalasa !
	;---------------------------------------------

	MOV ESI, OFFSET T
	MOV EAX, 0
	MOV EBX, 0
	MOV ECX, 1
	MOV EDX, 0

	seta1PVE:
		CMP ECX, 10
		JE setaVegPVE
		;TODO

		MOV EBX, [ESI]
		CMP EBX, 1
		JE EgyplusszEgyPVE

		CMP EBX, 2
		JE KettoplusszEgyPVE

		INC ECX
		ADD ESI, 4
		JMP seta1PVE


		EgyplusszEgyPVE:
		ADD EAX, 1
		INC ECX
		ADD ESI, 4
		JMP seta1PVE

		KettoplusszEgyPVE:
		ADD EDX, 1
		INC ECX
		ADD ESI, 4
		JMP seta1PVE

	setaVegPVE:

	CMP EAX, EDX
	JNE nemAMasodikJatekosLepettPVE
	JMP JatekosLepesePVE

	nemAMasodikJatekosLepettPVE:
	JMP CPULepesePVE

	JatekosLepesePVE:

	;---------------------------------------------
	; ! PLAYER LEP !
	;---------------------------------------------

	;---------------------------------------------
	; ! Sor bekeres !
	;---------------------------------------------

	MOV EDX, OFFSET szovegKovetkezoJatekos
	Call CallWSaNL

	mezobekeres1PVE1:
		MOV EAX, 0
		MOV EBX, 0

		Call ReadChar

		CMP AL, 97
		JE helyesAPVE1
		CMP AL, 98
		JE helyesBPVE1
		CMP AL, 99
		JE helyesCPVE1
			MOV EDX, OFFSET szovegBeBetuHiba
			Call CallWSaNL
			JMP mezobekeres1PVE1

	helyesAPVE1:
		ADD EBX, 10
		MOV EDX, OFFSET szovegKiJeloltOszlop1
		JMP helyesBetuENDPVE1
	helyesBPVE1:
		ADD EBX, 20
		MOV EDX, OFFSET szovegKiJeloltOszlop2
		JMP helyesBetuENDPVE1
	helyesCPVE1:
		ADD EBX, 30
		MOV EDX, OFFSET szovegKiJeloltOszlop3
		JMP helyesBetuENDPVE1

	helyesBetuENDPVE1:

	Call CallWSaNL
	MOV EDX, OFFSET szovegBeKovetkezo
	Call CallWSaNL

	;---------------------------------------------
	; ! Oszlop bekeres !
	;---------------------------------------------

	mezobekeres2PVE1:
		MOV AL, 0
		Call ReadChar

		CMP AL, 49
		JE helyes1PVE1
		CMP AL, 50
		JE helyes2PVE1
		CMP AL, 51
		JE helyes3PVE1
			MOV EDX, OFFSET szovegBeSzamHiba
			Call CallWSaNL
			JMP mezobekeres2PVE1

	helyes1PVE1:
		ADD EBX, 1
		JMP helyesSzamENDPVE1
	helyes2PVE1:
		ADD EBX, 2
		JMP helyesSzamENDPVE1
	helyes3PVE1:
		ADD EBX, 3
		JMP helyesSzamENDPVE1

	helyesSzamENDPVE1:
	
	MOV EDX, OFFSET szovegKiJeloltSor
	Call WriteString
	SUB AL, 48
	MOVSX EAX, AL
	Call WriteInt
	MOV EDX, OFFSET szovegKiJeloltSor2
	Call CallWSaNL

	PUSH EBX

	POP EAX
	PUSH EAX


	;---------------------------------------------
	; ! CPU LEP !
	;---------------------------------------------

	JMP AdottKorLepesekEND


	CPULepesePVE:
		;---------------------------------------------
		; ! CPU SOR GENERALAS!
		;---------------------------------------------
		MOV ECX, 0

		MOV EAX, 3
		call RandomRange
		INC EAX
		Call WriteInt
		CMP EAX, 1
		JE aSorCPU

		CMP EAX, 2
		JE bSorCPU

		CMP EAX, 3
		JE cSorCPU

		aSorCPU:
			MOV ECX, 10
			JMP SorCPUend

		bSorCPU:
			MOV ECX, 20
			JMP SorCPUend

		cSorCPU:
			MOV ECX, 30
			JMP SorCPUend

		SorCPUend:

		;---------------------------------------------
		; ! CPU OSZLOP GENERALAS!
		;---------------------------------------------

		MOV EAX, 3
		call RandomRange
		INC EAX
		Call WriteInt

		ADD ECX, EAX

		MOV EAX, ECX
		Call WriteInt

		PUSH EAX

	AdottKorLepesekEND:

	;---------------------------------------------
	; ! Tabla elokeszitese !
	;---------------------------------------------

	MOV ESI, OFFSET T
	MOV EBX, 0
	MOV ECX, 0
		
	;---------------------------------------------
	; ! Foglalt-e a mezo !
	;---------------------------------------------

	foglaltEPVE:
		
		MOV ESI, OFFSET T

		CMP EAX, 11
		JE foglaltEKeresesPVE
			ADD ESI, 4

		CMP EAX, 12
		JE foglaltEKeresesPVE
			ADD ESI, 4

		CMP EAX, 13
		JE foglaltEKeresesPVE
			ADD ESI, 4

		CMP EAX, 21
		JE foglaltEKeresesPVE
			ADD ESI, 4

		CMP EAX, 22
		JE foglaltEKeresesPVE
			ADD ESI, 4

		CMP EAX, 23
		JE foglaltEKeresesPVE
			ADD ESI, 4

		CMP EAX, 31
		JE foglaltEKeresesPVE
			ADD ESI, 4

		CMP EAX, 32
		JE foglaltEKeresesPVE
			ADD ESI, 4

		CMP EAX, 33
		JE foglaltEKeresesPVE

		foglaltEKeresesPVE:
		MOV EAX, [ESI]

		CMP EAX, 1
		JE nemValidPVE

		CMP EAX, 2
		JE nemValidPVE

		JMP validPVE

	nemValidPVE:
	MOV EDX, OFFSET szovegMezoKivalasztva2
	Call CallWSaNL
	MOV EDX, OFFSET szovegMezoKivalasztva3
	Call CallWSaNL
	POP EAX
	MOV EAX, 0
	JMP CPULepesePVE

	validPVE:
	MOV EDX, OFFSET szovegMezoKivalasztva
	Call CallWSaNL

	;---------------------------------------------
	; ! Mezo megjelolese !
	;---------------------------------------------

	POP EBX
	MOV EAX, 0
	MOV ESI, OFFSET T

	CMP EBX, 11
	JE talaltPVE
		ADD ESI, 4

	CMP EBX, 12
	JE talaltPVE
		ADD ESI, 4

	CMP EBX, 13
	JE talaltPVE
		ADD ESI, 4

	CMP EBX, 21
	JE talaltPVE
		ADD ESI, 4

	CMP EBX, 22
	JE talaltPVE
		ADD ESI, 4

	CMP EBX, 23
	JE talaltPVE
		ADD ESI, 4

	CMP EBX, 31
	JE talaltPVE
		ADD ESI, 4

	CMP EBX, 32
	JE talaltPVE
		ADD ESI, 4

	CMP EBX, 33
	JE talaltPVE

	talaltPVE:
	PUSH ESI

	;---------------------------------------------
	; ! Jatekos kitalasa !
	;---------------------------------------------

	MOV ESI, OFFSET T
	MOV EAX, 0
	MOV EBX, 0
	MOV ECX, 1
	MOV EDX, 0

	seta1PVE11:
		CMP ECX, 10
		JE setaVegPVE11


		MOV EBX, [ESI]
		CMP EBX, 1
		JE EgyplusszEgyPVE11

		CMP EBX, 2
		JE KettoplusszEgyPVE11

		INC ECX
		ADD ESI, 4
		JMP seta1PVE11


		EgyplusszEgyPVE11:
		ADD EAX, 1
		INC ECX
		ADD ESI, 4
		JMP seta1PVE11

		KettoplusszEgyPVE11:
		ADD EDX, 1
		INC ECX
		ADD ESI, 4
		JMP seta1PVE11

	setaVegPVE11:

	POP ESI

	CMP EAX, EDX
	JNE nemAMasodikJatekosLepettPVE11
	MOV EAX, 1
	MOV [ESI], EAX
	JMP setaVeg2PVE11

	nemAMasodikJatekosLepettPVE11:
	MOV EAX, 2
	MOV [ESI], EAX

	setaVeg2PVE11:

	ret
Mezobeiras2 ENDP



Check1 PROC NEAR
	MOV ESI, OFFSET T
	MOV EAX, 0
	MOV EBX, 0
	MOV ECX, 0
	MOV EDX, 0

	;--- 1. SOR
	MOV EAX, [ESI]
	MOV EBX, [ESI+4]
	MOV ECX, [ESI+8]

	CMP EAX, 0
	JE tovabb
	CMP EAX, EBX
	JNE tovabb
	CMP EBX, ECX
	JE gyozelem

	tovabb:

	;--- 2. SOR
	MOV EAX, [ESI+12]
	MOV EBX, [ESI+16]
	MOV ECX, [ESI+20]

	CMP EAX, 0
	JE tovabb2
	CMP EAX, EBX
	JNE tovabb2
	CMP EBX, ECX
	JE gyozelem

	tovabb2:
	;--- 3. SOR
	MOV EAX, [ESI+24]
	MOV EBX, [ESI+28]
	MOV ECX, [ESI+32]

	CMP EAX, 0
	JE tovabb3
	CMP EAX, EBX
	JNE tovabb3
	CMP EBX, ECX
	JE gyozelem

	tovabb3:
	;--- 1. OSZLOP
	MOV EAX, [ESI]
	MOV EBX, [ESI+12]
	MOV ECX, [ESI+24]

	CMP EAX, 0
	JE tovabb4
	CMP EAX, EBX
	JNE tovabb4
	CMP EBX, ECX
	JE gyozelem

	tovabb4:
	;--- 2. OSZLOP
	MOV EAX, [ESI+4]
	MOV EBX, [ESI+16]
	MOV ECX, [ESI+28]

	CMP EAX, 0
	JE tovabb5
	CMP EAX, EBX
	JNE tovabb5
	CMP EBX, ECX
	JE gyozelem

	tovabb5:
	;--- 3. OSZLOP
	MOV EAX, [ESI+8]
	MOV EBX, [ESI+20]
	MOV ECX, [ESI+32]

	CMP EAX, 0
	JE tovabb6
	CMP EAX, EBX
	JNE tovabb6
	CMP EBX, ECX
	JE gyozelem

	tovabb6:
	;--- balfentrol ATLO
	MOV EAX, [ESI]
	MOV EBX, [ESI+16]
	MOV ECX, [ESI+32]

	CMP EAX, 0
	JE tovabb7
	CMP EAX, EBX
	JNE tovabb7
	CMP EBX, ECX
	JE gyozelem

	tovabb7:
	;--- balalulrol ATLO
	MOV EAX, [ESI+24]
	MOV EBX, [ESI+16]
	MOV ECX, [ESI+8]
	
	CMP EAX, 0
	JE tovabb8
	CMP EAX, EBX
	JNE tovabb8
	CMP EBX, ECX
	JE gyozelem

	tovabb8:

	MOV EAX, 0

	gyozelem:
	
	ret
Check1 ENDP



End1 PROC NEAR
	MOV	EBX, OFFSET caption		; caption
	MOV	EDX, OFFSET HelloMsg		; contents
	Call	MsgBox
	ret
End1 ENDP



END main 