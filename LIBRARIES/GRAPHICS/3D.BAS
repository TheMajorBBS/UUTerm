'Do 3D animation
DEFINT A-Z
TYPE LineType
    X AS INTEGER
    Y AS INTEGER
    Z AS INTEGER
    X1 AS INTEGER
    Y1 AS INTEGER
    Z1 AS INTEGER
END TYPE
DIM Points(100) AS LineType
DIM Xs(100), Ys(100), Xe(100), Ye(100), Xn(100), Yn(100)
DIM Xs1(100), Ys1(100), Xe1(100), Ye1(100)
DIM X(100), Y(100), Z(100), Pointers1(100), Pointers2(100)
DIM R(100)
DIM Cosine&(360), Sine&(360)
CLS
PRINT "3-D Craft"
PRINT "By Rich Geldreich 1992"
PRINT
PRINT "Keys to use: (Turn NUMLOCK on!)"
PRINT "Q...............Quits"
PRINT "Numeric keypad..Controls your position(press 5 on the keypad"
PRINT "                to completly stop yourself) "
PRINT "-...............Forward exceleration"
PRINT "+...............Backward exceleration"
PRINT "Arrow keys......Controls the rotation of the craft"
PRINT "F...............Excelerates the craft (Forward)"
PRINT "B...............Slows the craft (Backward)"
PRINT "S...............Stops the craft"
PRINT "A...............Toggles Auto Center, use this when you lose";
PRINT " the craft"
PRINT "C...............Stops the craft's rotation"
PRINT "V...............Resets the craft to starting position"
PRINT
PRINT "Wait a sec..."

'The following for/next loop makes a sine & cosine table.
'Each sine & cosine is multiplied by 1024 and stored as long integers.
'This is done so that we don't have to use any slow floating point
'math at run time.
a = 0
FOR a! = 0 TO 359 / 57.29577951# STEP 1 / 57.29577951#
    Cosine&(a) = INT(.5 + COS(a!) * 1024)
    Sine&(a) = INT(.5 + SIN(a!) * 1024): a = a + 1
NEXT
'Next we read in all of the lines that are in the object...
FOR a = 0 TO 44
    READ Points(a).X, Points(a).Y, Points(a).Z
    READ Points(a).X1, Points(a).Y1, Points(a).Z1
NEXT
'Here comes the hard part... Consider this scenario:

'We have two connected lines, like this:

'   1--------2 and 3
'            |
'            |
'            |
'            |
'            4
'Where 1,2, 3, & 4 are the starting and ending points of each line.
'The first line consists of points 1 & 2  and the second line
'is made of points 3 & 4.
'So, you ask, what's wrong? Nothing, really, but don't you see that
'points 2 and 3 are really at the sample place? Why rotate them twice,
'that would be a total waste of time? The following code eliminates such
'occurrences from the line table. (great explanation, huh?)

NumberLines = 45
'take all of the starting & ending points and put them in one big
'array...
Np = 0
FOR a = 0 TO NumberLines - 1
    X(Np) = Points(a).X
    Y(Np) = Points(a).Y
    Z(Np) = Points(a).Z
    Np = Np + 1
    X(Np) = Points(a).X1
    Y(Np) = Points(a).Y1
    Z(Np) = Points(a).Z1
    Np = Np + 1
NEXT
'Now set up two sets of pointers that point to each point that a line
'is made of... (in other words, scan for the first occurrence of each
'starting and ending point in the point array we just built...)
FOR a = 0 TO NumberLines - 1
    Xs = Points(a).X
    Ys = Points(a).Y
    Zs = Points(a).Z            'get the 3 coordinates of the start point
    FOR B = 0 TO Np - 1         'scan the point array
        IF X(B) = Xs AND Y(B) = Ys AND Z(B) = Zs THEN
            Pointers1(a) = B    'set the pointer to point to the
            EXIT FOR            'point we have just found
        END IF
    NEXT
    Xs = Points(a).X1           'do the same thing that we did above
    Ys = Points(a).Y1           'except scan for the ending point
    Zs = Points(a).Z1           'of each line
    FOR B = 0 TO Np - 1
        IF X(B) = Xs AND Y(B) = Ys AND Z(B) = Zs THEN
            Pointers2(a) = B
            EXIT FOR
        END IF
    NEXT
