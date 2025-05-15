'this is a shell for a program.
'Aready has many of the routines each of your programs will need.
'All you do is program the main loop. Cut out any routines you don't need

DECLARE SUB register ()
DECLARE SUB mouseinit ()
DECLARE SUB mousespeed (speed%)
DECLARE SUB getmousechoice (choice$)
DECLARE SUB drawscreen ()
DECLARE SUB setspeed (speed%)
DECLARE SUB parse (args$())
DECLARE SUB MouseArea (y1%, y2%, min%, max%)
DECLARE SUB mouseget ()
DECLARE SUB mousepointer (OnOff%)
DEFINT A-Z

TYPE RegType                           'define area for DOS interrrupt calls
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
DECLARE SUB INTERRUPT (intnum AS INTEGER, inreg AS RegType, outreg AS RegType)

ON ERROR GOTO wrong

' $DYNAMIC                                           'dim arrays here
DIM SHARED args$(1 TO 5)
DIM SHARED nomouse%, mouseh%, mousev%, mouseb%    'mouse variables

parse args$()                    'parse command line

SCREEN 0                         'saves users previous screen colors
SHELL "CLS"
DEF SEG = &HB800
dosclr = PEEK(1)
dosfg = dosclr AND 15
dosbg = (dosclr \ 16) AND 7
DEF SEG

CLS                                'clear screen and set mode
errflag = 1                        'will check for proper graphic card
SCREEN 9
errflag = 0

mouseinit                               'see if mouse available
mousepointer 0                          'turn off display of mouse pointer
mousespeed 5                            'set speed of the mouse 0-9

left = 1: right = 630: bottom = 42: top = 0
MouseArea left, bottom, top, right       'set boundaries for mouse

drawscreen                              'display opening screen
setspeed delay      'if animated program, set consistent speed for 286/386/486

PRINT "Press Q when done playing"

DO                                      'main program loop
  mousepointer 1                        'display the mouse pointer
  DO                                    'get some action
    mouseget
    choice$ = UCASE$(INKEY$)
  LOOP UNTIL k% <> mouseb% OR choice$ <> ""
 
  getmousechoice choice$  'if using mouse, find choice
 
  SELECT CASE choice$
    CASE "1"
      'dochoice1
    CASE "A"
      'dochoice2
  END SELECT
LOOP UNTIL choice$ = "Q"             'loop until choose to quit

register                             'do final display screen before exit

COLOR dosfg, dosbg                   'restores original screen colors
CLS
END

wrong:                         'use this only if program requires CGA/EGA/VGA
SELECT CASE errflag
  CASE 1
    SCREEN 0: WIDTH 80
    CLS
    PRINT "You don't have the proper graphic card."
    END
END SELECT

REM $STATIC
DEFSNG A-Z
SUB drawscreen

mousepointer 0       'turn off mouse display
COLOR 11, 12: CLS
PRINT "this is the programs title screen or perhaps a menu of options"
mousepointer 1       'turn on display

END SUB

DEFINT A-Z
SUB getmousechoice (choice$)
IF nomouse THEN EXIT SUB

IF mousev% < 6 AND mouseb% <> 0 THEN          'check for click on menu bar
  IF mouseh% > 8 AND mouseh% < 15 THEN choice$ = "D"
  IF mouseh% > 17 AND mouseh% < 27 THEN choice$ = "P"
  IF mouseh% > 28 AND mouseh% < 40 THEN choice$ = "S"
  IF mouseh% > 41 AND mouseh% < 52 THEN choice$ = "T"
  IF mouseh% > 53 AND mouseh% < 63 THEN choice$ = "X"
  IF mouseh% > 64 AND mouseh% < 73 THEN choice$ = "H"
END IF
END SUB

DEFSNG A-Z
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
  IF nomouse% THEN EXIT SUB
  InRegs.ax = 3
  CALL INTERRUPT(&H33, InRegs, OutRegs)
  mouseb% = OutRegs.bx
  mouseh% = OutRegs.cx / 8 + 1
  mousev% = OutRegs.dx / 8 + 1
END SUB

SUB mouseinit
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

SUB mousepointer (OnOff%)
 IF nomouse% THEN EXIT SUB

 IF OnOff% = 0 THEN OnOff% = 2 ELSE OnOff% = 1
 InRegs.ax = OnOff%
 CALL INTERRUPT(&H33, InRegs, OutRegs)
 IF OnOff% = 1 THEN CALL INTERRUPT(&H33, InRegs, OutRegs) '** to be sure

END SUB

SUB mousespeed (speed%)
 IF nomouse% THEN EXIT SUB

 InRegs.ax = 15
 InRegs.cx = speed%
 InRegs.dx = speed% * 2
 CALL INTERRUPT(&H33, InRegs, OutRegs)
END SUB

SUB parse (args$()) STATIC

ParaLine$ = COMMAND$
FOR i% = 1 TO LEN(ParaLine$)
 IF LEFT$(ParaLine$, 1) <> " " AND LEFT$(ParaLine$, 1) <> "/" THEN EXIT FOR
 p$ = LEFT$(ParaLine$, 1)
 ParaLine$ = MID$(ParaLine$, 2)
 IF p$ = "/" THEN               '** a parameter follows
  p$ = LEFT$(ParaLine$, 1)
  ParaLine$ = MID$(ParaLine$, 2)
  SELECT CASE UCASE$(p$)
   CASE "R": arg(1) = -1
   CASE "I": arg(2) = -1
   CASE "D": arg(3) = -1
   CASE ELSE
    CLS
    PRINT "You tried to use an unknown parameter - /"; p$
    END
  END SELECT
 END IF
NEXT i%

END SUB

DEFINT A-Z
SUB register
mousepointer 0            'turn off mouse display while print to screen
COLOR 14, 1
CLS
PRINT "this is the ending screen usually registration info"
PRINT "press a key to exit..."
SLEEP
END SUB

SUB setspeed (speed)

x! = TIMER
FOR i = 0 TO 499
  y! = SIN(i)
  y! = y! ^ 2
  y! = y! + i
  y! = y! - i
NEXT
y! = TIMER - x!

SELECT CASE y!
  CASE 0 TO 1      '66-486
    speed = 3200
  CASE 1 TO 2.5
    speed = 1600   '33-486
  CASE 2.5 TO 5
    speed = 800    '33-386
  CASE 5 TO 10    '16-386
    speed = 400
  CASE IS > 10    '12-286
    speed = 1
END SELECT

END SUB

