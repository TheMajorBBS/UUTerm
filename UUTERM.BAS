DECLARE SUB disrupt (spce%, menusav%())
DECLARE SUB explore ()
DECLARE SUB cabalfind (menusav%(), log$, planet$())
DECLARE SUB config ()
DECLARE SUB savecfg (sw%)
DECLARE SUB updateSBack ()
DECLARE SUB dialit ()
DECLARE SUB Response (swi%, what$)
DECLARE SUB adjustscreen (expr%, menusav%())
DECLARE SUB flash (maxline%, spce%)
DECLARE SUB phaser (spce%, menusav%(), cl%)
DECLARE SUB ALTkey (keyinput$, which%)
DECLARE SUB loaddevice (dcnt%, sbksiz%)
DECLARE SUB mainmenu (where%)
DECLARE SUB getdevices (SaveRow0%, SaveCol0%, fI&(), fion%, line$)
DECLARE SUB donumber (nz%, choice%)
DECLARE SUB restscrn (menusav%(), y%)
DECLARE SUB doGFX (sw$, file$, h%, v%, menusav%())
DECLARE SUB inbar (prompt$, sel$, lenofinput%, txtclr%, fg%, bg%, x%)
DECLARE SUB scrollit (pntlow%, pnthigh%, size%, snd%)
DECLARE SUB doalarm (alarmsw%)
DECLARE SUB Nocary ()
DECLARE SUB delay (x%)
DECLARE SUB credits ()
DECLARE SUB init (dosfg%, dosbg%)
DECLARE SUB dowindo (num%, cl1%, cl2%)
DECLARE SUB checkmenu ()
DECLARE SUB doprint (ch0$, line$, fore0%, back0%, fion%, row%, col%)
DECLARE SUB loadgpxs ()
DECLARE SUB closerecord (recon%, recfirst%, maxline%, sw%)
DECLARE SUB alertchek ()
DECLARE SUB QSORT (First%, Last%)
DECLARE SUB printstat (z%)
DECLARE SUB sheltodos (expr%)
DECLARE SUB uudev (macon%, expr%)
DECLARE SUB readdir ()
DECLARE SUB fleamarket ()
DECLARE SUB viewfile ()
DECLARE SUB recorder ()
DECLARE SUB MacroScreen ()
DECLARE SUB dispfi ()
DECLARE SUB dooptions (keyinput$, expr%)
DECLARE SUB emul (st$)
DECLARE SUB setalarm ()
DECLARE SUB loadmac ()
DECLARE SUB menubar ()
DECLARE SUB starlog ()
DECLARE SUB dispinven (choice$)
DECLARE SUB reg ()
DECLARE SUB cabalreport ()
DECLARE SUB portfind (menusav%(), maxline%)
DECLARE SUB DoDirScreen (menusav%(), file$)
DECLARE SUB trade1 (logg%, Port$, PORTS%(), water%(), power%(), file$)
DECLARE SUB soundfx (sw%)
DECLARE SUB initsb ()
DECLARE SUB playvoc (filename$)
DECLARE SUB ermes (tp$, sw%)
DECLARE SUB spacefx (wide%, deep%, top%, sw%)
DECLARE SUB PutText2 (text$, TextColor%, BackColor%)
DECLARE SUB ScrnScroll (ULRow%, ULColumn%, LRRow%, LRColumn%, NumOfLines%, sw%)
DECLARE SUB disp (title$, cl%, row%)
DECLARE SUB Crypt (Buffer$, key$, Start%)
DECLARE SUB edittext (rw%, clm%, text$, min%, max%)
DECLARE FUNCTION inkey% (NoWait%, x%)
DECLARE FUNCTION Exists% (filename$)
DECLARE FUNCTION Iinkey$ (max%, row%, col%, fore%, sw%)
DECLARE FUNCTION DIR$ (FileSpec$)
DECLARE FUNCTION CurDir$ ()
DECLARE FUNCTION BufIn$ (filename$, done%)
    DECLARE SUB OpenComm CDECL ALIAS "_open_comm" (BYVAL Port%, IRQ%, BYVAL Wlen%, BYVAL Parity%, BYVAL Baud&, BYVAL HS%, BYVAL FOSSIL%)
    DECLARE SUB closecomm CDECL ALIAS "_close_comm" ()
    DECLARE FUNCTION ReadChar% CDECL ALIAS "_readchar" ()
    DECLARE SUB transmit CDECL ALIAS "_transmit_string" (addr$)
    DECLARE FUNCTION DataWaiting% CDECL ALIAS "_data_waiting" ()
    DECLARE SUB ClearInputBuffer CDECL ALIAS "_clear_input_buffer" ()
    DECLARE SUB CarrierDetect CDECL ALIAS "_carrier_detect_flag" (BYVAL OnOff%)
    DECLARE FUNCTION CarrierLost% CDECL ALIAS "_carrier_state" ()
    DECLARE SUB DTRcontrol CDECL ALIAS "_dtr" (BYVAL OnOff%)
DECLARE FUNCTION DRAWSTR% (mode%, strg$, x0%, y0%, fg%, bg%, gap%)
DECLARE FUNCTION EGAVIDEO% ()
DECLARE FUNCTION ival% (number$)
DECLARE SUB DRAWDOT (mode%, value%, x0%, y0%)
DECLARE SUB cubeit (h%, v%, WD%, HT%, C1%, C2%, FILD%)
DECLARE SUB icon (h%, v%, WD%, HT%, C1%, C2%, FILD%, OUTIN%)
DECLARE SUB smallprint (spx%, spy%, sp$, spcolor%)
DECLARE SUB tinyfont (hor%, ver%, inline$, CLR%)
DECLARE SUB chdrive (utility$)
'    DECLARE FUNCTION WriteChar% CDECL (BYVAL c%)
'    DECLARE FUNCTION DriverCopyright% CDECL ()
'    DECLARE SUB RTScontrol CDECL ALIAS "_rts" (BYVAL Onff%)
'    DECLARE FUNCTION ModemStatus% CDECL ALIAS "_inputstatus" ()

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
COMMON SHARED help() AS STRING * 76, spce, expr, device() AS STRING * 49
COMMON SHARED SCROLLBACK() AS STRING * 76, IRQ%, Baud&
COMMON SHARED sbksiz, line$, where%, log$, alarmtime$, regit
COMMON SHARED CRLF$, dcnt, recon, numturns%, linport$, Port, HS
COMMON SHARED fore0%, back0%, fion, regname$, pattern$

'$DYNAMIC
REDIM SHARED menusav(1 TO 32767), device(1 TO 32) AS STRING * 49
REDIM SHARED fI&(24), macro$(1), SCROLLBACK(1) AS STRING * 76, tm$(6)
REDIM SHARED help(1) AS STRING * 76, macrod$(1 TO 20), planet$(1 TO 10)
REDIM SHARED PORTS(1), water(1), power(1)
REDIM SHARED Bhole(256), planet(256), proc(256), cabal(256)
REDIM SHARED blnk(256)

pattern$ = CHR$(191) + CHR$(191) + CHR$(191) + CHR$(72)
pattern$ = pattern$ + CHR$(223) + CHR$(223) + CHR$(223) + CHR$(36)
pattern$ = pattern$ + CHR$(239) + CHR$(239) + CHR$(239) + CHR$(18)
pattern$ = pattern$ + CHR$(253) + CHR$(253) + CHR$(253) + CHR$(18)
pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(36)
pattern$ = pattern$ + CHR$(247) + CHR$(247) + CHR$(247) + CHR$(72)
RANDOMIZE TIMER
'
CLS
IF NOT EGAVIDEO% THEN PRINT "Sorry, EGA graphic card required to run UUTERM.": BEEP: END
IF Exists("uutscrn0.gfx") THEN x = x + 1     'alertsd?
IF Exists("uutscrn2.gfx") THEN x = x + 1     'main menu?
IF x <> 2 THEN PRINT "Sorry, It seems you are missing one or more of UUTERM's graphic files.": BEEP: END
IF NOT Exists("uuterm.cfg") THEN SHELL "setup"
'
initsb
init dosfg, dosbg
OpenComm Port, IRQ%, 8, 0, Baud&, HS, 0
'
playvoc "uutopen"
nz = DRAWSTR%(0, "Do you wish to dial a BBS?  (Y/n)", 188, 337, 14, 9, 8)
dial = inkey(0, 1)
'
LINE (0, 200)-(639, 201), 0, B
PLAY "mb l32 o0 ccccccccc"
y = 192
FOR x = 25 TO 1 STEP -1
  ScrnScroll 1, 1, x, 80, 1, 0
  FOR z = 1 TO 3000: NEXT
  IF x <> 25 THEN spacefx 640, 8, y, 7
  y = y - 8
