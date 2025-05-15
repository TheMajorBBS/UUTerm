'Demo of special effects
DEFINT A-Z
'$INCLUDE: 'qb.bi'                    'or QB.BI as appropriate
CONST False = 0, True = NOT False
DECLARE FUNCTION Monitor% (Segment%)
DECLARE FUNCTION Rand% (Lower%, Upper%)
DECLARE SUB ScreenSaver (Choice%)

	DIM SHARED Regs AS RegType
	DO
		Choice% = Choice% + 1
		IF Choice% > 11 THEN Choice% = 1
		ScreenSaver Choice%
		LOCATE 5, 5
		PRINT "That was version"; Choice%; "- Another (Y, n)?"
		Again$ = INPUT$(1)
	LOOP UNTIL UCASE$(LEFT$(Again$, 1)) = "N"

FUNCTION Monitor% (Segment%) STATIC
'=====================================================================
'  This is not mine - it came from the RIME Q-BASIC conference, of
'  unknown authorship.
'  But it works!
'  Returns -   1   Monochrome
'              2   Hercules
'              3   CGA
'              4   EGA
'              5   VGA
'Requires CALL Interrupt() declarations & includes at the module level
'=====================================================================
	DEF SEG = 0                'first see if it's color or mono
	Segment = &HB800           'assume color
	IF PEEK(&H463) = &HB4 THEN
		Segment = &HB000        'assign the monochrome segment
		Status = INP(&H3BA)     'get the current video status
	       FOR X = 1 TO 30000      'test for a Hercules 30000 times
			IF INP(&H3BA) <> Status THEN
		       Monitor% = 2      'the port changed, it's a Herc
				EXIT FUNCTION     'all done
			END IF
		NEXT
		Monitor% = 1            'it's a plain monochrome
		ELSE                    'it's some sort of color monitor
		Regs.ax = &H1A00        'first test for VGA
		CALL INTERRUPT(&H10, Regs, Regs)
		IF (Regs.ax AND &HFF) = &H1A THEN
			Monitor% = 5         'it's a VGA
			EXIT FUNCTION        'all done
		END IF
		Regs.ax = &H1200        'now test for EGA
		Regs.bx = &H10
		CALL INTERRUPT(&H10, Regs, Regs)
		IF (Regs.bx AND &HFF) = &H10 THEN
			Monitor% = 3    'if BL is still &H10 it's a CGA
			ELSE
			Monitor% = 4         'otherwise it's an EGA
		END IF
	END IF
END FUNCTION

FUNCTION Rand% (Lower%, Upper%)
RANDOMIZE TIMER
Rand% = INT((Upper% - Lower% + 1) * RND + Lower%)
END FUNCTION

DEFSNG A-Z
SUB ScreenSaver (Choice%)
'=====================================================================
'Drops into graphics mode, draws 1 of 10 random patterns on screen
'if color video is detected; otherwise runs a character based pattern
'in monochrome.  Other screens are simply blanked.
'                      CASE #
'The patterns are -       Monochrome, Hercules (text mode, blank only)
'                        1. Laser Wars!
'                        2. Plop, plop, plop
'                        3. Boxed in
'                        4. Spherical
'                        5. Radar run amuck
'                        6. Windmills of the mind
'                        7. Chute away!
'                        8. Our expanding universe . . .
'                        9. Night bomb raid
'                       10. Bubbles!
'                       11. Paint gun
'(I had to name them *something*!  :)
'  Choice%      - Flag for forcing a particular pattern (99 = random)
'  Requires     - Global CONSTs True, False
'                 A CGA, EGA or VGA adapter for the graphic routines
'  Uses         - Rand%(), Monitor%()
'======================================================================
	MaxChoice% = 11       'Set this to the number of screen savers

	IF Choice% > MaxChoice% OR Choice% < 1 THEN Choice% = 99

	SELECT CASE Monitor%(Segment%)
		CASE 3
			SCREEN 2: MaxX% = 639: MaxY% = 199     'CGA
			MaxColr% = 1
			CGA% = True
		CASE 4
			SCREEN 9: MaxX% = 639: MaxY% = 349     'EGA
			MaxColr% = 15
		CASE 5
			SCREEN 12: MaxX% = 639: MaxY% = 479    'VGA
			MaxColr% = 15
		CASE ELSE
			SCREEN 0                               'Mono
			CLS
			DO WHILE INKEY$ = "": LOOP
			EXIT SUB
	END SELECT

	IF Choice% = 99 THEN       'If not specified, a random choice
		WhichOne% = Rand%(1, MaxChoice%)
		ELSE
		WhichOne% = Choice%        'else the choice specified
	END IF

