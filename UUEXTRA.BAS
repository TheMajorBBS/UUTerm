DECLARE SUB printstat (z%)
DECLARE SUB spacefx (wide%, deep%, top%, sw%)
DECLARE SUB doGFX (sw$, file$, h%, v%, menusav%())
DECLARE SUB doalarm (alarmsw%)
DECLARE SUB disp (title$, cl%, row%)
DECLARE SUB PutText2 (text$, TextColor%, BackColor%)
DECLARE FUNCTION Iinkey$ (max%, row%, col%, fore%, sw%)
DECLARE SUB soundfx (sw%)
DECLARE SUB cubeit (h%, v%, WD%, HT%, C1%, C2%, FILD%)
DECLARE SUB icon (h%, v%, WD%, HT%, C1%, C2%, FILD%, OUTIN%)
DECLARE FUNCTION inkey% (NoWait%, x%)
DECLARE FUNCTION DIR$ (FileSpec$)
DECLARE FUNCTION BufIn$ (filename$, done%)
DECLARE FUNCTION DRAWSTR% (mode%, strg$, x0%, y0%, fg%, bg%, gap%)
DECLARE SUB DRAWDOT (mode%, value%, x0%, y0%)
DECLARE FUNCTION Exists% (filename$)

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
DIM SHARED inregs AS RegTypeX, outregs AS RegTypeX
DECLARE SUB InterruptX (intnum AS INTEGER, inregs AS RegTypeX, outregs AS RegTypeX)
CONST dos = &H21, SetDTA = &H1A00, FindFirst = &H4E00, FindNext = &H4F00

DEFINT A-Z
COMMON SHARED snd%, snddev, xmsflag, maxline, alarmsw, alarm()
COMMON SHARED help() AS STRING * 76, spce, expr

FUNCTION BufIn$ (filename$, done) STATIC

IF NOT reading THEN            'if the first time through
  reading = -1                 'show that we're now reading
  done = 0                     'clear Done just in case
  CR = 0                       'no return found yet.
  CR$ = CHR$(13)               'define for speed later

  filenum = FREEFILE           'open the file
  OPEN filename$ FOR BINARY AS #filenum
  Remaining& = LOF(filenum)    'byte count to be read

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
    GET #filenum, , Buffer$      'read a block
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
      IF SEEK(filenum) >= LOF(filenum) THEN
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
      SEEK #filenum, SEEK(filenum) - Slop  'seek to start
    END IF

  LOOP WHILE CR                'while more in buffer
  Remaining& = Remaining& - BufSize

LOOP
done = 1: reading = 0: CLOSE #filenum
END FUNCTION

SUB credits
COLOR 11, 0
PRINT CHR$(201) + STRING$(78, CHR$(196)) + CHR$(187)
LOCATE 22, 1: PRINT CHR$(200) + STRING$(78, CHR$(196)) + CHR$(188)
LOCATE 2, 28
COLOR 4: PRINT "-";
COLOR 12: PRINT "=";
COLOR 6: PRINT "ð";
COLOR 14: PRINT "[ ";
COLOR 15: PRINT "UUTERM CREDITS";
COLOR 14: PRINT " ]";
COLOR 6: PRINT "ð";
COLOR 12: PRINT "=";
COLOR 4: PRINT "-"
'
COLOR 14, 0
LOCATE 4, 1
PRINT "      Program Language Used: "
PRINT "                Programmers: "
PRINT
PRINT
PRINT " Sounds  Effects & Graphics: "
PRINT "              Beta  Testers: "
PRINT
LOCATE 12, 23: PRINT "       Distribution/Support"
'
COLOR 15, 0
LOCATE 4, 30: PRINT "Assembler and QuickBasic 4.5"
LOCATE 5, 30: PRINT "Will Boyett"
LOCATE 6, 30: PRINT "Jeff Sumberg (Communications - QBSerial)"
LOCATE 7, 30: PRINT "Cornel Huth  (Sounds - Ruckus)"
LOCATE 8, 30: PRINT "Will Boyett"
LOCATE 9, 30: PRINT "Nathan Haines"
LOCATE 14, 5: PRINT "Latest Releases:   213-227-7127  or  213-221-0172"
LOCATE 15, 24: PRINT "when asked for your name, enter: *WILLY BOY SOFTWARE"
LOCATE 16, 24: PRINT "to gain instant access."
LOCATE 18, 23: PRINT "  Telnet:   204.74.67.1"
LOCATE 19, 23: PRINT "Internet:   wboyett@annex.com"
LOCATE 20, 23: PRINT "   Voice:   310-924-4184"
LOCATE 21, 15: PRINT "UU and TW Forums:   Majornet, RIME, and Metrolink"
END SUB

