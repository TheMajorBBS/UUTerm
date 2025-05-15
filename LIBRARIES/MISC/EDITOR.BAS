'Edit a text string using PgeUP/PgeDWN/End/Home/BackSpace/DEL
' To use this program start QB with the following command at the DOS prompt:
' QB /LQB

DECLARE SUB edittext (rw%, clm%, text$, length%)
'$INCLUDE: 'qb.bi'
DEFINT A-Z
CLS
SCREEN 0

text$ = "Please edit this with Left/Right/Home/End/Delete/BackSpace"
rw = 5: clm = 10
length = 30

'Where TEXT$ is the string you want to edit.
'Where RW and CLM is the row and column where you want the text displayed
'Where LENGTH is the width of your editing field
edittext rw, clm, text$, length
END

SUB edittext (rw, clm, text$, length)
min = clm: max = min + length
LOCATE rw, clm, 1: PRINT text$;
LOCATE rw, clm
IF max < LEN(text$) THEN max = LEN(text$) + min
DO
  choice$ = INKEY$
 
  SELECT CASE choice$
  CASE CHR$(8)                           'backspace
    IF clm = min THEN
      BEEP
    ELSE
text$ = LEFT$(text$, clm - 1 - min) + RIGHT$(text$, (LEN(text$) - clm) + min)
      LOCATE rw, min: PRINT text$ + " "
      clm = clm - 1
      LOCATE rw, clm
    END IF
  CASE CHR$(0) + "M"                        'left
    clm = clm + 1
    IF clm > max THEN clm = max: BEEP
    LOCATE rw, clm
  CASE CHR$(0) + "K"                        'right
    clm = clm - 1
    IF clm < min THEN clm = min: BEEP
    LOCATE rw, clm
  CASE CHR$(0) + "G"                        'home
    clm = min
    LOCATE rw, clm
  CASE CHR$(0) + "O"                        'end
    clm = LEN(text$) + min
    LOCATE rw, clm
  CASE ELSE
    IF choice$ > CHR$(31) AND choice$ < CHR$(123) THEN
      IF LEN(text$) + min > max THEN
	BEEP
      ELSE
      z = (LEN(text$) + min) - clm
      IF z < 1 THEN temp$ = "" ELSE temp$ = RIGHT$(text$, z)
      text$ = LEFT$(text$, clm - min) + choice$ + temp$
      LOCATE rw, min: PRINT text$
      clm = clm + 1
      LOCATE rw, clm
      IF clm > max THEN clm = max: BEEP
      END IF
    END IF
    IF choice$ = CHR$(0) + "S" AND ((LEN(text$) + min) - clm) > 0 THEN
      text$ = LEFT$(text$, clm - min) + RIGHT$(text$, (LEN(text$) + min) - (clm + 1))
      LOCATE rw, min: PRINT text$ + " ";
      LOCATE rw, clm
    END IF
  END SELECT
LOOP UNTIL choice$ = CHR$(13)
END SUB

