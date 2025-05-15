DECLARE SUB ansi.det (find%)
DEFINT A-Z

' See if Ansi available
'FIND returns 32 if ansi installed

ansi.det find
CLS : COLOR 7
IF find = 32 THEN PRINT "ANSI installed" ELSE PRINT "ANSI not installed"
END

