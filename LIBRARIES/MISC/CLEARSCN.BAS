'neat way to clear the screen by tearing

TYPE regtype
     ax    AS INTEGER
     bx    AS INTEGER
     cx    AS INTEGER
     dx    AS INTEGER
     bp    AS INTEGER
     si    AS INTEGER
     di    AS INTEGER
     flags AS INTEGER
END TYPE
DECLARE SUB interrupt (intnum AS INTEGER, inreg AS regtype, outreg AS regtype)
DIM inreg AS regtype, outreg AS regtype
DEFINT A-Z

FOR x = 1 TO 25
  COLOR 11, 0: PRINT "                                   hello BABBBBBBBBBY!"
NEXT x
FOR x = 1 TO 25
    inreg.ax = &H601                         'scroll up 1 line
    inreg.bx = &H700                         'white on black
    inreg.cx = &H0                           'row =  0, col =  0
    inreg.dx = &H1813                        'row = 24, col = 19
    CALL interrupt(&H10, inreg, outreg)
    inreg.ax = &H601                         'scroll up 1 line
    inreg.bx = &H700                         'white on black
    inreg.cx = &H28                          'row =  0, col = 40
    inreg.dx = &H183B                        'row = 24, col = 59
    CALL interrupt(&H10, inreg, outreg)
    inreg.ax = &H701                         'scroll down 1 line
    inreg.bx = &H700                         'white on black
    inreg.cx = &H14                          'row =  0, col = 20
    inreg.dx = &H1827                        'row = 24, col = 39
    CALL interrupt(&H10, inreg, outreg)
    inreg.ax = &H701                         'scroll down 1 line
    inreg.bx = &H700                         'white on black
    inreg.cx = &H3C                          'row =  0, col = 60
    inreg.dx = &H184F                        'row = 24, col = 79
    CALL interrupt(&H10, inreg, outreg)
  FOR y = 1 TO 200: NEXT y
NEXT x
LOCATE 1, 1, 1

