DECLARE SUB PrintSC (hor%, ver%, colt%, colb%, text$)

'Prints menu bar with highlited options

' TEXT$ = Menu Titles
' HOR% and VER% = point where you want the bar to start
' COLT%= color of text
' COLB%= color of menu bar (or background)

text$ = " &FILES   &OPTIONS   &DOS "
hor% = 1: ver% = 1: colt% = 6: colb% = 11
length = 80 - LEN(text$)
text$ = text$ + STRING$(length + 3, " ")  'Add to length the number of "&"
                                          'in text$

SCREEN 0
CLS
PrintSC hor%, ver%, colt%, colb%, text$
SLEEP
END

SUB PrintSC (hor%, ver%, colt%, colb%, text$)
 '** the letter following a '&" will be highlighted as a shortcut

 IF hor% + ver% THEN LOCATE ver%, hor%
 SC% = INSTR(text$, "&")
 COLOR colt%, colb%

 IF SC% THEN
  PRINT LEFT$(text$, SC% - 1);
  IF colt% THEN COLOR colt% + 8, colb% ELSE COLOR colb% + 8, colb%
  PRINT MID$(text$, SC% + 1, 1);
  PrintSC 0, 0, colt%, colb%, MID$(text$, SC% + 2)
 ELSE
  PRINT text$;
 END IF

END SUB

