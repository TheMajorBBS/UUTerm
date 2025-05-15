DECLARE SUB edittext (rw%, clm%, choice$, text$, min%, max%)
DECLARE SUB disp3open ()
DECLARE SUB getcfg (file$)
DECLARE SUB savecfg ()
DECLARE SUB inbar (prompt$, sel$, lenofinput%, txtclr%, fg%, bg%, x%)
DECLARE FUNCTION Iinkey$ (max%, row%, col%, fore%, sw%)
DECLARE SUB initsb ()
DECLARE SUB disp2open ()
DECLARE SUB disp1open ()
DECLARE SUB disp (title$, cl%, row%)
DECLARE SUB windo (h%, v%, wd%, ht%, cl1%, cl2%, FILD%)
DECLARE SUB PutText2 (text$, TextColor%, BackColor%)
DECLARE SUB init (dosfg%, dosbg%)
DECLARE FUNCTION Exists% (filen$)
DECLARE FUNCTION inkey% (NoWait%, x%)
DECLARE FUNCTION BufIn$ (filename$, done%)
DECLARE FUNCTION DRAWSTR% (mode%, strg$, x0%, y0%, fg%, bg%, gap%)
DECLARE FUNCTION EGAVIDEO% ()
DECLARE FUNCTION grid$ ()
DECLARE FUNCTION zig$ ()
DECLARE FUNCTION zig2$ ()
DECLARE SUB cubeit (h%, v%, wd%, ht%, C1%, C2%, FILD%)
DECLARE SUB icon (h%, v%, wd%, ht%, C1%, C2%, FILD%, OUTIN%)
DECLARE SUB smallprint (spx%, spy%, sp$, spcolor%)
DECLARE SUB tinyfont (hor%, ver%, inline$, CLR%)
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
COMMON SHARED irq%, baud&, port, HS, snddev
COMMON SHARED spce, xmsflag, sbksiz, linport$, snd
COMMON SHARED Modem$, OffHook$, dial$, wate$, phone$()
'$DYNAMIC
REDIM SHARED menusav(1), phone$(1 TO 14)

init dosfg, dosbg
CLS
WIDTH 80, 25
disp1open   'press any key to start
IF NOT Exists("uuterm.cfg") THEN
  spce = 1: xmsflag = 0: sbksiz = 120: linport$ = "LPT1": snd = 1
  initsb     'gets snddev
  disp2open  'gets baud, hs,port,IRQ
  savecfg
END IF
file$ = "UUTdial.cfg"
IF Exists(file$) THEN
  getcfg file$   'gets dial configs
ELSE
  phone$(1) = "ATM0"
  phone$(2) = "ATH0"
  phone$(3) = "ATDT"
  phone$(4) = "35"
END IF
disp3open
row = 9: col = 31
DO
  LOCATE row, col: PutText2 "Û", 2, 1
  SLEEP
  DO
    choice$ = INKEY$
  LOOP UNTIL choice$ <> INKEY$
  SELECT CASE choice$
   CASE CHR$(0) + "H": GOSUB gup
   CASE CHR$(0) + "P": GOSUB gdown
   CASE CHR$(27): EXIT DO
   CASE ELSE
     SELECT CASE row
       CASE 9, 10, 11, 12
         rw = row - 8: min = 31: max = 62
       CASE IS > 14
         rw = row - 10
         IF col = 41 THEN
           rw = rw + 5: min = 41: max = 62
         ELSE
           min = 18: max = 31
         END IF
     END SELECT
     edittext row, col, choice$, phone$(rw), min, max
  END SELECT
LOOP
CLOSE
OPEN "O", 1, file$
PRINT #1, "  Modem Init String: " + phone$(1)
PRINT #1, "Modem Hangup String: " + phone$(2)
PRINT #1, "  Modem Dial String: " + phone$(3)
PRINT #1, "          Dial Time: " + phone$(4)
PRINT #1, "-------------------------- Phone Numbers"
PRINT #1, phone$(5) + ":" + phone$(10)
PRINT #1, phone$(6) + ":" + phone$(11)
PRINT #1, phone$(7) + ":" + phone$(12)
PRINT #1, phone$(8) + ":" + phone$(13)
PRINT #1, phone$(9) + ":" + phone$(14)
CLOSE
SCREEN 0
WIDTH 80, 25
COLOR dosfg, dosbg     'restore
END
'
gup:
    LOCATE row, col: PutText2 "Û", 2, 1
    row = row - 1
    IF row = 8 THEN row = 19: col = 41
    IF row = 14 THEN
      IF col = 41 THEN
        row = 19: col = 18
      ELSE
        row = 12: col = 31
      END IF
    END IF
