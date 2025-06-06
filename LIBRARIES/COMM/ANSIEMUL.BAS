'ANSI Emulator

ANSIprint:
   FOR disp0% = 1 TO LEN(St$)
      ch0$ = MID$(St$, disp0%, 1)
      GOSUB AP0
   NEXT
   RETURN

AP0:
   IF ANSIcode0% THEN
     
      IF LEFT$(ANSIst0$, 2) = "[M" OR LEFT$(ANSIst0$, 2) = "[m" THEN
         IF ASC(ch0$) = 14 THEN
            ANSIst0$ = ""
            ANSIcode0% = 0
         ELSE
            ANSIst0$ = ANSIst0$ + ch0$
         END IF
      ELSEIF INSTR("ABCDEFGHIJKLMNOPQRSTUVWXYZ", UCASE$(ch0$)) THEN
         SELECT CASE ch0$
            CASE "A": GOSUB CursorUp0
            CASE "B": GOSUB CursorDown0
            CASE "C": GOSUB CursorRight0
            CASE "D": GOSUB CursorLeft0
            CASE "H", "f": GOSUB CursorLocate0
            CASE "s": GOSUB SaveCursorPosn0
            CASE "u": GOSUB RestCursorPosn0
            CASE "J": GOSUB BigErase0
            CASE "K": GOSUB SmallErase0
            CASE "h", "l": REM  set display mode... ignored
            CASE "m": GOSUB SetColors0
            CASE ELSE
               PRINT ANSIst0$;
               ANSIcode0% = 0
               ANSIst0$ = ""
         END SELECT
         ANSIst0$ = ""
         ANSIcode0% = 0
      ELSEIF ASC(ch0$) <= 32 OR LEN(ANSIst0$) > 60 THEN   'special chr
         PRINT ANSIst0$;
         ANSIcode0% = 0
         ANSIst0$ = ""
      ELSE
         ANSIst0$ = ANSIst0$ + ch0$
      END IF
   ELSEIF ASC(ch0$) = 27 THEN       'turn on ansi characters
      ANSIcode0% = -1
      ANSIst0$ = ""
   ELSE
      PRINT ch0$;
   END IF
   RETURN

CursorUp0:
   Tmp0% = VAL(MID$(ANSIst0$, 2))
   IF Tmp0% < 1 THEN Tmp0% = 1
   Row0% = CSRLIN: Col0% = POS(0)
   Row0% = Row0% - Tmp0%
   IF Row0% < 1 THEN Row0% = 1
   LOCATE Row0%, Col0%
   RETURN

CursorDown0:
   Tmp0% = VAL(MID$(ANSIst0$, 2))
   IF Tmp0% < 1 THEN Tmp0% = 1
   Row0% = CSRLIN: Col0% = POS(0)
   Row0% = Row0% + Tmp0%
   IF Row0% > 25 THEN Row0% = 25
   LOCATE Row0%, Col0%
   RETURN

CursorLeft0:
   Tmp0% = VAL(MID$(ANSIst0$, 2))
   IF Tmp0% < 1 THEN Tmp0% = 1
   Row0% = CSRLIN: Col0% = POS(0)
   Col0% = Col0% - Tmp0%
   IF Col0% < 1 THEN Col0% = 1
   LOCATE Row0%, Col0%
   RETURN

CursorRight0:
   Tmp0% = VAL(MID$(ANSIst0$, 2))
   IF Tmp0% < 1 THEN Tmp0% = 1
   Row0% = CSRLIN: Col0% = POS(0)
   Col0% = Col0% + Tmp0%
   IF Col0% > 80 THEN Col0% = 80
   LOCATE Row0%, Col0%
   RETURN

CursorLocate0:
   Row0% = VAL(MID$(ANSIst0$, 2))
   Tmp0% = INSTR(ANSIst0$, ";")
   IF Tmp0% THEN
      Col0% = VAL(MID$(ANSIst0$, Tmp0% + 1))
   ELSE
      Col0% = 1
   END IF
   IF Row0% < 1 THEN
      Row0% = 1
   ELSEIF Row0% > 25 THEN
      Row0% = 25
   END IF
   IF Col0% < 1 THEN
      Col0% = 1
   ELSEIF Col0% > 80 THEN
      Col0% = 80
   END IF
   LOCATE Row0%, Col0%
   RETURN

SaveCursorPosn0:
   SaveRow0% = CSRLIN: SaveCol0% = POS(0)
   RETURN

RestCursorPosn0:
   IF SaveRow0% > 0 THEN
      LOCATE SaveRow0%, SaveCol0%
   END IF
   RETURN

BigErase0:
   CLS
   LOCATE 1, 1
   RETURN

SmallErase0:
   Row0% = CSRLIN: Col0% = POS(0)
   PRINT SPACE$(80 - Col0%)
   LOCATE Row0%, Col0%
   RETURN

SetColors0:
   ANSIst0$ = MID$(ANSIst0$, 2)
   'WGetColor Win%, Fore0%, Back0%
   DO WHILE LEN(ANSIst0$)
      Tmp0% = VAL(ANSIst0$)
      SELECT CASE Tmp0%
         CASE 0: Fore0% = 7: Back0% = 0             ' reset colors
         CASE 1: Fore0% = (Fore0% OR 8)             ' high intensity
         CASE 2: Fore0% = (Fore0% AND &H17)         ' normal intensity
         CASE 5: Fore0% = (Fore0% OR 16)            ' blink
         CASE 7: Fore0% = 0: Back0% = 7             ' reverse video
         CASE 8: Fore0% = 0: Back0% = 0             ' invisible
         CASE 30: Fore0% = (Fore0% AND &H18)        ' black foreground
         CASE 31: Fore0% = (Fore0% AND &H18) OR 4   ' red foreground
         CASE 32: Fore0% = (Fore0% AND &H18) OR 2   ' green foreground
         CASE 33: Fore0% = (Fore0% AND &H18) OR 6   ' yellow foreground
         CASE 34: Fore0% = (Fore0% AND &H18) OR 1   ' blue foreground
         CASE 35: Fore0% = (Fore0% AND &H18) OR 5   ' magenta foreground
         CASE 36: Fore0% = (Fore0% AND &H18) OR 3   ' cyan foreground
         CASE 37: Fore0% = (Fore0% OR 7)            ' white foreground
         CASE 40: Back0% = 0                        ' black background
         CASE 41: Back0% = 4                        ' red background
         CASE 42: Back0% = 2                        ' green background
         CASE 44: Back0% = 6                        ' yellow background
         CASE 44: Back0% = 1                        ' blue background
         CASE 45: Back0% = 5                        ' magenta background
         CASE 46: Back0% = 3                        ' cyan background
         CASE 47: Back0% = 7                        ' white background
         CASE ELSE                                  ' ignore anything weird
      END SELECT
      Tmp0% = INSTR(ANSIst0$, ";")
      IF Tmp0% THEN
         ANSIst0$ = MID$(ANSIst0$, Tmp0% + 1)
      ELSE
         ANSIst0$ = ""
      END IF
   LOOP
   COLOR Fore0%, Back0%
   RETURN