NEXT x
LOCATE 1, 1
'
IF dial <> 78 THEN 'yes dial
  ClearInputBuffer
  dialit
ELSE              'we either offline or already connected
  IF CarrierLost% <> 1 THEN transmit CHR$(13)
END IF
'
nz = DRAWSTR%(0, "Copyright 1995 by Will Boyett", 200, 337, 14, 9, 8)
fore0 = 7
DO                              ' Main communications loop.
  keyinput$ = INKEY$
  IF CarrierLost% THEN Nocary
  IF keyinput$ = CHR$(0) + "-" THEN   'alt-x exit
    soundfx 6
    LINE (4, 336)-(634, 344), 9, BF
    nz = DRAWSTR%(0, "Do you really want to exit UUTERM?  y/N", 164, 337, 14, 9, 8)
    nz = inkey(0, 1)
    IF nz = 89 THEN EXIT DO
  END IF
  IF alarmtime$ = LEFT$(TIME$, 5) THEN doalarm alarmsw
  IF LEN(keyinput$) = 2 THEN
    dooptions keyinput$, expr
  END IF
  IF keyinput$ <> "" THEN
    IF CarrierLost% <> 1 THEN transmit keyinput$
  END IF
  IF recon = 1 THEN                     'if playing back recorder
    LINE INPUT #7, modeminput$
    IF EOF(7) THEN recorder
    emul modeminput$                  'determines if menu display
  END IF
  DO WHILE DataWaiting
    modeminput$ = CHR$(ReadChar)
    IF recon = 2 THEN
      IF LEFT$(modeminput$, 1) = CHR$(10) THEN
	IF w$ <> "" THEN PRINT #7, w$
	PRINT #7, modeminput$
	w$ = ""
      ELSE
	w$ = w$ + modeminput$
      END IF
    END IF
    emul modeminput$           'determines if menu display
  LOOP
LOOP
IF dial <> 78 THEN DTRcontrol 0  ' DTR, doing so may let modem hang up modem
closecomm
CLOSE
IF Exists("temp.gfx") THEN KILL "temp.gfx"
IF regit = 0 THEN reg
SCREEN 0
WIDTH 80, 25
credits
IF regit = 0 THEN delay 36
COLOR dosfg, dosbg     'restore
END

REM $STATIC
SUB alertchek
IF line$ = "" THEN EXIT SUB
IF LEFT$(line$, 10) = "Report The" THEN playvoc "uuthail"
IF where <> 1 THEN EXIT SUB
row% = CSRLIN: col% = POS(0)
ver = (row * 8) - 31
IF ver < 1 THEN ver = 1
'
IF LEFT$(line$, 5) = " Plan" THEN
  IF LEFT$(line$, 10) <> " Planetary" THEN          'planet
    IF snd = 1 THEN SOUND 6000, 4: SOUND 5000, 2
    PUT (593, ver), planet, PSET
    IF snd = 1 THEN SOUND 6000, 4: SOUND 5000, 2
  ELSE                                      'planet missle
    playvoc "uutorp"
    phaser spce, menusav(), 14
    IF snddev = 0 THEN soundfx 3
    flash maxline, spce
  END IF
ELSEIF LEFT$(line$, 7) = "Sonic T" THEN
  soundfx 4
  disrupt spce, menusav()
ELSEIF LEFT$(line$, 9) = "Your part" THEN
  playvoc "uutphsr1"
  phaser spce, menusav(), 4
  IF snddev = 0 THEN soundfx 3
  flash maxline, spce
ELSEIF MID$(line$, 19, 9) = "The Cabal" THEN
  PUT (570, ver), cabal, PSET
  soundfx 11
ELSEIF MID$(line$, 8, 10) = "Procurator" THEN
  PUT (616, ver), proc, PSET
  IF snd = 1 THEN PLAY "L4<<T180MN": PLAY "MNG8MSB8>D8G8MN<"
ELSEIF LEFT$(line$, 8) = " Black H" THEN
  LINE (547, ver + 1)-(569, ver + 21), 4, BF
  PUT (547, ver), Bhole, XOR
  IF snd = 1 THEN
    y% = 30
    FOR x% = 700 TO 40 STEP -10
      SOUND x%, .1: y% = y% + 10: SOUND y%, .1
    NEXT x%
  END IF
ELSEIF RIGHT$(line$, 5) = "ping!" THEN
  soundfx 9
ELSEIF LEFT$(line$, 9) = "Planetary" THEN
  soundfx 9
ELSEIF LEFT$(line$, 9) = "Attack Gr" THEN
  playvoc "uutbatl"
ELSEIF LEFT$(line$, 3) = "<<<" THEN
  soundfx 2
ELSEIF LEFT$(line$, 8) = "A Planet" THEN
  soundfx 4
  phaser spce, menusav(), 14
  flash maxline, spce
END IF
END SUB

SUB ALTkey (keyinput$, which)
IF macro$(which) <> "" THEN
  REDIM tm$(10)
  IF which < 6 THEN                                    'if huge macro
    z = INSTR(macro$(which), ".")
    file$ = LEFT$(macro$(which), z - 1) + ".MAC"
    filenum = FREEFILE: cnt = 0
    OPEN "I", filenum, file$
    DO
      LINE INPUT #1, inline$
      cnt = cnt + 1
      tm$(cnt) = inline$ + CHR$(13)
    LOOP UNTIL EOF(filenum)
    CLOSE filenum
    x = 1: : inline$ = INKEY$
    transmit tm$(x)
    IF cnt > 1 THEN
      nz = DRAWSTR%(0, "Hit any key to run the next line in the macro.    Lines left to execute:   ", 12, 337, 14, 9, 8)
      nz = DRAWSTR%(0, STR$(cnt - x), 593, 337, 15, 9, 8)
      DO
	keyinput$ = INKEY$
	IF alarmtime$ = LEFT$(TIME$, 5) THEN doalarm alarmsw
	IF keyinput$ <> "" THEN
	  x = x + 1: transmit tm$(x)
	  nz = DRAWSTR%(0, STR$(cnt - x), 593, 337, 15, 9, 8)
	END IF
	IF x = cnt THEN EXIT DO
	DO WHILE DataWaiting
	  modeminput$ = CHR$(ReadChar)
	  IF recon = 2 THEN PRINT #7, modeminput$
	  emul modeminput$           'determines if menu display
	LOOP
      LOOP
      LINE (4, 335)-(634, 345), 9, BF
    END IF
  ELSE
    tm$(1) = macro$(which) + CHR$(13)
    transmit tm$(1)
  END IF
END IF
END SUB

SUB checkmenu
IF where = 1 THEN
  SELECT CASE LEFT$(line$, 5)
  CASE "[Comp"
    where = 2: mainmenu where
  CASE "[Plan"
    where = 3: mainmenu where
  CASE "[Cube"
    where = 4: mainmenu where
  CASE "Use W"
   loaddevice dcnt, sbksiz
  CASE "Welco"
    IF maxline = 24 THEN    'blanks screen when porting
      where = 2
      LINE (285, 205)-(636, 293), 7, BF
      LINE (285, 205)-(636, 293), 8, B
      PAINT (290, 210), pattern$, 8
    END IF
  END SELECT
ELSEIF where = 2 THEN
  IF line$ = "Comma" THEN
    where = 1: mainmenu where
  END IF
ELSEIF where = 3 THEN
  IF line$ = "Comma" THEN where = 1: mainmenu where
ELSE
  SELECT CASE LEFT$(line$, 5)
  CASE "Comma"
    where = 1: mainmenu where
  CASE "[Comp"
   where = 2: mainmenu where
  CASE "[Plan": where = 3: mainmenu where
  CASE "Use W"
   loaddevice dcnt, sbksiz
  END SELECT
END IF        'if len is 5
END SUB

SUB config
sbksw = 0
PCOPY 0, 1
SCREEN 9, , 0, 1
dowindo 8, 8, 15
GOSUB displ
GOSUB values
SCREEN 9, , 0, 0
DO
  DO
    choice = inkey(1, 0)
  LOOP UNTIL choice <> 0
  IF choice = 13 OR choice = 27 THEN EXIT DO
  GOSUB configit
