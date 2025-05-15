DECLARE FUNCTION ErrorLevel% ()
'Returns errorlevel from the last shelled program

   

FUNCTION ErrorLevel%
   DEF SEG = 0
   ErrorLevel% = PEEK(&H4FE)
   DEF SEG
END FUNCTION

