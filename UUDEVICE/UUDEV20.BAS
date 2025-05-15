DECLARE SUB final ()
DECLARE SUB readdir (cnt%, search$, files$())
DECLARE SUB delay (wt%)
DECLARE SUB reg ()
DECLARE SUB init ()
DECLARE SUB Crypt (Buffer$, key$, Start%)
DECLARE SUB reginfo ()
DECLARE SUB mergein (file1$, file2$)
DECLARE SUB doedit (top%, bottom%)
DECLARE SUB restorescreen (which$, winselect$, winopen$)
DECLARE SUB searchdev ()
DECLARE SUB loadarray (num$, h%, v%, x%)
DECLARE SUB creatmac (hold1$())
DECLARE SUB sondfx (which%)
DECLARE SUB sortit (order$)
DECLARE SUB disperrmsg (msg$, msg2$)
DECLARE SUB dopick (pickcnt%)
DECLARE SUB errorwarning3 ()
DECLARE SUB drawbox (h%, v%, wd%, ht%)
DECLARE SUB searchprice ()
DECLARE SUB dochoiceC ()
DECLARE SUB WinScroll (DR%, hor%, ver%, wd%, ht%, colw%, colt%)
DECLARE SUB drawsearch ()
DECLARE SUB scrolltext (size%, sw$)
DECLARE SUB dochoice2 (doextra$)
DECLARE SUB domenu (choice$, winselect$, winopen$)
DECLARE SUB errorwarning2 (tempfil$, soundx%)
DECLARE SUB MouseArea (y1%, y2%, min%, max%)
DECLARE SUB dochoice5 (doextra$)
DECLARE SUB dochoice1 (doextra$, choice$)
DECLARE SUB mouseget ()
DECLARE SUB mousepointer (OnOff%)
DECLARE SUB mouseinit ()
DECLARE SUB mousespeed (Speed%)
DECLARE SUB getmousechoice (choice$)
DECLARE SUB drawscreen ()
DECLARE SUB initbegin (title$, where%, choice$, winselect$, winopen$)
DECLARE SUB openwindow (sw%)
DECLARE SUB errorwarning (tempfil$, orig$)
DECLARE SUB doprint (file$)
DECLARE SUB dochoice4 (doextra$)
DECLARE SUB dochoice3 (choice$, doextra$)
DECLARE SUB conv ()
DECLARE SUB openscreen ()
DECLARE SUB metal (pattern$)
DECLARE SUB titles ()
DECLARE SUB opensmall (direction$, soundx%, timin%)
DECLARE SUB openconfig (timin%, soundx%, sw$)
DECLARE SUB config (a%, soundx%, linport$, anim$)
DECLARE SUB pushbutton (number$, whereicon%, whereprint%, doit%)
DECLARE SUB helpscreen (sw$)
DECLARE FUNCTION printerready! ()
DECLARE FUNCTION Exists% (FileName$)
DECLARE FUNCTION BufIn$ (FileName$, done%, reading%)
DECLARE FUNCTION iinkey$ (max%, Row%, col%, fore%)
DECLARE FUNCTION EGAVIDEO% ()
DECLARE FUNCTION DRAWSTR% (mode%, strg$, x0%, y0%, fg%, bg%, gap%)
DECLARE FUNCTION DIR$ (FileSpec$)
DECLARE SUB icon (h%, v%, wd%, ht%, C1%, c2%, fild%, outin%)
DECLARE SUB cubeit (h%, v%, wd%, ht%, C1%, c2%, fild%)

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
DECLARE SUB INTERRUPTX (intnum AS INTEGER, inregs AS RegTypeX, outregs AS RegTypeX)
CONST dos = &H21, SetDTA = &H1A00, FindFirst = &H4E00, FindNext = &H4F00
'
DEFINT A-Z
'$DYNAMIC
COMMON SHARED NumberOfFiles, zig$, pickcnt%, avail%, regit
COMMON SHARED FileNum, H2, h1, V2, winopen$, winselect$
COMMON SHARED nomouse%, mouseh%, mousev%, mouseb%, soundx%
COMMON SHARED done%, reading%, a%, linport$, anim$, timin%
REDIM SHARED menubar(2048), text1(1) AS STRING * 76, text2(1) AS STRING * 76
REDIM SHARED hold(24) AS STRING * 75, pick(24) AS INTEGER
patt$ = CHR$(191) + CHR$(191) + CHR$(191) + CHR$(72)
patt$ = patt$ + CHR$(223) + CHR$(223) + CHR$(223) + CHR$(36)
patt$ = patt$ + CHR$(239) + CHR$(239) + CHR$(239) + CHR$(18)
patt$ = patt$ + CHR$(253) + CHR$(253) + CHR$(253) + CHR$(18)
patt$ = patt$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(36)
zig$ = patt$ + CHR$(247) + CHR$(247) + CHR$(247) + CHR$(72)
RANDOMIZE TIMER
'
init
mouseinit
MouseArea 2, 42, 20, 620
mousepointer 1
mousespeed a%
GET (60, 13)-(560, 27), menubar
w = 36: q = 16
DO
  DO                                       'main loop
    mouseget
    choice$ = UCASE$(INKEY$)
    GOSUB efx
    IF mouseb <> 0 THEN getmousechoice choice$     'find the choice
  LOOP UNTIL choice$ <> ""
  meter = 1
  domenu choice$, winselect$, winopen$   'displays the menu
  SELECT CASE choice$
    CASE "C"
      dochoiceC
    CASE "1"
      dochoice1 doextra$, choice$
    CASE "2"
      dochoice2 doextra$
    CASE "3"
      dochoice3 choice$, doextra$
    CASE "4"
      dochoice4 doextra$
    CASE "5"
      dochoice5 doextra$
  END SELECT
  mousepointer 1                     'just to be sure it goes on
  IF choice$ <> "Q" THEN SLEEP 1
LOOP UNTIL choice$ = "Q"             'goes back for next choice
'final
SCREEN 0
CLS
IF regit = 0 THEN
  reg
  nz! = TIMER
  DO UNTIL TIMER > nz! + 3
  LOOP
END IF
COLOR dosfg, dosbg     'restore
CLOSE
END
'
efx:
x = x + 1
IF x = 16 THEN
  x = 0: g = g + 1
  IF g = 5 THEN q = 16: g = 1
  q = q + 1
  cl = x + 128 XOR 10: COLOR cl
  LOCATE q, w: PRINT "ฒ"
END IF
IF meter = 0 THEN
  LINE (50, 184)-(60, 177), x
  LINE (53, 182)-(61, 177), x
END IF
RETURN

REM $STATIC
FUNCTION BufIn$ (FileName$, done, reading) STATIC
IF NOT reading THEN            'if the first time through
  reading = -1                 'show that we're now reading
  done = 0                     'clear Done just in case
  CR = 0                       'no return found yet.
  CR$ = CHR$(13)               'define for speed later

  FileNum = FREEFILE           'open the file
  OPEN FileName$ FOR BINARY AS #FileNum
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
done = 1
END FUNCTION

SUB conv
REDIM pick(550) AS INTEGER
OPEN "o", 2, "device.con"
DO
  cnt = cnt + 1
  line$ = BufIn$("device.doc", done, reading)
  IF done THEN EXIT DO
  '
  SELECT CASE sw
  CASE 4
    temp$ = temp$ + port$ + " " + price$
    PRINT #2, temp$
    DO
      line$ = BufIn$("device.doc", done, reading)
      IF LEFT$(line$, 2) = "ฤฤ" THEN EXIT DO
      IF line$ <> "" THEN PRINT #2, line$
    LOOP
    line$ = "": sw = 0
  CASE 3                       'where to buy it at
    IF LEFT$(line$, 2) = "ฤฤ" THEN
      temp$ = temp$ + port$ + " " + price$
      PRINT #2, temp$
      DO
	line$ = BufIn$("device.doc", done, reading)
	IF LEFT$(line$, 2) = "ฤฤ" THEN EXIT DO
	PRINT #2, line$
      LOOP
      line$ = "": sw = 0
    ELSE
      SELECT CASE RIGHT$(line$, 4)
      CASE "Inc."
	port$ = "(5)": sw = 4
      CASE "Ltd."
	port$ = "(?)": sw = 4
      CASE "Sol."
	port$ = "(1)": sw = 4
      CASE ELSE
	port$ = "( )"
	IF LEFT$(line$, 5) = "Avail" THEN
	  z = LEN(line$)
	  port$ = "(" + MID$(line$, z - 1, 1) + ")"
	  y = VAL(MID$(line$, z - 1, 1))
	  IF y = 0 THEN
	    port$ = "( )"
	  END IF
	  sw = 4
	END IF
      END SELECT
    END IF
  CASE 2
    price$ = line$: sw = 3
  CASE 1                'device name
    temp$ = temp$ + line$
    DO UNTIL LEN(temp$) > 46
      temp$ = temp$ + " "
    LOOP
    sw = 2
  END SELECT
  '
  IF MID$(line$, 6, 3) = "e #" THEN          'device number
    z = LEN(line$)
    pick(VAL(MID$(line$, 9, z - 9))) = 1
    temp$ = line$ + "  "
    sw = 1
    DO UNTIL LEN(temp$) = 14
      temp$ = temp$ + " "
    LOOP
  END IF
  '
  SELECT CASE cnt
    CASE 800: COLOR 4, 0: LOCATE 17, 32: PRINT "ฐ"
    CASE 1600: COLOR 12, 0: LOCATE 18, 32: PRINT "ฐ"
    CASE 2400: COLOR 13, 0: LOCATE 19, 32: PRINT "ฐ"
    CASE 3200: COLOR 6, 0: LOCATE 20, 32: PRINT "ฐ"
  END SELECT
LOOP
'
FOR x = 1 TO 550
  IF pick(x) = 0 THEN
    line$ = "Device #" + LTRIM$(STR$(x)) + ".  "
    DO UNTIL LEN(line$) = 14
      line$ = line$ + " "
    LOOP
    line$ = line$ + "Device Not Available"
    z = 51 - LEN(line$)
    line$ = line$ + SPACE$(z) + "Retail Value:0"
    PRINT #2, line$
    PRINT #2, " This item is not installed in the game"
  END IF