NEXT
'Okay, were almost done! All we have to do now is to build a table
'that tells us which points to actually rotate...
Nr = 0
FOR a = 0 TO NumberLines - 1
    F1 = Pointers1(a)   'get staring & ending point number
    S1 = Pointers2(a)
    IF Nr = 0 THEN      'if this is the first point then it of course
                        'has to be rotated
        R(Nr) = F1: Nr = Nr + 1
    ELSE
        found = 0       'scan to see if this point already exists...
        FOR B = 0 TO Nr - 1
            IF R(B) = F1 THEN
                found = -1: EXIT FOR    'shoot, it's already here!
            END IF
        NEXT
        IF NOT found THEN R(Nr) = F1: Nr = Nr + 1   'point the point
                                                    'in the array it we
    END IF                                          'can't find it...

    found = 0   'now look for the ending point
    FOR B = 0 TO Nr - 1
        IF R(B) = S1 THEN
            found = -1: EXIT FOR
        END IF
    NEXT
    IF NOT found THEN R(Nr) = S1: Nr = Nr + 1
NEXT
PRINT "Press any key to begin..."
a$ = INPUT$(1)
'The following sets up the rotation & perspective variables.

'Vs = the screen that is currently being viewed
'Ws = the screen that is currently being worked on
Vs = 1: Ws = 0

'Deg1 & Deg2 are the two angles of rotation
'D1 & D2 are the deltas of each axes. If D1 = -5, for instance, then
'Deg1 will be decreased 5 degress every frame.
Deg1 = 0: Deg2 = 0: D1 = 0: D2 = 0

'Spos & Mypos are for the perspective routines...
'Spos is the screen's Z coordinate and Mypos is the users Z coordinate
Spos = -250: Mypos = 0

