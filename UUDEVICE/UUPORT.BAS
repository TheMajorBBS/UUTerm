DECLARE SUB trade1 (logg%, port$)
DECLARE SUB wind (hor%, ver%, wid%, ht%)
DECLARE SUB disp (title$, row%)
DECLARE FUNCTION exists% (filename$)
DEFINT A-Z
DECLARE FUNCTION BufIn$ (filename$, done)
TYPE RegTypeX
  ax    AS INTEGER
  bx    AS INTEGER
  cx    AS INTEGER
  dx    AS INTEGER
  bp    AS INTEGER
  si    AS INTEGER
  di    AS INTEGER
  flags AS INTEGER
  DS    AS INTEGER
  es    AS INTEGER
END TYPE
DIM SHARED InRegs AS RegTypeX, OutRegs AS RegTypeX
DECLARE SUB INTERRUPTX (intnum AS INTEGER, InReg AS RegTypeX, OutReg AS RegTypeX)
'$DYNAMIC
DIM SHARED water(1), power(1), PORTS(1)
DIM SHARED file$, outfil$

SCREEN 0
COLOR 1, 3
CLS
PRINT " Ultimate Universe Utility         UUPORT        Copyright 1993 by Will Boyett "
wind 1, 2, 79, 22
file$ = COMMAND$