NEXT x
CLOSE
reading = 1
opensmall "O", soundx%, timin%
LINE (35, 286)-(228, 307), 7, BF
LINE (35, 285)-(228, 285), 15
COLOR 12, 0
LOCATE 20, 6: PRINT "  Delete Device.Doc?"
icon 150, 289, 28, 15, 15, 8, 7, 1
icon 193, 289, 28, 15, 15, 8, 7, 1
nz = DRAWSTR%(0, "Y", 153, 290, 4, 7, 8)
nz = DRAWSTR%(0, "N", 199, 290, 4, 7, 8)
nz = DRAWSTR%(0, "es", 161, 290, 0, 7, 8)
nz = DRAWSTR%(0, "o", 207, 290, 0, 7, 8)
nz = DRAWSTR%(0, "Default (No)", 46, 290, 0, 7, 8)
mousepointer 1
IF soundx% = 1 THEN sondfx 2
DO
  choice$ = INKEY$
  mouseget
LOOP UNTIL choice$ <> "" OR mouseb% <> 0
IF mouseh% > 20 AND mouseh% < 24 AND mousev% > 36 AND mousev% < 40 THEN choice$ = "Y"
IF UCASE$(choice$) = "Y" THEN KILL "Device.Doc"
mousepointer 0
opensmall "C", soundx%, timin%
icon 247, 224, 9, 56, 15, 8, 9, 0
REDIM pick(24) AS INTEGER
END SUB

DEFSNG A-Z
SUB creatmac (hold1$())
DEFINT A-Z
REDIM mac$(1 TO 5)
'
x = 0: z = 0      'port 1
DO
  x = x + 1
  IF hold1$(x) = "1" THEN
    IF z = 1 THEN mac$(1) = mac$(1) + "B;" + LTRIM$(STR$(pick(x))) + "Y;"
    IF z = 0 THEN mac$(1) = "P;M;B;" + LTRIM$(STR$(pick(x))) + ";y;": z = 1
  END IF
LOOP UNTIL x = pickcnt
IF mac$(1) <> "" THEN mac$(1) = mac$(1) + "Q;"
'
x = 0: z = 0      'port 4
DO
  x = x + 1
  IF hold1$(x) = "4" THEN
    IF z = 1 THEN
      IF pick(x) = 241 THEN mac$(4) = mac$(4) + "D;Y;"
      IF pick(x) = 242 THEN mac$(4) = mac$(4) + "E;Y;"
    END IF
    IF z = 0 THEN
      IF pick(x) = 241 THEN mac$(4) = "M;4:P;D;Y;"
      IF pick(x) = 242 THEN mac$(4) = "M;4:P;E;Y;"
      z = 1
    END IF
  END IF
LOOP UNTIL x = pickcnt
IF mac$(4) <> "" THEN mac$(4) = mac$(4) + "Q;"
'
x = 0: z = 0  'port 5
DO
  x = x + 1
  IF hold1$(x) = "5" THEN
    IF z = 1 THEN mac$(3) = mac$(3) + "B;" + LTRIM$(STR$(pick(x))) + ";Y;"
    IF z = 0 THEN mac$(3) = "M;5;P;B;" + LTRIM$(STR$(pick(x))) + ";Y;": z = 1
  END IF
LOOP UNTIL x = pickcnt
IF mac$(3) <> "" THEN mac$(3) = mac$(3) + "Q;"
'
x = 0: z = 0
DO                                    'port 7
  x = x + 1
  IF hold1$(x) = "7" AND z = 0 THEN mac$(4) = "M;6;M;7;P;6;Q;": z = 1
LOOP UNTIL sev = 1 OR x = pickcnt
'
x = 0: z = 0      'allien
DO
  x = x + 1
  IF hold1$(x) = "?" THEN
    IF z = 1 THEN mac$(5) = mac$(5) + "B;" + LTRIM$(STR$(pick(x))) + ";Y;"
    IF z = 0 THEN mac$(5) = "P;B;" + LTRIM$(STR$(pick(x))) + ";Y;": z = 1
  END IF
LOOP UNTIL x = pickcnt
IF mac$(5) <> "" THEN mac$(5) = mac$(5) + "Q;"
'
z = 0
FOR x = 1 TO 4
 IF mac$(x) <> "" THEN
   IF z = 0 THEN OPEN "o", 1, "Buyfed.mac": z = 1
   PRINT #1, mac$(x)
 END IF
NEXT x
IF z = 1 THEN CLOSE #1
'
IF mac$(5) <> "" THEN
  OPEN "o", 1, "BuyAlien.mac"
  PRINT #1, mac$(5)
  CLOSE #1
END IF
ERASE mac$
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

SUB delay (wt)
DEF SEG = &H40
T% = (PEEK(&H6C) + wt) AND 255: WHILE T% > PEEK(&H6C): WEND
DEF SEG
END SUB

FUNCTION DIR$ (FileSpec$) STATIC
DIM dta AS STRING * 44 ', inregs AS RegTypeX
Null$ = CHR$(0)
'-----  Set up our own DTA so we don't destroy COMMAND$
inregs.ax = SetDTA                    'Set DTA function
inregs.dx = VARPTR(dta)               'DS:DX points to our DTA
inregs.DS = -1                        'Use current value for DS
INTERRUPTX dos, inregs, inregs          'Do the interrupt
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
INTERRUPTX dos, inregs, inregs          'Do the interrupt
'-----  Return file name or null
IF inregs.flags AND 1 THEN            'No files found
  DIR$ = ""                        'Return null string
ELSE
  Null = INSTR(31, dta, Null$)     'Get the filename found
  DIR$ = MID$(dta, 31, Null - 30)  'It's an ASCIIZ string starting
END IF                              'at offset 30 of the DTA
END FUNCTION

DEFSNG A-Z
SUB disperrmsg (msg$, msg2$)
DEFINT A-Z
COLOR 13, 0
LOCATE 16, 7: PRINT "                     "
T! = TIMER + .4: WHILE T! > TIMER: WEND
LOCATE 16, 7: PRINT msg$
T! = TIMER + .4: WHILE T! > TIMER: WEND
IF soundx% = 1 THEN sondfx 2
COLOR 14, 0: LOCATE 16, 7: PRINT msg2$

END SUB

DEFSNG A-Z
SUB dochoice1 (doextra$, choice$)
DEFINT A-Z
pushbutton "1", 66, 71, 0
SELECT CASE winselect$

CASE "T"
REDIM files$(1 TO 13)
readdir NumberOfFiles, "*.lst", files$()
IF NumberOfFiles > 0 THEN
  IF winopen$ = "Yes" THEN LINE (308, 58)-(612, 327), 0, BF ELSE openwindow 0: winopen$ = "Yes"
  LINE (307, 58)-(612, 90), 7, BF
  LINE (307, 91)-(612, 91), 8
  LINE (307, 301)-(612, 327), 7, BF
  LINE (307, 300)-(612, 300), 15
  DO
    icon 310, 303, 300, 22, 8, 15, 3, 0
    cl = 4 + 128 XOR 3: COLOR cl
    LOCATE 23, 40: PRINT "Enter number of the file to print:"
    IF NumberOfFiles > 13 THEN NumberOfFiles = 13
    FOR I = 1 TO NumberOfFiles
      COLOR 14, 0: LOCATE I + 8, 50: PRINT I; ">  ";
      COLOR 13, 0: PRINT files$(I)
    NEXT I
    cl% = 0 + 128 XOR 3
    choice$ = iinkey$(2, 23, 74, cl%)
    I = VAL(choice$)
    IF I > 0 AND I <= NumberOfFiles THEN doprint files$(I)
    icon 310, 303, 300, 22, 8, 15, 3, 0
    cl = 4 + 128 XOR 3: COLOR cl
    LOCATE 23, 42: PRINT "Do you care to print another?"
    DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ <> ""
    IF choice$ = "N" THEN EXIT DO
  LOOP
  openwindow 1: winopen$ = "No"
ELSE
  disperrmsg " No .LST files found", ""
END IF
nz = DRAWSTR(0, "  Make A Selection  ", 51, 210, 14, 0, 8)
'
CASE "P"
IF pickcnt% = 0 THEN disperrmsg "  No Devices Picked ", "   Pick An Option   "
IF pickcnt% = 0 THEN pushbutton "1", 66, 70, 1: EXIT SUB
IF Exists("device.nam") THEN
  REDIM hold(1 TO 24) AS STRING * 75
  reading = 1
  sortit "A"
  cnt = 0: cnt2 = 1: total& = 0  '         hold array loads it
  DO
    DO
      cnt = cnt + 1
      line$ = BufIn$("device.nam", done, reading)
      IF cnt2 = 25 THEN EXIT DO
      IF pick(cnt2) = 0 THEN EXIT DO
      IF VAL(MID$(line$, 9, 3)) = pick(cnt2) THEN
	hold(cnt2) = line$
	cnt2 = cnt2 + 1
	total& = total& + VAL(RIGHT$(line$, LEN(line$) - 64))
      END IF
    LOOP UNTIL done
    CLOSE : reading = 1
  LOOP UNTIL cnt2 >= pickcnt% + 1
  drawsearch
  LINE (280, 11)-(280, 29), 15
  LINE (283, 11)-(283, 29), 8
  cl = 4 + 128 XOR 3: COLOR cl
  LOCATE 2, 42: PRINT "to Edit"
  LOCATE 2, 11: PRINT pickcnt%
  LOCATE 2, 21: PRINT USING "##########,"; total&
  cl = 0 + 128 XOR 3: COLOR cl
  LOCATE 2, 38: PRINT "F1"
  LOCATE 2, 4: PRINT "Items:     Cost:"
  IF pickcnt% > 24 THEN pickcnt% = 24
  IF cnt2 > 24 THEN cnt2 = 24
  scrolltext cnt2, winselect$
  restorescreen "P", winselect$, winopen$
ELSE
  errorwarning3
END IF
'
CASE "D"
IF avail = 0 THEN loadarray "1", 66, 70, 1
IF NOT Exists("device.con") THEN EXIT SUB
drawsearch
searchdev
restorescreen "D", winselect$, winopen$
'
CASE "X"
choice$ = "Q"