LOOP
savecfg 0
IF change = 0 THEN PCOPY 1, 0: soundfx 7
IF sbksw = 1 THEN REDIM SCROLLBACK(1 TO sbksiz) AS STRING * 76
EXIT SUB
'
displ:
cubeit 77, 0, 486, 126, 15, 8, 7
icon 84, 6, 473, 115, 8, 15, 7, 0
icon 104, 10, 193, 18, 8, 15, 7, 0
LINE (340, 10)-(540, 28), 8, B
PAINT (342, 12), pattern$, 8
LINE (340, 28)-(540, 28), 15, B
LINE (540, 11)-(540, 28), 15, B
nz = DRAWSTR%(0, ") ...Printer Port:", 110, 43, 0, 7, 8)
nz = DRAWSTR%(0, ") ......Comm Port:", 110, 58, 0, 7, 8)
nz = DRAWSTR%(0, ") ....Handshaking:", 110, 73, 0, 7, 8)
nz = DRAWSTR%(0, ") ............IRQ:", 110, 88, 0, 7, 8)
nz = DRAWSTR%(0, ") ...........Baud:", 110, 103, 0, 7, 8)
nz = DRAWSTR%(0, ") .........Memory:", 340, 43, 0, 7, 8)
nz = DRAWSTR%(0, ") ...Sound Device:", 340, 58, 0, 7, 8)
nz = DRAWSTR%(0, ") ..........Sound:", 340, 73, 0, 7, 8)
nz = DRAWSTR%(0, ") .Space Graphics:", 340, 88, 0, 7, 8)
nz = DRAWSTR%(0, ") Scrollback Size:", 340, 103, 0, 7, 8)
cnt = 65: h = 98
FOR x = 43 TO 113 STEP 15
  cnt = cnt + 1
  nz = DRAWSTR%(0, CHR$(cnt), h, x, 4, 7, 8)
  IF x = 103 THEN x = 28: h = 328
  IF cnt = 75 THEN x = 113
NEXT x
smallprint 124, 23, "CONFIGURATION MENU", 0
smallprint 123, 22, "CONFIGURATION MENU", 14
RETURN
'
configit:
SELECT CASE choice
CASE 66
  IF linport$ = "LPT1" THEN linport$ = "LPT2" ELSE linport$ = "LPT1"
CASE 67
  Port = Port + 1: IF Port = 5 THEN Port = 0
CASE 68
  HS = HS + 1: IF HS = 4 THEN HS = 0
CASE 69
  IRQ = IRQ + 1: IF IRQ = 8 THEN IRQ = 2
CASE 70
  SELECT CASE Baud&
  CASE 2400: Baud& = 9600
  CASE 9600: Baud& = 14400
  CASE 14400: Baud& = 19200
  CASE 19200: Baud& = 38400
  CASE 38400: Baud& = 57600
  CASE 57600: Baud& = 2400
  END SELECT
CASE 71
  IF xmsflag = 1 THEN xmsflag = 0 ELSE xmsflag = 1
CASE 72
  IF snddev <> 0 THEN
    snddev = 0
  ELSE
    i = 1
    DO UNTIL LEFT$(ENVIRON$(i), 8) = "BLASTER="
      i = i + 1
      IF ENVIRON$(i) = "" THEN EXIT DO
    LOOP
    inline$ = UCASE$(ENVIRON$(i))
    IF inline$ = "" THEN
      snddev = 0
    ELSE
      DaType = VAL(MID$(inline$, INSTR(8, inline$, "T") + 1, 1))
      IF DaType = 4 THEN snddev = 5 ELSE snddev = 4
    END IF
  END IF
CASE 73
  IF snd = 0 THEN snd = 1 ELSE snd = 0
CASE 74      'stars
  IF spce = 1 THEN spce = 0 ELSE spce = 1
CASE 75
  sbksw = 1
  sbksiz = sbksiz + 2
  IF sbksiz > 200 THEN sbksiz = 50
END SELECT
IF choice > 65 AND choice < 71 THEN
  LINE (257, 40)-(327, 112), 7, BF
ELSE
  LINE (486, 40)-(550, 112), 7, BF
END IF
GOSUB values
RETURN
'
values:
SELECT CASE HS
  CASE 0: temp$ = "NONE"
  CASE 1: temp$ = "XON/XOFF"
  CASE 2: temp$ = "CTS/RTS"
  CASE 3: temp$ = "ALL"
END SELECT
y = 9
nz = DRAWSTR%(0, linport$, 258, 43, y, 7, 8)
nz = DRAWSTR%(0, STR$(Port%), 258, 58, y, 7, 8)
nz = DRAWSTR%(0, temp$, 258, 73, y, 7, 8)
nz = DRAWSTR%(0, STR$(IRQ%), 258, 88, y, 7, 8)
nz = DRAWSTR%(0, LTRIM$(STR$(Baud&) + " "), 258, 103, y, 7, 8)
IF xmsflag = 1 THEN temp$ = " XMS " ELSE temp$ = "CONV"
nz = DRAWSTR%(0, temp$, 488, 43, y, 7, 8)
SELECT CASE snddev
CASE 0: temp$ = "PC SPKR"
CASE 4: temp$ = " SB "
CASE 5: temp$ = "SB PRO "
END SELECT
nz = DRAWSTR%(0, temp$, 488, 58, y, 7, 8)
IF snd = 1 THEN temp$ = " ON " ELSE temp$ = " OFF"
nz = DRAWSTR%(0, temp$, 488, 73, y, 7, 8)
IF spce = 1 THEN temp$ = " ON " ELSE temp$ = " OFF"
nz = DRAWSTR%(0, temp$, 488, 88, y, 7, 8)
nz = DRAWSTR%(0, LTRIM$(STR$(sbksiz)), 496, 103, y, 7, 8)
RETURN
END SUB

SUB dialit
  LOCATE 4, 1
  file$ = "UUTdial.cfg"
  GOSUB getcfg
  CarrierDetect 0     ' <-- NEEDED TO TALK TO MODEM W/NO CARRIER!!
  DO                   'make sure modem OK first
    transmit modem$ + CRLF$
    z = 0
    Response z, "OK"
    IF z >= 0 THEN EXIT DO
    SLEEP 2
  LOOP UNTIL INKEY$ = CHR$(27)
  '
  IF z >= 0 THEN    'if we got an OK
    DO
      transmit dial$ + phone$ + CRLF$
      z = wate
      Response z, "CONNECT"
      IF z >= 0 THEN EXIT DO
      SLEEP 3
      choice$ = INKEY$
    LOOP UNTIL choice$ = CHR$(27)
    IF choice$ = CHR$(27) THEN
      ClearInputBuffer
      transmit OffHook$ + CRLF$
      z = 0
      Response z, "OK"
    END IF
    LINE (4, 336)-(634, 344), 9, BF
  ELSE
    CarrierDetect 2
  END IF
EXIT SUB
getcfg:
  IF Exists(file$) THEN
    FOR x = 1 TO 4
      inline$ = BufIn$(file$, done)
      SELECT CASE x
	CASE 1: modem$ = MID$(inline$, 22)
	CASE 2: OffHook$ = MID$(inline$, 22)
	CASE 3: dial$ = MID$(inline$, 22)
	CASE 4: wate = VAL(MID$(inline$, 22))
      END SELECT
    NEXT x
    inline$ = BufIn$(file$, done)
    REDIM phone$(1 TO 5)
    FOR x = 1 TO 5
      phone$(x) = BufIn$(file$, done)
      IF done THEN x = 5
    NEXT x
    y = 260: v = 10
    icon y - 3, v - 3, 346, 96, 15, 8, 7, 0
    icon y, v, 340, 90, 8, 15, 7, 0
    nz = DRAWSTR%(0, "Choose BBS To Dial", y + 100, v + 6, 4, 7, 8)
    v = v + 30
    FOR x = 1 TO 5
      a = INSTR(phone$(x), ":")
      IF a <> 0 THEN
	nz = DRAWSTR%(0, STR$(x) + ">", y + 10, v, 4, 7, 8)
	nz = DRAWSTR%(0, LEFT$(phone$(x), a - 1), y + 45, v, 1, 7, 8)
	nz = DRAWSTR%(0, MID$(phone$(x), a + 1), y + 181, v, 1, 7, 8)
	phone$(x) = MID$(phone$(x), a + 1)
      END IF
      v = v + 9
    NEXT x
    choice = inkey(0, 0)
    choice = choice - 48
    phone$ = ""
    IF choice > 0 AND choice < 6 THEN
      FOR x = 1 TO LEN(phone$(choice))
	IF MID$(phone$(choice), x, 1) <> "-" THEN phone$ = phone$ + MID$(phone$(choice), x, 1)
      NEXT x
    END IF
    IF phone$ = "" THEN EXIT SUB
  ELSE
    ermes "You need to run SETUP.EXE first!", snd
    EXIT SUB
  END IF
RETURN
END SUB

SUB dispinven (choice$)
row% = CSRLIN: col% = POS(0)
dowindo 4, 8, 15
GET (118, 0)-(518, 320), menusav
cubeit 118, 0, 400, 320, 15, 8, 7
LINE (120, 296)-(516, 296), 8
LINE (120, 297)-(516, 297), 15
icon 455, 300, 32, 14, 8, 15, 3, 0
cl = 8 + 128 XOR 7: COLOR cl
LOCATE 39, 20: PRINT "Press <ENTER> to Exit, or # to use:"
pixy = 7
FOR offset = 1 TO dcnt
  nz = DRAWSTR%(0, device(offset), 121, pixy, 1, 7, 8)
  pixy = pixy + 9
