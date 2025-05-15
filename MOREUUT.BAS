DECLARE SUB emul (st$)
DECLARE SUB DoDirScreen (menusav%(), file$)
DECLARE SUB inbar (prompt$, sel$, lenofinput%, txtclr%, fg%, bg%, x%)
DECLARE SUB readdir ()
DECLARE SUB printstat (z%)
DECLARE SUB doGFX (sw$, file$, h%, v%, menusav%())
DECLARE SUB spacefx (wide%, deep%, top%, sw%)
DECLARE SUB soundfx (sw%)
DECLARE SUB QSORT (First%, Last%)
DECLARE SUB ScrnScroll (ULRow%, ULColumn%, LRRow%, LRColumn%, NumOfLines%, sw%)
DECLARE SUB doalarm (alarmsw%)
DECLARE SUB ermes (tp$, sw%)
DECLARE SUB dowindo (num%, cl1%, cl2%)
DECLARE SUB cubeit (h%, v%, WD%, HT%, C1%, C2%, FILD%)
DECLARE SUB icon (h%, v%, WD%, HT%, C1%, C2%, FILD%, OUTIN%)
DECLARE FUNCTION Exists% (filename$)
DECLARE FUNCTION DRAWSTR% (mode%, strg$, x0%, y0%, fg%, bg%, gap%)
DECLARE FUNCTION inkey% (NoWait%, x%)
DECLARE FUNCTION DIR$ (FileSpec$)
DECLARE FUNCTION CurDir$ ()
DECLARE FUNCTION BufIn$ (filename$, done%)
  DECLARE FUNCTION CarrierLost% CDECL ALIAS "_carrier_state" ()
  DECLARE SUB OpenComm CDECL ALIAS "_open_comm" (BYVAL port%, irq%, BYVAL Wlen%, BYVAL parity%, BYVAL baud&, BYVAL hs%, BYVAL FOSSIL%)
  DECLARE SUB closecomm CDECL ALIAS "_close_comm" ()
  DECLARE FUNCTION ReadChar% CDECL ALIAS "_readchar" ()
  DECLARE SUB transmit CDECL ALIAS "_transmit_string" (addr$)
  DECLARE FUNCTION DataWaiting% CDECL ALIAS "_data_waiting" ()
DECLARE FUNCTION ival% (number$)

DEFINT A-Z
COMMON SHARED snd%, snddev, xmsflag, maxline, alarmsw, alarm()
COMMON SHARED help() AS STRING * 76, spce, expr, device() AS STRING * 49
COMMON SHARED scrollback() AS STRING * 76

DATA Sort Device Bays, B,Empty A Bay,E,Switch Bays,J
DATA Use Device Bay,U,Use Device By #,V,Attack Ship,A, Deploy Mines,D
DATA Deploy Drones,F, Create Planet,G, Probe Planet,N,Land On Planet,L
DATA Quit UU,Q,Warp Menu,W, Team Menu,T, Computer Menu,C
DATA Scan Around,S,Redisplay Sector,R, Over Space Drive,O
DATA Move To A Sector,M, Port,P, Inventory,I,"",""
COMP:
DATA Ship Directory,G,Players Rankings,T,Lords Of Creation,L
DATA Universe Stats,I,Self Destruct,!,Determine Cpt,D,Terminate Cpt,K
DATA Locate Device By #,F, Device Search,M,Wait,W,ANSI,A
DATA Read News,N,Cloaking Report,B,Scan Remote Sect,S,UPS Delivery,U
DATA Access Radio,R,Reroute Sensors,X,Foolhardy Terms,O
DATA Export Ship,E,Make Amens,*,Expert Display,Y,Close Computer,Q
DATA Help,H,Color,C
planet:
DATA "",""
DATA Planet Defenses,A,Team Acess,B,Planet Device,C,Shuttle Shields,D
DATA Shuttle Mines,E,"","","","","","","","","","","",""
DATA Leave Item,I,Take Item,O,Rename Planet,R,Planetary Stats,S
DATA Dump All Cargo,T,View Production,V,Planet Device,W,Leave Planet,Q
DATA "","","",""
Cube:
DATA "","",Access Cube Within Cube,A,Eject Device From Cube,E
DATA Place Device in Cube,I,Take Device Out of Cube,O
DATA List Contents of Cube,L,Return Orientation of Cube,R
DATA Sort Cube,S,View Ship's Device Bays,V
DATA Quit Cube,Q,"",""
DATA "","","","","","","","","","","","","","","","","","","","","",""