CASE "H"
IF winopen$ = "No" THEN openwindow 0: winopen$ = "Yes"
helpscreen "D"
END SELECT
pushbutton "1", 66, 70, 1
END SUB

SUB dochoice2 (doextra$)
pushbutton "2", 94, 99, 0
SELECT CASE winselect$

CASE "T"
IF winopen$ = "Yes" THEN openwindow 1: winopen$ = "No"
IF Exists("device.nam") THEN
  COLOR 12, 0: LOCATE 16, 8: PRINT "   Please Wait!  "
  doprint "device.nam"
  COLOR 14, 0: LOCATE 16, 8: PRINT " Make A Selection  "
ELSE
  errorwarning2 "Device.Nam", soundx%
END IF
CASE "P"                         '@
  IF pickcnt% = 0 THEN
    disperrmsg "  No Devices Picked ", "                   "
  ELSE
  IF Exists("device.nam") THEN
    sortit "A"
    REDIM hold1$(1 TO 24)
    reading = 1
    cnt = 0: cnt2 = 1
don:
    DO
      cnt = cnt + 1
      line$ = BufIn$("device.nam", done, reading)
      IF cnt2 = 25 THEN EXIT DO
      IF pick(cnt2) = 0 THEN EXIT DO
      IF VAL(MID$(line$, 9, 3)) = pick(cnt2) THEN
	hold1$(cnt2) = MID$(line$, 49, 1)
	cnt2 = cnt2 + 1
      END IF
    LOOP UNTIL done
    CLOSE : reading = 1
    IF cnt2 < pickcnt% THEN : GOTO don
    creatmac hold1$()
    IF pickcnt% > 24 THEN pickcnt% = 24
  ELSE
    errorwarning3
  END IF
  END IF
'
CASE "D"
IF avail = 0 THEN loadarray "2", 94, 98, 1
IF NOT Exists("device.con") THEN EXIT SUB
drawsearch
searchprice
restorescreen "D", winselect$, winopen$
'
CASE "X"
mousepointer 0
CLS : COLOR 14, 0
PRINT "Type EXIT to return to UUDEVICE."
SHELL
SCREEN 9, , 0, 1
CLS
openscreen
choice$ = "X": winopen$ = "Yes"
temp% = soundx%: soundx% = 0
titles
domenu choice$, winselect$, winopen$
PALETTE 13, 39: PALETTE 9, 51
soundx% = temp%
SCREEN 9, , 0, 0
'
CASE "H"
IF winopen$ = "No" THEN openwindow 0: winopen$ = "Yes"
helpscreen "P"

END SELECT
pushbutton "2", 94, 98, 1
END SUB

SUB dochoice3 (choice$, doextra$)
pushbutton "3", 122, 127, 0
SELECT CASE winselect$

CASE "T"
REDIM files$(1 TO 13)
readdir NumberOfFiles, "*.dev", files$()
IF NumberOfFiles > 0 THEN
  IF winopen$ = "Yes" THEN LINE (308, 58)-(612, 327), 0, BF ELSE openwindow 0: winopen$ = "Yes"
  LINE (307, 58)-(612, 90), 7, BF
  LINE (307, 91)-(612, 91), 8
  LINE (307, 301)-(612, 327), 7, BF
  LINE (307, 300)-(612, 300), 15
  DO
    icon 310, 303, 300, 22, 8, 15, 3, 0
    cl = 4 + 128 XOR 3: COLOR cl
    LOCATE 23, 40: PRINT "Enter number of the file to print:"
    IF NumberOfFiles > 13 THEN NumberOfFiles = 13
    FOR I = 1 TO NumberOfFiles
      COLOR 14, 0: LOCATE I + 8, 50: PRINT I; ">  ";
      COLOR 13, 0: PRINT files$(I)
    NEXT I
    cl% = 0 + 128 XOR 3
    choice$ = iinkey$(2, 23, 74, cl%)
    I = VAL(choice$)
    IF I > 0 AND I <= NumberOfFiles THEN doprint files$(I)
    icon 310, 303, 300, 22, 8, 15, 3, 0
    cl = 4 + 128 XOR 3: COLOR cl
    LOCATE 23, 42: PRINT "Do you care to print another?"
    DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ <> ""
    IF choice$ = "N" THEN EXIT DO
  LOOP
  openwindow 1: winopen$ = "No"
ELSE
  disperrmsg " No .DEV files found", " Make A Selection  "
END IF
COLOR 14, 0: LOCATE 16, 8: PRINT " Make A Selection  "

CASE "P"
IF pickcnt% <> 0 THEN
  savnam$ = "PICK": num$ = "01": ext$ = ".LST"
  file$ = savnam$ + num$ + ext$: cnt = 1
  DO UNTIL NOT Exists(file$)
    cnt = cnt + 1
    num$ = LTRIM$(STR$(cnt))
    IF LEN(num$) = 1 THEN num$ = "0" + num$
    file$ = savnam$ + num$ + ext$
  LOOP
  COLOR 13, 0: LOCATE 16, 7: PRINT "Saving as: "; file$
 
  IF Exists("device.nam") THEN
    REDIM hold(1 TO 24) AS STRING * 75
    reading = 1
    sortit "A"
    cnt = 0: cnt2 = 1  '                     loads it
    DO
      DO
	cnt = cnt + 1
	line$ = BufIn$("device.nam", done, reading)
	IF cnt2 = 25 THEN EXIT DO
	IF pick(cnt2) = 0 THEN EXIT DO
	IF VAL(MID$(line$, 9, 3)) = pick(cnt2) THEN hold(cnt2) = line$: cnt2 = cnt2 + 1
      LOOP UNTIL done
      CLOSE : reading = 1
    LOOP UNTIL cnt2 >= pickcnt%
    OPEN "o", 1, file$
    FOR x = 1 TO pickcnt%
      PRINT #1, hold(x)
    NEXT x
  ELSE
    OPEN "o", 1, file$
    FOR x = 1 TO pickcnt%
      PRINT #1, pick%(x)
    NEXT x
  END IF
  PRINT #1, ""
  CLOSE
ELSE
  disperrmsg "  No Items In List", ""
END IF
COLOR 13, 0: LOCATE 16, 7: PRINT "   Pick An Option    "
'
CASE "D"
IF NOT Exists("device.con") THEN EXIT SUB
REDIM hold(1 TO 550) AS STRING * 75
IF NOT Exists("device.nam") AND Exists("device.con") THEN    'no device.nam file
  cnt = 1
  OPEN "o", 2, "device.nam"
  IF avail% = 0 THEN loadarray "3", 122, 126, 1
  FOR x = 1 TO 1300
    IF LEFT$(text1(x), 8) = "Device #" THEN PRINT #2, text1(x)
  NEXT x
  FOR x = 1 TO 1300
    IF LEFT$(text2(x), 8) = "Device #" THEN PRINT #2, text2(x)
  NEXT x
END IF
CLOSE
cnt = 1
IF avail = 1 THEN
  FOR x = 1 TO 1300
    IF LEFT$(text1(x), 8) = "Device #" THEN hold(cnt) = text1(x): cnt = cnt + 1
  NEXT x
  FOR x = 1 TO 1300
    IF LEFT$(text2(x), 8) = "Device #" THEN hold(cnt) = text2(x): cnt = cnt + 1
  NEXT x
ELSE
  reading = 1
  OPEN "I", 1, "device.nam"
  DO
    line$ = BufIn$("device.nam", done, reading)
    IF done THEN EXIT DO
    hold(cnt) = line$: cnt = cnt + 1
  LOOP
  reading = 1: CLOSE
END IF                                 'hold is now loaded and ready
drawsearch
temp$ = ""
IF regit = 0 THEN x = 67 ELSE x = 12: temp$ = "/DOUBLE CLICK LFT"
LINE (25, 12)-(395, 26), 3, BF
z = DRAWSTR(0, "ESC = Exit  INSERT/RGHT MOUSE" + temp$ + " = Select", x, 14, 0, 3, 7)
scrolltext cnt - 1, "N"
restorescreen "D", winselect$, winopen$
ERASE hold
'
CASE "X"
mousepointer 0
IF winopen$ = "Yes" THEN openwindow 1: winopen$ = "No"
openconfig timin%, soundx%, "O"
config a%, soundx%, linport$, anim$
COLOR 7, 0
mousepointer 1
DO                     'gets key press
  DO
    mouseget
    choice$ = UCASE$(INKEY$)
  LOOP UNTIL choice$ <> "" OR mouseb% <> 0
  IF choice$ = "" THEN                            'does mouse choice
    IF mousev% = 15 OR mousev% = 16 THEN choice$ = "M"
    IF mousev% = 17 OR mousev% = 18 THEN choice$ = "S"
    IF mousev% = 19 OR mousev% = 20 THEN choice$ = "L"
    IF mousev% = 21 OR mousev% = 22 THEN choice$ = "A"
    IF mousev% = 23 OR mousev% = 24 THEN
      IF mouseh% > 46 AND mouseh% < 55 THEN choice$ = "D"
      IF mouseh% > 63 AND mouseh% < 72 THEN choice$ = "V"
    END IF
  END IF
  mousepointer 0
  IF choice$ = "D" THEN EXIT DO
  z! = TIMER: DO UNTIL TIMER > z! + .3: LOOP
  cl = 1 + 128 XOR 11: COLOR cl
  SELECT CASE choice$
    CASE "M"
      a% = a% + 1
      IF a% = 10 THEN a% = 1
      LINE (510, 195)-(546, 206), 11, BF
      LOCATE 15, 65: PRINT a%
    CASE "S"
      IF soundx% = 1 THEN soundx% = 0 ELSE soundx% = 1
      IF soundx% = 1 THEN mssg$ = "On" ELSE mssg$ = "Off"
      LINE (510, 223)-(546, 237), 11, BF
      LOCATE 17, 66: PRINT mssg$
    CASE "L"
      IF linport$ = "LPT1" THEN linport$ = "LPT2" ELSE linport$ = "LPT1"
      LINE (510, 253)-(546, 264), 11, BF
      LOCATE 19, 65: PRINT linport$
    CASE "A"
      SELECT CASE anim$
      CASE "286": anim$ = "386": timin% = 40
      CASE "386": anim$ = "486+": timin% = 120
      CASE "486+": anim$ = "286": timin% = 4
      END SELECT
      LINE (510, 279)-(546, 290), 11, BF
      LOCATE 21, 65: PRINT anim$
    CASE "V"
      icon 500, 305, 56, 18, 8, 15, 7, 1
      cl = 0 + 128 XOR 7: COLOR cl: LOCATE 23, 65: PRINT "Sa e";
      cl = 4 + 128 XOR 7: COLOR cl: LOCATE 23, 67: PRINT "V";
      OPEN "o", #2, "UUDEV.CFG"
      PRINT #2, a%; ","; soundx%; ","; linport$; ","; anim$
      CLOSE #2
      T! = (TIMER + .4): WHILE T! > TIMER: WEND
      icon 500, 305, 56, 18, 15, 8, 7, 1
      cl = 0 + 128 XOR 7: COLOR cl: LOCATE 23, 65: PRINT "Sa e";
      cl = 4 + 128 XOR 7: COLOR cl: LOCATE 23, 67: PRINT "V";
  END SELECT
  mousepointer 1
