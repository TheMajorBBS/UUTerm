'Adds BASIC 7 PDS's DIR$ function to QB.
'This function allows you to read a directory of filenames. It also
'allows you to check the existence of a file
DEFINT A-Z
DECLARE FUNCTION DIR$ (FileSpec$)
'$INCLUDE: 'QB.BI'
'-----  Some constants that DIR$ uses
CONST DOS = &H21
CONST SetDTA = &H1A00, FindFirst = &H4E00, FindNext = &H4F00
'This shows how to call DIR$ to find all matching files
CLS
FileSpec$ = "*.*"
Found$ = DIR$(FileSpec$)
DO WHILE LEN(Found$)
  PRINT Found$
  Found$ = DIR$("")
LOOP
     
'    'This shows how to see if a file exists
'    IF LEN(DIR$("COMMAND.COM")) THEN
'      PRINT "File Found"
'    ELSE
'      PRINT "File not found"
'    END IF
'

FUNCTION DIR$ (FileSpec$) STATIC
DIM DTA AS STRING * 44, Regs AS RegTypeX
Null$ = CHR$(0)
'-----  Set up our own DTA so we don't destroy COMMAND$
Regs.ax = SetDTA                    'Set DTA function
Regs.dx = VARPTR(DTA)               'DS:DX points to our DTA
Regs.ds = -1                        'Use current value for DS
INTERRUPTX DOS, Regs, Regs          'Do the interrupt
'-----  Check to see if this is First or Next
IF LEN(FileSpec$) THEN              'FileSpec$ isn't null, so
				    'FindFirst
  FileSpecZ$ = FileSpec$ + Null$   'Make FileSpec$ into an ASCIIZ
				   'string
  Regs.ax = FindFirst              'Perform a FindFirst
  Regs.cx = 0                      'Only look for normal files
  Regs.dx = SADD(FileSpecZ$)       'DS:DX points to ASCIIZ file
  Regs.ds = -1                     'Use current DS
ELSE                                'We have a null FileSpec$,
  Regs.ax = FindNext               'so FindNext
END IF
INTERRUPTX DOS, Regs, Regs          'Do the interrupt
'-----  Return file name or null
IF Regs.flags AND 1 THEN            'No files found
  DIR$ = ""                        'Return null string
ELSE
  Null = INSTR(31, DTA, Null$)     'Get the filename found
  DIR$ = MID$(DTA, 31, Null - 30)  'It's an ASCIIZ string starting
END IF                              'at offset 30 of the DTA
END FUNCTION

