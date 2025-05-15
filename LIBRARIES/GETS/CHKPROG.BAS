'gets name of program running and it's command line
'$INCLUDE: 'QB.BI'

DEFINT A-Z
DECLARE FUNCTION CommandLine$ ()
DECLARE FUNCTION ProgramName$ ()

PRINT
PRINT "This program was loaded as "; ProgramName$
IF LEN(CommandLine$) THEN PRINT "With a command line of "; CommandLine$

FUNCTION CommandLine$ STATIC

   DIM IRegs AS RegType, ORegs AS RegType

   IRegs.ax = &H5100
   CALL INTERRUPT(&H21, IRegs, ORegs)
   Segment% = ORegs.bx
   Offset% = &H80

   DEF SEG = Segment%
   Lenght% = PEEK(Offset%)
   Temp$ = SPACE$(127)

   FOR I% = 1 TO Lenght%
	  MID$(Temp$, I%, 1) = CHR$(PEEK(Offset% + I%))
   NEXT I%
   DEF SEG

   CommandLine$ = LTRIM$(RTRIM$(Temp$))
   Temp$ = ""

END FUNCTION

FUNCTION ProgramName$ STATIC

	DIM InRegs AS RegType, OutRegs AS RegType

	InRegs.ax = &H6200
	CALL INTERRUPT(&H21, InRegs, OutRegs)
	DEF SEG = OutRegs.bx

	EnvBlkSeg& = CVI(CHR$(PEEK(&H2C)) + CHR$(PEEK(&H2D)))
	DEF SEG = EnvBlkSeg&

	EnvBlkPtr% = 0
	DO
		IF PEEK(EnvBlkPtr%) = 0 THEN
			IF PEEK(EnvBlkPtr% + 1) = 0 THEN EXIT DO
		END IF
		IF EnvBlkPtr% < &H7FFF THEN EnvBlkPtr% = EnvBlkPtr% + 1
	LOOP

	EnvBlkPtr% = EnvBlkPtr% + 4
	DO
		Char% = PEEK(EnvBlkPtr%)
		IF Char% THEN
			Temp$ = Temp$ + CHR$(Char%)
			EnvBlkPtr% = EnvBlkPtr% + 1
		END IF
	LOOP WHILE Char% > 0 AND LEN(Temp$) < 80
	DEF SEG

	ProgramName$ = Temp$

END FUNCTION