SUB adjustscreen (expr, menusav())
soundfx 7
IF maxline = 24 THEN
  LINE (0, 200)-(639, 330), 0, BF
  maxline = 40
  spacefx 640, 112, 200, 50
ELSE
  maxline = 24
  row = CSRLIN: col = POS(0)
  IF row > 24 THEN
    z = row * 8
    y = z - 192
  ELSE
    y = 0: z = 200
  END IF
  GET (0, y)-(639, z), menusav
  PCOPY 0, 1
  SCREEN 9, , 0, 1
  PUT (0, 0), menusav, PSET
  LINE (0, 193)-(639, 200), 0, BF
  doGFX "L", "uutSCRN0", 0, 201, menusav()
  printstat expr - 2
  SCREEN 9, , 0, 0
  IF row > maxline THEN
    row = maxline
    IF row < 1 THEN row = 1
  END IF
  LOCATE row, col
END IF
END SUB

SUB cabalfind (menusav(), log$, planet$())
DoDirScreen menusav(), file$
LINE (0, 0)-(639, 201), 0, BF
PUT (0, 0), menusav, PSET
IF Exists(file$) THEN
  cnt = 0
  LINE (4, 336)-(634, 344), 9, BF
  nz = DRAWSTR%(0, "Now Processing!", 260, 337, 15, 9, 8)
  IF log$ = "ON" THEN
    log$ = "OFF": CLOSE #6
    dowindo 3, 15, 8
  END IF
  DO
    inline$ = BufIn$(file$, done)
    IF done THEN EXIT DO
    IF MID$(inline$, 10, 8) = "[Sector:" THEN
      a = 19: p$ = "]": GOSUB formatsct
    ELSEIF MID$(inline$, 2, 7) = "Sector:" THEN
      a = 10: p$ = " ": GOSUB formatsct
    ELSEIF MID$(inline$, 9, 20) = "Drones of The Cabal:" THEN
      cnt = cnt + 1
      IF cnt = 1 THEN j = FREEFILE: OPEN "o", j, "cabal.lst"
      inline$ = MID$(inline$, 19)
      PRINT #j, sect$ + "  " + inline$
    ELSEIF MID$(inline$, 2, 7) = "Planet:" THEN
      p$ = sect$ + MID$(inline$, 9)
      FOR x = 1 TO 10
        IF planet$(x) = "" THEN planet$(x) = p$
        IF p$ = planet$(x) THEN p$ = "": x = 10
      NEXT x
    END IF
  LOOP
  IF cnt <> 0 THEN
    CLOSE #j
    REDIM help(cnt) AS STRING * 76
    cnt = 0
    DO
      cnt = cnt + 1
      inline$ = BufIn$("cabal.lst", done)
      IF done THEN EXIT DO
      help(cnt) = inline$
    LOOP
    cnt = cnt - 1
    QSORT 1, cnt
    a = FREEFILE: OPEN "o", a, "cabal.lst"
    nz = 0
    FOR x = 1 TO cnt
      IF help(x) <> inline$ THEN
        inline$ = help(x)
        PRINT #a, inline$
        nz = nz + 1
      END IF
    NEXT x
    CLOSE #a
    REDIM help(1) AS STRING * 76
  END IF
  LINE (4, 336)-(634, 344), 9, BF
  IF planet$(1) <> "" THEN
    nz = DRAWSTR%(0, "Planets found now being saved to disk in the PLANET.LST file", 80, 337, 14, 9, 8)
    SLEEP 2
    y = FREEFILE
    OPEN "A", y, "planet.lst"
    PRINT #y, "****"
    PRINT #y, DATE$
    PRINT #y, ""
    FOR x = 1 TO 10
      IF planet$(x) <> "" THEN PRINT #y, planet$(x)
    NEXT x
    CLOSE y
    LINE (4, 336)-(634, 344), 9, BF
  END IF
