DECLARE SUB mouseget ()
DECLARE SUB mousepointer (OnOff%)
DECLARE SUB mousemovewait ()
DECLARE SUB mousek0wait ()
DECLARE SUB MouseArea (y1%, y2%, min%, max%)
DECLARE SUB mouseinit ()
DECLARE SUB mousespeed (Speed%)

'All the mouse routines you need

TYPE RegType
  ax    AS INTEGER
  bx    AS INTEGER
  cx    AS INTEGER
  dx    AS INTEGER
  bp    AS INTEGER
  si    AS INTEGER
  di    AS INTEGER
  flags AS INTEGER
  ds    AS INTEGER
  es    AS INTEGER
END TYPE
DIM SHARED InRegs AS RegType, OutRegs AS RegType
DECLARE SUB INTERRUPT (intnum AS INTEGER, InReg AS RegType, OutReg AS RegType)

DIM SHARED nomouse%, mouseh%, mousev%, mouseb%
SCREEN 9
CLS
mouseinit               'initialize for mouse
mousepointer 1          'turn on mouse pointer  0=off
mousespeed 9            'set speed of mouse 0-9
MouseArea 10, 30, 50, 590
  mouseget                                     'checks for key or mouse press
  k% = mouseb%
  DO
    mouseget
    choice$ = UCASE$(INKEY$)
  LOOP UNTIL k% <> mouseb% OR choice$ <> ""
  IF choice$ <> "" THEN GOTO executechoice      'keypress
  IF mouseh% < 28 THEN x = 65              'mouse
  IF mouseh% > 28 THEN x = 73
  IF mouseh% > 51 THEN x = 81
  IF mousev% > 35 THEN x = x + 7: choice$ = CHR$(x): GOTO executechoice
  IF mousev% > 31 THEN x = x + 6: choice$ = CHR$(x): GOTO executechoice
  IF mousev% > 27 THEN x = x + 5: choice$ = CHR$(x): GOTO executechoice
  IF mousev% > 24 THEN x = x + 4: choice$ = CHR$(x): GOTO executechoice
  IF mousev% > 21 THEN x = x + 3: choice$ = CHR$(x): GOTO executechoice
  IF mousev% > 17 THEN x = x + 2: choice$ = CHR$(x): GOTO executechoice
  IF mousev% > 13 THEN x = x + 1: choice$ = CHR$(x): GOTO executechoice
  choice$ = CHR$(x)
executechoice:

END

SUB MouseArea (y1%, y2%, min%, max%)
 '** Define area for mouse movement, y1% thru y2%

 IF nomouse% THEN EXIT SUB

 InRegs.ax = 8
 InRegs.cx = y1% * 8 - 8
 InRegs.dx = y2% * 8 - 8
 CALL INTERRUPT(&H33, InRegs, OutRegs)
   
 InRegs.ax% = &H7
 InRegs.cx% = min%
 InRegs.dx% = max%
 CALL INTERRUPT(&H33, InRegs, OutRegs)
 
END SUB

SUB mouseget
  '*** Get mouse position and button status: mouseh%, mousev% and MouseB%

  IF nomouse% THEN EXIT SUB
  InRegs.ax = 3
  CALL INTERRUPT(&H33, InRegs, OutRegs)
  mouseb% = OutRegs.bx
  mouseh% = OutRegs.cx / 8 + 1
  mousev% = OutRegs.dx / 8 + 1

END SUB

SUB mouseinit
 '*** Initialize mouse driver

 IF nomouse% THEN EXIT SUB

 InRegs.ax = 0                  '** Mouse initialization
 CALL INTERRUPT(&H33, InRegs, OutRegs)
 IF OutRegs.ax = 0 THEN nomouse% = 1: EXIT SUB   '*** no mouse driver

 InRegs.ax = 10                 '** Mouse should blink
 InRegs.bx = 0
 InRegs.cx = &HFFFF
 InRegs.dx = &HFF00
 CALL INTERRUPT(&H33, InRegs, OutRegs)

END SUB

SUB mousek0wait
  '*** wait for mouse click

WHILE mouseb%
  mouseget
WEND
END SUB

SUB mousemovewait
 '*** wait for mouse movement or click

 IF nomouse% THEN EXIT SUB
 mouseget
 x% = mouseh%: y% = mousev%: k% = mouseb%
 DO
  mouseget
 LOOP UNTIL x% <> mouseh% OR y% <> mousev% OR k% <> mouseb%
END SUB

SUB mousepointer (OnOff%)
   '*** mouse pointer on/off

 IF nomouse% THEN EXIT SUB

 IF OnOff% = 0 THEN OnOff% = 2 ELSE OnOff% = 1
 InRegs.ax = OnOff%
 CALL INTERRUPT(&H33, InRegs, OutRegs)
 IF OnOff% = 1 THEN CALL INTERRUPT(&H33, InRegs, OutRegs) '** to be sure

END SUB

SUB mousespeed (Speed%)
   '*** Set mouse speed

 IF nomouse% THEN EXIT SUB

 InRegs.ax = 15
 InRegs.cx = Speed%
 InRegs.dx = Speed% * 2
 CALL INTERRUPT(&H33, InRegs, OutRegs)
END SUB