NEXT offset
cl = 14 + 128 XOR 3
choice$ = Iinkey$(2, 39, 59, cl, 456)
IF choice$ <> "" THEN choice$ = "U;" + choice$ + CHR$(13)
PUT (118, 0), menusav, PSET
dowindo 4, 15, 8
LOCATE row%, col%
END SUB

SUB dooptions (keyinput$, expr)
SELECT CASE RIGHT$(keyinput$, 1)       '0 #$%&
CASE ";"                                  'f1
  viewfile
CASE "<"                                  'f2
  setalarm
CASE "="                            'F3
  starlog
CASE ">"                            'F4
  IF CarrierLost% THEN
    ermes "Need to be online to access this feature.", snd
  ELSE
    keyinput$ = ""
    dispinven keyinput$
    IF keyinput$ <> "" THEN transmit keyinput$
  END IF
CASE "?"                            'F5
  IF CarrierLost% THEN
    ermes "Need to be online to access this feature.", snd
  ELSE
    IF where = 1 THEN transmit "IS" + CHR$(13)
    'row% = CSRLIN: col% = POS(0)
    'dowindo 5, 8, 15
    'nz = DRAWSTR%(0, "One moment please!", 244, 337, 14, 9, 8)
    'LOCATE row, col
    'transmit "~|~[SF"
    'LOCATE row, col
  END IF
CASE "@"                            'F6
  IF CarrierLost% THEN
    ermes "Need to be online to access this feature.", snd
  ELSE
    explore
  END IF
CASE "A"                             'F7
  MacroScreen
CASE "B"                             'F8
  config
CASE "C"                               'f9
  sheltodos expr
CASE "D"                              'f10
  uudev macon, expr
  IF macon = 1 THEN transmit CHR$(13)
  macon = 0
CASE ","                  'alt z to enlarge
  adjustscreen expr, menusav()
CASE "!"                  'ALT F  flea market
  IF regit = 1 THEN fleamarket ELSE ermes "Only Available to Registered Users", 1
CASE ""                  'ALT P port find
  IF regit = 1 THEN portfind menusav(), maxline ELSE ermes "Only Available to Registered Users", 1
CASE "."                  'ALT C cabal
  IF regit = 1 THEN
    row% = CSRLIN: col% = POS(0)
    dowindo 12, 8, 15
    nz = DRAWSTR%(0, "S", 140, 337, 0, 9, 8)
    nz = DRAWSTR%(0, "can a log file for Cabal, or Report Cabal?", 148, 337, 14, 9, 8)
    nz = DRAWSTR%(0, "R", 379, 337, 0, 9, 8)
    DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ = "S" OR choice$ = "R" OR choice$ = CHR$(13)
    IF choice$ <> CHR$(13) THEN
      IF choice$ = "S" THEN cabalfind menusav(), log$, planet$() ELSE cabalreport
    END IF
    LINE (4, 336)-(634, 344), 9, BF
    dowindo 12, 15, 8
    LOCATE row, col
  ELSE
    ermes "Only Available to Registered Users", 1
  END IF
CASE ""                  'recorder
  recorder
CASE ELSE
  IF CarrierLost <> 1 THEN
    nz = INSTR("xyz{|/0 #$%&", RIGHT$(keyinput$, 1))
    IF nz <> 0 THEN ALTkey keyinput$, nz
  END IF
END SELECT
keyinput$ = ""
END SUB

SUB emul (st$) STATIC

IF LEN(st$) > 2 THEN
  z = INSTR(st$, CRLF$)
  st$ = MID$(st$, z + 1)
END IF
FOR disp0% = 1 TO LEN(st$)
  ch0$ = MID$(st$, disp0%, 1)
  IF ANSIcode0% THEN
    IF LEFT$(ANSIst0$, 2) = "[M" OR LEFT$(ANSIst0$, 2) = "[m" THEN
      IF ASC(ch0$) = 14 THEN
	ANSIst0$ = ""
	ANSIcode0% = 0
      ELSE
	ANSIst0$ = ANSIst0$ + ch0$
      END IF
    ELSEIF INSTR("ABCDEFGHIJKLMNOPQRSTUVWXYZ", UCASE$(ch0$)) THEN
	 SELECT CASE ch0$
	    CASE "A": GOSUB CursorUp0
	    CASE "B": GOSUB CursorDown0
	    CASE "C": GOSUB CursorRight0
	    CASE "D": GOSUB CursorLeft0
	    CASE "H", "f": GOSUB CursorLocate0
	    CASE "s": GOSUB SaveCursorPosn0
	    CASE "u": GOSUB RestCursorPosn0
	    CASE "J": GOSUB BigErase0
	    CASE "K": GOSUB SmallErase0
	    CASE "h", "l": REM  set display mode... ignored
	    CASE "m": GOSUB SetColors0
	    CASE ELSE
	       PRINT ANSIst0$;
	       ANSIcode0% = 0: ANSIst0$ = ""
	 END SELECT
	 ANSIst0$ = ""
	 ANSIcode0% = 0
      ELSEIF ASC(ch0$) <= 32 OR LEN(ANSIst0$) > 60 THEN   'special chr
	 ANSIcode0% = 0: ANSIst0$ = ""
      ELSE
	 ANSIst0$ = ANSIst0$ + ch0$
      END IF
   ELSEIF ASC(ch0$) = 27 THEN       'turn on ansi characters
      ANSIcode0% = -1
      ANSIst0$ = ""
   ELSE
     IF ch0$ = CHR$(10) THEN                    'end of line
       IF fion > 0 THEN                             'if doing f5
	 getdevices SaveRow0, SaveCol0, fI&(), fion, line$
       ELSE                                    'prints screen/log/scrollback
	 PRINT ch0$;
	 alertchek
	 IF log$ = "ON" THEN PRINT #6, line$
	 updateSBack
       END IF
       col = POS(0): row = CSRLIN
       IF RIGHT$(line$, 4) = "++SF" THEN
	 fion = 1
	 IF row > maxline THEN row = maxline
	 col = LEN(line$) - 3
	 LOCATE row, col: COLOR 0, 0: PRINT "++SF";
	 SaveRow0% = row: SaveCol0% = col
       END IF
       IF row% > maxline THEN
	 ScrnScroll 1, 1, maxline, 80, 1, 0
	 IF maxline = 24 THEN x = 184 ELSE x = 312
	 spacefx 640, 8, x, 7
	 LOCATE maxline, 1
       END IF
       line$ = ""
     ELSEIF ch0$ <> CHR$(13) THEN '                        if not end of line
       doprint ch0$, line$, fore0, back0, fion, row%, col  'print to screen
       IF LEN(line$) = 5 THEN checkmenu                   'display menu
       LOCATE row, col%
     END IF
   END IF
NEXT
EXIT SUB

CursorUp0:
   Tmp0% = VAL(MID$(ANSIst0$, 2))
   IF Tmp0% < 1 THEN Tmp0% = 1
   row0% = CSRLIN: col0% = POS(0)
   row0% = row0% - Tmp0%
   IF row0% < 1 THEN row0% = 1
   LOCATE row0%, col0%
   RETURN

CursorDown0:
   Tmp0% = VAL(MID$(ANSIst0$, 2))
   IF Tmp0% < 1 THEN Tmp0% = 1
   row0% = CSRLIN: col0% = POS(0)
   row0% = row0% + Tmp0%
   IF row0% > 25 THEN row0% = 25
   LOCATE row0%, col0%
   RETURN

CursorLeft0:
   Tmp0% = VAL(MID$(ANSIst0$, 2))
   IF Tmp0% < 1 THEN Tmp0% = 1
   row0% = CSRLIN: col0% = POS(0)
   col0% = col0% - Tmp0%
   IF col0% < 1 THEN col0% = 1
   LOCATE row0%, col0%
   RETURN

CursorRight0:
   Tmp0% = VAL(MID$(ANSIst0$, 2))
   IF Tmp0% < 1 THEN Tmp0% = 1
   row0% = CSRLIN: col0% = POS(0)
   col0% = col0% + Tmp0%
   IF col0% > 80 THEN col0% = 80
   LOCATE row0%, col0%
   RETURN

CursorLocate0:
   row0% = VAL(MID$(ANSIst0$, 2))
   Tmp0% = INSTR(ANSIst0$, ";")
   IF Tmp0% THEN
      col0% = VAL(MID$(ANSIst0$, Tmp0% + 1))
   ELSE
      col0% = 1
   END IF
   IF row0% < 1 THEN
      row0% = 1
   ELSEIF row0% > 25 THEN
      row0% = 25
   END IF
   IF col0% < 1 THEN
      col0% = 1
   ELSEIF col0% > 80 THEN
      col0% = 80
   END IF
   LOCATE row0%, col0%
   RETURN