ELSE
  IF file$ <> "" THEN ermes "File not found in the current directory.", 1
END IF
EXIT SUB
formatsct:
sect$ = MID$(inline$, a, 4)
a = INSTR(sect$, p$)
IF a <> 0 THEN sect$ = LEFT$(sect$, a - 1)
DO UNTIL LEN(sect$) = 4
  sect$ = " " + sect$
LOOP
RETURN
END SUB

SUB cabalreport
IF CarrierLost THEN EXIT SUB
IF Exists("cabal.lst") THEN
  cubeit 0, 0, 640, 30, 15, 8, 7
  nz = DRAWSTR%(0, "To report Cabal you'll need to be at the E.E.C.C. Headquarters prompt.", 36, 7, 0, 7, 8)
  nz = DRAWSTR%(0, "Go to sector 5 and port or use E.E.C.C. calling before running this feature.", 18, 17, 0, 7, 8)
  DO
    inline$ = BufIn$("cabal.lst", done)
    IF done THEN EXIT DO
    cnt = cnt + 1
  LOOP
  REDIM tm$(cnt): cnt = 0
  DO
    inline$ = BufIn$("cabal.lst", done)
    IF done THEN EXIT DO
    cnt = cnt + 1
    tm$(cnt) = "1;" + LTRIM$(LEFT$(inline$, 4)) + CHR$(13)
  LOOP
  x = 1: inline$ = INKEY$
  nz = DRAWSTR%(0, "Hit <ESC> to Exit any other key to report Cabal.     Sightings left:      ", 28, 337, 14, 9, 8)
  nz = DRAWSTR%(0, STR$((cnt + 1) - x), 579, 337, 15, 9, 8)
  DO
    keyinput$ = INKEY$
    IF alarmtime$ = LEFT$(TIME$, 5) THEN doalarm alarmsw
    IF keyinput$ = CHR$(27) THEN EXIT DO
    IF keyinput$ <> "" THEN
      transmit tm$(x)
      x = x + 1
      LINE (577, 336)-(632, 344), 9, BF
      nz = DRAWSTR%(0, STR$((cnt + 1) - x), 579, 337, 15, 9, 8)
    END IF
    IF x = cnt + 1 THEN EXIT DO
    DO WHILE DataWaiting
      modeminput$ = CHR$(ReadChar)
      IF recon = 2 THEN PRINT #7, modeminput$
      emul modeminput$           'determines if menu display
    LOOP
  LOOP
  IF x < cnt + 1 THEN
    a = FREEFILE
    OPEN "I", a, "cabal.lst"
    FOR y = 1 TO cnt
      LINE INPUT #a, tm$(y)
    NEXT y
    CLOSE #a
    a = FREEFILE
    OPEN "o", a, "cabal.lst"
    FOR y = x TO cnt
      PRINT #a, tm$(y)
    NEXT y
    CLOSE #a
  ELSE
    KILL "cabal.lst"
  END IF
  transmit "Q" + CHR$(13)
ELSE
  ermes "Sorry Captain, computers show no Cabal to report.", snd
END IF
END SUB

SUB closerecord (recon, recfirst, maxline, sw)
SELECT CASE sw
CASE 1
  CLOSE #7: recon = 0: recfirst = 0
CASE 2
  ermes "RECORDER.UUT Not Found!", 1
END SELECT
dowindo 14, 15, 8
END SUB

SUB doalarm (alarmsw)
IF alarmsw = 1 THEN EXIT SUB
alarmsw = 1
row% = CSRLIN: col% = POS(0)
IF maxline = 24 THEN
  icon 120, 253, 44, 12, 8, 15, 4, 0
  dowindo 2, 15, 8
ELSE
  icon 587, 251, 24, 22, 12, 8, 3, 0
  PUT (588, 252), alarm, XOR
END IF
IF sw <> 0 THEN soundfx 8
alarmtime$ = ""
LOCATE row%, col%
END SUB

