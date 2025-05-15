'To copy a file without using SHELL "COPY..."
' Call Syntax: CopyFile% (Source$, Dest$)
'     Returns: 0 - Everything went all right
'              1 - Source file does not exist
'              2 - Destination file does exist
'              3 - Failure in setting copy's time/date to that of source
'   Libraries: QB.QLB (QB.LIB) for CALL INTERRUPT
'External Routines Required: DIR$ function with QuickBASIC v4.x
     DEFINT A-Z
     DECLARE FUNCTION DIR$ (FileSpec$)    'Comment out if using BASIC 7
     DECLARE FUNCTION CopyFile% (Source$, Dest$)
     '$INCLUDE: 'QB.BI'                   'Required for CALL INTERRUPT
     
     CONST Block = 4096                   'Set this to the length you
					  'want your buffer to be
     
     'Example of how to call CopyFile
     'Ercd = CopyFile("D:\PDQ\HISTORY.DOC", "C:\SCRAP\TEST1")

FUNCTION CopyFile% (Source$, Dest$) STATIC
DIM Regs AS RegType                    'Needed for CALL INTERRUPT
'-----  See if source file exists
IF LEN(DIR$(Source$)) = 0 THEN         'Use my DIR$ function
				       'if you are
				       'using QB 4.x.
   CopyFile% = 1                       'Source doesn't exist
   EXIT FUNCTION                       'Exit with error code
END IF
'-----  See if destination exists
IF LEN(DIR$(Dest$)) THEN
  CopyFile% = 2                       'Destination already exists
  EXIT FUNCTION                       'Exit with error code
END IF
'-----  Open files for BINARY
SFileNum = FREEFILE
OPEN Source$ FOR BINARY AS #SFileNum
DFileNum = FREEFILE
OPEN Dest$ FOR BINARY AS #DFileNum
'-----  Now copy the files over
DO
  Buffer$ = INPUT$(Block, #SFileNum)
  PUT #DFileNum, , Buffer$
LOOP UNTIL EOF(SFileNum)
'-----  Set the date and time of the copy to that of the original
Regs.ax = &H5700
Regs.bx = FILEATTR(SFileNum, 2)        'This gets DOS's file handle
INTERRUPT &H21, Regs, Regs             'Get date and time of original
'-----  Check for an error
IF (Regs.flags AND 1) THEN
  CLOSE #SFileNum, #DFileNum          'Close the files
  KILL Dest$                         'Kill our copy because something
  CopyFile% = 3                       'went wrong. Exit with error
  EXIT FUNCTION
END IF
Regs.ax = &H5701
Regs.bx = FILEATTR(DFileNum, 2)
INTERRUPT &H21, Regs, Regs             'Set date and time of copy
'-----  Check for an error
IF (Regs.flags AND 1) THEN
  CLOSE #SFileNum, #DFileNum          'Close the files
  KILL Dest$                         'Kill our copy because something
  CopyFile% = 3                       'went wrong. Exit with error
  EXIT FUNCTION
END IF
CLOSE #SFileNum, #DFileNum             'All done
CopyFile% = 0                          'Return with success
END FUNCTION