RETURN
gdown:
    LOCATE row, col: PutText2 "Û", 2, 1
    row = row + 1
    IF row = 13 THEN
      row = 15: col = 18
    END IF
    IF row = 20 THEN
      IF col = 18 THEN
        row = 15: col = 41
      ELSE
       row = 9: col = 31
      END IF
    END IF
RETURN

REM $STATIC
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

SUB disp (title$, cl, row)
y = 40 - (LEN(title$) \ 2)
cl = cl + 128 XOR 7
COLOR cl: LOCATE row, y: PRINT title$
END SUB

SUB disp1open
SCREEN 9, , 0, 1
CLS
PAINT (317, 175), zig2$, 8
h = 132: v = 100
windo h, v, 359, 110, 15, 8, 7
SCREEN 9, , 0, 0
disp "WELCOME TO UUTERM'S SET-UP PROGRAM", 4, 9
nz = DRAWSTR%(0, "  Use this utility to configure your modem", h + 10, v + 30, 0, 7, 8)
nz = DRAWSTR%(0, "to work with UUTERM. Also use this utility", h + 10, v + 44, 0, 7, 8)
nz = DRAWSTR%(0, "whenever you wish to modify your dial list", h + 10, v + 58, 0, 7, 8)
disp "Press any key to continue..", 4, 14
x = inkey(0, 0)
PCOPY 0, 1
END SUB

SUB disp2open
  SCREEN 9, , 0, 1
  CLS
  PAINT (251, 101), zig$, 8
  windo 110, 70, 410, 140, 15, 8, 7
  SCREEN 9, , 0, 0
  disp "MODEM SETTINGS", 4, 7
  disp "Tell me a little bit about your modem. Is it:", 6, 9
  v = 110
nz = DRAWSTR%(0, "a 2400", 305, v + 30, 0, 7, 8)
nz = DRAWSTR%(0, "a 9600", 305, v + 44, 0, 7, 8)
nz = DRAWSTR%(0, "a 14.4", 305, v + 58, 0, 7, 8)
nz = DRAWSTR%(0, "a 28.8", 305, v + 72, 0, 7, 8)
FOR x = 1 TO 4
 nz = DRAWSTR%(0, STR$(x) + ">", 265, v + 30, 4, 7, 8)
 v = v + 14
NEXT x
DO: choice = inkey(0, 0): LOOP UNTIL choice > 48 AND choice < 53
  SELECT CASE choice
  CASE 49: HS = 0: baud& = 2400
  CASE 50: HS = 2: baud& = 9600
  CASE 51, 52: HS = 2: baud& = 19200
  END SELECT
  LINE (130, 100)-(500, 200), 7, BF
  disp "What Port is it connected to:", 6, 9
  v = 110
  nz = DRAWSTR%(0, "COM1", 313, v + 30, 0, 7, 8)
  nz = DRAWSTR%(0, "COM2", 313, v + 44, 0, 7, 8)
  nz = DRAWSTR%(0, "COM3", 313, v + 58, 0, 7, 8)
  nz = DRAWSTR%(0, "COM4", 313, v + 72, 0, 7, 8)
  FOR x = 1 TO 4
   nz = DRAWSTR%(0, STR$(x) + ">", 273, v + 30, 4, 7, 8)
   v = v + 14
  NEXT x
  DO: choice = inkey(0, 0): LOOP UNTIL choice > 48 AND choice < 53
  port = choice - 48
  SELECT CASE port
  CASE 1: irq = 4
  CASE 2: irq = 3
  CASE ELSE: irq = 5
  END SELECT
  LINE (130, 100)-(500, 200), 7, BF
  v = 110
  nz = DRAWSTR%(0, "By default, COM" + LTRIM$(STR$(port)) + " uses IRQ" + STR$(irq), 204, v, 6, 7, 8)
  nz = DRAWSTR%(0, "Shall we use this IRQ?", 224, v + 14, 6, 7, 8)
  v = 124
  nz = DRAWSTR%(0, "Yes", 317, v + 30, 0, 7, 8)
  nz = DRAWSTR%(0, "No", 317, v + 44, 0, 7, 8)
  FOR x = 1 TO 2
   nz = DRAWSTR%(0, STR$(x) + ">", 277, v + 30, 4, 7, 8)
   v = v + 14
  NEXT x
  DO: choice = inkey(0, 0): LOOP UNTIL choice > 48 AND choice < 51
  IF choice = 50 THEN
    LINE (130, 100)-(500, 200), 7, BF
    v = 110
    inbar "Enter the IRQ you wish to use: ", irq$, 2, 6, 4, 7, 0
    irq = VAL(irq$)
  END IF
