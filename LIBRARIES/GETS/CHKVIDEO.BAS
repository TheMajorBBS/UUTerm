DECLARE FUNCTION VidType% ()
' determines video adapter installed
DEFINT A-Z
'$INCLUDE: 'qb.bi'

PRINT : PRINT "This computer is equipped with ";
SELECT CASE VidType
  CASE 1
    PRINT "a Monochrome Text ";
  CASE 2
    PRINT "a Hercules ";
  CASE 3
    PRINT "a CGA ";
  CASE 4
    PRINT "an EGA ";
  CASE 5
    PRINT "a VGA ";
END SELECT
PRINT "adapter."

FUNCTION VidType%
  ' VGA: 5
  ' EGA: 4
  ' CGA: 3
  ' HGC: 2 (Hercules)
  ' MDA: 1
  '
  ' Uses CALL Interrupt - set up Registers TYPEd variable
  DIM Regs AS RegType

  ' force variables local
  STATIC EgaInfo, InitialMode, i, Ticks

  ' If all else fails, it's the old MDA
  VidType% = 1 ' MDA

  ' Check for VGA - INT 10h svc 1B will return 1B in AL if VGA
  Regs.AX = &H1B00
  CALL Interrupt(&H10, Regs, Regs)
  IF ((Regs.AX AND &HFF) = &H1B) THEN
    VidType% = 5 ' VGA
  ELSE
    ' Check for EGA - EGA Info byte at 0000:0487 will have bits set
    DEF SEG = 0
    EgaInfo = PEEK(&H487)
    DEF SEG
    IF EgaInfo <> 0 THEN
      VidType% = 4 ' EGA
    ELSE
      ' Check for CGA - if initial display mode was not 80x25 MONO
      CALL Interrupt(&H11, Regs, Regs) ' get equipment list
      InitialMode = (Regs.AX MOD 256) AND &H30 ' mask vid bits
      IF InitialMode <> &H30 THEN
        VidType% = 3 ' CGA
      ELSE
' Check for HGC - bit 7 of port 3BAh is 1 during vert retrace
' we loop through two timer-tick changes (> 1/18th sec)
' to give it enough time to set.
        DEF SEG = 0
        FOR i = 1 TO 2
          Ticks = PEEK(&H46D) AND 1
          DO WHILE Ticks = (PEEK(&H46D) AND 1)
          IF INP(&H3BA) AND &H80 THEN
          VidType% = 2 ' HGC
        EXIT FOR
    END IF ' hgc
  LOOP
NEXT
DEF SEG
      END IF  ' cga
    END IF  ' ega
  END IF  ' vga
END FUNCTION