'Mx, My, and Mz are the coordinates of the user.
'Ox, Oy, and Oz are the coordinates of the craft.
Mx = 0: my = 0: Mz = 0: Ox = 0: Oy = 0: Oz = -260
'main loop
NumberOfFrames = 0
DEF SEG = &H40
StartTime = PEEK(&H6C)
DO

    'swap the viewing and working screens for page flipping...
    SWAP Vs, Ws
    SCREEN 9, , Ws, Vs

    'adjust the angles according to their deltas...
    Deg1 = (Deg1 + D1) MOD 360
    Deg2 = (Deg2 + D2) MOD 360
    'fix the angles up if they go out of range
    IF Deg1 < 0 THEN Deg1 = Deg1 + 360
    IF Deg2 < 0 THEN Deg2 = Deg2 + 360
    'get the sine and cosine of each angle from the tables
    'that were prepared at the beginning of the program
    C1& = Cosine&(Deg1): S1& = Sine&(Deg1)
    C2& = Cosine&(Deg2): S2& = Sine&(Deg2)

    'now we must adjust the object's coordinates
    'based on how quickly it is moving...

    X = Speed: Y = 0: Z = 0

    X1 = (X * C1&) \ 1024: Y1 = (X * S1&) \ 1024
    X2 = (X1 * C2&) \ 1024: Zn = (X1 * S2&) \ 1024
    Ox = Ox + X2: Oy = Oy + Y1: Oz = Oz + Zn
    IF Oz > 32000 THEN Oz = 32000
    IF Oz < -32000 THEN Oz = -32000
    IF Ox > 32000 THEN Ox = 32000
    IF Ox < -32000 THEN Ox = -32000
    IF Oy > 32000 THEN Oy = 32000
    IF Oy < -32000 THEN Oy = -32000

    'if Atloc is true then Auto-Center is on...
    IF Atloc THEN
        Mx = Mx + (Ox - Mx) \ 4
        my = my + (Oy - my) \ 4
        Mz = Mz + ((Oz + 200) - Mz) \ 4
    ELSE
        'adjust the users position based on how much he is moving...
        Mz = Mz + Mzm: Mx = Mx + Mxm: my = my + Mym
        IF Mz > 32000 THEN Mz = 32000
        IF Mz < -32000 THEN Mz = -32000
        IF Mx > 32000 THEN Mx = 32000
        IF Mx < -32000 THEN Mx = -32000
        IF my > 32000 THEN my = 32000
        IF my < -32000 THEN my = -32000
    END IF
    '(Wait for vertical retrace, reduces flicker. This was recommended
    'by someone on the echo but I can't remember who! Thanks)
    WAIT &H3DA, 8
    'erase the old lines...
    IF Ws = 1 THEN
        FOR a = 0 TO Ln(Ws) - 1
            LINE (Xs1(a), Ys1(a))-(Xe1(a), Ye1(a)), 0
        NEXT
    ELSE
        FOR a = 0 TO Ln(Ws) - 1
            LINE (Xs(a), Ys(a))-(Xe(a), Ye(a)), 0
        NEXT
    END IF
    'print frames per second
    LOCATE 1, 1: PRINT a$
    'rotate the points...
    FOR a = 0 TO Nr - 1
        R = R(a): Xo = X(R): Yo = Y(R): Zo = Z(R)
        X1 = (Xo * C1& - Yo * S1&) \ 1024
        Y1& = (Xo * S1& + Yo * C1&) \ 1024 - my + Oy
        X1& = (X1 * C2& - Zo * S2&) \ 1024 - Mx + Ox
        Zn = (X1 * S2& + Zo * C2&) \ 1024 - Mz + Oz
        'if the point is too close(or behind) the viewer then
        'don't draw it...
        IF (Mypos - Zn) < 15 THEN
            Xn(R) = -1: Yn(R) = 0: Zn = 0
        ELSE
            'Put the point into perspective...
            'The original formula was:
            'Xnew=Xnew+( -Xold * ( (Spos-Z) / (MPos-Z) ) )
            'Ynew=Ynew=( -Yold * ( (Spos-Z) / (Mpos-Z) ) )
            v = (1330& * (Spos - Zn)) \ (Mypos - Zn)
            Xn(R) = 320 + X1& + (-X1& * v) \ 1330

            'The Y coordinate is also multiplied by .8 to adjust
            'for SCREEN 9's height to width ratio...

            Yn(R) = 175 + (8 * (Y1& + (-Y1& * v) \ 1330)) \ 10
        END IF
    NEXT
    'draw the lines...
    '(There are two seperate cases, each puts it's coordinates
    'in a different array for later erasing. I could of used a
    '2 dimensional array for this but that is slower.)
    IF Ws = 1 THEN
        Ln = 0
        FOR a = 0 TO NumberLines - 1
            F1 = Pointers1(a): S1 = Pointers2(a)
            Xn = Xn(F1): Yn = Yn(F1)
            'if Xn<>-1 then it's in view...
            IF Xn <> -1 THEN
                IF Xn(S1) <> -1 THEN
                    X1 = Xn(S1): Y1 = Yn(S1)
                    LINE (X1, Y1)-(Xn, Yn), 14
                    'store the lines so they can be erased later...
                    Xs1(Ln) = X1: Ys1(Ln) = Y1
                    Xe1(Ln) = Xn: Ye1(Ln) = Yn
                    Ln = Ln + 1
                END IF
            END IF
        NEXT
    ELSE
        Ln = 0
        FOR a = 0 TO NumberLines - 1
            F1 = Pointers1(a): S1 = Pointers2(a)
            Xn = Xn(F1): Yn = Yn(F1)
            'if Xn<>-1 then it's in view...
            IF Xn <> -1 THEN
                IF Xn(S1) <> -1 THEN
                    X1 = Xn(S1): Y1 = Yn(S1)
                    LINE (X1, Y1)-(Xn, Yn), 14
                    'store the lines so they can be erased later...
                    Xs(Ln) = X1: Ys(Ln) = Y1
                    Xe(Ln) = Xn: Ye(Ln) = Yn
                    Ln = Ln + 1
                END IF
            END IF
        NEXT
    END IF
    Ln(Ws) = Ln
    K$ = UCASE$(INKEY$)
    'Process the keystroke(if any)...
    IF K$ <> "" THEN
        SELECT CASE K$
            CASE "A"
                Atloc = NOT Atloc
            CASE "+"
                Mzm = Mzm + 2
            CASE "-"
                Mzm = Mzm - 2
            CASE "5"
                Mxm = 0: Mym = 0: Mzm = 0
            CASE "4"
                Mxm = Mxm - 2
            CASE "6"
                Mxm = Mxm + 2
            CASE "8"
                Mym = Mym - 2
            CASE "2"
                Mym = Mym + 2
            CASE "F"
                Speed = Speed + 5
            CASE "B"
                Speed = Speed - 5
            CASE "C"
                D1 = 0: D2 = 0
            CASE "S"
                Speed = 0
            CASE CHR$(0) + CHR$(72)
                D1 = D1 + 1
            CASE CHR$(0) + CHR$(80)
                D1 = D1 - 1
            CASE CHR$(0) + CHR$(75)
                D2 = D2 - 1
            CASE CHR$(0) + CHR$(77)
                D2 = D2 + 1
            CASE "Q"
                SCREEN 0, , 0, 0: CLS : PRINT "See ya later!"
                END
            CASE "V"
                D1 = 0: D2 = 0: Deg1 = 0: Deg2 = 0: Speed = 0
        END SELECT
    END IF
    NumberOfFrames = NumberOfFrames + 1
    SOUND 32767, .1
    'see if 20 frames have passed; if so then see
    'how long it took...
    IF NumberOfFrames = 20 THEN
        TotalTime = PEEK(&H6C) - StartTime
        IF TotalTime < 0 THEN TotalTime = TotalTime + 256
        FramesPerSecX100 = 36400 \ TotalTime
        High = FramesPerSecX100 \ 100
        Low = FramesPerSecX100 - High
        'A$ has the string that is printed at the upper left
        'corner of the screen
        a$ = MID$(STR$(High), 2) + "."
        a$ = a$ + RIGHT$("0" + MID$(STR$(Low), 2), 2) + "  "
        NumberOfFrames = 0
        StartTime = PEEK(&H6C)
    END IF
