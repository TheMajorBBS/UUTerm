          'Fix for Scrolling bug when ANSI.SYS is installed
               '8/30/93        By J. S. Paravati

DECLARE SUB FindSeg (Segment1&, Segment2&, SegFlag&)
DEFLNG A-Z
CLS
SegFlag = 0
CALL FindSeg(Segment1, Segment2, SegFlag)

OPEN "cons:" FOR OUTPUT AS #2
SCREEN 12         'try mode 12 also  (rows 30 & 60)
RW = 60        'Rows variable
WIDTH 80, RW
IF SegFlag = 1 THEN       'Perform actual "fix"
  DEF SEG = Segment1
  POKE &H2F3, RW      'VGA
  POKE &H307, RW      'EGA
END IF

'LINE (0, 205)-(640, 349), 3, BF
FOR x = 1 TO 100
  PRINT #2, x
NEXT
DEF SEG
END

'-----------------------------------------------------------------------
SUB FindSeg (Segment1, Segment2, SegFlag)

CLS : Segment1 = 0: Segment2 = 0: SegFlag = 0

                        'Check for "ANSI & CON"

FOR S = 0 TO 4096 STEP 4096
   DEF SEG = S
   FOR N = 0 TO 65519 STEP 8

       'ATTACH NEXT 3 LINES !!!
     IF PEEK(N) = 65 AND PEEK(N + 1) = 78 AND PEEK(N + 2) = 83 AND PEEK(N + 3) = 73 AND PEEK(N + 18) = 67 AND PEEK(N + 19) = 79 AND PEEK(N + 20) = 78 THEN

      LB = PEEK(N - 6): MB = PEEK(N - 7)
      Segment1 = LB * 256 + MB
      PRINT "Check 1: Segment ="; Segment1, HEX$(Segment1); " Hex"
      EXIT FOR
    END IF
   NEXT N
     IF Segment1 <> 0 THEN EXIT FOR
NEXT S

 IF Segment1 = 0 THEN
   PRINT "Ansi.Sys not installed or cannot be detected."
   PRINT "       Scrolling will be normal."
      SLEEP 2
      EXIT SUB
    END IF

                          'Check for "CON" in Segment 0
DEF SEG = 0
   CT = 0
   FOR N = 0 TO 65533
    IF PEEK(N) = 67 AND PEEK(N + 1) = 79 AND PEEK(N + 2) = 78 THEN
     CT = CT + 1
    END IF

    IF CT = 2 THEN        'look for 2nd 'CON' in Seg. 0
      LB = PEEK(N - 22): MB = PEEK(N - 23)
      Segment2 = LB * 256 + MB
      PRINT "Check 2: Segment ="; Segment2, HEX$(Segment2); " Hex":
PRINT
      EXIT FOR
    END IF
  NEXT N

 IF Segment1 = Segment2 THEN
  SegFlag = 1
   PRINT "Ansi.Sys detected, scrolling 'fix' will be implemented."
   SLEEP 2
 END IF
DEF SEG

END SUB