LOOP
mousespeed a%
mousepointer 0
openconfig timin%, soundx%, "C"
mousepointer 1
'
CASE "H"
  IF winopen$ = "No" THEN openwindow 0: winopen$ = "Yes"
  helpscreen "S"
END SELECT
pushbutton "3", 122, 126, 1
END SUB

SUB dochoice4 (doextra$)
pushbutton "4", 150, 155, 0
SELECT CASE winselect$
CASE "P"
ERASE hold: pickcnt% = 0
FOR x = 1 TO 24
  pick(x) = 0
NEXT x
'
CASE "D"
merge:
REDIM files$(1 TO 13)
readdir NumberOfFiles, "*.dev", files$()

IF NumberOfFiles > 1 THEN
  IF winopen$ = "Yes" THEN LINE (308, 58)-(612, 327), 0, BF ELSE openwindow 0: winopen$ = "Yes"
  LINE (307, 58)-(612, 90), 7, BF
  LINE (307, 91)-(612, 91), 8
  LINE (307, 301)-(612, 327), 7, BF
  LINE (307, 300)-(612, 300), 15
  
    icon 310, 303, 300, 22, 8, 15, 3, 0
    cl = 4 + 128 XOR 3: COLOR cl
    LOCATE 23, 41: PRINT "Enter number of the first file:"
    IF NumberOfFiles > 13 THEN NumberOfFiles = 13
    FOR I = 1 TO NumberOfFiles
      COLOR 14, 0: LOCATE I + 8, 50: PRINT I; ">  ";
      COLOR 13, 0: PRINT files$(I)
    NEXT I
    cl% = 0 + 128 XOR 3
    choice$ = iinkey$(2, 23, 74, cl%)
    I = VAL(choice$)
    IF I > 0 AND I <= NumberOfFiles THEN file1$ = files$(I)
    icon 310, 303, 300, 22, 8, 15, 3, 0
    cl = 4 + 128 XOR 3: COLOR cl
    LOCATE 23, 40: PRINT "Enter number of the second file:"
    cl% = 0 + 128 XOR 3
    choice$ = iinkey$(2, 23, 74, cl%)
    I = VAL(choice$)
    IF I > 0 AND I <= NumberOfFiles THEN file2$ = files$(I)
    IF file1$ <> file2$ THEN
      IF file2$ <> "" THEN mergein file1$, file2$
    END IF
    icon 310, 303, 300, 22, 8, 15, 3, 0
    cl = 4 + 128 XOR 3: COLOR cl
    LOCATE 23, 41: PRINT "Care to merge two more?"
    DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ <> ""
    LINE (307, 95)-(612, 298), 0, BF
    openwindow 1: winopen$ = "No"
    IF choice$ = "Y" THEN GOTO merge
ELSE
  disperrmsg " No .DEV files found", ""
END IF
COLOR 14, 0: LOCATE 16, 8: PRINT " Make A Selection  "
'
CASE "X"
IF winopen$ = "No" THEN openwindow 0: winopen$ = "Yes"
reginfo
'
CASE "H"
IF winopen$ = "No" THEN openwindow 0: winopen$ = "Yes"
helpscreen "T"

END SELECT
pushbutton "4", 150, 154, 1
END SUB

DEFSNG A-Z
SUB dochoice5 (doextra$)
pushbutton "5", 178, 183, 0
SELECT CASE winselect$
CASE "H"
IF winopen$ = "No" THEN openwindow 0: winopen$ = "Yes"
helpscreen "X"
END SELECT
pushbutton "5", 178, 182, 1
END SUB

DEFINT A-Z
SUB dochoiceC
IF Exists("device.con") THEN EXIT SUB
mousepointer 0
file$ = "Device.Doc"
IF Exists(file$) THEN
  nz = DRAWSTR(0, "Please Wait!", 83, 210, 14, 0, 8)
  conv
  LINE (330, 13)-(400, 28), 3, BF
  LINE (39, 210)-(223, 224), 0, BF
  GET (60, 13)-(560, 27), menubar
ELSE
  errorwarning2 file$, soundx%
  LINE (39, 210)-(223, 224), 0, BF
END IF
mousepointer 1
END SUB

DEFSNG A-Z
SUB doedit (top%, bottom%)
DEFINT A-Z
mousepointer 0
cnt = 1
LINE (15, 11)-(395, 29), 3, BF
cl = 4 + 128 XOR 3
COLOR cl: LOCATE 2, 6
PRINT "Device number to remove, `0' to Exit: "

DO                                               'get input
  cl = 0 + 128 XOR 3
  texty$ = iinkey$(3, 2, 46, cl)                 'one to exit
  IF texty$ = "0" THEN EXIT DO
  FOR x = 1 TO 24
    IF MID$(hold(x), 9, LEN(texty$)) = texty$ THEN hold(x) = "": pick%(x) = 0: x = 24
  NEXT x
  clt = 14 + 128 XOR 1: COLOR clt
  LINE (10, 43)-(628, 323), 1, BF
  v = 4                      'dispays to screen
  FOR x = top TO bottom
    LOCATE v, 5
    IF LEFT$(hold(x), 1) = "D" THEN PRINT hold(x): v = v + 1
  NEXT x
  cnt = 1
LOOP
sortit "D"
pickcnt% = 0
FOR x = 1 TO 24
  IF pick%(x) <> 0 THEN pickcnt% = pickcnt% + 1
NEXT
sortit "A"
top = 0
END SUB

SUB domenu (choice$, winselect$, winopen$)
x = INSTR("TDPCXH", choice$)
IF x = 0 THEN EXIT SUB
mousepointer 0
LINE (37, 60)-(225, 202), 0, BF     'blanks windo
LINE (39, 210)-(223, 224), 0, BF
SELECT CASE choice$
  CASE "T"
    title$ = "PrinT": x = 8 * 8
    GOSUB begin
    nz = DRAWSTR(0, "  Print Picklist", 60, 70, 10, 0, 8)
    nz = DRAWSTR(0, "Print Device Names", 60, 97, 10, 0, 8)
    nz = DRAWSTR(0, "Print a .DEV  file", 60, 124, 10, 0, 8)
    nz = DRAWSTR(0, "Make A Selection", 67, 210, 14, 0, 8)
  CASE "D"
    title$ = "Devices": x = 18 * 8
    GOSUB begin
    nz = DRAWSTR(0, "   Search by Text", 52, 70, 10, 0, 8)
    nz = DRAWSTR(0, "  Search by  Price", 52, 97, 10, 0, 8)
    nz = DRAWSTR(0, " List Device Names", 56, 124, 10, 0, 8)
    nz = DRAWSTR(0, "Merge two .DEV Files", 52, 153, 10, 0, 8)
    nz = DRAWSTR(0, "Make A Selection", 67, 210, 14, 0, 8)
  CASE "P"
    title$ = "Picklist": x = 29 * 8
    GOSUB begin
    nz = DRAWSTR(0, "View/Edit  List", 68, 70, 10, 0, 8)
    nz = DRAWSTR(0, "Make Macro", 88, 97, 10, 0, 8)
    nz = DRAWSTR(0, "Save  List", 88, 124, 10, 0, 8)
    nz = DRAWSTR(0, "Erase List", 88, 153, 10, 0, 8)
    nz = DRAWSTR(0, "Pick An Option", 75, 210, 14, 0, 8)
  CASE "C"
    IF NOT Exists("device.con") THEN
      title$ = "Convert": x = 42 * 8
      GOSUB begin
    END IF
  CASE "X"
    title$ = "Xtras": x = 54 * 8
    GOSUB begin
    nz = DRAWSTR(0, "  Exit  UUDEVICE", 60, 70, 10, 0, 8)
    nz = DRAWSTR(0, "   Shell To DOS", 60, 97, 10, 0, 8)
    nz = DRAWSTR(0, "Configuration  Menu", 56, 124, 10, 0, 8)
    nz = DRAWSTR(0, " Registration Info", 56, 153, 10, 0, 8)
    nz = DRAWSTR(0, "Pick An Option", 75, 210, 14, 0, 8)
  CASE "H"
    title$ = "Help": x = 65 * 8
    GOSUB begin
    nz = DRAWSTR(0, " Print", 104, 70, 10, 0, 8)
    nz = DRAWSTR(0, "Devices", 104, 97, 10, 0, 8)
    nz = DRAWSTR(0, "Picklist", 100, 124, 10, 0, 8)
    nz = DRAWSTR(0, "Convert", 104, 153, 10, 0, 8)
    nz = DRAWSTR(0, " Xtras", 104, 180, 10, 0, 8)
    nz = DRAWSTR(0, "Choose A Topic", 75, 210, 14, 0, 8)
END SELECT
mousepointer 1
EXIT SUB
'
begin:
PUT (60, 13), menubar, PSET
nz = DRAWSTR(0, title$, x, 14, 14, 3, 8)
winselect$ = choice$
IF winopen$ = "Yes" THEN openwindow 1: winopen$ = "No" 'closes windo if open
RETURN
END SUB