LOOP
'The following data is the shuttle craft...
'stored as Start X,Y,Z & End X,Y,Z
DATA -157,22,39,-157,-18,39
DATA -157,-18,39,-127,-38,39
DATA -127,-38,39,113,-38,39
DATA 113,-38,39,193,12,39
DATA 33,42,39,33,42,-56
DATA 33,42,-56,-127,42,-56
DATA -127,42,-56,-157,22,-56
DATA -157,22,-56,-157,22,39
DATA -157,22,-56,-157,-18,-56
DATA -157,-18,-56,-157,-18,39
DATA -157,-18,-56,-127,-38,-56
DATA -127,-38,-56,-127,-38,39
DATA -127,-38,-56,113,-38,-56
DATA 113,-38,-56,113,-38,39
DATA 113,-38,-56,193,12,-56
DATA 193,12,-56,193,12,39
DATA -157,22,-56,193,12,-56
DATA 193,12,39,-157,22,39
DATA -56,-13,41,-56,-3,41
DATA -56,-3,41,-26,-3,41
DATA -26,-3,41,-26,7,41
DATA -51,7,41,-31,-13,41
DATA -11,-13,41,-11,-3,41
DATA -11,-3,41,-1,7,41
DATA 9,7,41,9,-8,41
DATA 9,-8,41,24,-8,41
DATA 34,16,41,34,-38,41
DATA 33,-39,41,33,-39,-53
DATA 33,-39,-53,33,15,-53
DATA -42,-38,19,-72,-38,19
DATA -72,-38,19,-72,-38,-41
DATA -72,-38,-41,-42,-38,-41
DATA -42,-38,-41,-42,-38,19
DATA 33,42,39,34,16,41
DATA 33,42,-56,33,15,-53
DATA -157,22,39,-127,42,39
DATA -127,42,-56,-127,42,39
DATA -127,42,39,33,42,39
DATA 159,-8,-56,159,-8,40
DATA 143,-18,-56,143,-18,39
DATA 193,12,39,193,32,30
DATA 33,42,39,193,32,30
DATA 193,32,30,193,32,-47
DATA 33,42,-56,193,32,-47
DATA 193,12,-56,193,32,-47