SaveCursorPosn0:
   IF fion = 0 THEN SaveRow0% = CSRLIN: SaveCol0% = POS(0)
   RETURN

RestCursorPosn0:
   IF SaveRow0% > 0 THEN
      LOCATE SaveRow0%, SaveCol0%
   END IF
   RETURN

BigErase0:
   IF maxline = 24 THEN x = 200 ELSE x = 330
   LINE (0, 0)-(639, x), 0, BF
   spacefx 640, x - 16, 1, 150
   LOCATE 1, 1
   RETURN

SmallErase0:
   row0% = CSRLIN: col0% = POS(0)
   ver% = row0% * 8 - 8
   remain = 80 - col0%
   FOR x = 1 TO remain + 1
     hor% = col0% * 8 - 8
     nz = DRAWSTR%(0, " ", hor%, ver%, fore0%, back0%, 8)
     col0% = col0% + 1
   NEXT
   IF col0% > 80 THEN col0% = 80
   LOCATE row0%, col0%
   RETURN

SetColors0:
   ANSIst0$ = MID$(ANSIst0$, 2)
   DO WHILE LEN(ANSIst0$)
      Tmp0% = VAL(ANSIst0$)
      SELECT CASE Tmp0%
	 CASE 0: fore0% = 7: back0% = 0             ' reset colors
	 CASE 1: fore0% = (fore0% OR 8)             ' high intensity
	 CASE 2: fore0% = (fore0% AND &H17)         ' normal intensity
	 CASE 5: fore0% = (fore0% OR 16)            ' blink
	 CASE 7: fore0% = 0: back0% = 7             ' reverse video
	 CASE 8
	  fore0% = 0: back0% = 0            ' invisible
	 CASE 30: fore0% = (fore0% AND &H18)        ' black foreground
	 CASE 31: fore0% = (fore0% AND &H18) OR 4   ' red foreground
	 CASE 32: fore0% = (fore0% AND &H18) OR 2   ' green foreground
	 CASE 33: fore0% = (fore0% AND &H18) OR 6   ' yellow foreground
	 CASE 34: fore0% = (fore0% AND &H18) OR 1   ' blue foreground
	 CASE 35: fore0% = (fore0% AND &H18) OR 5   ' magenta foreground
	 CASE 36: fore0% = (fore0% AND &H18) OR 3   ' cyan foreground
	 CASE 37: fore0% = (fore0% OR 7)            ' white foreground
	 CASE 40: back0% = 0                        ' black background
	 CASE 41: back0% = 4                        ' red background
	 CASE 42: back0% = 2                        ' green background
	 CASE 43: back0% = 6                        ' yellow background
	 CASE 44: back0% = 1                        ' blue background
	 CASE 45: back0% = 5                        ' magenta background
	 CASE 46: back0% = 3                        ' cyan background
	 CASE 47: back0% = 7                        ' white background
	 CASE ELSE                                  ' ignore anything weird
      END SELECT
      Tmp0% = INSTR(ANSIst0$, ";")
      IF Tmp0% THEN
	 ANSIst0$ = MID$(ANSIst0$, Tmp0% + 1)
      ELSE
	 ANSIst0$ = ""
      END IF
   LOOP
   RETURN
END SUB

SUB explore STATIC
dowindo 6, 8, 15
IF numturns = 0 THEN
  row% = CSRLIN: col% = POS(0)
  REDIM planet$(1 TO 10)
  nz = DRAWSTR%(0, "Manual Mode or Automatic Mode?", 200, 337, 14, 9, 8)
  nz = DRAWSTR%(0, "M", 200, 337, 0, 9, 8)
  nz = DRAWSTR%(0, "A", 320, 337, 0, 9, 8)
  z = inkey%(0, 1)
  IF z = 13 OR z = 27 THEN dowindo 6, 15, 8: EXIT SUB
  IF z <> 65 THEN z = 77 ELSE IF log$ = "OFF" THEN starlog
  cubeit 130, 0, 380, 20, 15, 8, 7
  nz = DRAWSTR%(0, "To run this feature you'll need Device #168", 144, 7, 0, 7, 8)
  nz = DRAWSTR%(0, "Enter a sector number to start at: ", 14, 337, 14, 9, 8)
  cl2 = 0 + 128 XOR 9
  startsec = VAL(Iinkey$(4, 43, 38, cl2, 288))
  LINE (4, 335)-(634, 345), 9, BF
  nz = DRAWSTR%(0, "Enter the number of times (turns) you wish to spend: ", 14, 337, 14, 9, 8)
  numturns = VAL(Iinkey$(4, 43, 56, cl2, 435))
  LINE (4, 335)-(634, 345), 9, BF
  IF numturns = 0 THEN numturns = 1
  IF startsec <> 0 THEN expr = startsec
  IF expr = 0 THEN expr = 9
  LOCATE row%, col%
END IF
'
DO
  IF maxline = 24 THEN GOSUB stats
  numturns = numturns - 1
  sw = 0: look$ = INKEY$: look$ = ""
  DO
    IF sw = 0 THEN
      send$ = "v;168;" + LTRIM$(STR$(expr)) + CHR$(13)
      transmit send$
      IF z = 65 THEN look$ = "lp]"
      IF look$ = "" THEN sw = 0 ELSE sw = 1
    END IF
    IF CarrierLost% THEN Nocary
    IF keyin$ = CHR$(27) THEN EXIT DO
    keyin$ = INKEY$
    DO WHILE DataWaiting
      modemin$ = CHR$(ReadChar)
      emul modemin$
      IF RIGHT$(line$, LEN(look$)) = look$ THEN sw = 0
    LOOP
  LOOP UNTIL sw = 0 OR keyin$ = CHR$(27)
  expr = expr + 2
LOOP UNTIL z = 77 OR numturns = 0 OR keyin$ = CHR$(27)
expr = expr - 2
IF maxline = 24 THEN GOSUB stats
expr = expr + 2
IF z = 65 THEN
  row% = CSRLIN: col% = POS(0)
  nz = DRAWSTR%(0, "Would you like to scan .LOG file for any Cabal/Planets found?   Y/n", 56, 337, 14, 9, 8)
  z = inkey%(0, 1)
  IF z <> 78 THEN  'if didn't press N
    starlog
    cabalfind menusav(), log$, planet$()
  END IF
  LOCATE row%, col%
END IF
dowindo 6, 15, 8
EXIT SUB
'
stats:
row% = CSRLIN: col% = POS(0)
LINE (232, 254)-(270, 263), 3, BF
LINE (182, 254)-(220, 263), 3, BF
CLR = 14 + 128 XOR 3: COLOR CLR
LOCATE 33, 24: PRINT USING "####"; expr
LOCATE 33, 30: PRINT USING "####"; numturns
LOCATE row%, col%
RETURN
END SUB

SUB fleamarket
STATIC afile$
row% = CSRLIN: col% = POS(0)
dowindo 11, 8, 15
IF afile$ = "" THEN
  DoDirScreen menusav(), afile$
ELSE
  GET (0, 0)-(639, 200), menusav
  cubeit 0, 0, 640, 201, 15, 8, 7
  icon 7, 6, 627, 189, 8, 15, 7, 0
END IF
IF Exists(afile$) THEN
  DO
    REDIM help(200) AS STRING * 76
    size = 0: cnt = 0
    DO
      inbar "Enter a device to search for (partial name OK): ", name$, 20, 14, 15, 9, snd
    LOOP UNTIL LEN(name$) > 2
    name$ = UCASE$(name$)
    LINE (4, 336)-(634, 344), 9, BF
    nz = DRAWSTR%(0, "Now Processing!", 260, 337, 15, 9, 8)
    DO
      inline$ = UCASE$(BufIn$(afile$, done))
      IF done THEN EXIT DO
      a = INSTR(inline$, name$)
      IF a <> 0 THEN
	a = INSTR(inline$, "]")
	IF a = 0 THEN cnt = cnt + 1: help(cnt) = RIGHT$(inline$, LEN(inline$) - 7) + " " + LEFT$(inline$, 7)
      END IF
    LOOP
    QSORT 1, cnt
    FOR x = 1 TO cnt
      help(x) = RIGHT$(help(x), 5) + " " + LEFT$(help(x), 70)
    NEXT
    LINE (4, 336)-(634, 344), 9, BF
    LINE (9, 9)-(632, 193), 7, BF
    size = cnt
    IF size > 22 THEN pnthigh = 22 ELSE pnthigh = size
    a$ = INKEY$: cnt = 16
    FOR x = 1 TO pnthigh
      nz = DRAWSTR%(0, help(x), 17, cnt, 8, 7, 8)
      cnt = cnt + 8
    NEXT
    LINE (4, 336)-(634, 344), 9, BF
    nz = DRAWSTR%(0, "[     PageUp  PageDown ]      Any Other Key To Return", 90, 337, 14, 9, 8)
    scrollit 1, pnthigh, size, snd
    LINE (4, 336)-(634, 344), 9, BF
    nz = DRAWSTR%(0, "Care to do another (Y/N)?", 220, 337, 14, 9, 8)
    DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ = "Y" OR choice$ = "N"
  LOOP UNTIL choice$ = "N"
