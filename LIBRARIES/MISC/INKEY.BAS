'converts BASIC's INKEY$ to INKEY%
DEFINT A-Z
DECLARE FUNCTION InKey% (NoWait%)

'* PURPOSE
'*    Works similarly to BASIC's INKEY$ function, except the value
'*    returned is an integer rather than a string, if the key pressed
'*    is an extended key the value will be returned negated, and this
'*    routine optionally waits until a key is pressed before it returns
'*    control to the calling routine (set NoWait% to zero).
'*
DO
  keycode% = InKey%(0)                   'Get a key, wait for it
  PRINT "You pressed ";
  SELECT CASE keycode%
    CASE 48 TO 57, 65 TO 90, 97 TO 122
       PRINT "Alphanumeric (0 - 9, A - Z, a - z)"
    CASE -68 TO -59, -133, -134
       PRINT "F1 - F12"
    CASE -113 TO -104, -139, -140
       PRINT "ALT-F1 - ALT-F12"
    CASE -103 TO -94, -137, -138
       PRINT "CTRL-F1 - CTRL-F12"
    CASE -93 TO -84, -135, -136
       PRINT "SHIFT-F1 - SHIFT-F12"
    CASE 27
       PRINT "<ESC> Key"
  END SELECT
LOOP UNTIL keycode = 27
END

FUNCTION InKey% (NoWait%) STATIC
   DO
      K$ = INKEY$                            'Check for a key
   LOOP UNTIL NoWait% OR LEN(K$)             'Wait for a key, unless
                                             '  NoWait% is TRUE
   SELECT CASE LEN(K$)                       'Was a key pressed?
      CASE 1: InKey% = ASC(K$)               'Return ASCII value
      CASE 2: InKey% = -ASC(RIGHT$(K$, 1))   'Extended key, return ASCII
   END SELECT                                '  value negated
END FUNCTION

