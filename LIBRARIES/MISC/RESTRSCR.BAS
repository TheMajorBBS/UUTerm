'restores a users computer to its original state

DEFINT A-Z
SCREEN 0
SHELL "CLS"
DEF SEG = &HB800
dosclr = PEEK(1)
dosfg = dosclr AND 15
dosbg = (dosclr \ 16) AND 7
DEF SEG

'your program goes here


SCREEN 0
COLOR dosfg, dosbg     'restore
CLS

END