SUB DoDirScreen (menusav(), file$)
GET (0, 0)-(639, 200), menusav
cubeit 0, 0, 640, 201, 15, 8, 7
icon 7, 6, 627, 189, 8, 15, 7, 0
readdir
inbar "Enter the name of a file to work with:", file$, 12, 14, 15, 9, snd
END SUB

SUB donumber (nz, choice)
cl1 = 4 + 128 XOR 7: COLOR cl1
LINE (10, 10)-(25, 164), 7, BF
nz = 3
FOR x = 65 TO 82
  LOCATE nz, 3: PRINT CHR$(x)
  nz = nz + 1
NEXT x
DO
  choice = inkey(1, 0)
  IF choice = 13 OR choice = 27 THEN EXIT DO
LOOP UNTIL choice > 64 AND choice < 83
IF choice = 13 OR choice = 27 THEN EXIT SUB
nz = choice - 62
x = DRAWSTR%(0, "Edit    Run", 276, 337, 14, 9, 8)
x = DRAWSTR%(0, "E", 276, 337, 0, 9, 8)
x = DRAWSTR%(0, "R", 339, 337, 0, 9, 8)
soundfx 6
choice = inkey(0, 1)
END SUB

SUB dowindo (num, cl1, cl2)
soundfx 7
IF maxline <> 24 THEN EXIT SUB
REDIM button(512)
SELECT CASE num
CASE IS < 11
  x = 4 + ((num - 1) * 55): z = 302
CASE 11, 12, 13, 14
  x = 4: z = 241
  IF num = 12 THEN x = 59
  IF num = 13 THEN z = 268
  IF num = 14 THEN z = 268: x = 59
END SELECT
GET (x + 3, z + 2)-(x + 50, z + 23), button
icon x, z, 52, 25, cl1, cl2, 7, 1
IF cl1 = 8 THEN z = z + 3 ELSE z = z + 1
PUT (x + 3, z), button, PSET
ERASE button
END SUB

SUB getdevices (SaveRow0, SaveCol0, fI&(), fion, line$)
fI&(fion) = VAL(line$)
fion = fion + 1
LOCATE SaveRow0%, SaveCol0%
IF fion = 25 THEN
  row = SaveRow0: col = SaveCol0
  GOSUB dispfi
  IF row% < 14 THEN
    row% = 14: col% = 1
    LOCATE row%, col%
    transmit CHR$(13)
  ELSE
    LOCATE row%, col%
  END IF
  fion = 0
END IF
EXIT SUB
dispfi:
cubeit 0, 0, 640, 94, 15, 8, 7
icon 7, 6, 627, 82, 8, 15, 7, 0
icon 10, 12, 215, 22, 8, 15, 7, 0
icon 10, 36, 215, 22, 8, 15, 7, 0
icon 10, 60, 215, 22, 8, 15, 7, 0
icon 230, 12, 195, 70, 8, 15, 7, 0
icon 430, 12, 199, 30, 8, 15, 7, 0
icon 430, 60, 199, 22, 8, 15, 7, 0
  cl1 = 4 + 128 XOR 7
  cl2 = 1 + 128 XOR 7
  COLOR cl2
  LOCATE 3, 7: PRINT "  FUEL:"
  LOCATE 4, 7: PRINT "  CASH:"
  LOCATE 6, 7: PRINT "DRONES:"
  LOCATE 7, 7: PRINT " MINES:"
  LOCATE 9, 7: PRINT "CLOAKS:"
  LOCATE 10, 3: PRINT "ANTICLOAKS:"
  LOCATE 4, 34: PRINT "     ORE:"
  LOCATE 5, 34: PRINT "ORGANICS:"
  LOCATE 6, 33: PRINT "EQUIPMENT:"
  LOCATE 7, 34: PRINT "   POWER:"
  LOCATE 8, 34: PRINT "   WATER:"
  LOCATE 10, 32: PRINT "TOTAL HOLDS:"
  LOCATE 3, 59: PRINT " PLASMA WARPS:"
  LOCATE 4, 59: PRINT "   GATE WARPS:"
  LOCATE 5, 59: PRINT "  FLASH WARPS:"
  LOCATE 9, 56: PRINT "GENESIS TORPEDOS:"
  LOCATE 10, 59: PRINT "PLANET PROBES:"
  COLOR cl1
  LOCATE 3, 18: PRINT USING "##########"; fI&(7)
  LOCATE 4, 15: PRINT USING "#,###,###,###"; fI&(6)
  LOCATE 6, 15: PRINT USING "#,###,###,###"; fI&(9)
  LOCATE 7, 15: PRINT USING "#,###,###,###"; fI&(10)
  LOCATE 9, 15: PRINT USING "#,###,###,###"; fI&(11)
  LOCATE 10, 15: PRINT USING "#,###,###,###"; fI&(12)
  LOCATE 4, 45: PRINT USING "##,###"; fI&(1)
  LOCATE 5, 45: PRINT USING "##,###"; fI&(2)
  LOCATE 6, 45: PRINT USING "##,###"; fI&(3)
  LOCATE 7, 45: PRINT USING "##,###"; fI&(4)
  LOCATE 8, 45: PRINT USING "##,###"; fI&(5)
  LOCATE 10, 46: PRINT USING "##,###"; fI&(8)
  LOCATE 3, 74: PRINT USING "####"; fI&(13)
  LOCATE 4, 74: PRINT USING "####"; fI&(14)
  LOCATE 5, 74: PRINT USING "####"; fI&(15)
  LOCATE 9, 74: PRINT USING "####"; fI&(16)
  LOCATE 10, 74: PRINT USING "####"; fI&(17)
  LINE (4, 336)-(634, 344), 9, BF
  dowindo 5, 15, 8
