'Scroll a window without using INTERRUPTs
DECLARE SUB Assign.Cursor.Keys ()    'I made this SUB so that I wouldn't
CALL Assign.Cursor.Keys              'have to remember the ASCII codes for
                                     'the cursor, and function keys
Start:
Lines = 0
CLS
filename$ = "MAT.BAS"
OPEN filename$ FOR INPUT AS #1  'Replace FileName$ with whatever file you
                                'wish to browse.
    DO UNTIL EOF(1)
LINE INPUT #1, a$               'Get the number of lines in the file, in
Lines = Lines + 1               'order to set the array, and ensure that
    LOOP                        'you don't scroll past the end of the file
CLOSE #1

DIM SHARED Line$(1 TO Lines)
OPEN filename$ FOR INPUT AS #1  'Assign the lines of data in the file to
                                'the variable Line$(Z), so that Line #1
        FOR Z = 1 TO Lines      'will be Line$(1), Line #2=Line$(2) etc.
LINE INPUT #1, Line$(Z)

 IF LEN(Line$(Z)) > 80 THEN     'If the line is over 80 charcters long this
Line$(Z) = LEFT$(Line$(Z), 80)  'cuts it to 80 chracters, otherwise it adds
  ELSE                          'spaces to the end to make it 80 charcters
Line$(Z) = Line$(Z) + SPACE$(80 - LEN(Line$(Z)))
 END IF
        NEXT
CLOSE #1

Main:
        Z = 0
        LineNum = 0
DO                             'Print one screen of data from FileName$
  FOR X = 1 TO 23
 Z = LineNum + (X)             'I used this method to change the value
 LOCATE X: PRINT Line$(Z)      'of Z throughout the printing
  NEXT
RecKey:
  GOSUB GetKey                  'Uses subroutine to wait for key press
  GOSUB Use.Key                 'Uses Subroutine to act upon Keypress
LOOP

OVER:
END

GetKey:                           'Subroutine to wait for keypress. Assigns
   DO                             'the pressed key to the variable Key$
 Key$ = UCASE$(INKEY$)
 IF Key$ <> "" THEN RETURN
   LOOP

Use.Key:                            'Subroutine to utilize the keypress
SELECT CASE Key$
  CASE CHR$(27)                      'Ends if Esc is hit
          STOP
  CASE Dn$                           'Scrolls down if Dn arrow is hit
          Z = Z + 1                     'and will beep if down arrow is hit
          LineNum = LineNum + 1         'at the end of the file
       IF Z > (Lines) THEN              'To avoid jumpiness I had it print
          Z = Lines                     'to row 24, which will smoothly
          PLAY "E30"                    'scroll text up the screen.
        GOTO RecKey
       END IF
          LOCATE 24, 1
          PRINT Line$(Z)
        GOTO RecKey
  CASE Up$                           'Scrolls up if Up arrow is hit
          LineNum = LineNum - 1
  CASE End$                          'Goes to the end of the file if
          LineNum = Lines               ' End is hit
  CASE Home$                         'Goes to the top of the file if
          LineNum = 0                   ' Home is hit
  CASE PgDn$                         'Scrolls down 1 screen if PgDn
          LineNum = LineNum + 20
  CASE PgUp$                         'Scrolls up 1 screen if PgUp
          LineNum = LineNum - 20
  CASE F7$                           'Returns to beginning of program
        GOTO Start                   'if [F7] is hit (which can be useful
                                     'if you have the option of changing
END SELECT                           'of changing FileName$

  IF LineNum < 1 THEN                'This stops the program from trying
        LineNum = 1                  'to access lines before the start
        PLAY "A30"                   'of the file
    ELSEIF LineNum > (Lines - 20) THEN
        LineNum = (Lines - 20)       'This does the same about the end of
        PLAY "E30"                   'the file
  END IF

RETURN

SUB Assign.Cursor.Keys
SHARED F1$, F2$, F3$, F4$, F5$, F6$, F7$, F8$, F9$, F10$, F11$, F12$
SHARED Home$, End$, PgUp$, PgDn$, Up$, Dn$, Lft$, Rt$, Esc$, Ins$, Del$

 Up$ = CHR$(0) + CHR$(72)              'This assigns the ASCII codes for
 Dn$ = CHR$(0) + CHR$(80)              'the cursor and function keys to
Lft$ = CHR$(0) + CHR$(75)              'easy to remember variable names
 Rt$ = CHR$(0) + CHR$(77)

Home$ = CHR$(0) + CHR$(71)
 End$ = CHR$(0) + CHR$(79)
PgUp$ = CHR$(0) + CHR$(73)
PgDn$ = CHR$(0) + CHR$(81)

 F1$ = CHR$(0) + CHR$(59)
 F2$ = CHR$(0) + CHR$(60)
 F3$ = CHR$(0) + CHR$(61)
 F4$ = CHR$(0) + CHR$(62)
 F5$ = CHR$(0) + CHR$(63)
 F6$ = CHR$(0) + CHR$(64)
 F7$ = CHR$(0) + CHR$(65)
 F8$ = CHR$(0) + CHR$(66)
 F9$ = CHR$(0) + CHR$(67)
F10$ = CHR$(0) + CHR$(68)
F11$ = CHR$(0) + CHR$(133)
F12$ = CHR$(0) + CHR$(134)

Ins$ = CHR$(0) + CHR$(82)
Del$ = CHR$(0) + CHR$(83)
Esc$ = CHR$(0) + CHR$(27)

END SUB

