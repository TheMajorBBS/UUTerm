 'Program will make a cursor available in the graphic modes.   
   'CURSOR for GRAPHICS PATCH & SHAPE PICKER (PDS 7.1 & QB 4.5 Version)
                      'By J. S. Paravati   1/94

 'Note!: This program will modify a QB(X).EXE file! Backup your original
 '       file first!

 'Load QB or PDS with the default lib. (QB(X) /L)

 'Program will make a cursor available in the graphic modes.  After
 'patch is in place LOCATE , , 1 and LOCATE , , 0 will turn cursor on
 'and off (see SUBs CurOn & CurOff).  You also can pick a cursor shape.
 'Any ASCII character shape (0 - 255) can be used. Change will be made
 'to the shape in the QB(X) environment and, if you want, the file
'itself
 'and related compile files.  The program automatically knows if QB or
 'PDS (QBX) is being used.  Run program from environment ONLY.
 'DO NOT COMPILE AND EXECUTE!
 'The SHAPE picker can be used as often as you want.  Once the main
 'patch is in place you will go directly to the SHAPE picker routine
 'at each "RUN", by-passing the patch routine.

DECLARE SUB ChangeFile (F$, NewCur%)
DECLARE SUB CurOn ()
DECLARE SUB CurOff ()
DECLARE SUB YESNO (OK$)
DECLARE SUB WhichFile ()
DECLARE SUB Check4Fix (F$)
DECLARE SUB CloseAll ()
   DEFINT A-Z
TYPE RegType
     AX    AS INTEGER
     BX    AS INTEGER
     cx    AS INTEGER
     dx    AS INTEGER
     bp    AS INTEGER
     si    AS INTEGER
     di    AS INTEGER
     flags AS INTEGER
END TYPE

COMMON SHARED START, FINISH, CHOICE, X, PSP, CH$, PSPoffset
COMMON SHARED FixAddr, ShapeAddr, Shape
   DIM inregs AS RegType, outregs AS RegType
   DIM SHARED F$(7), FixAddress&(7), ShapeAddress&(7)
    FOR N = 1 TO 7
     READ F$(N), FixAddress&(N), ShapeAddress&(N)
    NEXT N
 CALL CurOff
  SCREEN 9
   COLOR 15, 4
   inregs.AX = &H5100
   CALL INTERRUPT(&H21, inregs, outregs)
   PSP = outregs.BX
 CALL WhichFile
 CALL Check4Fix(F$)
PICKCUR:
  CLS : PRINT CH$
  PRINT "Shape in Environment ="; Shape - 1;
  PRINT "("; HEX$(Shape - 1); " Hex) "; CHR$(Shape - 1)
  PRINT
     OPEN CH$ FOR BINARY AS #1
     SEEK #1, ShapeAddress&(START):
     GET #1, , AX
     AH = ((AX AND &HFF00) \ &H100) AND &HFF
     AH = AH - 1
     AL = (AX AND &HFF00 \ &H100) AND &HFF
    PRINT "Shape in FILE        ="; AH;
    PRINT "("; HEX$(AH); " Hex) "; CHR$(AH)
    CLOSE #1
     PRINT
50   INPUT "New Cursor (0-254)"; NewCur%
      IF NewCur > 254 OR NewCur < 0 THEN GOTO 50
  SELECT CASE CHOICE
      CASE 1
        POKE &H9334, NewCur + 1
      CASE 2
        POKE &H7F2A, NewCur + 1
  END SELECT
   PRINT : PRINT "        "; CHR$(NewCur)
 PRINT "OK <Y>es <N>o ? "
 CALL YESNO(OK$)
  IF OK$ = "N" THEN GOTO PICKCUR
DEF SEG
LOCATE , 20: PRINT "Press Some Keys. Use <ESC> to End Test."
  CALL CurOn
DO
  K$ = INKEY$
     IF K$ <> "" THEN
       CALL CurOff: PRINT K$; : CALL CurOn
     END IF