RETURN
END SUB

SUB loaddevice (dcnt, sbksiz)
scrollcnt = sbksiz
IF LEFT$(scrollback(scrollcnt - 1), 7) <> "Command" THEN
  dcnt = 32: REDIM device(1 TO 32) AS STRING * 49
  FOR x = 1 TO 32
    device(x) = STRING$(7, " ") + "empty"
  NEXT x
  FOR x = scrollcnt TO 1 STEP -1
    z = VAL(MID$(scrollback(x), 2, 2))
    IF z > 0 THEN
      device(z) = LEFT$(scrollback(x), 33) + MID$(scrollback(x), 42, 16)
    END IF
    IF z = 1 THEN x = 1
  NEXT x
END IF
END SUB

SUB mainmenu (where)
IF maxline <> 24 THEN EXIT SUB
row% = CSRLIN: col% = POS(0)
SELECT CASE where
CASE 1
  RESTORE
CASE 2
  RESTORE COMP:
CASE 3
  RESTORE planet:
CASE 4
  RESTORE Cube:
CASE ELSE
  RESTORE
END SELECT
LINE (285, 205)-(636, 293), 7, BF
pixy = 206: ver = 294
FOR offset = 1 TO 22
  READ sel$
  IF sel$ <> "" THEN nz = DRAWSTR%(0, "( ) " + sel$, ver, pixy, 0, 7, 8)
  READ sel$
  nz = DRAWSTR%(0, sel$, ver + 8, pixy, 4, 7, 7)
  pixy = pixy + 8
  IF offset = 11 THEN ver = 476: pixy = 206
NEXT
IF where = 2 THEN
  ver = 384
  FOR pixy = 279 TO 289 STEP 8
    READ sel$
    IF sel$ <> "" THEN nz = DRAWSTR%(0, "( ) " + sel$, ver, pixy, 0, 7, 8)
    READ sel$
    nz = DRAWSTR%(0, sel$, ver + 8, pixy, 4, 7, 7)
  NEXT pixy
END IF
LOCATE row%, col%
END SUB