SUB dopick (pickcnt%)
REDIM bg(5800)
mousepointer 0
v = 125: ht = 100
h = 210: wd = 220
GET (h, v)-(h + wd, v + ht), bg
drawbox h, v, wd, ht
cl = 4 + 128 XOR 7: COLOR cl
LOCATE 13, 32: PRINT "Enter the device #"
cl = 8 + 128 XOR 7: COLOR cl
LOCATE 12, 32: PRINT "Total in list:"
cl = 14 + 128 XOR 7: COLOR cl
LOCATE 12, 47: PRINT pickcnt%
cl% = 0 + 128 XOR 7
pic$ = iinkey$(3, 14, 40, cl%)
PUT (h, v), bg, PSET
ERASE bg
amt = VAL(pic$)
IF amt < 1 OR amt > 500 THEN amt = 0
IF amt <> 0 AND pickcnt% < 24 THEN
  pickcnt% = pickcnt% + 1: pick%(pickcnt%) = amt
END IF
mousepointer 1
END SUB

DEFSNG A-Z
SUB doprint (file$)
IF printerready THEN                   'and printr then print
  OPEN "I", 2, file$
  OPEN linport$ FOR OUTPUT AS #3
  DO
    LINE INPUT #2, line$
    PRINT #3, line$
    IF EOF(2) THEN EXIT DO
  LOOP
  PRINT #3, ""
ELSE                                  'if file exist but no printer
  disperrmsg "  Printer not ready  ", "                    "
END IF
END SUB

DEFINT A-Z
SUB drawbox (h, v, wd, ht)
cubeit h, v, wd, ht, 15, 8, 7
icon h + 30, v + 22, wd - 60, ht - 44, 15, 8, 7, 1
LINE (h + 10, v + 10)-(h + wd - 10, v + ht - 10), 8, B
PAINT (h + 12, v + 12), zig$, 8
LINE (220, 215)-(420, 215), 15
LINE -(420, 135), 15
END SUB

SUB drawscreen
SCREEN 9, , 0, 1                     'draws to background
PALETTE 6, 62
PALETTE 13, 39
PALETTE 9, 51
'
openscreen
'
IF Exists("UUdev.gfx") THEN file$ = "UUdev.gfx"
IF file$ <> "" THEN                  'opens graphic
  REDIM plak2(1 TO 8400)
  DEF SEG = VARSEG(plak2(1))
  BLOAD file$, VARPTR(plak2(1))
  DEF SEG
  PUT (37, 59), plak2, PSET
END IF
LINE (35, 58)-(227, 204), 7, B
LINE (36, 59)-(226, 203), 7, B
'
titles
'
FOR x% = 58 TO 320 STEP 15
  icon 307, x%, 305, 14, 15, 8, 7, 0
  PSET (307, x%): DRAW "c8 d14"
NEXT x%
nz = DRAWSTR(0, "Version 2.1", 87, 210, 14, 0, 8)
SCREEN 9, , 0, 0
END SUB

SUB drawsearch
mousepointer 0
SCREEN , , 0, 1
CLS
cubeit 0, 4, 640, 32, 15, 8, 7      'menubar
cubeit 0, 37, 640, 295, 15, 8, 7    'main back
icon 5, 42, 630, 285, 8, 15, 1, 0
IF regit = 0 THEN x = 500 ELSE x = 390
icon 10, 10, x, 20, 8, 15, 3, 0
icon 545, 10, 30, 20, 15, 8, 7, 1    'arrows
icon 585, 10, 30, 20, 15, 8, 7, 1
IF regit = 1 THEN
  icon 480, 10, 55, 20, 15, 8, 7, 1
  icon 415, 10, 55, 20, 15, 8, 7, 1
  nz = DRAWSTR%(0, "Page Up", 420, 13, 4, 7, 6)
  nz = DRAWSTR%(0, "Page Dn", 485, 13, 4, 7, 6)
END IF
LINE (550, 15)-(570, 15), 14
LINE -(560, 25), 14
LINE -(550, 15), 14
PAINT (555, 18), 5, 14
LINE (590, 25)-(610, 25), 14
LINE -(600, 15), 14
LINE -(590, 25), 14
PAINT (595, 23), 5, 14
SCREEN , , 0, 0
END SUB

SUB errorwarning (tempfil$, orig$)
IF winopen$ = "Yes" THEN LINE (308, 58)-(612, 327), 0, BF ELSE openwindow 0: winopen$ = "Yes"
  COLOR 12, 0: LOCATE 6, 53: PRINT "* WARNING *"
  LOCATE 7, 53: PRINT "อออออออออออ"
  LOCATE 10, 53: PRINT "อออออออออออ"
  x = LEN(tempfil$): x = ((40 - x) / 2) + 38
  COLOR 14, 0: LOCATE 8, x: PRINT tempfil$
  COLOR 15, 0: LOCATE 9, 40: PRINT "  Invalid filename/No such database "
  COLOR 11, 0
  LOCATE 12, 40: PRINT "You are trying to read the file above"
  LOCATE 13, 40: PRINT "which can not be found.  1) Make sure"
  LOCATE 14, 40: PRINT "you have access to UUDEVICE directory"
  LOCATE 15, 40: PRINT "where your  database files are stored"
  LOCATE 16, 40: PRINT " 2)  See that the file exists.  3) If"
  LOCATE 17, 40: PRINT "the file doesn'exist then you may not"
  LOCATE 18, 40: PRINT "have  created  a database  compatible"
  LOCATE 19, 40: PRINT "with UUDEVICE. Run the CONVERT option"
  LOCATE 20, 40: PRINT "from the main menu first."
IF soundx% = 1 THEN sondfx 1
END SUB

SUB errorwarning2 (tempfil$, soundx%)
IF winopen$ = "Yes" THEN LINE (308, 58)-(612, 327), 0, BF
IF winopen$ = "No" THEN openwindow 0: winopen$ = "Yes"
mousepointer 0
COLOR 12, 0: LOCATE 6, 52: PRINT "* WARNING *"
LOCATE 7, 52: PRINT "อออออออออออ"
LOCATE 9, 52: PRINT "อออออออออออ"
x = LEN(tempfil$): x = ((40 - x) / 2) + 38
COLOR 14, 0: LOCATE 8, x: PRINT tempfil$
COLOR 15, 0
LOCATE 11, 40: PRINT "    The above file cannot be found!"
COLOR 11, 0
LOCATE 13, 40: PRINT " To run UUDEVICE and convert the file"
LOCATE 14, 40: PRINT "DEVICE.DOC  to  a  format  compatible"
LOCATE 15, 40: PRINT "with  UUDEVICE,  the DEVICE.DOC  file"
LOCATE 16, 40: PRINT "must be in the current directory."
LOCATE 18, 40: PRINT "  You will also get this  error  when"
LOCATE 19, 40: PRINT "UUDEVICE  can't locate the  database."
LOCATE 20, 40: PRINT "Shell to DOS to change directories if"
LOCATE 21, 40: PRINT "need be."
IF soundx% = 1 THEN sondfx 1
mousepointer 1
END SUB

DEFSNG A-Z
SUB errorwarning3
IF winopen$ = "Yes" THEN LINE (308, 58)-(612, 327), 0, BF ELSE openwindow 0: winopen$ = "Yes"
  COLOR 12, 0: LOCATE 6, 53: PRINT "* WARNING *"
  LOCATE 7, 53: PRINT "อออออออออออ"
  COLOR 15, 0: LOCATE 8, 40: PRINT "           Need DEVICE.NAM "
  COLOR 11, 0
  LOCATE 10, 41: PRINT "In order to use this option you"
  LOCATE 11, 41: PRINT "need to have the file DEVICE.NAM."
  LOCATE 13, 41: PRINT "To create the file  DEVICE.NAM, go"
  LOCATE 14, 41: PRINT "to the Main Menu and choose DEVICES"
  LOCATE 16, 41: PRINT "From the DEVICES menu, choose the:"
  LOCATE 17, 41: PRINT "SEARCH BY NAME option."
  LOCATE 19, 41: PRINT "That option will create the file if"
  LOCATE 20, 41: PRINT "you don't have it.  Then come back"
  LOCATE 21, 41: PRINT "and run this option again."
IF soundx% = 1 THEN sondfx 1
END SUB

SUB final
mousepointer 0
opensmall "O", soundx%, timin%
LINE (35, 286)-(228, 307), 7, BF
LINE (35, 285)-(228, 285), 15
COLOR 12, 0
LOCATE 20, 6: PRINT "  Delete .DEV files?"

icon 150, 289, 28, 15, 15, 8, 7, 1
icon 193, 289, 28, 15, 15, 8, 7, 1
nz = DRAWSTR%(0, "Y", 153, 290, 4, 7, 8)
nz = DRAWSTR%(0, "N", 199, 290, 4, 7, 8)
nz = DRAWSTR%(0, "es", 161, 290, 0, 7, 8)
nz = DRAWSTR%(0, "o", 207, 290, 0, 7, 8)
nz = DRAWSTR%(0, "Default (No)", 46, 290, 0, 7, 8)
mousepointer 1
IF soundx% = 1 THEN sondfx 2          'PLAY "l12 o4 b b b"
DO
  choice$ = INKEY$
  mouseget
LOOP UNTIL choice$ <> "" OR mouseb% <> 0
IF mouseh% > 20 AND mouseh% < 24 AND mousev% > 36 AND mousev% < 40 THEN choice$ = "Y"
IF Exists("*.dev") THEN
 IF choice$ = "Y" OR choice$ = "y" THEN KILL "*.dev"
END IF
END SUB

SUB getmousechoice (choice$)
IF mousev% < 4 AND mouseb% <> 0 THEN                   'check for top bar
  IF mouseh% > 8 AND mouseh% < 15 THEN choice$ = "T"
  IF mouseh% > 17 AND mouseh% < 27 THEN choice$ = "D"
  IF mouseh% > 28 AND mouseh% < 40 THEN choice$ = "P"
  IF mouseh% > 41 AND mouseh% < 52 THEN choice$ = "C"
  IF mouseh% > 53 AND mouseh% < 63 THEN choice$ = "X"
  IF mouseh% > 64 AND mouseh% < 73 THEN choice$ = "H"
