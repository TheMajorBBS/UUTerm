DECLARE SUB ParCline (Arg$(), maxarg%, Res%)

'Parses the command line into an array
'input:  Arg$() = array to hold arguments
'        maxarg% = maximum number of arguments
'return: Res% = Switch for error checking

DEFINT A-Z

maxarg% = 2             'Maximum number of arguments
DIM Arg$(maxarg%)       'Array to hold the arguments

CLS
CALL ParCline(Arg$(), maxarg%, Res%)
FOR x = 1 TO maxarg%: PRINT Arg$(x): NEXT x
IF Res% = -1 THEN PRINT "Too Many Arguments"
IF Res% = 0 THEN PRINT "Sucessful Processing"
IF Res% = 1 THEN PRINT "No Arguments Found"
END

SUB ParCline (Arg$(), maxarg%, Res%)
NumArg = 1
ArgPos = 1              'The first position in the array

Cline$ = LTRIM$(RTRIM$(COMMAND$))  'Get the command line and trim all the spaces
Clen = LEN(Cline$)      'Get the length of the command line

IF Clen = 0 THEN Res% = 1: EXIT SUB

FOR Scount = 1 TO Clen  'Get the number of arguments
   IF MID$(Cline$, Scount, 1) = " " THEN NumArg = NumArg + 1
NEXT Scount

IF NumArg > maxarg% THEN Res% = -1: EXIT SUB

FOR wcount = 1 TO Clen
   IF MID$(Cline$, wcount, 1) <> " " THEN
      Arg$(ArgPos) = Arg$(ArgPos) + MID$(Cline$, wcount, 1)
                        'If a character is found, then add it to the
                        'current string
   ELSEIF MID$(Cline$, wcount, 1) = " " THEN
      ArgPos = ArgPos + 1
                        'If a space is found, start processing the
                        'next string
   END IF
NEXT wcount

END SUB