PCOPY 0, 1
END SUB

SUB disp3open
SCREEN 9, , 0, 1
CLS
PAINT (251, 101), grid$, 8
windo 85, 41, 460, 266, 15, 8, 7
icon 231, 108, 273, 60, 8, 15, 1, 0
icon 131, 194, 122, 75, 8, 15, 1, 0
icon 308, 194, 198, 75, 8, 15, 1, 0
SCREEN 9, , 0, 0
PCOPY 0, 1
disp "DIAL  SETTINGS", 4, 5
nz = DRAWSTR%(0, "Here is where you configure your", 184, 72, 6, 7, 8)
nz = DRAWSTR%(0, "modem commands and phone numbers.", 184, 86, 6, 7, 8)
cl = 0 + 128 XOR 7: COLOR cl
 x = 15
LOCATE 9, x: PRINT "  Init String:"
LOCATE 10, x: PRINT "Hangup String:"
LOCATE 11, x: PRINT "  Dial String:"
LOCATE 12, x: PRINT "    Dial Time:"
nz = DRAWSTR%(0, "BBS Name", 160, 179, 0, 7, 7)
nz = DRAWSTR%(0, "Phone Number", 368, 179, 0, 7, 7)
nz = DRAWSTR%(0, "Hit <ESC> to Exit", 261, 285, 4, 7, 7)
clm = 112
FOR x = 1 TO 4
  nz = DRAWSTR%(0, phone$(x), 240, clm, 14, 1, 8)
  clm = clm + 14
NEXT x
clm = 196
FOR x = 5 TO 9
  nz = DRAWSTR%(0, phone$(x), 136, clm, 14, 1, 8)
  nz = DRAWSTR%(0, phone$(x + 5), 320, clm, 14, 1, 8)
  clm = clm + 14
NEXT x
END SUB