ELSEIF mouseb% <> 0 THEN   'check for #
  IF mouseh% > 9 AND mouseh% < 36 THEN
    IF mousev% = 6 OR mousev% = 7 THEN choice$ = "1"
    IF mousev% = 8 OR mousev% = 9 THEN choice$ = "2"
    IF mousev% = 10 OR mousev% = 11 THEN choice$ = "3"
    IF mousev% = 12 OR mousev% = 13 THEN choice$ = "4"
    IF mousev% = 14 OR mousev% = 15 THEN choice$ = "5"
  END IF
END IF
END SUB

DEFINT A-Z
FUNCTION iinkey$ (max%, Row%, col%, fore)
CONST yes = 1, NO = 0, ENTER = &HD, BS = 8
hor = col% * 8 - 8
LOCATE Row%, col%
COLOR fore
DO
  DO
    k$ = INKEY$
  LOOP UNTIL k$ <> ""

  IF LEN(k$) = 2 THEN
    Extend% = yes
    k% = ASC(RIGHT$(k$, 1))
  ELSE
    Extend% = NO
    k% = ASC(k$)
  END IF
  IF (Extend% = NO) AND k% = ENTER OR k% = 27 THEN
    iinkey$ = I$: EXIT FUNCTION
  ELSEIF (Extend% = NO) AND (k% = BS) AND (Le% > 0) AND (CurPos% > 0) THEN
    Work1$ = LEFT$(I$, CurPos% - 1)
    Work2$ = RIGHT$(I$, Le% - CurPos%)
    I$ = Work1$ + Work2$
    CurPos% = CurPos% - 1
    Le% = Le% - 1
    LOCATE Row%, col%, 1
    IF max% = 2 THEN LINE (583, 305)-(607, 322), 3, BF
    IF max% = 3 AND col% <> 46 THEN LINE (hor, 180)-(hor + 30, 196), 7, BF
    IF max% = 19 OR max% = 10 OR col% = 46 THEN
      IF regit = 0 THEN x = 495 ELSE x = 385
      LINE (hor, 13)-(x, 26), 3, BF       '16
    END IF
    PRINT I$ + SPACE$(1);
    LOCATE Row%, col% + CurPos%
  ELSEIF (Extend% = NO) AND (k% > 31) AND (k% < 127) AND (Le% < max%) THEN
    Work1$ = LEFT$(I$, CurPos%)
    Work2$ = RIGHT$(I$, Le% - CurPos%)
    I$ = Work1$ + CHR$(k%) + Work2$
    Le% = Le% + 1
    CurPos% = CurPos% + 1
    IF max% = 2 THEN LINE (583, 305)-(607, 322), 3, BF
    IF max% = 3 AND col% <> 46 THEN LINE (hor, 180)-(hor + 30, 196), 7, BF
    IF max% = 19 OR max% = 10 OR col% = 46 THEN
      IF regit = 0 THEN x = 495 ELSE x = 385
      LINE (hor, 13)-(x, 26), 3, BF       '16
    END IF
    LOCATE Row%, col%, 1
    PRINT I$;
    LOCATE Row%, col% + Le%
  ELSE
    BEEP
  END IF
LOOP
END FUNCTION

SUB init
'------ check see if graphic card OK
IF NOT EGAVIDEO% THEN
  CLS : BEEP
  PRINT "Sorry, EGA graphic card required to run UUDEVICE."
  END
END IF
SCREEN 0
'-------- get screen colors
SHELL "CLS"
DEF SEG = &HB800
dosclr = PEEK(1)
dosfg = dosclr AND 15
dosbg = (dosclr \ 16) AND 7
DEF SEG
'--------------- get registration name
regit = 0
file$ = "register.key"
IF Exists(file$) THEN
  OPEN "i", 1, file$
  LINE INPUT #1, regname$
  LINE INPUT #1, key1$
  key$ = "willhenry"
  CALL Crypt(regname$, key$, 10)
  IF key$ = key1$ THEN regit = 1
  CLOSE #1
END IF
IF regit = 0 THEN regname$ = "UNREGISTERED"
'--------------- get config
winopen$ = "No": soundx% = 1             'INIT MOUSE AND VARIABLES
linport$ = "LPT1": anim$ = "386": a% = 5
IF Exists("UUDEV.CFG") THEN
  OPEN "I", #1, "UUDEV.cfg"
  INPUT #1, a%, soundx%, linport$, anim$
  CLOSE #1
END IF
timin% = 120
IF anim$ = "286" THEN timin% = 4
IF anim$ = "386" THEN timin% = 40
'---------- drawscreen
drawscreen
temp$ = "Licensed: " + regname$
x = ((237 - (LEN(temp$) * 8)) / 2) + 36
nz% = DRAWSTR%(0, temp$, x, 318, 1, 11, 8)
END SUB

SUB loadarray (num$, h, v, x)
IF Exists("device.con") THEN        'need this to load
  REDIM text1(1 TO 1300) AS STRING * 76
  REDIM text2(1 TO 1300) AS STRING * 76
  reading = 1: avail = 1
  DO
    cnt = cnt + 1
    line$ = BufIn$("device.con", done, reading)
    IF cnt < 1301 THEN text1(cnt) = line$
    IF cnt > 1300 THEN text2(cnt - 1300) = line$
  LOOP UNTIL done
ELSE
  errorwarning "Device.Con", orig$
  pushbutton num$, h, v, x
END IF
END SUB

SUB mergein (file1$, file2$)

a = INSTR(file1$, ".")
file1$ = LEFT$(file1$, a - 1)
a = INSTR(file2$, ".")
file2$ = LEFT$(file2$, a - 1)
NAME file1$ + ".dev" AS file1$ + ".old"
NAME file2$ + ".dev" AS file2$ + ".old"
CLOSE
OPEN "I", 1, file1$ + ".old"
OPEN "I", 2, file2$ + ".old"
OPEN "O", 3, file1$ + ".dev"

DO
  LINE INPUT #1, line$
LOOP UNTIL MID$(line$, 8, 1) = "#"
DO
  LINE INPUT #2, line2$
LOOP UNTIL MID$(line2$, 8, 1) = "#"
file1 = VAL(MID$(line$, 9, 3))
file2 = VAL(MID$(line2$, 9, 3))

DO
  IF file1 > file2 THEN
    PRINT #3, line2$
    DO
      LINE INPUT #2, line2$
      IF EOF(2) THEN EXIT DO
      IF MID$(line2$, 8, 1) <> "#" THEN PRINT #3, line2$
    LOOP UNTIL MID$(line2$, 8, 1) = "#"
    IF NOT EOF(2) THEN file2 = VAL(MID$(line2$, 9, 3)) ELSE file2 = 501
  ELSE
    PRINT #3, line$
    DO
      LINE INPUT #1, line$
      IF EOF(1) THEN EXIT DO
      IF MID$(line$, 8, 1) <> "#" THEN PRINT #3, line$
    LOOP UNTIL MID$(line$, 8, 1) = "#"
    IF NOT EOF(1) THEN file1 = VAL(MID$(line$, 9, 3)) ELSE file1 = 501
  END IF
LOOP UNTIL file1 = 501 AND file2 = 501
CLOSE
KILL "*.old"
END SUB

DEFSNG A-Z
SUB MouseArea (y1%, y2%, min%, max%)
 '** Define area for mouse movement, y1% thru y2%
IF nomouse% THEN EXIT SUB
inregs.ax = 8
inregs.cx = y1% * 8 - 8
inregs.dx = y2% * 8 - 8
CALL INTERRUPTX(&H33, inregs, outregs)
inregs.ax% = &H7
inregs.cx% = min%
inregs.dx% = max%
CALL INTERRUPTX(&H33, inregs, outregs)
END SUB

SUB mouseget
IF nomouse% THEN EXIT SUB
inregs.ax = 3
CALL INTERRUPTX(&H33, inregs, outregs)
mouseb% = outregs.bx
mouseh% = outregs.cx / 8 + 1
mousev% = outregs.dx / 14 + 1
END SUB

SUB mouseinit
 inregs.ax = 0                  '** Mouse initialization
 CALL INTERRUPTX(&H33, inregs, outregs)
 IF outregs.ax = 0 THEN nomouse% = 1: EXIT SUB   '*** no mouse driver
 inregs.ax = 10                 '** Mouse should blink
 inregs.bx = 0
 inregs.cx = &HFFFF
 inregs.dx = &HFF00
 CALL INTERRUPTX(&H33, inregs, outregs)
END SUB

SUB mousepointer (OnOff%)
IF nomouse% THEN EXIT SUB
IF OnOff% = 0 THEN OnOff% = 2 ELSE OnOff% = 1
inregs.ax = OnOff%
CALL INTERRUPTX(&H33, inregs, outregs)
IF OnOff% = 1 THEN CALL INTERRUPTX(&H33, inregs, outregs) '** to be sure
END SUB

SUB mousespeed (Speed%)
 IF nomouse% THEN EXIT SUB
 inregs.ax = 15
 inregs.cx = Speed%
 inregs.dx = Speed% * 2
 CALL INTERRUPTX(&H33, inregs, outregs)
END SUB

DEFINT A-Z
SUB openscreen
cubeit 0, 4, 640, 32, 15, 8, 7     'menubar
icon 20, 10, 600, 20, 8, 15, 3, 0    'menubar
cubeit 0, 37, 640, 310, 15, 8, 15    'main back
LINE (4, 40)-(637, 344), 7, B
metal pattern$
PAINT (7, 44), pattern$, 7
icon 25, 49, 213, 190, 15, 8, 7, 0    'question window edge
cubeit 32, 55, 198, 176, 8, 15, 0    'question window
icon 35, 205, 192, 23, 7, 7, 7, 0   '    ""
icon 37, 207, 188, 19, 8, 15, 0, 0   '    ""
LINE (35, 205)-(227, 205), 15
FOR x = 66 TO 200 STEP 28
  icon 249, x, 27, 21, 15, 8, 7, 1     'choice buttons