IF exists(file$) THEN
  x = INSTR(file$, "\")                 'gets filename to save
  outfil$ = MID$(file$, x + 1)
  DO UNTIL x = 0
    x = INSTR(outfil$, "\")
    outfil$ = MID$(outfil$, x + 1)
  LOOP
  x = INSTR(outfil$, ".")
  IF x <> 0 THEN outfil$ = (LEFT$(outfil$, x - 1)) + ".POR"
 
DO
  COLOR 15, 3: LOCATE 4, 29: PRINT "Welcome Space Warrior!"
  COLOR 14, 3: LOCATE 7, 18: PRINT "  What type of port are you interested in?    "
  wind 31, 11, 18, 2
  wind 31, 15, 18, 2
  wind 31, 19, 18, 2
  COLOR 4, 3: LOCATE 20, 34: PRINT "3."
  LOCATE 16, 34: PRINT "2.": LOCATE 12, 34: PRINT "1."
  COLOR 0, 3: LOCATE 12, 38: PRINT "Trading "
  LOCATE 16, 38: PRINT " Buys   "
  LOCATE 20, 38: PRINT " Sells  "
  DO: port$ = INKEY$: LOOP UNTIL port$ = "1" OR port$ = "2" OR port$ = "3"
 
  COLOR 14, 3: LOCATE 7, 18: PRINT "  Now Processing please wait. Info will be  "
  title$ = "saved as " + outfil$ + " in the current directory"
  disp title$, 8
  BEEP: SLEEP 3

'outfil$ has save name - file$ has logg name  - port$ has class
  DO                                          'determines logg type
    line$ = BufIn$(file$, done)
    IF done THEN EXIT DO
  LOOP UNTIL LEFT$(line$, 6) = "Sector"
  a = INSTR(line$, "Selling")
  IF a <> 0 THEN logg = 1 ELSE logg = 2
 
  trade1 logg, port$
 
  OPEN "a", 1, outfil$
  PRINT #1, ""
  PRINT #1, "Date: "; DATE$
  IF port$ = "1" THEN PRINT #1, "   WATER       POWER"
  IF port$ = "2" THEN PRINT #1, "   BUYS ALL"
  IF port$ = "3" THEN PRINT #1, "   SELLS ALL"
  PRINT #1, " --------------------"
   
  IF port$ = "1" THEN
    FOR x = 1 TO 50
      PRINT #1, "  "; water(x), power(x)
      IF water(x) = 0 AND power(x) = 0 THEN x = 50
    NEXT
  ELSE
    FOR x = 1 TO 50
      PRINT #1, "  "; PORTS(x)
      IF PORTS(x) = 0 THEN x = 50
    NEXT
  END IF
  PRINT #1, "END"
  CLOSE
 
  COLOR 14, 3: LOCATE 7, 18: PRINT "        All done! Care to do another?       "
  LOCATE 8, 14: PRINT STRING$(50, " ")
  COLOR 0, 3: LOCATE 12, 38: PRINT "  Yes  "
  LOCATE 16, 38: PRINT "  No    "
  LOCATE 19, 31: PRINT "                   "
  LOCATE 20, 31: PRINT "                   "
  LOCATE 21, 31: PRINT "                   "
  DO: logg$ = INKEY$: LOOP UNTIL logg$ = "1" OR logg$ = "2"
LOOP UNTIL logg$ = "2"
ELSE
  COLOR 14
  LOCATE 4, 40: PRINT "SYNTAX:   UUPORT path\filename.fileext"
  COLOR 8
  LOCATE 4, 4: PRINT "Welcome to UUPORT!"
  LOCATE 6, 4: PRINT "UUPORT scans a capture file of the port listing that you find in sector 10."
  LOCATE 7, 4: PRINT "You can choose between 3 types of port reports to create from your capture"
  LOCATE 8, 4: PRINT "files.      TIP: Try to get at least 300 ports in your capture file."
  COLOR 0
  disp "TRADING PORTS", 10
  LOCATE 11, 4: PRINT "This option finds the best Water and Power ports for trading. To be in"
  LOCATE 12, 4: PRINT "the report, the port must sell at the lowest price and buy at the highest."
  LOCATE 13, 4: PRINT "For Water, that means selling at less than 20.99 and buying Power at 22"
  LOCATE 14, 4: PRINT "or more. For Power, it sells at less than 16.99 and buys Water at 27 plus."
  disp "BUY PORTS", 16
  LOCATE 17, 4: PRINT "Lists ports that buy all. Real useful when you want to unload a planet of"
  LOCATE 18, 4: PRINT "its commodities."
  disp "SELL PORTS", 20
  LOCATE 21, 4: PRINT "Lists ports that sell all. Real useful when you want to build a planet."
  COLOR 15
  disp "Press a key to end...", 23
  SLEEP
END IF
COLOR 7, 0
CLS
END

REM $STATIC
FUNCTION BufIn$ (filename$, done) STATIC

IF NOT reading THEN            'if the first time through
  reading = -1                 'show that we're now reading
  done = 0                     'clear Done just in case
  CR = 0                       'no return found yet.
  CR$ = CHR$(13)               'define for speed later

  FileNum = FREEFILE           'open the file
  OPEN filename$ FOR BINARY AS #FileNum
  Remaining& = LOF(FileNum)    'byte count to be read

  BufSize = 4096               'bytes to read each pass
  Buffer$ = SPACE$(BufSize)    'assume BufSize bytes
END IF

'---- This is the main outer loop.
DO WHILE Remaining&              'while more in the file

  IF CR = 0 THEN                 'if no Return was found
    IF Remaining& < BufSize THEN 'read only what remains
      BufSize = Remaining&       'resize the buffer
      IF BufSize < 1 THEN EXIT DO'possible only if EOF 26
      Buffer$ = SPACE$(BufSize)  'create the file buffer
    END IF
    GET #FileNum, , Buffer$      'read a block
    BufPos = 1                   'start at the beginning
  END IF                         '  of that block

  DO                                 'walk through buffer
    CR = INSTR(BufPos, Buffer$, CR$) 'look for a Return
    IF CR THEN                       'we found one
      SaveCR = CR                    'save where
      BufIn$ = MID$(Buffer$, BufPos, CR - BufPos)
      BufPos = CR + 2                'skip inevitable LF
      EXIT FUNCTION                  'all done for now
    ELSE                             'back up in the file
      '---- If we reached the end of the file and no 13
      '     was found, return what remains in the string.
      IF SEEK(FileNum) >= LOF(FileNum) THEN
        Output$ = MID$(Buffer$, SaveCR + 2)
        '---- Trap a trailing CHR$(26) EOF marker.
        IF RIGHT$(Output$, 1) = CHR$(26) THEN
          Output$ = LEFT$(Output$, LEN(Output$) - 1)
        END IF
        BufIn$ = Output$             'assign the function
        Remaining& = BufSize         'set to fall out
        EXIT DO                      'and exit now
      END IF
      Slop = BufSize - SaveCR - 1    'calc buffer excess
      Remaining& = Remaining& + Slop 'calc file excess
      SEEK #FileNum, SEEK(FileNum) - Slop  'seek to start
    END IF

  LOOP WHILE CR                'while more in buffer
  Remaining& = Remaining& - BufSize

LOOP
done = 1: reading = 0: CLOSE
END FUNCTION

SUB disp (title$, row)
Y = 40 - (LEN(title$) \ 2)
LOCATE row, Y: PRINT title$
END SUB

SUB trade1 (logg, port$)
IF port$ = "1" THEN REDIM water(1 TO 50), power(1 TO 50) ELSE REDIM PORTS(50)

DO
  line$ = BufIn$(file$, done)
  IF done THEN EXIT DO
  IF LEFT$(line$, 6) = "Sector" THEN      'if a sector look for kind
    IF logg = 1 THEN
      IF port$ = "1" THEN
        IF RIGHT$(line$, 5) = "Water" THEN wat = 1 ELSE IF RIGHT$(line$, 5) = "Power" THEN wat = 2
      ELSEIF port$ = "2" THEN
        IF RIGHT$(line$, 4) = "None" THEN wat = 3
      ELSEIF port$ = "3" THEN
        IF RIGHT$(line$, 3) = "All" THEN wat = 3
      END IF
    ELSE
      IF port$ = "1" THEN
        IF RIGHT$(line$, 1) = "5" THEN wat = 1 ELSE IF RIGHT$(line$, 1) = "4" THEN wat = 2
      ELSEIF port$ = "2" THEN
        IF RIGHT$(line$, 1) = "7" THEN wat = 3
      ELSEIF port$ = "3" THEN
        IF RIGHT$(line$, 1) = "6" THEN wat = 3
      END IF
    END IF
  END IF
 
  IF wat <> 0 THEN        'if what we want
    sect = VAL(MID$(line$, 9, 4))
    line$ = BufIn$(filename$, done)
      
    IF wat = 1 THEN                          'if water then this
       water1% = VAL(MID$(line$, 66, 5))
       IF water1% <= 20 THEN
         power1% = VAL(MID$(line$, 50, 5))
         IF power1% >= 22 THEN wcnt = wcnt + 1: water(wcnt) = sect
       END IF
    ELSEIF wat = 2 THEN
      power1% = VAL(MID$(line$, 50, 5))
      IF power1% <= 17 THEN
        water1% = VAL(MID$(line$, 66, 5))
        IF water1% >= 28 THEN pcnt = pcnt + 1: power(pcnt) = sect
      END IF
    ELSEIF wat = 3 THEN
      pcnt = pcnt + 1: PORTS(pcnt) = sect
    END IF
  END IF
  wat = 0
LOOP UNTIL done
END SUB

SUB wind (hor, ver, wid, ht)

COLOR 9, 3
LOCATE ver, hor: PRINT "É"
LOCATE ver + ht, hor: PRINT "È";
FOR x = (ver + 1) TO ver + ht - 1
  LOCATE x, hor: PRINT "º"
NEXT x
FOR x = (hor + 1) TO (hor + wid - 1)
    LOCATE ver, x: PRINT "Í"
NEXT x
COLOR 1, 3
LOCATE ver, hor + wid: PRINT "»"
LOCATE ver + ht, hor + wid: PRINT "¼";
FOR x = (ver + 1) TO ver + ht - 1
  LOCATE x, hor + wid: PRINT "º";
NEXT x
FOR x = hor + 1 TO (hor + wid - 1)
  LOCATE ver + ht, x: PRINT "Í";
NEXT x
END SUB