SUB Crypt (Buffer$, key$, Start)
'encrypt text strings and data files
BufLen = LEN(Buffer$)
KeyLen = LEN(key$)
IF Start = 0 OR Start > KeyLen THEN
  Start = 1
END IF
FOR I = 1 TO BufLen
  MID$(Buffer$, I, 1) = CHR$(ASC(MID$(Buffer$, I, 1)) XOR (ASC(MID$(key$, Start, 1)) XOR (ASC(MID$(key$, 1, 1)) * Start)) AND &HFF)
  IF Start < KeyLen THEN
    MID$(key$, Start, 1) = CHR$((ASC(MID$(key$, Start, 1)) + ASC(MID$(key$, Start + 1, 1))) AND &HFF)
    Start = Start + 1
  ELSE
    MID$(key$, Start, 1) = CHR$((ASC(MID$(key$, Start, 1)) + ASC(MID$(key$, 1, 1))) AND &HFF)
    Start = 1
  END IF
NEXT
END SUB

SUB delay (x)
DEF SEG = &H40
t% = (PEEK(&H6C) + x) AND 255: WHILE t% > PEEK(&H6C): WEND
END SUB

FUNCTION DIR$ (FileSpec$) STATIC
DIM dta AS STRING * 44 ', inregs AS RegTypeX
Null$ = CHR$(0)
'-----  Set up our own DTA so we don't destroy COMMAND$
inregs.ax = SetDTA                    'Set DTA function
inregs.dx = VARPTR(dta)               'DS:DX points to our DTA
inregs.DS = -1                        'Use current value for DS
InterruptX dos, inregs, inregs          'Do the interrupt
'-----  Check to see if this is First or Next
IF LEN(FileSpec$) THEN              'FileSpec$ isn't null, so FindFirst
  FileSpecZ$ = FileSpec$ + Null$   'Make FileSpec$ into an ASCIIZ string
  inregs.ax = FindFirst              'Perform a FindFirst
  inregs.cx = 0                      'Only look for normal files
  inregs.dx = SADD(FileSpecZ$)       'DS:DX points to ASCIIZ file
  inregs.DS = -1                     'Use current DS
ELSE                                'We have a null FileSpec$,
  inregs.ax = FindNext               'so FindNext
END IF
InterruptX dos, inregs, inregs          'Do the interrupt
'-----  Return file name or null
IF inregs.flags AND 1 THEN            'No files found
  DIR$ = ""                        'Return null string
ELSE
  Null = INSTR(31, dta, Null$)     'Get the filename found
  DIR$ = MID$(dta, 31, Null - 30)  'It's an ASCIIZ string starting
END IF                              'at offset 30 of the DTA
END FUNCTION

SUB disp (title$, cl, row)
y = 40 - (LEN(title$) \ 2)
COLOR cl: LOCATE row, y: PRINT title$
END SUB

SUB doGFX (sw$, file$, h, v, menusav())
file$ = file$ + ".GFX"
IF sw$ = "S" THEN
  GET (0, v)-(639, v + 200), menusav
  DEF SEG = VARSEG(menusav(1))
  BSAVE file$, VARPTR(menusav(1)), 65534
  DEF SEG                 ' Restore default BASIC segment.
ELSE
  DEF SEG = VARSEG(menusav(1))
  BLOAD file$, VARPTR(menusav(1))
  DEF SEG               ' Restore default BASIC segment.
  PUT (h, v), menusav, PSET
END IF
END SUB

SUB doprint (ch0$, line$, fore0%, back0%, fion%, row%, col%)
IF ch0$ = CHR$(8) THEN
  row% = CSRLIN: col% = POS(0)
  IF col% <> 1 THEN col% = col% - 1: ch0$ = " "
  IF line$ <> "" THEN line$ = LEFT$(line$, LEN(line$) - 1)
  hor% = col% * 8 - 8: ver% = row% * 8 - 8
  nz = DRAWSTR%(0, ch0$, hor%, ver%, fore0%, back0%, 8)
ELSE
  line$ = line$ + ch0$
  IF fion = 0 THEN          'if in UUI don't print this
    row% = CSRLIN: col% = POS(0)
    IF row% > maxline THEN row% = maxline
    ver% = row% * 8 - 8
    hor% = col% * 8 - 8
    nz = DRAWSTR%(0, ch0$, hor%, ver%, fore0%, back0%, 8)
    col% = col% + 1
  END IF