SUB QSORT (First%, Last%)
 '*****  Quick-Sort
 '*** sorts(ascending) the fields in array(), from field First% thru Field Last%
 IF First% >= Last% THEN EXIT SUB
 DIM Lft%(10), Rght%(10)
 temp% = 1
 Lft%(1) = First%
 Rght%(1) = Last%

 DO
   start% = Lft%(temp%)
   Ende% = Rght%(temp%)
   temp% = temp% - 1

   DO           '** (WHILE Start% < Ende%)
    IndexLft% = start%
    IndexRght% = Ende%
    x$ = UCASE$(help((start% + Ende%) \ 2))

    DO
     WHILE UCASE$(help(IndexLft%)) < x$: IndexLft% = IndexLft% + 1: WEND
     WHILE x$ < UCASE$(help(IndexRght%)): IndexRght% = IndexRght% - 1: WEND

     IF IndexLft% > IndexRght% THEN EXIT DO

     SWAP help(IndexLft%), help(IndexRght%)   '*** switch elements
     IndexLft% = IndexLft% + 1
     IndexRght% = IndexRght% - 1
    LOOP

    IF IndexRght% - start% >= Ende% - IndexLft% THEN
      IF start% < IndexRght% THEN
        temp% = temp% + 1
        Lft%(temp%) = start%
        Rght%(temp%) = IndexRght%
      END IF
      start% = IndexLft%
    ELSE
      IF IndexLft% < Ende% THEN
        temp% = temp% + 1
        Lft%(temp%) = IndexLft%
        Rght%(temp%) = Ende%
      END IF
       Ende% = IndexRght%
    END IF
  LOOP WHILE start% < Ende%
LOOP WHILE temp%
END SUB

SUB readdir
  cl = 4 + 128 XOR 7: COLOR cl
  REDIM help(88) AS STRING * 76
  found$ = DIR$("*.*")
  IF LEN(found$) THEN
    help(1) = found$: cnt = 2
    DO WHILE LEN(found$)
      found$ = DIR$("")
      IF RIGHT$(found$, 4) <> "GFX" + CHR$(0) THEN
        IF RIGHT$(found$, 4) <> "SND" + CHR$(0) THEN
          help(cnt) = found$
          cnt = cnt + 1: IF cnt = 89 THEN EXIT DO
        END IF
      END IF
    LOOP
  END IF
  QSORT 1, cnt - 1
  sw = 2: z = 34
  IF cnt > 22 THEN z = 24
  IF cnt > 43 THEN z = 16
  IF cnt > 64 THEN z = 6
  FOR cnt = z TO 61 STEP 18
    FOR x = 3 TO 23
      LOCATE x, cnt: PRINT LEFT$(help(sw), 12)
      sw = sw + 1
    NEXT x
  NEXT cnt
END SUB

' Read data comming from the modem. SUB will not return until an OK is
' detected. SUB will time-out if an OK is not detected in 4 seconds.                                 
SUB Response (swi, what$)
IF swi = 0 THEN z = 4 ELSE z = swi
start! = TIMER
DO
  IF DataWaiting THEN
    x$ = CHR$(ReadChar)
    I$ = I$ + x$
    IF ASC(x$) = 10 OR ASC(x$) = 13 THEN
      IF ASC(x$) = 10 THEN PRINT ""
      GOSUB scrll
      I$ = ""
    ELSE
      PRINT x$;
    END IF
  END IF
  j = TIMER - start!
  nz = DRAWSTR%(0, "Now Dialing  " + STR$(j), 260, 337, 14, 9, 8)
  IF j > z THEN
    GOSUB scrll
    PRINT "Problem Initializing Modem"
    LINE (4, 336)-(634, 344), 9, BF
    swi = -1: EXIT DO
  END IF
  IF swi <> 0 THEN  'if it's not medem init but actual dial
    IF INSTR(I$, "NO CARRIER") THEN swi = -1: EXIT DO
    IF INSTR(I$, "BUSY") THEN swi = -1: EXIT DO
    IF INSTR(I$, "NO DIAL") THEN swi = -1: EXIT DO
  END IF
  IF INKEY$ = CHR$(27) THEN swi = -1: EXIT DO
LOOP UNTIL INSTR(I$, what$)
EXIT SUB
scrll:
  col = POS(0): row = CSRLIN
  IF row% > maxline THEN
    ScrnScroll 1, 1, maxline, 80, 1, 0
    IF maxline = 24 THEN x = 184 ELSE x = 312
    spacefx 640, 8, x, 7
    LOCATE maxline, 1
  END IF
RETURN
END SUB