ELSE
  IF file$ <> "" THEN ermes "File not found in the current directory.", 1
END IF

LINE (4, 336)-(634, 344), 9, BF
LINE (0, 0)-(639, 201), 0, BF
PUT (0, 0), menusav, PSET
REDIM help(1) AS STRING * 76
dowindo 11, 15, 8
LOCATE row, col
END SUB

SUB init (dosfg, dosbg)
'--------  saves original pc colors
SCREEN 0
SHELL "CLS"
DEF SEG = &HB800
dosclr = PEEK(1)
dosfg = dosclr AND 15
dosbg = (dosclr \ 16) AND 7
DEF SEG
'----------- gets registered name
regit = 0
IF Exists("register.key") THEN
  OPEN "i", 1, "register.key"
  LINE INPUT #1, regname$
  LINE INPUT #1, key1$
  key$ = "willhenry"
  CALL Crypt(regname$, key$, 10)
  IF key$ = key1$ THEN regit = 1
  CLOSE #1
END IF
'--------- all is set have regname, now disply ---------------
LOCATE 1, 1, 0
menubar
'------ loads settings/data -----------------
device(1) = "   Your bays have not been loaded into memory."
device(2) = "       From the MAIN prompt in UU type: U"
CRLF$ = CHR$(10) + CHR$(13)
dcnt = 2: log$ = "OFF": maxline = 24
savecfg 1
loadmac
REDIM SCROLLBACK(1 TO sbksiz) AS STRING * 76
END SUB

SUB loadmac
x = 20: y = 6
REDIM macro$(1 TO x)
FileSpec$ = "*.mac"
found$ = DIR$(FileSpec$)
IF LEN(found$) THEN
  macro$(1) = RTRIM$(found$): cnt = 2
  DO WHILE LEN(found$)
    found$ = DIR$("")
    macro$(cnt) = RTRIM$(found$)
    cnt = cnt + 1: IF cnt = y THEN EXIT DO
  LOOP
END IF

IF Exists("macros.uut") THEN
  filenum = FREEFILE
  OPEN "I", filenum, "macros.uut"
  IF LOF(filenum) <> 0 THEN
  DO
    LINE INPUT #filenum, inline$
    IF LEFT$(inline$, 1) = "'" THEN
      IF LEN(inline$) > 73 THEN inline$ = LEFT$(inline$, 73)
      macrod$(y) = MID$(inline$, 2)
      y = y - 1
    ELSE
      macro$(y) = inline$
      IF LEN(inline$) > 72 THEN macro$(y) = LEFT$(macro$(y), 72)
    END IF
    y = y + 1
    IF y > x THEN EXIT DO
  LOOP UNTIL EOF(filenum)
  END IF
  CLOSE filenum
END IF
END SUB

SUB MacroScreen
row% = CSRLIN: col% = POS(0)
dowindo 7, 8, 15
loadmac
cl = 8 + 128 XOR 7: cl1 = 4 + 128 XOR 7
bottom = 200: x = 23: y = 9: z = 622: hor = 417
GET (0, 0)-(639, bottom), menusav
cubeit 0, 0, 640, bottom, 15, 8, 7
icon 7, 6, 627, bottom - 12, 8, 15, 7, 0
icon 31, 11, 600, bottom - 72, 8, 15, 1, 0
icon y, bottom - 59, z, 15, 8, 15, 7, 0
smallprint hor, bottom - 30, "AVAILABLE MACROS", 9
smallprint hor + 1, bottom - 30, "AVAILABLE MACROS", 9
COLOR cl
LOCATE x, 4: PRINT "Hit <ENTER> to exit, or letter of macro to edit. To run a macro, exit this"
LOCATE x + 1, 4: PRINT "menu, hit <ALT> key along with the letter or number of the macro to run."
COLOR cl1: y = 2
FOR x = 81 TO 86
  y = y + 1
  LOCATE y, 3: PRINT CHR$(x) + ":"
NEXT x

  FOR x = 65 TO 76
    IF x = 70 OR x = 67 THEN x = x + 1
    IF x = 71 THEN x = x + 1
    y = y + 1
    LOCATE y, 3: PRINT CHR$(x) + ":"
  NEXT x
  x = 50: y = 160
  icon x, y, 50, 12, 15, 8, 7, 0
  smallprint x + 20, y + 9, "LIP", 0
  smallprint x + 21, y + 9, "LIP", 0
  smallprint x + 11, y + 9, "F", 4
  smallprint x + 12, y + 9, "F", 4

IF macro$(1) <> "" THEN         'print .mac files
  x = 12: z = 5: offset = 126
  FOR y = 1 TO z
    nz = DRAWSTR%(0, LTRIM$(STR$(y)) + ":", x, bottom - 54, 4, 7, 8)
    nz = DRAWSTR%(0, LEFT$(macro$(y), 12), x + 17, bottom - 54, 0, 7, 8)
    x = x + offset
  NEXT
ELSE
  x = 145
  nz = DRAWSTR%(0, "No .MAC files found in the current directory.", 150, x, 0, 7, 8)
END IF

clm = 16: y = 20: z = 6
FOR x = z TO y
  nz = DRAWSTR%(0, macrod$(x), 40, clm, 14, 1, 8)
  clm = clm + 8
NEXT x

again:
clm = 0
DO
  IF alarmtime$ = LEFT$(TIME$, 5) THEN doalarm alarmsw
  choice$ = INKEY$
LOOP UNTIL choice$ <> ""
choice$ = UCASE$(choice$)
nz = INSTR("QRSTUVABDEHIJKL", choice$): y = 6: z = 20
IF nz <> 0 THEN
  mc = (y - 1) + nz: nz = nz + 2: clm = 6
  LOCATE nz, clm: PutText2 "Û", 2, 1
  IF flip = 1 THEN edittext nz, clm, macro$(mc), 6, 78 ELSE edittext nz, clm, macrod$(mc), 6, 78
  file$ = "macros.uut"
  filenum = FREEFILE
  OPEN "O", filenum, file$
  FOR x = y TO z
    IF macrod$(x) <> "" THEN PRINT #filenum, "'" + macrod$(x)
    PRINT #filenum, macro$(x)
  NEXT
  CLOSE filenum
  clm = 1
END IF
IF clm = 1 THEN GOTO again
IF nz <> 0 OR choice$ <> "F" THEN GOTO there

LINE (34, 13)-(627, 137), 1, BF
z = 16
FOR x = 6 TO 20
  IF flip = 1 THEN
    nz = DRAWSTR%(0, macrod$(x), 40, z, 14, 1, 8)
  ELSE
    nz = DRAWSTR%(0, macro$(x), 40, z, 14, 1, 8)
  END IF
  z = z + 8
NEXT x
IF flip = 0 THEN flip = 1 ELSE flip = 0
GOTO again

there:
PUT (0, 0), menusav, PSET
dowindo 7, 15, 8
LOCATE row%, col%
END SUB

SUB menubar
WIDTH 80, 43
SCREEN 9, , 0, 1
'
doGFX "L", "uuTSCRN0", 0, 201, menusav()
doGFX "L", "uutscrn2", 8, 10, menusav()
x = 42: y = 10: GET (x, y)-(x + 24, y + 23), Bhole
x = 91: y = 10: GET (x, y)-(x + 24, y + 23), planet
x = 115: y = 10: GET (x, y)-(x + 23, y + 23), proc
x = 67: y = 10: GET (x, y)-(x + 23, y + 23), cabal
'
FOR ver = 6 TO 196 STEP 7              'shield scren
  icon 0, ver, 640, 6, 15, 8, 7, 0
NEXT ver
LINE (140, 94)-(500, 104), 7, BF      'where reg name goes
LINE (140, 90)-(140, 110), 15
LINE (500, 90)-(500, 110), 8
IF regit = 0 THEN
  shad = 6: textcl = 14: sp = shad
  spx = 175: spy = 104
  FOR i = 0 TO 1
    smallprint spx + i, spy, "UUTERM@", sp
    sp = textcl: spy = spy - 1
  NEXT
  tinyfont 275, 103, "COPYRIGHT 1995, BY WILL BOYETT", 8
ELSE
  text$ = "Registered To: " + regname$
  cl = 14 + 128 XOR 8
  disp text$, cl, 13