END IF
IF col% = 81 THEN col% = 1: row = row + 1
END SUB

SUB edittext (rw, clm, text$, min, max)
vert = max * 8
DO
  IF alarmtime$ = LEFT$(TIME$, 5) THEN doalarm alarmsw
  choice$ = INKEY$
  SELECT CASE choice$
  CASE CHR$(8)                           'backspace
    rw1 = rw * 8 - 8
    LINE (35, rw1)-(vert, rw1 + 7), 1, BF
    IF clm = min THEN
      BEEP
      clm = clm + 1
    ELSE
      text$ = LEFT$(text$, clm - 7) + RIGHT$(text$, (LEN(text$) + 6) - clm)
    END IF
    clm = clm - 1
    LOCATE rw, min: PutText2 text$, 14, 1
    LOCATE rw, clm: PutText2 "Û", 2, 1
  CASE CHR$(0) + "M"                        'right
    z = LEN(text$) + 6
    IF clm < z THEN
      LOCATE rw, clm: PutText2 "Û", 2, 1
      clm = clm + 1
      IF clm > max THEN clm = max: BEEP
      LOCATE rw, clm: PutText2 "Û", 2, 1
    END IF
  CASE CHR$(0) + "K"                        'left
    LOCATE rw, clm: PutText2 "Û", 2, 1
    clm = clm - 1
    IF clm < min THEN clm = min: BEEP
    LOCATE rw, clm: PutText2 "Û", 2, 1
  CASE CHR$(0) + "G"                        'home
    LOCATE rw, clm: PutText2 "Û", 2, 1
    clm = 6
    LOCATE rw, clm: PutText2 "Û", 2, 1
  CASE CHR$(0) + "O"                        'end
    LOCATE rw, clm: PutText2 "Û", 2, 1
    clm = LEN(text$) + 6
    LOCATE rw, clm: PutText2 "Û", 2, 1
  CASE ELSE
    IF choice$ > CHR$(31) AND choice$ < CHR$(123) THEN
      IF LEN(text$) + 6 > max THEN
        BEEP
      ELSE
      rw1 = rw * 8 - 8                               'if entering text
      LINE (35, rw1)-(vert, rw1 + 7), 1, BF
      z = (LEN(text$) + 6) - clm
      IF z < 1 THEN temp$ = "" ELSE temp$ = RIGHT$(text$, z)
      text$ = LEFT$(text$, clm - 6) + choice$ + temp$
      LOCATE rw, min: PutText2 text$, 14, 1
      clm = clm + 1
      IF clm > max THEN clm = max: BEEP
      LOCATE rw, clm: PutText2 "Û", 2, 1
      END IF
    END IF
    IF choice$ = CHR$(0) + "S" AND ((LEN(text$) + 5) - clm) > -1 THEN
      rw1 = rw * 8 - 8                             'if deleting
      LINE (35, rw1)-(vert, rw1 + 7), 1, BF
      text$ = LEFT$(text$, clm - 6) + RIGHT$(text$, (LEN(text$) + 5) - clm)
      LOCATE rw, min: PutText2 text$, 14, 1
      LOCATE rw, clm: PutText2 "Û", 2, 1
    END IF
  END SELECT
LOOP UNTIL choice$ = CHR$(13)
LOCATE rw, clm: PutText2 "Û", 2, 1
END SUB

SUB ermes (tp$, sw)
LINE (4, 336)-(634, 344), 9, BF
x = (640 - (LEN(tp$) * 8)) \ 2
nz = DRAWSTR%(0, tp$, x, 337, 14, 9, 8)
IF sw <> 0 THEN soundfx 8
SLEEP 2
LINE (4, 336)-(634, 344), 9, BF
END SUB

FUNCTION Iinkey$ (max%, row%, col%, fore, sw)
CONST YES = 1, NO = 0, ENTER = &HD, bs = 8