NEXT x
icon 297, 49, 324, 286, 15, 8, 7, 0    'display window
cubeit 304, 55, 311, 275, 8, 15, 0     'display window
icon 31, 313, 247, 22, 15, 8, 7, 0           'bbsname
icon 34, 315, 241, 18, 8, 15, 11, 0          'bbsname
cubeit 241, 217, 21, 70, 15, 8, 7            'input window
icon 245, 222, 13, 60, 8, 15, 7, 0
icon 247, 224, 9, 56, 15, 8, 9, 0
cubeit 273, 217, 21, 70, 15, 8, 7            'output window
icon 277, 222, 13, 60, 8, 15, 7, 0
icon 279, 224, 9, 56, 15, 8, 9, 0
icon 25, 248, 213, 63, 15, 8, 7, 0      'bottom window
icon 29, 251, 205, 57, 8, 15, 7, 0
LINE (129, 252)-(130, 307), 8, B         'bottom halfs of window
LINE (131, 252)-(132, 307), 15, B
END SUB

SUB openwindow (sw)
mousepointer 0
IF soundx% = 1 THEN
  PLAY "mb l32 o0 ccccc": IF timin% > 99 THEN PLAY "cccccc"
END IF
IF sw = 1 THEN                        'close
  FOR x% = 58 TO 320 STEP 15
    icon 307, x%, 305, 14, 15, 8, 7, 0
    PSET (307, x%): DRAW "c8 d14"
    FOR y = 1 TO timin%: NEXT y
  NEXT x%
ELSE
  FOR x% = 313 TO 58 STEP -15          'open or erase
    icon 307, x%, 305, 14, 0, 0, 0, 0
    FOR y = 0 TO timin%: NEXT y
  NEXT x%
END IF
END SUB

SUB readdir (cnt, search$, files$())
found$ = DIR$(search$)
IF LEN(found$) THEN
  files$(1) = found$: cnt = 2
  DO WHILE LEN(found$)
    found$ = DIR$("")
    files$(cnt) = found$
    cnt = cnt + 1: IF cnt = 15 THEN EXIT DO
  LOOP
END IF
cnt = cnt - 2
END SUB

DEFSNG A-Z
SUB reginfo
COLOR 10, 0: LOCATE 6, 49: PRINT " REGISTRATION INFO"
COLOR 11, 0
LOCATE 8, 41: PRINT "If you like what you see here,and"
LOCATE 9, 41: PRINT "you're not the registered owner,"
LOCATE 10, 41: PRINT "you can still get in on the many"
LOCATE 11, 41: PRINT "benefits offered to our registered"
LOCATE 12, 41: PRINT "users."
COLOR 13, 0
LOCATE 14, 41: PRINT "   * Your own copy of UUDEVICE *"
LOCATE 15, 41: PRINT "     * No Shareware Screens *"
LOCATE 16, 41: PRINT "  * Hints and Strategies for UU *"
COLOR 9, 0
LOCATE 19, 41: PRINT "       Send $8 plus $3 S/H to:"
LOCATE 20, 41: PRINT "            Will Boyett"
LOCATE 21, 41: PRINT "          11955 209th St."
LOCATE 22, 41: PRINT "        Lakewood, CA 90715"
END SUB

SUB restorescreen (which$, winselect$, winopen$)
DEFINT A-Z
mousepointer 0
SCREEN , , 0, 1                     'draws to background
openscreen
LINE (35, 58)-(227, 204), 7, B
LINE (36, 59)-(226, 203), 7, B
temp% = soundx%: soundx% = 0
openwindow 1
titles
domenu which$, winselect$, winopen$
SCREEN , , 0, 0
soundx% = temp%
mousepointer 1
END SUB

SUB scrolltext (size, sw$)
top = 1: bottom = 20
pixy = 28: cl1 = 1 + 128 XOR 4

FOR offset = top TO bottom
  pixy = pixy + 14
  IF MID$(hold(offset), 6, 3) = "e #" THEN cl = 14 ELSE cl = 15
  nz = DRAWSTR%(0, hold(offset), 32, pixy, cl, 1, 8)
NEXT offset
DO                                         'gets key press
  mousepointer 1
  DO                                       'main loop
    mouseget
    choice$ = UCASE$(INKEY$)
  LOOP UNTIL k% <> mouseb% OR choice$ <> ""
  IF choice$ = CHR$(27) THEN EXIT DO         'exit
  IF mouseb% = 2 THEN choice$ = CHR$(0) + "R"
  IF mouseb% = 1 THEN
    IF mousev% = 2 OR mousev% = 3 THEN         'do a scroll
      SELECT CASE mouseh
	CASE 53 TO 60: choice$ = CHR$(0) + "I"
	CASE 62 TO 68: choice$ = CHR$(0) + "Q"
	CASE 69 TO 72: choice$ = CHR$(0) + "P"
	CASE 75 TO 78: choice$ = CHR$(0) + "H"
      END SELECT
    ELSE
      IF mousev% = 4 THEN mousev% = 5
      mousepointer 0
      COLOR cl1
      IF mousev% - 1 = l% THEN                   'if second mouse click
	LOCATE mousev% - 1, 3: PRINT STRING$(75, CHR$(219)): l% = 0
	mousepointer 1
	sel = (mousev% - 5) + top
	FOR x = 1 TO sel
	  IF MID$(hold(x), 6, 3) = "e #" THEN amt = VAL(MID$(hold(x), 9, 3))
	NEXT x
	IF amt <> 0 AND pickcnt% < 24 THEN
	  pickcnt% = pickcnt% + 1: pick%(pickcnt%) = amt
	END IF
	delay 9
      ELSE
	IF regit = 1 THEN
	  IF l% <> 0 THEN LOCATE l%, 3: PRINT STRING$(75, CHR$(219))
	  l% = mousev% - 1
	  LOCATE mousev% - 1, 3: PRINT STRING$(75, CHR$(219))
	  mousepointer 1
	  delay 9
	END IF
      END IF
    END IF
  END IF
  
  IF LEFT$(choice$, 1) = CHR$(0) THEN         'if its 2 length press
    IF RIGHT$(choice$, 1) = "R" THEN dopick pickcnt%
    IF RIGHT$(choice$, 1) = ";" AND winselect$ = "P" THEN doedit top, bottom
    IF RIGHT$(choice$, 1) = "Q" OR RIGHT$(choice$, 1) = "I" THEN
      IF regit <> 0 THEN
	l% = 0
	mousepointer 0
	IF RIGHT$(choice$, 1) = "Q" THEN top = top + 20: bottom = bottom + 20
	IF RIGHT$(choice$, 1) = "I" THEN top = top - 20: bottom = bottom - 20
	IF top >= size THEN top = size - 19: bottom = size
	IF top < 1 THEN top = 1: bottom = 20
	IF bottom > size THEN
	  IF size > 20 THEN bottom = size: top = size - 19
	END IF
	LINE (10, 43)-(628, 323), 1, BF
	pixy = 28
	FOR offset = top TO bottom
	  pixy = pixy + 14
	  IF MID$(hold(offset), 6, 3) = "e #" THEN cl = 14 ELSE cl = 15
	  nz = DRAWSTR%(0, hold(offset), 32, pixy, cl, 1, 8)
	NEXT offset
	mousepointer 1
      END IF
    END IF
    IF RIGHT$(choice$, 1) = "P" THEN                       'executes choicd
      offset = bottom + 1
      IF offset <= size THEN
	mousepointer 0
	IF l% <> 0 THEN LOCATE l%, 3: PRINT STRING$(75, CHR$(219)): l% = 0
	bottom = bottom + 1: top = top + 1
	WinScroll -1, 1, 3, 79, 22, 0, 1        'up
	IF MID$(hold(offset), 6, 3) = "e #" THEN cl = 14 ELSE cl = 15
	nz = DRAWSTR%(0, hold(offset), 32, 308, cl, 1, 8)
      END IF
    END IF
    IF RIGHT$(choice$, 1) = "H" THEN                     'executes choicd
      offset = top - 1
      IF offset > 0 THEN
	mousepointer 0
	IF l% <> 0 THEN LOCATE l%, 3: PRINT STRING$(75, CHR$(219)): l% = 0
	bottom = bottom - 1: top = top - 1: godwn = 8
	WinScroll 1, 1, 3, 79, 22, 0, 1          'down
	IF MID$(hold(offset), 6, 3) = "e #" THEN cl = 14 ELSE cl = 15
	nz = DRAWSTR%(0, hold(offset), 32, 42, cl, 1, 8)
      END IF
    END IF
  END IF
LOOP UNTIL top = 0
END SUB

SUB searchdev
'$DYNAMIC
DO
  REDIM ptr(1 TO 500)
  REDIM hold(1 TO 800) AS STRING * 75
  DO
    cl = 4 + 128 XOR 3: COLOR cl: LOCATE 2, 6
    PRINT "Text string to search: "
    cl = 0 + 128 XOR 3
    texty$ = iinkey$(10, 2, 30, cl)
    IF texty$ = "" THEN GOTO droptobottom
    IF LEN(texty$) < 3 THEN
      LINE (25, 12)-(395, 26), 3, BF
      LOCATE 2, 3: PRINT "Text to search for must be 3 characters or more"
      IF soundx% = 1 THEN sondfx 2
      SLEEP 1
      LINE (15, 12)-(395, 26), 3, BF
    END IF
  LOOP UNTIL LEN(texty$) > 2
  cnt = 1: spot = 1: temp = 0
  FOR x = 1 TO 2600                'finds devices taht pertain
    IF x < 1301 THEN
      IF MID$(text1(x), 6, 3) = "e #" THEN
	temp = VAL(MID$(text1(x), 9, 3))    'add device list here
	IF ptr(cnt) <> 0 THEN cnt = cnt + 1
      END IF
      IF INSTR(text1(x), texty$) AND ptr(cnt) <> temp THEN ptr(cnt) = temp
    ELSE                          'searches 2nd array
      IF MID$(text2(x - 1300), 6, 3) = "e #" THEN
	temp = VAL(MID$(text2(x - 1300), 9, 3))  'add device list here
	IF ptr(cnt) <> 0 THEN cnt = cnt + 1
      END IF
      IF INSTR(text2(x - 1300), texty$) AND ptr(cnt) <> temp THEN ptr(cnt) = temp
    END IF
  NEXT x
  CLOSE
