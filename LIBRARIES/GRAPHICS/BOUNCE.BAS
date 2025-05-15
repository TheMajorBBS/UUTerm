'Interesting animation routine
'LINES.BAS 15 May 1993, Released to Public Domain
'By Richard Vannoy, PO Box 1892, Vista, CA  92085

OPTION BASE 1
DEFINT A-Z
RANDOMIZE TIMER
LinesShowing = 30 'Change value to suit. From 20 to 200?
DIM x(LinesShowing, 6), y(LinesShowing, 6)
'1,2,3 = x/y position;    4,5,6 = Velocity of that point
White = 15: Blue = 0: colr = 15
MaxX = 640: MaxY = 350'Change for EGA or other screens
SCREEN 9   '640 X 480 VGA.  Change for EGA or other
CLS
COLOR White ', Blue
FOR i = 1 TO 3 'Initial x/y coordinates
        x(1, i) = RND(1) * MaxX: y(1, i) = RND(1) * MaxY
NEXT i
FOR i = 4 TO 6 'Initial Velocities (+ or -)
        xvel = RND(1) * 5 + 1: IF RND(1) > .5 THEN xvel = -xvel
        yvel = RND(1) * 5 + 14: IF RND(1) > .5 THEN yvel = -yvel
        x(1, i) = xvel: y(1, i) = yvel
NEXT i
DO
        'Paint the new line
        counter = counter + 1
        IF counter > 75 THEN 'Randomly change colors
                counter = 0: colr = RND(1) * 13 + 2'No Black or Blue
        END IF
        COLOR colr  'Draw the new triangle
        LINE (x(1, 1), y(1, 1))-(x(1, 2), y(1, 2))
        LINE -(x(1, 3), y(1, 3))
        LINE -(x(1, 1), y(1, 1))
        'Slide everything down one in the array
        FOR i = LinesShowing TO 2 STEP -1
                FOR j = 1 TO 6
                        x(i, j) = x(i - 1, j): y(i, j) = y(i - 1, j)
                NEXT j
        NEXT i
        'Get/compute new X,Y for array position 1
        FOR i = 1 TO 3
                x(1, i) = x(1, i) + x(1, i + 3)'Add Velocity
                y(1, i) = y(1, i) + y(1, i + 3)
                'DON'T use SELECT CASE for the four IFs below!!
                IF x(1, i) < 0 THEN 'If off screen to left, reverse
                        x(1, i) = -x(1, i)
                        v = RND(1) * 6 + 1'Pick a new random velocity
                        IF x(1, i + 3) > 0 THEN 'Reverse old direction
                                x(1, i + 3) = -v
                        ELSE
                                x(1, i + 3) = v
                        END IF
                END IF
                IF y(1, i) < 0 THEN 'If off the top of screen, reverse
                        y(1, i) = -y(1, i)
                        v = RND(1) * 5 + 1'Pick a new random velocity
                        IF y(1, i + 3) > 0 THEN 'Reverse old direction
                                y(1, i + 3) = -v
                        ELSE
                                y(1, i + 3) = v
                        END IF
                END IF
                IF x(1, i) > MaxX - 1 THEN 'Off screen to the right, and so on
                        x(1, i) = MaxX - (x(1, i) - MaxX)
                        v = RND(1) * 6 + 1
                        IF x(1, i + 3) > 0 THEN
                                x(1, i + 3) = -v
                        ELSE
                                x(1, i + 3) = v
                        END IF
                END IF
                IF y(1, i) > MaxY - 1 THEN
                        y(1, i) = MaxY - (y(1, i) - MaxY)
                        v = RND(1) * 5 + 1
                        IF y(1, i + 3) > 0 THEN
                                y(1, i + 3) = -v
                        ELSE
                                y(1, i + 3) = v
                        END IF
                        yvel = -yvel
                END IF
        NEXT i   'Now erase the oldest Triangle
        COLOR Blue
        LINE (x(LinesShowing, 1), y(LinesShowing, 1))-(x(LinesShowing, 2), y(LinesShowing, 2))
        LINE -(x(LinesShowing, 3), y(LinesShowing, 3))
        LINE -(x(LinesShowing, 1), y(LinesShowing, 1))
        k$ = INKEY$ 'Pressing any key will stop it
        IF LEN(k$) THEN EXIT DO
LOOP
END