LOOP UNTIL K$ = CHR$(27)
 CALL CurOff: PRINT
IF CHOICE = 1 THEN
  PRINT "Want to make change Permanent (Write to QBX.EXE File & LIBs) ";
 ELSE
  PRINT "Want to make change Permanent (Write to QB.EXE File & LIB) ";
END IF
PRINT "<Y>es <N>o ?"
   CALL YESNO(OK$)
 IF OK$ = "Y" THEN CALL ChangeFile(F$, NewCur%)
END

                        'PDS 7.1 Data
 DATA QBX.EXE, &H453CF, &H454A4
 DATA "C:\BC7\LIB\BCL71AFR.LIB", &H1C5B7, &H1C68C
 DATA "C:\BC7\LIB\BCL71ANR.LIB", &H19BA7, &H19C7C
 DATA "C:\BC7\LIB\BCL71EFR.LIB", &H19987, &H19A5C
 DATA "C:\BC7\LIB\BCL71ENR.LIB", &H17167, &H1723C

                         'QB 4.5 Data
 DATA QB.EXE, &H20ABC, &H20B8A
 DATA BCOM45.LIB, &H18FF6, &H190C4

DEFSNG A-Z
SUB ChangeFile (F$, NewCur%)
CLS
   H = 196
   V = 197
   FORM$ = STRING$(24, CHR$(H)) + CHR$(V)
   FORM$ = FORM$ + STRING$(14, CHR$(H)) + CHR$(V)
   FORM$ = FORM$ + STRING$(13, CHR$(H)) + CHR$(V)
   FORM$ = FORM$ + STRING$(26, CHR$(H))
    V = 193
   FORM2$ = STRING$(24, CHR$(H)) + CHR$(V)
   FORM2$ = FORM2$ + STRING$(14, CHR$(H)) + CHR$(V)
   FORM2$ = FORM2$ + STRING$(13, CHR$(H)) + CHR$(V)
   FORM2$ = FORM2$ + STRING$(26, CHR$(H))
PRINT "FILE": LINE$ = CHR$(179)
 LOCATE 1, 25: PRINT LINE$; " Old Shape  "
 LOCATE 1, 40: PRINT LINE$; " New Shape"
 LOCATE 1, 54: PRINT LINE$; " Verifying File": PRINT FORM$
 FOR N = START TO FINISH
  F$ = F$(N): PRINT F$,
  F$ = UCASE$(F$)
 OPEN F$ FOR BINARY AS #1
  SEEK #1, ShapeAddress&(N):
    GET #1, , AX: GET #1, , BX
     AH = ((AX AND &HFF00) \ &H100) AND &HFF
     AH = AH - 1
     AL = (AX AND &HFF00 \ &H100) AND &HFF
     LOCATE , 25
     PRINT LINE$; AH; "("; HEX$(AH); ") "; CHR$(AH);
   IF AL <> &HB0 AND BX <> &H749D THEN PRINT "ERROR !": STOP
    NH = NewCur + 1
    NL = &HB0
    IF NH < 0 OR NH > 255 THEN STOP
       IF NH < 128 THEN
         NewByte = NH * 256 + NL
        ELSE
         NewByte = (NH OR -256) * 256 + NL
       END IF
   SEEK #1, ShapeAddress&(N)
     PUT #1, , NewByte
     NH = NH - 1
  LOCATE , 40
  PRINT LINE$; NH; "("; HEX$(NH); ") "; CHR$(NH);
  SEEK #1, ShapeAddress&(N)
    GET #1, , AX
     AH = ((AX AND &HFF00) \ &H100) AND &HFF
     AH = AH - 1
  LOCATE , 54
  PRINT LINE$; AH; "("; HEX$(AH); ") "; CHR$(AH)
  IF AH <> NH THEN
    PRINT "File NOT modified. New Shape NOT in place."
    CLOSE : EXIT SUB
  END IF
 CLOSE #1
 IF N < FINISH THEN PRINT FORM$ ELSE PRINT FORM2$