LOCATE row%, col%
COLOR fore
DO
  DO
    IF alarmtime$ = LEFT$(TIME$, 5) THEN doalarm alarmsw
    K$ = INKEY$
  LOOP UNTIL K$ <> ""

  IF LEN(K$) = 2 THEN
    Extend% = YES
    K% = ASC(RIGHT$(K$, 1))
  ELSE
    Extend% = NO
    K% = ASC(K$)
  END IF
  IF (Extend% = NO) AND (K% = ENTER) THEN
    Iinkey$ = I$
    EXIT FUNCTION
  ELSEIF (Extend% = NO) AND (K% = bs) AND (Le% > 0) AND (CurPos% > 0) THEN
    Work1$ = LEFT$(I$, CurPos% - 1)
    Work2$ = RIGHT$(I$, Le% - CurPos%)
    I$ = Work1$ + Work2$
    CurPos% = CurPos% - 1
    Le% = Le% - 1
    LOCATE row%, col%, 1
    IF sw = 456 THEN LINE (sw, 302)-(480, 312), 3, BF ELSE LINE (sw, 335)-(634, 345), 9, BF
    PRINT I$ + SPACE$(1);
    LOCATE row%, col% + CurPos%
  ELSEIF (Extend% = NO) AND (K% > 31) AND (K% < 127) AND (Le% < max%) THEN
    Work1$ = LEFT$(I$, CurPos%)
    Work2$ = RIGHT$(I$, Le% - CurPos%)
    I$ = Work1$ + CHR$(K%) + Work2$
    Le% = Le% + 1
    CurPos% = CurPos% + 1
    LOCATE row%, col%, 1
    IF sw = 456 THEN LINE (sw, 302)-(480, 312), 3, BF ELSE LINE (sw, 335)-(634, 345), 9, BF
    PRINT I$;
    LOCATE row%, col% + Le%
  ELSE
    BEEP
  END IF
LOOP
END FUNCTION

SUB inbar (prompt$, sel$, lenofinput%, txtclr%, fg%, bg%, x)
IF x = 1 THEN soundfx 6
row% = CSRLIN: col% = POS(0)
z = (LEN(prompt$) * 8) + ((lenofinput + 2) * 8)
z = (639 - z) / 2
y = (LEN(prompt$) * 8) + z
cl2 = fg + 128 XOR bg
LINE (4, 336)-(634, 344), 9, BF
nz = DRAWSTR%(0, prompt$, z, 337, txtclr, 9, 8)
nz = (y + 24) / 8
sel$ = Iinkey$(lenofinput, 43, nz, cl2, y)
LINE (4, 336)-(634, 344), 9, BF
LOCATE row, col
END SUB

FUNCTION inkey% (NoWait%, x)
DO
  K$ = UCASE$(INKEY$)
LOOP UNTIL NoWait% OR LEN(K$)
SELECT CASE LEN(K$)
  CASE 1: inkey% = ASC(K$)
  CASE 2: inkey% = -ASC(RIGHT$(K$, 1))   'Extended key, return ASCII
END SELECT                                '  value negated
IF x = 1 THEN LINE (4, 336)-(634, 344), 9, BF
END FUNCTION

SUB Nocary STATIC
IF cl = 99 THEN EXIT SUB
row% = CSRLIN
cl = 3 + 128 XOR 0: COLOR cl
LOCATE row + 1, 1: PRINT "NO CARRIER      Free Memory: "; FRE(-1); "   Free String Space: "; FRE("")
cl = 99
END SUB

SUB PutText2 (text$, TextColor%, BackColor%)
col% = POS(0) - 1
inregs.bx = (TextColor% XOR BackColor%) XOR 128
inregs.cx = 1
FOR ptr% = 1 TO LEN(text$)
  inregs.ax = &H900 + ASC(MID$(text$, ptr%, 1))
  LOCATE , col% + ptr%
  CALL InterruptX(&H10, inregs, outregs)
NEXT
END SUB