SUB edittext (rw, clm, choice$, text$, min, max)
vert = max * 8
DO
  SELECT CASE choice$
  CASE CHR$(8)                           'backspace
    rw1 = rw * 14 - 14
    LINE ((min - 1) * 8, rw1)-(vert, rw1 + 13), 1, BF
    IF clm = min THEN
      BEEP
      clm = clm + 1
    ELSE
      text$ = LEFT$(text$, (clm - min) - 1) + MID$(text$, (clm - min) + 1)
    END IF
    clm = clm - 1
    LOCATE rw, min: PutText2 text$, 14, 1
    LOCATE rw, clm: PutText2 "Û", 2, 1
  CASE CHR$(0) + "M"                        'right
    LOCATE rw, clm: PutText2 "Û", 2, 1
    clm = clm + 1
    IF clm > max THEN clm = max: BEEP
    LOCATE rw, clm: PutText2 "Û", 2, 1
  CASE CHR$(0) + "K"                        'left
    LOCATE rw, clm: PutText2 "Û", 2, 1
    clm = clm - 1
    IF clm < min THEN clm = min: BEEP
    LOCATE rw, clm: PutText2 "Û", 2, 1
  CASE CHR$(0) + "G"                        'home
    LOCATE rw, clm: PutText2 "Û", 2, 1
    clm = (clm - LEN(text$)) + 1
    IF clm < min THEN clm = min: BEEP
    IF clm > max THEN clm = max: BEEP
    LOCATE rw, clm: PutText2 "Û", 2, 1
  CASE CHR$(0) + "O"                        'end
    LOCATE rw, clm: PutText2 "Û", 2, 1
    clm = (LEN(text$) + clm) - 1
    IF clm > max THEN clm = max: BEEP
    IF clm < min THEN clm = min: BEEP
    LOCATE rw, clm: PutText2 "Û", 2, 1
  CASE ELSE
    IF choice$ > CHR$(31) AND choice$ < CHR$(123) THEN
      IF LEN(text$) + min > max THEN
        BEEP
      ELSE
        rw1 = rw * 14 - 14                               'if entering text
        LINE ((min - 1) * 8, rw1)-(vert, rw1 + 13), 1, BF
        z = (LEN(text$) + min) - clm
        IF z < 1 THEN temp$ = "" ELSE temp$ = RIGHT$(text$, z)
        text$ = LEFT$(text$, clm - min) + choice$ + temp$
        LOCATE rw, min: PutText2 text$, 14, 1
        clm = clm + 1
        IF clm > max THEN clm = max: BEEP
        LOCATE rw, clm: PutText2 "Û", 2, 1
      END IF
    END IF
    IF choice$ = CHR$(0) + "S" THEN 'AND ((LEN(text$) + 5) - clm) > -1 THEN
      rw1 = rw * 14 - 14                             'if deleting
      LINE ((min - 1) * 8, rw1)-(vert, rw1 + 13), 1, BF
      text$ = LEFT$(text$, clm - min) + MID$(text$, clm - min + 2)
      LOCATE rw, min: PutText2 text$, 14, 1
      LOCATE rw, clm: PutText2 "Û", 2, 1
    END IF
  END SELECT
  IF choice$ = CHR$(0) + "H" OR choice$ = CHR$(0) + "P" THEN EXIT DO
  choice$ = INKEY$
LOOP UNTIL choice$ = CHR$(27)
LOCATE rw, clm: PutText2 "Û", 2, 1
END SUB

SUB getcfg (file$)
  FOR x = 1 TO 4
    inline$ = BufIn$(file$, done)
    SELECT CASE x
      CASE 1: phone$(1) = MID$(inline$, 22)
      CASE 2: phone$(2) = MID$(inline$, 22)
      CASE 3: phone$(3) = MID$(inline$, 22)
      CASE 4: phone$(4) = MID$(inline$, 22)
    END SELECT
  NEXT x
  inline$ = BufIn$(file$, done)
  FOR x = 5 TO 9
    inline$ = BufIn$(file$, done)
    z = INSTR(inline$, ":")
    phone$(x) = LEFT$(inline$, z - 1)
    phone$(x + 5) = MID$(inline$, z + 1)
    IF done THEN x = 9
  NEXT x
END SUB

DEFSNG A-Z
FUNCTION grid$

'little metal pop up buttons
  pattern$ = CHR$(255) + CHR$(255) + CHR$(255) + CHR$(0)
  pattern$ = pattern$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(124)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(195) + CHR$(195) + CHR$(195) + CHR$(124)
  pattern$ = pattern$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(0)

grid$ = pattern$
END FUNCTION

DEFINT A-Z
FUNCTION Iinkey$ (max%, row%, col%, fore, sw)
CONST YES = 1, NO = 0, ENTER = &HD, bs = 8
LOCATE row%, col%
COLOR fore
DO
  DO
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
    LINE (sw, 138)-(sw + 30, 160), 7, BF
    PRINT I$ + SPACE$(1);
    LOCATE row%, col% + CurPos%
  ELSEIF (Extend% = NO) AND (K% > 31) AND (K% < 127) AND (Le% < max%) THEN
    Work1$ = LEFT$(I$, CurPos%)
    Work2$ = RIGHT$(I$, Le% - CurPos%)
    I$ = Work1$ + CHR$(K%) + Work2$
    Le% = Le% + 1
    CurPos% = CurPos% + 1
    LOCATE row%, col%, 1
    LINE (sw, 138)-(sw + 30, 160), 7, BF
    PRINT I$;
    LOCATE row%, col% + Le%
  ELSE
    BEEP
  END IF