SUB scrollit (pntlow, pnthigh, size, snd)
IF pnthigh < 22 THEN pnthigh = 22: size = 22
DO
  choice = inkey(0, 0)
  IF choice >= 0 THEN EXIT DO
  SELECT CASE choice
    CASE -72
      IF pntlow = 1 THEN
        IF snd = 1 THEN BEEP
        pnthigh = 22
      ELSE
        pntlow = pntlow - 1: pnthigh = pnthigh - 1
        ScrnScroll 3, 3, 24, 79, -1, 1
        nz = DRAWSTR%(0, help(pntlow), 17, 16, 8, 7, 8)
      END IF
    CASE -80
      IF pnthigh >= size THEN
        IF snd = 1 THEN BEEP
      ELSE
        pntlow = pntlow + 1: pnthigh = pnthigh + 1
        ScrnScroll 3, 3, 24, 79, 1, 1
        nz = DRAWSTR%(0, help(pnthigh), 17, 184, 8, 7, 8)
      END IF
    CASE -81
      IF pnthigh >= size THEN
        IF snd = 1 THEN BEEP
      ELSE
        pntlow = pnthigh
        pnthigh = pntlow + 22
        IF pnthigh > size THEN pnthigh = size: pntlow = size - 21
        LINE (10, 7)-(632, 193), 7, BF
        FOR x = 2 TO 23
          nz = DRAWSTR%(0, help(pntlow + x - 2), 17, x * 8, 8, 7, 8)
        NEXT x
      END IF
    CASE -73
      IF pntlow = 1 THEN
        IF snd = 1 THEN BEEP
      ELSE
        pnthigh = pntlow
        pntlow = pnthigh - 22
        IF pntlow < 1 THEN pntlow = 1: pnthigh = 22
        LINE (10, 7)-(632, 193), 7, BF
        FOR x = 2 TO 23
          nz = DRAWSTR%(0, help(pntlow + x - 2), 17, x * 8, 8, 7, 8)
        NEXT x
      END IF
    CASE ELSE
      z = 1
  END SELECT
LOOP UNTIL z = 1
END SUB

SUB trade1 (logg, port$, PORTS(), water(), power(), file$)
DO
  inline$ = BufIn$(file$, done)
  IF done THEN EXIT DO
  IF LEFT$(inline$, 6) = "Sector" THEN      'if a sector look for kind
    IF logg = 1 THEN
      IF port$ = "T" THEN
        IF RIGHT$(inline$, 5) = "Water" THEN wat = 1 ELSE IF RIGHT$(inline$, 5) = "Power" THEN wat = 2
      ELSEIF port$ = "B" THEN
        IF RIGHT$(inline$, 4) = "None" THEN wat = 3
      ELSEIF port$ = "S" THEN
        IF RIGHT$(inline$, 3) = "All" THEN wat = 3
      END IF
    ELSE
      IF port$ = "T" THEN
        IF RIGHT$(inline$, 1) = "5" THEN wat = 1 ELSE IF RIGHT$(inline$, 1) = "4" THEN wat = 2
      ELSEIF port$ = "B" THEN
        IF RIGHT$(inline$, 1) = "7" THEN wat = 3
      ELSEIF port$ = "S" THEN
        IF RIGHT$(inline$, 1) = "6" THEN wat = 3
      END IF
    END IF
  END IF
  IF wat <> 0 THEN        'if what we want
    sect = VAL(MID$(inline$, 9, 4))
    inline$ = BufIn$(file$, done)
    IF wat = 1 THEN                          'if water then this
       water1% = VAL(MID$(inline$, 66, 5))
       IF water1% <= 20 THEN
         power1% = VAL(MID$(inline$, 50, 5))
         IF power1% >= 22 THEN wcnt = wcnt + 1: water(wcnt) = sect
       END IF
    ELSEIF wat = 2 THEN
      power1% = VAL(MID$(inline$, 50, 5))
      IF power1% <= 17 THEN
        water1% = VAL(MID$(inline$, 66, 5))
        IF water1% >= 28 THEN pcnt = pcnt + 1: power(pcnt) = sect
      END IF
    ELSEIF wat = 3 THEN
      pcnt = pcnt + 1: PORTS(pcnt) = sect
    END IF
  END IF
  wat = 0
LOOP UNTIL done
END SUB

