'part 2 of fading screen 13
'Aaa- what the hell. The following two programs will allow you to fade
'any VGA screen. The first, USEFADE.BAS, shows you how to use the
'subroutine. The second, FADE.BAS, makes a small .OBJ file which contains
'the machine language subroutine to fade the screen. Follow the
'instructions at the beginning of FADE.BAS to make a .QLB or .LIB file.

'(NOTE:Works strange in text modes. Seems that the palette in
'the text mode is not contagious for some odd reason.
'FadeScreen 0,255,1 works however.)

'The total time for a fade is about:
'TotalTime=(Delay/70)*64

DEFINT A-Z
DECLARE SUB FadeScreen (BYVAL StartC, BYVAL EndC, BYVAL Delay)
'fade the text screen...
FadeScreen 0, 255, 1
'go to 320x200x256
SCREEN 13
'draw some garbage
FOR A = 0 TO 40
    X = RND * 320: Y = RND * 200
    R = RND * 50: C = RND * 255
    CIRCLE (X, Y), R, C
    PAINT (X, Y), RND * 255, C
NEXT
'fade it to black
FadeScreen 0, 255, 2    '256 color fade, two frames each fade
'go to 640x480x16
SCREEN 12
'draw some more garbage
FOR A = 0 TO 80
    X = RND * 640: Y = RND * 480
    R = RND * 50: C = RND * 15
    CIRCLE (X, Y), R, C
    PAINT (X, Y), RND * 15, C
NEXT
'fade it to black again
FadeScreen 0, 15, 1     '16 color fade, one frame each fade
SLEEP 1
PALETTE

