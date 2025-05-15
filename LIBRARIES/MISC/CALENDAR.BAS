DECLARE SUB DrawFrame (x%, y%, w%, h%, Typ%, Fill$)
DECLARE SUB DrawBox (y%, x%, w%, h%, Box$)
 'Draws 6 month calendar

DEFINT A-Z
 DIM SHARED colb%, colt%
 MaxLines = 25: colb% = 3: colt% = 6
 Month = VAL(LEFT$(DATE$, 2)) - 1
 Day = VAL(MID$(DATE$, 4, 2))
 Year = VAL(RIGHT$(DATE$, 4))
 IF Month = 0 THEN Month = 12: Year = Year - 1
 Months$ = "January  February March    April    May      June     "
 Months$ = Months$ + "July     August   SeptemberOctober  November December "
 y = 2: x = -19

 CLS
 FOR Page = 0 TO 5 - 6 * (MaxLines > 25)
  MoName$ = MID$(Months$, Month * 9 - 8, 9)
  x = x + 24
  IF x > 60 THEN y = y + 12: x = 5

  DrawFrame x, y, 22, 10, 1, " "
  COLOR colt, colb
  LOCATE y + 2, x: PRINT "Ì" + STRING$(22, "Í") + "¹"
  LOCATE y + 4, x: PRINT "Ç" + STRING$(22, "Ä") + "¶"
  LOCATE y + 3, x + 2
  PRINT "Mo Tu We Th Fr ";
  COLOR colt + 8: PRINT "Sa Su"

  LOCATE y + 1, x + 5, 0
  PRINT MoName$ + " " + STR$(Year)

  GOSUB FindDay
  WeekDay = FirstDay& - (FirstDay& \ 7) * 7
  LOCATE y + 5, x + 1 - 3 * WeekDay * (WeekDay <> 7)

  Month = Month MOD 12 + 1
  Year = Year - (Month = 1)

  StartDay& = FirstDay&
  GOSUB FindDay

  COLOR colt, colb
  FOR i = 1 TO FirstDay& - StartDay&
     IF (WeekDay MOD 7) > 4 THEN COLOR colt + 8 ELSE COLOR colt
     IF i = Day AND Page = 1 THEN COLOR colt + 24
     PRINT USING " ##"; i;
     WeekDay = WeekDay + 1
     IF WeekDay MOD 7 = 0 THEN
       PRINT
       LOCATE , x + 1
     END IF
  NEXT i
 NEXT Page
SLEEP
END

FindDay:                      'calculate first day of the month
 IF Month > 2 THEN
  Month1 = Month + 1
  Year1 = Year - 1900
 ELSE
  Month1 = Month + 13
  Year1 = Year - 1901
 END IF
 FirstDay& = INT(365.25 * Year1) + INT(30.6 * Month1)
RETURN

SUB DrawBox (y%, x%, w%, h%, Box$) STATIC
 
   COLOR colt%, colb%
   LOCATE y%, x%
   PRINT LEFT$(Box$, 1); STRING$(w%, MID$(Box$, 2, 1)); MID$(Box$, 3, 1);
   FOR row = y% + 1 TO h% + y%
      LOCATE row, x%
      PRINT MID$(Box$, 4, 1); STRING$(w%, MID$(Box$, 5, 1)); MID$(Box$, 4, 1);
   NEXT row
   LOCATE row, x%
   PRINT MID$(Box$, 7, 1); STRING$(w%, MID$(Box$, 8, 1)); MID$(Box$, 9, 1);
END SUB

DEFSNG A-Z
SUB DrawFrame (x%, y%, w%, h%, Typ%, Fill$)
 '*** draws box in Position X%/Y%, Width w%, Height H%, Color Col%
 '*** Typ (Frame type): 0-7, fill pattern Fill$


 SELECT CASE Typ%
  CASE 0: Box$ = "ÚÄ¿³ ³ÀÄÙ"
  CASE 1: Box$ = "ÉÍ»º ºÈÍ¼"
  CASE 2: Box$ = "±±±± ±±±±"
  CASE 3: Box$ = "**** ****"
  CASE 4: Box$ = ":::: ::::"
  CASE 5: Box$ = "!!!! !!!!"
  CASE 6: Box$ = "???? ????"
  CASE ELSE: Box$ = "         "
 END SELECT
 IF Fill$ = "" THEN Fill$ = CHR$(0)
 MID$(Box$, 5, 1) = Fill$

 DrawBox y%, x%, w%, h%, Box$

END SUB

