'write to video buffer for a faster text display
DEFINT A-Z
GOSUB GetVidBuf
SCREEN 0, 0, 0, 0
CLS
DEF SEG = vidseg
K = vidoff

FOR I = 0 TO 24 STEP 4
        FOR j = I * 2 TO 150 - (I * 2) STEP 2
                GOSUB EraseShip
                K = j + I * 160
                GOSUB DrawShip
              FOR m = 1 TO 1555
              NEXT m

        NEXT j

        FOR j = 150 - (I * 2) TO I * 2 STEP -2
                GOSUB EraseShip
                K = j + ((I + 2) * 160)
                GOSUB DrawShip
               FOR m = 1 TO 1555
               NEXT m
        NEXT j
NEXT I

END

GetVidBuf:
DEF SEG = &H40
IF ((PEEK(&H63) AND &H40) = &H40) THEN
        vidseg = &HB800
ELSE
        vidseg = &HB000
END IF
vidoff = PEEK(&H44)
vidoff = (vidoff * 256) + PEEK(&H43)
RETURN

DrawShip:
POKE K, 199
POKE K + 2, 79
POKE K + 4, 182
RETURN

EraseShip:
POKE K, 32
POKE K + 2, 32
POKE K + 4, 32
RETURN

badvideo:
PRINT "Video error"
RESUME NEXT

