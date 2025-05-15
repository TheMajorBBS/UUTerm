DECLARE SUB main ()
DECLARE SUB radar ()
DECLARE SUB loadgpxs ()
DECLARE SUB disp (title$, cl%, row%)
DECLARE SUB cubeit (h%, v%, WD%, HT%, C1%, C2%, FILD%)
DECLARE SUB icon (h%, v%, WD%, HT%, C1%, C2%, FILD%, OUTIN%)
DECLARE SUB smallprint (spx%, spy%, sp$, spcolor%)
DECLARE SUB tinyfont (hor%, ver%, inline$, clr%)
DECLARE FUNCTION Exists% (filen$)
DECLARE FUNCTION DRAWSTR% (mode%, strg$, x0%, y0%, fg%, bg%, gap%)
DECLARE SUB DRAWDOT (mode%, value%, x0%, y0%)

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

DEFINT A-Z
COMMON SHARED pat$, spce, pattern$, patt$

REDIM SHARED bhole(271), planet(271), proc(271)
REDIM SHARED exits(192), zoom(192), cabal(192), portit(192), macro(192)
REDIM SHARED flea(256), recrder(192), viewit(192), conf(192), strlog(192)
REDIM SHARED bays(192), inven(192), explr(192), alarm(192), dosit(256)
REDIM SHARED util(192)
REDIM SHARED menusav(1 TO 32767)
spce = 1

pattern$ = CHR$(191) + CHR$(191) + CHR$(191) + CHR$(72)
pattern$ = pattern$ + CHR$(223) + CHR$(223) + CHR$(223) + CHR$(36)
pattern$ = pattern$ + CHR$(239) + CHR$(239) + CHR$(239) + CHR$(18)
pattern$ = pattern$ + CHR$(253) + CHR$(253) + CHR$(253) + CHR$(18)
pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(36)
pattern$ = pattern$ + CHR$(247) + CHR$(247) + CHR$(247) + CHR$(72)

patt$ = CHR$(255) + CHR$(255) + CHR$(255) + CHR$(0)
patt$ = patt$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(124)
patt$ = patt$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
patt$ = patt$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
patt$ = patt$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
patt$ = patt$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
patt$ = patt$ + CHR$(195) + CHR$(195) + CHR$(195) + CHR$(124)
patt$ = patt$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(0)

WIDTH 80, 43
SCREEN 9 '#, , 0, 1
main

GET (0, 201)-(639, 349), menusav
DEF SEG = VARSEG(menusav(1))
BSAVE "UUTSCRN0.GFX", VARPTR(menusav(1)), 48127
DEF SEG                 ' Restore default BASIC segment.

END

SUB loadgpxs
DEF SEG = VARSEG(menusav(1))
BLOAD "uuterm.gfx", VARPTR(menusav(1))
DEF SEG               ' Restore default BASIC segment.
PUT (8, 10), menusav ', XOR
x = 14: y = 34: GET (x, y)-(x + 18, y + 18), bhole
x = 41: y = 23: GET (x, y)-(x + 18, y + 18), planet
x = 41: y = 43: GET (x, y)-(x + 18, y + 18), proc
x = 70: y = 47: GET (x, y)-(x + 22, y + 21), cabal
x = 71: y = 18: GET (x, y)-(x + 22, y + 22), portit
x = 184: y = 43: GET (x, y)-(x + 22, y + 20), recrder
GET (232, 14)-(270, 34), flea
  LINE (63, 243)-(85, 264), 14, BF
  PUT (63, 243), cabal, XOR 'PSET
  tinyfont 76, 256, "ABAL", 0
  PUT (24, 269), portit, PSET
  PUT (67, 272), recrder, PSET
  PUT (17, 243), flea, PSET