SUB reg
WIDTH , 25
LINE (0, 0)-(639, 349), 7, BF
cubeit 0, 0, 639, 24, 15, 8, 7
icon 4, 4, 631, 16, 8, 15, 3, 0
cubeit 0, 325, 639, 24, 15, 8, 7
icon 4, 329, 631, 16, 8, 15, 3, 0
nz = DRAWSTR%(0, "UUTERM v.3.0                                 Copyright 1995 by Will Boyett", 24, 6, 4, 3, 8)
cl = 1 + 128 XOR 7: COLOR cl
disp "If you find this utility useful and want more power then register it.", cl, 4
disp "Besides, there are many other benefits as a registered user.", cl, 5
PALETTE 2, 36
cl = 2 + 128 XOR 7: COLOR cl
disp "The latest registered version of UUTERM which includes", cl, 8
disp "many more features. Don't miss out on this upgrade!", cl, 9
disp "Info and updates on more utilities for UU", cl, 11
disp "Tips and strategies on how you can win at UU", cl, 12
disp "Continued Support!", cl, 13
disp "NO shareware screens to slow you down", cl, 14
cl = 1 + 128 XOR 7: COLOR cl
LOCATE 17, 2
PRINT " To receive the above benefits, please send your registration in the amount of"
PRINT " $15.00 U.S. plus $3 S/H to:"
PRINT
cl = 0 + 128 XOR 7: COLOR cl
PRINT "                                Will Boyett"
PRINT "                               11955 209th St."
PRINT "                             Lakewood, CA 90715"
nz = DRAWSTR%(0, "PRESS ANY KEY TO EXIT", 200, 331, 15, 3, 10)
SLEEP
FOR x = 1 TO 25
    inregs.ax = &H601                         'scroll up 1 line
    inregs.bx = &H0                          'white on black
    inregs.cx = &H0                           'row =  0, col =  0
    inregs.dx = &H1813                        'row = 24, col = 19
    CALL InterruptX(&H10, inregs, outregs)
    inregs.ax = &H601                         'scroll up 1 line
    inregs.bx = &H0                          'white on black
    inregs.cx = &H28                          'row =  0, col = 40
    inregs.dx = &H183B                        'row = 24, col = 59
    CALL InterruptX(&H10, inregs, outregs)
    inregs.ax = &H701                         'scroll down 1 line
    inregs.bx = &H0                          'white on black
    inregs.cx = &H14                          'row =  0, col = 20
    inregs.dx = &H1827                        'row = 24, col = 39
    CALL InterruptX(&H10, inregs, outregs)
    inregs.ax = &H701                         'scroll down 1 line
    inregs.bx = &H0                          'white on black
    inregs.cx = &H3C                          'row =  0, col = 60
    inregs.dx = &H184F                        'row = 24, col = 79
    CALL InterruptX(&H10, inregs, outregs)
  FOR y = 1 TO 30: NEXT y
NEXT x
PALETTE
END SUB

SUB restscrn (menusav(), y)
WIDTH 80, 43
SCREEN 9, , 0, 1
IF maxline = 24 THEN
  doGFX "L", "UUTSCRN0", 0, 201, menusav()
  doGFX "L", "temp", 0, 0, menusav()
  printstat expr - 2
ELSE
  doGFX "L", "temp", 0, y, menusav()
  'y = pixel line grx dispaleyd on
  IF y > 0 THEN
    sw = (y / 8) * 5
    IF sw = 0 THEN sw = 1
    spacefx 640, y, 0, sw
    sw = (y + 200)
    y = 331 - sw
    IF y > 0 THEN  'if there is some to do on bottom
      spacefx 640, y, sw, (y / 8) * 5  'sw = top  y = how deep
    END IF
  ELSE
    sw = (y / 8) * 5
    IF sw = 0 THEN sw = 1
    spacefx 640, 130, 200, 80
  END IF
END IF
IF Exists("temp.gfx") THEN KILL "temp.gfx"
SCREEN 9, , 0, 0
IF maxline <> 24 THEN
  icon 0, 331, 640, 18, 15, 8, 7, 0     'bottom bar
  icon 2, 333, 636, 14, 8, 15, 7, 0
  LINE (4, 335)-(634, 345), 9, BF
END IF
soundfx 7
END SUB

SUB ScrnScroll (ULRow%, ULColumn%, LRRow%, LRColumn%, NumOfLines%, sw)
DEF SEG = 0
IF sw = 0 THEN inregs.bx = &H0 * 256 ELSE inregs.bx = &H7 * 256
DEF SEG
inregs.cx = ((ULRow% - 1) * 256) OR (ULColumn% - 1)
inregs.dx = ((LRRow% - 1) * 256) OR (LRColumn% - 1)
IF NumOfLines% < 0 THEN
  inregs.ax = &H700 OR ABS(NumOfLines%)
ELSE
  inregs.ax = &H600 OR NumOfLines%
END IF
InterruptX &H10, inregs, inregs
END SUB

SUB spacefx (wide, deep, top, sw)
IF spce = 0 OR spce = 2 THEN EXIT SUB
FOR c = 1 TO sw
  x = INT(RND * wide)
  y = INT(RND * deep) + top
  z = INT(RND * 14) + 1
  SELECT CASE z
  CASE 2, 4, 5
    z = 8
  CASE 10, 13, 12
    z = 7
  CASE 14, 1
    z = 3
  CASE 9
    z = 15
  END SELECT
  DRAWDOT 0, z, x, y
NEXT c
END SUB