entries = cnt - 1
temp$ = ""
IF regit = 0 THEN x = 67 ELSE x = 12: temp$ = "/DOUBLE CLICK LFT"
LINE (25, 12)-(395, 26), 3, BF
z = DRAWSTR(0, "ESC = Exit  INSERT/RGHT MOUSE" + temp$ + " = Select", x, 14, 0, 3, 7)

cnt = 1                           'loads descriptions in array
FOR x = 1 TO 2600
  IF x < 1301 THEN                     'checks array 1
    IF MID$(text1(x), 6, 3) = "e #" THEN
      IF ptr(spot) = VAL(MID$(text1(x), 9, 3)) THEN    'do this if wanted
	DO
	  IF cnt > 800 THEN x = 2601: EXIT DO
	  hold(cnt) = text1(x): x = x + 1: cnt = cnt + 1
	  IF x = 1301 THEN EXIT DO
	LOOP UNTIL MID$(text1(x), 6, 3) = "e #"
	x = x - 1: spot = spot + 1: cnt = cnt + 1
      END IF
    END IF
  ELSE
    IF MID$(text2(x - 1300), 6, 3) = "e #" THEN
      IF ptr(spot) = VAL(MID$(text2(x - 1300), 9, 3)) THEN
	DO
	  IF cnt > 800 THEN x = 2601: EXIT DO
	  hold(cnt) = text2(x - 1300): x = x + 1: cnt = cnt + 1
	  IF x > 2600 THEN EXIT DO
	LOOP UNTIL MID$(text2(x - 1300), 6, 3) = "e #"
	x = x - 1: spot = spot + 1: cnt = cnt + 1
      END IF
    END IF
   END IF
 NEXT
CLOSE
IF cnt > 800 THEN cnt = 800:  ELSE cnt = cnt - 1
IF entries = 0 THEN GOTO droptobottom
scrolltext cnt, winselect$
mousepointer 0
IF regit = 1 THEN x = 395 ELSE x = 495
LINE (12, 12)-(x, 26), 3, BF
cl = 4 + 128 XOR 3
COLOR cl: LOCATE 2, 8
PRINT "Save this group to disk   (y/N)?"
DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ <> ""
IF choice$ = "Y" THEN
  file$ = LEFT$(texty$, 8) + ".DEV"
  OPEN "o", 1, file$
  FOR x = 1 TO cnt
    PRINT #1, hold(x)
  NEXT x
  CLOSE
END IF

droptobottom:
LINE (12, 12)-(395, 26), 3, BF
cl = 4 + 128 XOR 3
COLOR cl: LOCATE 2, 8
PRINT "Care to do another search  (Y/n)?"
DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ <> ""
IF choice$ = "N" THEN EXIT DO
LINE (12, 12)-(395, 26), 3, BF
LINE (7, 43)-(630, 323), 1, BF
LOOP
END SUB

REM $STATIC
DEFSNG A-Z
SUB searchprice
DEFINT A-Z
DO
cl = 4 + 128 XOR 3
COLOR cl: LOCATE 2, 5
PRINT "Price Range:"
cl = 0 + 128 XOR 3
texty$ = iinkey$(19, 2, 19, cl)
temp$ = texty$
min! = INSTR(texty$, ">")
IF min! <> 0 THEN
  texty$ = RIGHT$(texty$, LEN(texty$) - min!)
  min! = INSTR(texty$, "<")
  IF min! = 0 THEN
     min! = VAL(texty$)
  ELSE
     min! = VAL(LEFT$(texty$, min!))
  END IF
END IF
max! = INSTR(temp$, "<")
IF max! <> 0 THEN
  temp$ = RIGHT$(temp$, LEN(temp$) - max!)
  temp! = max!
  max! = INSTR(temp$, ">")
  IF max! = 0 THEN
     max! = VAL(temp$)
  ELSE
     max! = VAL(LEFT$(temp$, max!))
  END IF
END IF

REDIM hold(800) AS STRING * 75
cnt = 0
FOR x = 1 TO 2200                'finds devices taht pertain
  IF x < 1101 THEN
    IF MID$(text1(x), 6, 3) = "e #" THEN
      temp = VAL(MID$(text1(x), 9, 3))     'dev num
      yes = INSTR(text1(x), ":")           'finds price
      price! = VAL(RIGHT$(text1(x), 76 - yes))
      IF price! >= min! THEN
	IF max! < min! THEN
	  tote = tote + 1
	  DO
	    cnt = cnt + 1
	    hold(cnt) = text1(x)
	    x = x + 1
	  LOOP UNTIL MID$(text1(x), 6, 3) = "e #" OR cnt >= 800 OR x >= 1100
	  cnt = cnt + 1: x = x - 1
	ELSE
	  IF price! <= max! THEN
	    tote = tote + 1
	    DO
	      cnt = cnt + 1
	      hold(cnt) = text1(x)
	      x = x + 1
	    LOOP UNTIL MID$(text1(x), 6, 3) = "e #" OR cnt = 800 OR x = 1100
	    IF cnt = 800 THEN x = 2201
	    cnt = cnt + 1: x = x - 1
	  END IF
	END IF
      END IF
    END IF
  ELSE
    IF MID$(text2(x - 1100), 6, 3) = "e #" THEN
      temp = VAL(MID$(text2(x - 1100), 9, 3))   'dev num
      yes = INSTR(text2(x - 1100), ":")         'finds price
      price! = VAL(RIGHT$(text2(x - 1100), 76 - yes))
      IF price! >= min! THEN
	IF max! < min! THEN
	  tote = tote + 1
	  DO
	    cnt = cnt + 1
	    hold(cnt) = text2(x - 1100)
	    x = x + 1
	  LOOP UNTIL MID$(text2(x - 1100), 6, 3) = "e #" OR cnt >= 800 OR x >= 2200
	  IF cnt = 800 THEN x = 2201
	  cnt = cnt + 1: x = x - 1
	ELSE
	  IF price! <= max! THEN
	    tote = tote + 1
	    DO
	      cnt = cnt + 1
	      hold(cnt) = text2(x - 1100)
	      x = x + 1
	    LOOP UNTIL MID$(text2(x - 1100), 6, 3) = "e #" OR cnt >= 800 OR x >= 2200
	    cnt = cnt + 1: x = x - 1
	 END IF
	END IF
      END IF
    END IF
  END IF
NEXT x
CLOSE

temp$ = ""
IF regit = 0 THEN x = 67 ELSE x = 12: temp$ = "/DOUBLE CLICK LFT"
LINE (25, 12)-(395, 26), 3, BF
z = DRAWSTR(0, "ESC = Exit  INSERT/RGHT MOUSE" + temp$ + " = Select", x, 14, 0, 3, 7)

IF cnt > 800 THEN cnt = 800
scrolltext cnt, winselect$
mousepointer 0
IF regit = 1 THEN x = 395 ELSE x = 495
LINE (12, 12)-(x, 26), 3, BF
cl = 4 + 128 XOR 3
COLOR cl: LOCATE 2, 8
PRINT "Save this group to disk   (y/N)?"
DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ <> ""
IF choice$ = "Y" THEN
  text$ = ""
  FOR cntr = 1 TO LEN(texty$)
    IF MID$(texty$, cntr, 1) = "<" THEN
      temp$ = "L"
    ELSEIF MID$(texty$, cntr, 1) = ">" THEN
      temp$ = "M"
    ELSE
      temp$ = MID$(texty$, cntr, 1)
    END IF
    text$ = text$ + temp$
  NEXT

  IF LEN(text$) > 7 THEN text$ = LEFT$(text$, 7)
  file$ = text$ + ".DEV"
  OPEN "o", 1, file$
  FOR x = 1 TO cnt
    PRINT #1, hold(x)
  NEXT x
  CLOSE
END IF

LINE (12, 12)-(395, 26), 3, BF
cl = 4 + 128 XOR 3
COLOR cl: LOCATE 2, 8
PRINT "Care to do another search  (Y/n)?"
DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ <> ""
IF choice$ <> "Y" THEN EXIT DO
LINE (12, 12)-(395, 26), 3, BF
LINE (7, 43)-(630, 323), 1, BF
LOOP
END SUB

DEFSNG A-Z
SUB sondfx (which%)
DEFINT A-Z
SELECT CASE which
 CASE 1
 'alarm
 PLAY "MB": x% = 0
 FOR x% = 1 TO 3
 FOR y% = 400 TO 500 STEP 5
   SOUND y%, .5
 NEXT y%
 NEXT x%

CASE 2
'another alarm
 PLAY "MB"
 FOR x% = 0 TO 50
 SOUND 3000, .08: SOUND 1000, .06: SOUND 2000, .05
 NEXT x%
 PLAY "MF": SOUND 40, 0

CASE 4
'phaser or something
 FOR x = 1 TO 5
 SOUND 2000, .1: SOUND 1500, 1: SOUND 1000, 1: SOUND 500, 1: SOUND 250, 1
 NEXT x
END SELECT
END SUB

DEFSNG A-Z
SUB sortit (order$)
IF order$ = "D" THEN
  n% = pickcnt%
  FOR I = 1 TO n% - 1             'sort routine here
    FOR j = I + 1 TO n%
      IF pick%(I) < pick%(j) THEN SWAP pick%(I), pick%(j)
    NEXT j
  NEXT I
ELSE
  n% = pickcnt%
  FOR I = 1 TO n% - 1             'sort routine here
    FOR j = I + 1 TO n%
      IF pick%(I) > pick%(j) THEN SWAP pick%(I), pick%(j)
    NEXT j
  NEXT I
END IF
END SUB

DEFINT A-Z
SUB WinScroll (DR%, hor%, ver%, wd%, ht%, colw%, colt%)
 '*** scrolls the contents of a window up or down
 '** move up-(Dr%<0) or down-(Dr%>0)
 inregs.bx = &H1000 * colw% + &H100 * colt%
 inregs.cx = &H100 * ver% + hor%
 inregs.dx = inregs.cx + &H100 * ht% + wd% - &H303
 IF DR% < 0 THEN
  inregs.ax = &H600 - DR%            '*** Scroll up
 ELSE
  inregs.ax = &H700 + DR%            '*** Scroll down
 END IF
 CALL INTERRUPTX(&H10, inregs, outregs)
END SUB