END IF
SCREEN 9, , 0, 0
CLR = 14 + 128 XOR 3: COLOR CLR
LOCATE 33, 24: PRINT USING "####"; expr
LOCATE 33, 30: PRINT USING "####"; numturns
END SUB

SUB portfind (menusav(), maxline)
row% = CSRLIN: col% = POS(0)
dowindo 13, 8, 15
DoDirScreen menusav(), file$
LINE (0, 0)-(639, 201), 0, BF
PUT (0, 0), menusav, PSET
IF Exists(file$) THEN
  x = INSTR(file$, ".")
  IF x <> 0 THEN outfil$ = (LEFT$(file$, x - 1)) + ".POR"
  DO
    size = 0
    LINE (4, 336)-(634, 344), 9, BF
    nz = DRAWSTR%(0, "What type of port are you interested in:   rading    uys All    ells All", 30, 337, 14, 9, 8)
    nz = DRAWSTR%(0, "T", 365, 337, 0, 9, 8)
    nz = DRAWSTR%(0, "B", 444, 337, 0, 9, 8)
    nz = DRAWSTR%(0, "S", 533, 337, 0, 9, 8)
    DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ = "T" OR choice$ = "B" OR choice$ = "S"
    LINE (4, 336)-(634, 344), 9, BF
    nz = DRAWSTR%(0, "Now Processing!", 260, 337, 15, 9, 8)

'outfil$ has save name - file$ has logg name  - choice$ has class
    DO                                          'determines logg type
      inline$ = BufIn$(file$, done)
      IF done THEN EXIT DO
    LOOP UNTIL LEFT$(inline$, 6) = "Sector"
    a = INSTR(inline$, "Selling")
    IF a <> 0 THEN x = 1 ELSE x = 2
    IF choice$ = "T" THEN
      REDIM water(1 TO 50), power(1 TO 50), PORTS(1)
    ELSE
      REDIM PORTS(50), water(1), power(1)
    END IF
    trade1 x, choice$, PORTS(), water(), power(), file$
    OPEN "a", 5, outfil$
    PRINT #5, ""
    PRINT #5, "Date: "; DATE$
    IF choice$ = "T" THEN PRINT #5, "   WATER       POWER"
    IF choice$ = "B" THEN PRINT #5, "   BUYS ALL"
    IF choice$ = "S" THEN PRINT #5, "   SELLS ALL"
    PRINT #5, " --------------------"
    IF choice$ = "T" THEN
      FOR x = 1 TO 50
	size = size + 1
	PRINT #5, "  "; water(x), power(x)
	IF water(x) = 0 AND power(x) = 0 THEN x = 50
      NEXT
    ELSE
      FOR x = 1 TO 50
	size = size + 1
	PRINT #5, "    "; PORTS(x)
	IF PORTS(x) = 0 THEN x = 50
      NEXT
    END IF
    PRINT #5, "END"
    CLOSE #5
    LINE (4, 336)-(634, 344), 9, BF
    text$ = "Data appended to file " + UCASE$(outfil$) + ".  Care to do another (Y/N)?"
    x = (640 - (LEN(text$) * 8)) \ 2
    nz = DRAWSTR%(0, text$, x, 337, 14, 9, 8)
    DO: choice$ = UCASE$(INKEY$): LOOP UNTIL choice$ = "Y" OR choice$ = "N"
  LOOP UNTIL choice$ = "N"
ELSE
  IF file$ <> "" THEN ermes "File not found in the current directory.", 1
END IF
dowindo 13, 15, 8
LINE (4, 336)-(634, 344), 9, BF
LOCATE row%, col%
REDIM water(1), power(1), PORTS(1)
END SUB

SUB printstat (z)
IF z < 0 THEN z = 0
LINE (232, 254)-(270, 263), 3, BF
LINE (182, 254)-(220, 263), 3, BF
CLR = 14 + 128 XOR 3: COLOR CLR
LOCATE 33, 24: PRINT USING "####"; z
LOCATE 33, 30: PRINT USING "####"; numturns
x = snd: snd = 0
IF log$ = "ON" THEN dowindo 3, 8, 15
IF alarmsw = 2 THEN dowindo 2, 8, 15
IF recon <> 0 THEN dowindo 14, 8, 15
snd = x
END SUB

SUB recorder STATIC
IF recfirst = 0 THEN
  dowindo 14, 8, 15
  IF CarrierLost THEN
    IF Exists("recorder.uut") THEN
      OPEN "i", 7, "recorder.uut": recon = 1
      recfirst = 1
      IF LOF(7) = 0 THEN
	closerecord recon, recfirst, maxline, 2
	closerecord recon, recfirst, maxline, 1
	KILL "recorder.UUT"
      END IF
    ELSE
      closerecord recon, recfirst, maxline, 2
    END IF
  ELSE
    OPEN "o", 7, "recorder.uut": recon = 2: recfirst = 1
  END IF
ELSE
  closerecord recon, recfirst, maxline, 1
END IF
END SUB

SUB savecfg (sw)
file$ = "UUTerm.cfg"
z = FREEFILE
IF sw = 0 THEN
  OPEN "O", #z, file$
  PRINT #z, snd%, spce, snddev
  PRINT #z, Port%, HS, IRQ, Baud&
  PRINT #z, xmsflag, sbksiz
  WRITE #z, linport$
ELSE
  OPEN "I", z, file$
  INPUT #z, snd%, spce, snddev
  INPUT #z, Port%, HS, IRQ%, Baud&
  INPUT #z, xmsflag, sbksiz
  INPUT #z, linport$
END IF
CLOSE #z
END SUB

SUB setalarm
row% = CSRLIN: col% = POS(0)
IF alarmsw <> 2 THEN dowindo 2, 8, 15
inbar "How many minutes till alarm sounds:", file$, 3, 15, 0, 3, snd
wait1 = VAL(file$)
IF wait1 > 0 THEN
  alarmsw = 2
  icon 120, 253, 44, 12, 8, 15, 3, 0
  alarmtime$ = TIME$
  hour = VAL(LEFT$(alarmtime$, 2))
  min = VAL(MID$(alarmtime$, 4, 2))
  min = min + wait1
  DO UNTIL min < 60
    hour = hour + 1
    min = min - 60
  LOOP
  IF hour > 23 THEN hour = hour - 24
  hour$ = LTRIM$(STR$(hour))
  IF LEN(hour$) = 1 THEN hour$ = "0" + hour$
  min$ = LTRIM$(STR$(min))
  IF LEN(min$) = 1 THEN min$ = "0" + min$
  alarmtime$ = hour$ + ":" + min$
  LOCATE row%, col%
ELSE
  IF alarmsw <> 2 THEN dowindo 2, 15, 8
END IF
END SUB

SUB sheltodos (expr)
row% = CSRLIN: col% = POS(0)
soundfx 7
IF row > 24 THEN
  y = row * 8
  y = y - 192
END IF
doGFX "S", "temp", 0, y, menusav()
startdir$ = CurDir$
WIDTH 80, 25
SCREEN 0
COLOR 14, 0: PRINT "Type EXIT to return to UUTERM"
SHELL
IF CurDir$ <> startdir$ THEN CHDIR startdir$
restscrn menusav(), y
LOCATE row%, col%
END SUB

SUB starlog STATIC
row% = CSRLIN: col% = POS(0)
IF log$ = "OFF" THEN
  log$ = "ON"
  dowindo 3, 8, 15
  inbar "Enter the filename (an ext of .LOG will be added to your file): ", file$, 8, 14, 0, 9, 0
  IF file$ <> "" THEN
    file$ = LTRIM$(file$)
    IF LEN(file$) > 8 THEN file$ = LEFT$(file$, 8)
    a = INSTR(file$, ".")
    IF a <> 0 THEN file$ = LEFT$(file$, a - 1): a = 0
    file$ = file$ + ".LOG"
    IF Exists(file$) THEN
      soundfx 6
      nz = DRAWSTR%(0, "LOG File already exists, Overwrite .LOG file (Y/n)?", 95, 337, 14, 9, 8)
      choice = inkey(0, 1)
      IF choice = 78 THEN    'no
	OPEN "A", 6, file$
      ELSE
	OPEN "o", 6, file$
      END IF
    ELSE
      OPEN "o", 6, file$
    END IF
    PRINT #6, DATE$ + "      *****************************"
  ELSE
    log$ = "OFF": file$ = ""
  END IF
ELSE
  log$ = "OFF": file$ = "": CLOSE #6
END IF
IF log$ = "OFF" THEN dowindo 3, 15, 8
LOCATE row%, col%
END SUB

SUB updateSBack
FOR x = 1 TO sbksiz - 1
  SWAP SCROLLBACK(x), SCROLLBACK(x + 1)
NEXT x
SCROLLBACK(sbksiz) = line$
END SUB

