'finds largest box to fit in a curcle

SCREEN 1

sq2 = SQR(2) / 2

'for the greatest Circumscribed DIAMOND, instead of use sq2 = SQR(2)

x = 160          ' Center the circle on screen
y = 100
r = 50           ' Circle is 50 pixels in nominal radius
ar = 1           ' Actual Aspect Ratio to be shown
sar = .88        ' Screen Aspect ratio
nar = ar * sar   ' Net Aspect Ratio
rr = r * nar - 1 ' y value of radius. ("-1") is fudge-factor!
                 ' NOTE:  For general use, you'll have to be a LOT
                 ' cleverer than this if you want to use ellipses...

CIRCLE (x, y), r, 1 ' make the call

' Corners of outside box:
xb = x - r
xf = x + r
yb = y - rr
yf = y + rr

'Box OUTSIDE the CIRCLE
LINE (xb, yb)-(xf, yf), 2, B

irx = INT(r * sq2) - 1  ' 1/2 the width of inside box with fudge-factor
iry = irx * nar         ' 1/2 the hight of box--acct'ing for AR.

' Corners of inside box
xbi = x - irx
xfi = x + irx
ybi = y - iry
yfi = y + iry

'Call it!
LINE (xbi, ybi)-(xfi, yfi), 3, B

' Of course, if you want a DIAMOND, then use
'LINE (x,yb)-(xb,y)
'LINE (xb,y)-(x,yf)
'LINE (x,yf)-(xf,y)
'LINE (xf,y)-(x,yb)