LINE (65, 216)-(87, 237), 0, B      'zoom
LINE (65, 218)-(65, 228), 7
LINE (71, 216)-(79, 216), 7
LINE (87, 222)-(87, 233), 7
LINE (76, 237)-(83, 237), 7
LINE (68, 233)-(82, 220), 5
LINE (69, 233)-(83, 220), 5
tinyfont 64, 226, "2", 5
tinyfont 65, 226, "2", 5
tinyfont 72, 222, "4", 5
tinyfont 73, 222, "4", 5
tinyfont 76, 236, "4", 5
tinyfont 77, 236, "4", 5
tinyfont 83, 230, "1", 5
tinyfont 84, 230, "1", 5
GET (65, 216)-(87, 238), zoom
LINE (21, 224)-(52, 236), 9, BF       'exit
LINE (21, 224)-(52, 236), 0, B
tinyfont 24, 233, "EXIT", 15
GET (21, 224)-(52, 236), exits
x = 128: y = 39                           'f1
GET (x, y)-(x + 22, y + 22), viewit
PUT (27, 304), viewit, PSET
x = 206: y = 15                           'f2  alarm
GET (x, y)-(x + 22, y + 20), alarm
PUT (81, 304), alarm, PSET
x = 178: y = 14                           'f3  starlog
PAINT (x + 20, y + 4), 15, 6
LINE (x + 14, y + 7)-(x + 19, y + 6), 0
LINE (x + 13, y + 10)-(x + 17, y + 10), 0
LINE (x + 13, y + 13)-(x + 15, y + 14), 0
GET (x, y)-(x + 23, y + 22), strlog
PUT (136, 303), strlog, PSET
x = 122: y = 13                           ' f4 device
GET (x, y)-(x + 22, y + 22), bays
PUT (190, 304), bays, PSET
x = 218: y = 43                           'f5 inventory
GET (x, y)-(x + 22, y + 22), inven
PUT (246, 303), inven, PSET
x = 96: y = 15                           'f6
LINE (x, y)-(x + 22, y + 20), 1, B
PAINT (x + 1, y + 1), 12, 1
GET (x, y)-(x + 22, y + 20), explr
PUT (300, 304), explr, PSET
x = 95: y = 42                           'f7
PAINT (x + 5, y + 5), 14, 4
GET (x, y)-(x + 27, y + 22), macro
PUT (355, 303), macro, PSET
x = 418: y = 312                           'f8  alarm
tinyfont x, y, "ON", 6
tinyfont x, y + 10, "OFF", 6
tinyfont x + 1, y, "ON", 6
tinyfont x + 1, y + 10, "OFF", 6
icon x - 10, y - 6, 6, 17, 8, 15, 9, 0
icon x - 9, y - 1, 4, 7, 15, 8, 7, 0
GET (x - 11, y - 8)-(x + 20, y + 12), conf
shad = 8: textcl = 10                      'f9
sp = shad: spx = 465: spy = 318
FOR i = 0 TO 1
  smallprint spx + i, spy, "DOS", sp
  sp = textcl: spy = spy - 1
NEXT
x = 467: y = 323
LINE (x, y)-(x + 22, y), 8
LINE (x, y - 17)-(x + 22, y - 17), 8
GET (462, 304)-(494, 325), dosit
x = 148: y = 12                           'f10  utility
'LINE (x, y)-(x + 22, y + 22), 4, B
GET (x, y)-(x + 22, y + 20), util
PUT (525, 303), util, PSET
END SUB

SUB main
CLS
icon 0, 331, 640, 18, 15, 8, 7, 0     'bottom bar
icon 2, 333, 636, 14, 8, 15, 7, 0
LINE (4, 335)-(634, 345), 9, BF
icon 0, 298, 640, 32, 15, 8, 7, 0          'middle BAR
icon 2, 300, 552, 29, 8, 15, 7, 0
x = 4
FOR y = 1 TO 10
  icon x, 302, 52, 25, 15, 8, 7, 1
  tinyfont x + 8, 312, "F", 8
  tinyfont x + 10, 312, "F", 15
  tinyfont x + 9, 312, "F", 4
  tinyfont x, 322, STR$(y), 8
  tinyfont x + 2, 322, STR$(y), 15
  tinyfont x + 1, 322, STR$(y), 4
  x = x + 55