SUB uudev (macon, expr)
row% = CSRLIN: col% = POS(0)
dowindo 10, 8, 15
PCOPY 0, 1
SCREEN 9, , 0, 1
bottom = 200
cubeit 0, 0, 640, bottom, 15, 8, 7
icon 7, 6, 627, bottom - 12, 8, 15, 7, 0
icon 28, 12, 595, bottom - 45, 8, 15, 1, 0
smallprint 31, bottom - 15, "UTILITY MENU", 0
smallprint 30, bottom - 16, "UTILITY MENU", 14
nz = DRAWSTR%(0, "Here is where you can run DOS commands or other programs.", 170, bottom - 21, 8, 7, 8)
cnt = 18
REDIM help(cnt) AS STRING * 76
FOR x = 1 TO cnt
  help(x) = " "
NEXT x
COLOR 14, 0
file$ = "utility.uut"
IF Exists(file$) THEN
  filenum = FREEFILE
  OPEN "I", filenum, file$
  z = cnt
  IF LOF(filenum) < 80 THEN z = 1
  y = 16
  FOR x = 1 TO z
    LINE INPUT #filenum, help(x)
    nz = DRAWSTR%(0, LEFT$(help(x), 72), 40, y, 14, 1, 8)
    IF EOF(filenum) THEN x = z
    y = y + 8
  NEXT x
  CLOSE filenum
END IF
SCREEN 9, , 0, 0
sw = 0

DO
  donumber nz, choice
  IF alarmtime$ = LEFT$(TIME$, 5) THEN doalarm alarmsw
  IF choice = 82 THEN
    sw = 1
    utility$ = RTRIM$(help(nz - 2))
    startdir$ = CurDir$
    IF row > 24 THEN y = (row * 8) - 192 ELSE y = 0
    SCREEN 9, , 1, 0
    doGFX "S", "temp", 0, y, menusav()
    WIDTH 80, 25
    SCREEN 0
    SHELL utility$
    IF CurDir$ <> startdir$ THEN CHDIR startdir$
    restscrn menusav(), y
    IF CarrierLost% <> 1 THEN macon = 1
    choice = 13
  ELSEIF choice = 69 THEN
    x = 6
    LOCATE nz, x: PutText2 "Û", 2, 1
    utility$ = RTRIM$(help(nz - 2))
    edittext nz, x, utility$, 6, 72
    help(nz - 2) = utility$
  END IF
LOOP UNTIL choice = 13 OR choice = 27

IF sw = 0 THEN PCOPY 1, 0     'if only edited
filenum = FREEFILE
OPEN "o", filenum, file$
FOR x = 1 TO cnt
  PRINT #filenum, help(x)
NEXT x
CLOSE filenum
REDIM help(1) AS STRING * 76
dowindo 10, 15, 8
LOCATE row%, col%
END SUB

SUB viewfile
row% = CSRLIN: col% = POS(0)
PCOPY 0, 1
dowindo 1, 8, 15
nz = DRAWSTR%(0, "H       S              T        ", 210, 337, 0, 9, 8)
nz = DRAWSTR%(0, "elp", 218, 337, 14, 9, 8)
nz = DRAWSTR%(0, "croll Back", 282, 337, 14, 9, 8)
nz = DRAWSTR%(0, "ext File", 401, 337, 14, 9, 8)
DO
  choice = inkey(1, 0)
  IF alarmtime$ = LEFT$(TIME$, 5) THEN doalarm alarmsw
  IF choice = 27 OR choice = 13 THEN EXIT DO
LOOP UNTIL choice = 72 OR choice = 83 OR choice = 84
LINE (4, 336)-(634, 344), 9, BF
IF choice = 72 OR choice = 83 OR choice = 84 THEN
  cubeit 0, 0, 640, 201, 15, 8, 7
  icon 7, 6, 627, 189, 8, 15, 7, 0
END IF
cl1 = 14 + 128 XOR 9: COLOR cl1
pntlow = 1: pnthigh = 22
cnt = 0: sw = 0
SELECT CASE choice
CASE IS = 84
  readdir
  DO
    inbar "Enter the name of the file to view:", file$, 12, 14, 15, 9, snd
    IF file$ = "" THEN EXIT DO
    IF NOT Exists(file$) THEN
      ermes "File not found in the current directory.", 1
      sw = 1
    END IF
  LOOP UNTIL Exists(file$)
  LINE (4, 336)-(634, 344), 9, BF
  cnt = 0
  IF file$ <> "" THEN
    DO
      inline$ = BufIn$(file$, done)
      cnt = cnt + 1
    LOOP UNTIL done
    IF cnt < pnthigh THEN pnthigh = cnt ELSE IF cnt > 850 THEN cnt = 850
    REDIM help(1 TO cnt) AS STRING * 76
    x = 0
    DO
      inline$ = BufIn$(file$, done)
      x = x + 1
      IF x <= cnt THEN help(x) = inline$
    LOOP UNTIL done
    LINE (9, 9)-(630, 193), 7, BF
    size = cnt: a$ = INKEY$: cnt = 16
    GOSUB display
  END IF
CASE 72   'H
  IF maxline <> 24 THEN
    ermes "Can only view Icons in 24 line mode (ALT-Z)", 1
  ELSE
    GET (20, 216)-(54, 237), blnk: PUT (55, 136), blnk, PSET
    GET (61, 216)-(95, 237), blnk: PUT (55 + 98, 138), blnk, PSET
    GET (20, 243)-(54, 264), blnk: PUT (55 + 202, 138), blnk, PSET
    GET (61, 243)-(95, 264), blnk: PUT (55 + 304, 138), blnk, PSET
    GET (20, 270)-(54, 291), blnk: PUT (55 + 404, 138), blnk, PSET
    GET (61, 270)-(95, 291), blnk: PUT (55 + 499, 138), blnk, PSET
    GET (22, 304)-(54, 325), blnk: PUT (63, 16), blnk, PSET
    GET (77, 304)-(109, 325), blnk: PUT (190, 16), blnk, PSET
    GET (132, 304)-(164, 325), blnk: PUT (313, 16), blnk, PSET
    GET (187, 304)-(219, 325), blnk: PUT (437, 16), blnk, PSET
    GET (242, 304)-(274, 325), blnk: PUT (559, 16), blnk, PSET
    GET (297, 304)-(329, 325), blnk: PUT (59, 79), blnk, PSET
    GET (352, 304)-(384, 325), blnk: PUT (180, 79), blnk, PSET
    GET (407, 304)-(439, 325), blnk: PUT (303, 79), blnk, PSET
    GET (462, 304)-(495, 325), blnk: PUT (437, 79), blnk, PSET
    GET (521, 304)-(549, 325), blnk: PUT (554, 79), blnk, PSET
    tinyfont 395, 151, "L", 0
    nz = DRAWSTR%(0, "View File      Alarm Clock       Capture     List Devices     List Ship's", 36, 48, 1, 7, 8)
    nz = DRAWSTR%(0, "  Menu                           A  File     On Your Ship      Inventory", 36, 56, 1, 7, 8)
    nz = DRAWSTR%(0, "Explore/Scan     Macro Menu     Configuration    Shell To DOS   Run Another", 18, 109, 1, 7, 8)
    nz = DRAWSTR%(0, "  Universe                          Menu                          Program", 18, 117, 1, 7, 8)
    nz = DRAWSTR%(0, "Exit       Toggle     Locate Sale   Find And    Find Best     Black", 56, 170, 1, 7, 8)
    nz = DRAWSTR%(0, " UUTERM   Display Mode     Items    Report Cabal    Ports        Box", 40, 178, 1, 7, 8)
    LINE (224, 133)-(520, 191), 4, B
    DO
      IF alarmtime$ = LEFT$(TIME$, 5) THEN doalarm alarmsw
    LOOP UNTIL INKEY$ <> ""
  END IF
CASE 83  'S"
  REDIM help(1 TO sbksiz) AS STRING * 76
  FOR x = 1 TO sbksiz
    help(x) = SCROLLBACK(x)
  NEXT x
  size = sbksiz: a$ = INKEY$: cnt = 16
  pnthigh = size: pntlow = size - 21
  GOSUB display
END SELECT
REDIM help(1) AS STRING * 76
PCOPY 1, 0
soundfx 7
LOCATE row%, col%
EXIT SUB
'
display:
FOR x = pntlow TO pnthigh
  nz = DRAWSTR%(0, help(x), 17, cnt, 8, 7, 8)
  cnt = cnt + 8
NEXT
LINE (4, 336)-(634, 344), 9, BF
nz = DRAWSTR%(0, "[     PageUp  PageDown ]      Any Other Key To Return", 90, 337, 14, 9, 8)
scrollit pntlow, pnthigh, size, snd
RETURN
END SUB

