'move lines, columns with ANSI.SYS
DECLARE SUB MoveCursor (X, Y)
   
OPEN "CONS:" FOR OUTPUT AS #1
X = 5                       ' screen line to display on
Y = 15                      ' screen column to display on
CALL MoveCursor(X, Y)       ' position cursor where we want to display
PRINT #1, "Hello World!"

SUB MoveCursor (X, Y)
PRINT #1, CHR$(27) + "[" + LTRIM$(STR$(X)) + ";" + LTRIM$(STR$(Y)) + "H";
END SUB