NEXT y
shad = 6: textcl = 14
sp = shad: spx = 565: spy = 313
FOR i = 0 TO 1
  smallprint spx + i, spy, "UUTERM@", sp
  sp = textcl: spy = spy - 1
NEXT
shad = 6: textcl = 14
sp = shad: spx = 587: spy = 323
FOR i = 0 TO 1
  smallprint spx + i, spy, "3.0", sp
  sp = textcl: spy = spy - 1
NEXT
icon 0, 202, 640, 95, 15, 8, 7, 0     'upperbar
icon 284, 204, 354, 91, 8, 15, 7, 0
LINE (285, 205)-(636, 293), 8, B
PAINT (290, 210), pattern$, 8
icon 172, 247, 108, 47, 8, 15, 7, 0   'EXPLOR
icon 175, 250, 102, 18, 15, 8, 7, 0
icon 179, 253, 44, 12, 8, 15, 3, 0
icon 229, 253, 44, 12, 8, 15, 3, 0
x = 187
tinyfont x, 279, "LAST", 15
tinyfont x + 2, 279, "LAST", 8
tinyfont x + 1, 279, "LAST", 5
tinyfont x - 1, 289, "SCAN", 15
tinyfont x + 1, 289, "SCAN", 8
tinyfont x, 289, "SCAN", 5
tinyfont x + 47, 279, "SCANS", 15
tinyfont x + 49, 279, "SCANS", 8
tinyfont x + 48, 279, "SCANS", 5
tinyfont x + 51, 289, "LEFT", 15
tinyfont x + 53, 289, "LEFT", 8
tinyfont x + 52, 289, "LEFT", 5
icon 115, 247, 54, 47, 8, 15, 7, 0   'TIMER
icon 117, 250, 50, 18, 15, 8, 7, 0
icon 120, 253, 44, 12, 8, 15, 3, 0
tinyfont 124, 283, "ALARM", 15
tinyfont 126, 283, "ALARM", 8
tinyfont 125, 283, "ALARM", 5
tinyfont 31, 210, "ALT KEYS", 15     'ALTKEYS
tinyfont 33, 210, "ALT KEYS", 8
tinyfont 32, 210, "ALT KEYS", 4
icon 2, 212, 111, 83, 8, 15, 7, 0
icon 5, 204, 19, 6, 8, 15, 7, 0
icon 91, 204, 19, 6, 8, 15, 7, 0
FOR x = 214 TO 270 STEP 27
  icon 4, x, 52, 25, 15, 8, 7, 1
  icon 59, x, 52, 25, 15, 8, 7, 1
NEXT x
tinyfont 9, 224, "X", 8
tinyfont 11, 224, "X", 15
tinyfont 10, 224, "X", 4
tinyfont 100, 224, "Z", 8
tinyfont 102, 224, "Z", 15
tinyfont 101, 224, "Z", 4
  tinyfont 9, 251, "F", 8
  tinyfont 11, 251, "F", 15
  tinyfont 10, 251, "F", 4
  tinyfont 100, 251, "C", 8
  tinyfont 102, 251, "C", 15
  tinyfont 101, 251, "C", 4
  tinyfont 9, 278, "P", 8
  tinyfont 11, 278, "P", 15
  tinyfont 10, 278, "P", 4
  tinyfont 100, 278, "W", 8
  tinyfont 102, 278, "W", 15
  tinyfont 101, 278, "W", 4
LINE (118, 208)-(280, 240), 1, BF      'TOP GRAPHIC
PAINT (120, 221), patt$, 7
LINE (168, 208)-(230, 240), 7, BF
CIRCLE (200, 224), 15, 14
CIRCLE (200, 224), 14, 6
CIRCLE (200, 224), 13, 14
LINE (192, 212)-(206, 225), 6
LINE -(193, 223), 6
LINE -(208, 236), 6
LINE (191, 212)-(204, 224), 14
LINE -(194, 222), 14
LINE -(209, 235), 14
loadgpxs
nz = DRAWSTR%(0, "On", 30, 246, 15, 6, 7)
nz = DRAWSTR%(0, "Sale", 24, 254, 15, 6, 6)
END SUB