NEXT N
 CLOSE : PRINT
  IF CHOICE = 1 THEN
    PRINT "QBX and Compile Files Have Been Modified. ";
    PRINT "New Cursor ("; CHR$(AH); ") is in effect.";
   ELSE
    PRINT "QB and Compile File Have Been Modified. ";
    PRINT "New Cursor ("; CHR$(AH); ") is in effect.";
  END IF
END SUB

SUB Check4Fix (F$)
 FOR N = START TO FINISH
  F$ = F$(N): PRINT F$
  F$ = UCASE$(F$)
 OPEN F$ FOR BINARY AS #1
  SEEK #1, FixAddress&(N):
    GET #1, , AX: GET #1, , BX
    IF BX = &HA11A AND AX = &H7500 THEN
    PRINT HEX$(AX); "  "; HEX$(BX); " Original Should = HEX 7500  A11A "
       IF N = START THEN
        PRINT " Want to install Graphic Cursor Patch ?  <Y>, <N>"
        CALL YESNO(OK$)
       END IF
      IF OK$ = "Y" THEN
        FixByte = &H7200
        SEEK #1, FixAddress&(N)
        PUT #1, , FixByte
        IF N = START THEN
         DEF SEG = PSP + PSPoffset
         X = PEEK(FixAddr)
         POKE FixAddr, &H72
        END IF
        ELSE CALL CloseAll
      END IF
     ELSE CLOSE #1: EXIT SUB
    END IF
  SEEK #1, FixAddress&(N)
    GET #1, , AX
    PRINT "Changed to: "; HEX$(AX), HEX$(BX)
  IF AX <> FixByte THEN
    PRINT "File NOT modified. Patch NOT in place."
    CALL CloseAll
  END IF
 CLOSE #1: PRINT
NEXT N
 CLOSE
  IF CHOICE = 1 THEN
    PRINT "QBX and Compile Files Have Been Modified"
    PRINT "Graphic Cursor Patch in Place. ";
   ELSE
    PRINT "QB and Compile File Have Been Modified"
    PRINT "Graphic Cursor Patch in Place. ";
  END IF
   LOCATE 24, 32: PRINT "<Press Any Key>";
   SLEEP
   CLS
END SUB

SUB CloseAll
 DEF SEG : CLOSE #1: CLOSE
 END
END SUB

SUB CurOff
  LOCATE , , 0
END SUB

SUB CurOn
 IF POS(0) = 1 THEN PRINT
  LOCATE , , 1
END SUB

SUB WhichFile
   DEF SEG = PSP
    FOR CHR = &H24AE TO &H24B4
     CH$ = CH$ + CHR$(PEEK(CHR))
    NEXT CHR
    IF CH$ = "QBX.EXE" THEN CHOICE = 1 ELSE CH$ = ""
  IF CH$ = "" THEN
    FOR CHR = &H1CB0 TO &H1CB5
     CH$ = CH$ + CHR$(PEEK(CHR))
    NEXT CHR
  END IF
      IF CH$ = "QB.EXE" THEN CHOICE = 2
      IF CHOICE = 0 THEN PRINT "ERROR": CALL CloseAll
   IF CHOICE = 1 THEN
      START = 1: FINISH = 5: PSPoffset = 14887
      FixAddr = &H925F: ShapeAddr = &H9334
     ELSE START = 6: FINISH = 7: PSPoffset = 5846
      FixAddr = &H7E5C: ShapeAddr = &H7F2A
   END IF
     DEF SEG = PSP + PSPoffset
      Shape = PEEK(ShapeAddr)
END SUB

SUB YESNO (OK$)
DO
  OK$ = INKEY$: OK$ = UCASE$(OK$)
LOOP UNTIL OK$ = "Y" OR OK$ = "N"
END SUB