'  Screen savers start here
	SELECT CASE WhichOne%
		CASE 1
			DO
				StartX = Rand%(0, MaxX%)
				StartY = Rand%(0, MaxY%)
				EndX = Rand%(0, MaxX%)
				EndY = Rand%(0, MaxY%)
				Colr = Rand%(8, MaxColr%)
			    LINE (StartX, StartY)-(EndX, EndY), Colr
				GOSUB PauseIt
			      LINE (StartX, StartY)-(EndX, EndY), 0
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			EXIT SUB
		CASE 2
			DO
				StartX = Rand%(0, MaxX%)
				StartY = Rand%(0, MaxY%)
				Radius = Rand%(1, 200)
				Colr& = Rand%(0, MaxColr%)
				GOSUB PauseIt
				CIRCLE (StartX, StartY), Radius, Colr&
				PAINT (StartX, StartY), Colr&
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			EXIT SUB
		CASE 3
			DO
				StartX = Rand%(0, MaxX%)
				StartY = Rand%(0, MaxY%)
				EndX = Rand%(0, MaxX%)
				EndY = Rand%(0, MaxY%)
				Colr = Rand%(0, MaxColr%)
			  LINE (StartX, StartY)-(EndX, EndY), Colr, BF
				GOSUB PauseIt
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			EXIT SUB
		CASE 4
			DO
				StartX = Rand%(0, MaxX%)
				StartY = Rand%(0, MaxY%)
				Colr& = Rand%(1, MaxColr%)
				FOR X = 1 TO 50
					Radius = Radius + 2
				CIRCLE (StartX, StartY), Radius, Colr&
				NEXT
				Count% = Count% + 1
				IF Count% = 50 THEN Count% = 0: CLS
				Radius = 0
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			EXIT SUB
		CASE 5
			StartX = 0
			StartY = 0
			EndX = MaxX%
			EndY = MaxY%
			DO
				Colr% = Rand%(1, MaxColr%)
			     LINE (StartX, StartY)-(EndX, EndY), Colr%
				LINE (StartX, StartY)-(EndX, EndY), 0
				StartX = StartX + 1
				IF StartX > MaxX% THEN StartX = 0
				StartY = StartY + 1
				IF StartY > MaxY% THEN StartY = 0
				EndX = EndX - 1
				IF EndX < 0 THEN EndX = MaxX%
				EndY = EndY - 1
				IF EndY < 0 THEN EndY = MaxY%
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			EXIT SUB
		CASE 6
			StartX = Rand%(0, MaxX%)
			StartY = Rand%(0, MaxY%)
			EndX = Rand%(0, MaxX%)
			EndY = Rand%(0, MaxY%)
			DO
			LINE (StartX, StartY)-(EndX, EndY), Colr%, , 16
				StartX = StartX + 1
				IF StartX > MaxX% THEN StartX = 0
				StartY = StartY + 1
				IF StartY > MaxY% THEN StartY = 0
				EndX = EndX - 1
				IF EndX < 0 THEN EndX = MaxX%
				EndY = EndY - 1
				IF EndY < 0 THEN EndY = MaxY%
		   IF Count MOD 200 = 0 THEN Colr% = Rand%(0, MaxColr%)
				Count = Count + 1
				IF Count = 2000 THEN
					Count = 1
				   IF CGA% THEN CLS
				END IF
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			CGA% = False
			EXIT SUB
		CASE 7
			StartX = 0
			StartY = 0
			Z = 2
			DO
				EndX = StartX + 75
				EndY = StartY + 50
			  LINE (StartX, StartY)-(EndX, EndY), Colr%, B
				StartX = StartX + Z
				StartY = StartY + Z
				IF StartX > 564 THEN StartX = 0
				IF StartY > 429 THEN StartY = 0
				Count = Count + 1
				IF Count = 250 THEN
					Count = 1
					Colr% = Rand%(0, MaxColr%)
				END IF
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			EXIT SUB
		CASE 8
			DO
				StartX = Rand%(0, MaxX%)
				StartY = Rand%(0, MaxY%)
				Colr& = Rand%(1, MaxColr%)
				Radius = Rand%(1, 150)
				FOR X = 1 TO Radius
				     CIRCLE (StartX, StartY), X, Colr&
				     CIRCLE (StartX, StartY), X - 1, 0
				NEXT
				GOSUB PauseIt
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			EXIT SUB
		CASE 9
			DO
				StartX = Rand%(0, MaxX%)
				StartY = Rand%(0, MaxY%)
				Colr& = Rand%(1, MaxColr%)
				Radius = Rand%(1, 150)
				FOR X = 1 TO Radius
				     CIRCLE (StartX, StartY), X, Colr&
				NEXT
				FOR X = 1 TO Radius
					CIRCLE (StartX, StartY), X, 0
				NEXT
				GOSUB PauseIt
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			EXIT SUB
		CASE 10
			DO
				StartX = Rand%(0, MaxX%)
				StartY = Rand%(0, MaxY%)
				Colr& = Rand%(1, MaxColr%)
				Radius = Rand%(1, 150)
				FOR X = 1 TO Radius
				     CIRCLE (StartX, StartY), X, Colr&
					CIRCLE (StartX, StartY), X, 0
				NEXT
				GOSUB PauseIt
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			EXIT SUB
		CASE 11
			DO
				Radius% = Rand%(10, 70)
				Colr% = Rand%(0, MaxColr%)
				StartX% = Rand%(0, MaxX%)
				StartY% = Rand%(0, MaxY%)
			     CIRCLE (StartX%, StartY%), Radius%, Colr%
				PAINT (StartX%, StartY%), Colr%, Colr%
			  FOR VPos% = StartY% TO StartY% + MaxX% \ 9.6
	 CIRCLE (StartX%, VPos% + Radius% * .16), Radius% * .75, Colr%
				NEXT
			   FOR VPos% = StartY% TO StartY% + MaxX% \ 7.4
	   CIRCLE (StartX%, VPos% + Radius% * .5), Radius% * .66, Colr%
				NEXT
			   FOR VPos% = StartY% TO StartY% + MaxX% \ 6.8
	  CIRCLE (StartX%, VPos% + Radius% * 1), Radius% * .58, Colr%
				NEXT
			     FOR VPos% = StartY% TO StartY% + MaxX% \ 6
	    CIRCLE (StartX%, VPos% + Radius% * 2), Radius% * .4, Colr%
				NEXT
			    FOR VPos% = StartY% TO Start% + MaxX% \ 5.3
	  CIRCLE (StartX%, VPos% + Radius% * 3), Radius% * .25, Colr%
				NEXT
			LOOP WHILE INKEY$ = ""
			SCREEN 0
			CGA% = False
			EXIT SUB

		CASE ELSE
			CLS
			DO WHILE INKEY$ = "": LOOP
	END SELECT
PauseIt:
	Start! = TIMER
	DO UNTIL TIMER > Start! + .1: LOOP
	RETURN

END SUB