LOOP
END FUNCTION

SUB inbar (prompt$, sel$, lenofinput%, txtclr%, fg%, bg%, x)
z = (LEN(prompt$) * 8) + ((lenofinput + 2) * 8)
z = (639 - z) / 2
y = (LEN(prompt$) * 8) + z
cl2 = fg + 128 XOR bg
nz = DRAWSTR%(0, prompt$, z, 140, txtclr, 7, 8)
nz = (y + 24) / 8
sel$ = Iinkey$(lenofinput, 11, nz, cl2, y)
END SUB

SUB init (dosfg, dosbg)
IF NOT EGAVIDEO% THEN
  CLS : BEEP
  PRINT "Sorry, EGA graphic card required to run SETUP.EXE."
  END
END IF
'--------  saves original pc colors
SCREEN 0
SHELL "CLS"
DEF SEG = &HB800
dosclr = PEEK(1)
dosfg = dosclr AND 15
dosbg = (dosclr \ 16) AND 7
DEF SEG
END SUB

SUB initsb
I = 1
DO UNTIL UCASE$(LEFT$(ENVIRON$(I), 8)) = "BLASTER="
  I = I + 1
  IF ENVIRON$(I) = "" THEN EXIT DO
LOOP
inline$ = UCASE$(ENVIRON$(I))
IF inline$ = "" THEN
  snddev = 0
ELSE
  DaIrq = VAL(MID$(inline$, INSTR(8, inline$, "I") + 1, 2))
  DaType = VAL(MID$(inline$, INSTR(8, inline$, "T") + 1, 1))
  IF DaType = 4 THEN snddev = 5 ELSE snddev = 4
  IF DaIrq = 10 THEN snddev = 5
END IF
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

SUB savecfg
file$ = "UUTerm.cfg"
z = FREEFILE
  OPEN "O", #z, file$
  PRINT #z, snd%, spce, snddev
  PRINT #z, port%, HS, irq, baud&
  PRINT #z, xmsflag, sbksiz
  WRITE #z, linport$
CLOSE #z
END SUB

SUB windo (h, v, wd, ht, cl1, cl2, FILD)
REDIM menusav(1 TO 4096)
z = (v / 14) + 2
y = ((v + ht) / 14)
w = ((h + wd) / 8) + 1
x = (h / 8 + 1)
cl = 0 + 128 XOR 7: COLOR cl
LOCATE y + 1, x + 1: PRINT STRING$((w - x), CHR$(223))
FOR x = z TO y
  LOCATE x, w: PRINT CHR$(219)
NEXT x
cubeit h%, v%, wd%, ht%, cl1, cl2, FILD%
icon h% + 4, v% + 4, wd% - 8, ht% - 8, cl2, cl1, FILD%, 0
END SUB

DEFSNG A-Z
FUNCTION zig$
'metal zig-zag
pattern$ = CHR$(191) + CHR$(191) + CHR$(191) + CHR$(72)
pattern$ = pattern$ + CHR$(223) + CHR$(223) + CHR$(223) + CHR$(36)
pattern$ = pattern$ + CHR$(239) + CHR$(239) + CHR$(239) + CHR$(18)
pattern$ = pattern$ + CHR$(253) + CHR$(253) + CHR$(253) + CHR$(18)
pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(36)
pattern$ = pattern$ + CHR$(247) + CHR$(247) + CHR$(247) + CHR$(72)
zig$ = pattern$
END FUNCTION

FUNCTION zig2$
'zig-zag pattern
pattern$ = CHR$(224) + CHR$(111) + CHR$(127) + CHR$(239)
pattern$ = pattern$ + CHR$(112) + CHR$(183) + CHR$(191) + CHR$(247)
pattern$ = pattern$ + CHR$(56) + CHR$(219) + CHR$(223) + CHR$(251)
pattern$ = pattern$ + CHR$(56) + CHR$(219) + CHR$(223) + CHR$(251)
pattern$ = pattern$ + CHR$(112) + CHR$(183) + CHR$(191) + CHR$(247)
pattern$ = pattern$ + CHR$(224) + CHR$(111) + CHR$(127) + CHR$(239)
zig2$ = pattern$
END FUNCTION

