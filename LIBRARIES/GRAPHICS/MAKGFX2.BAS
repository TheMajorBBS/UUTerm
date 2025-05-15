'saves and loads graphic screens using OUT  
    DECLARE SUB VGALoad (Title$, screenmode%)
    DECLARE SUB VGASave (Title$, screenmode%)
DATA "ESCHER", 9, 639, 349, 68,4,200,76
DATA 52,12,112,44,128,52,172,76,128,52,68,84,112,44,84,60,128,68,99,84
DATA 68,36,97,52,128,68,154,84,128,68,128,116,128,52,128,68,68,4,52,12
DATA 172,76,142,90,142,76,142,108,142,108,200,76,200,76,200,92,200,92,68,164
DATA 128,116,84,140,52,12,52,154,52,154,68,164,68,164,68,100,68,36,68,84
DATA 84,45,84,76,84,109,84,140,68,100,97,116,84,124,112,108,68,84,128,116
DATA 84,76,112,92,112,77,112,108,84,119,92,114,142,86,151,82,180,66,186,62
DATA 186,62,236,90,236,90,68,184,68,184,16,154,16,154,52,133,16,154,16,160
DATA 16,160,68,190,68,190,68,184,68,190,236,96,236,96,236,90

DEFINT A-Z
screenmode% = 9
    RESTORE
    READ Title$, screenmode%, xMax%, yMax%
    SCREEN screenmode%
    LINE (0, 0)-(xMax%, yMax%), 6, BF
    VIEW (32, 4)-(xMax% - 32, yMax% - 4), 0, 5
    WINDOW SCREEN (0, 0)-(255, 191)
    FOR I% = 1 TO 39
        READ A%, B%, C%, D%: LINE (A%, B%)-(C%, D%), 1
    NEXT I%
    PAINT (56, 20), 1, 1: PAINT (136, 64), 1, 1
    PAINT (120, 80), 1, 1: PAINT (192, 88), 14, 1
    PAINT (76, 48), 14, 1: PAINT (124, 60), 14, 1
    PAINT (68, 12), 2, 1: PAINT (80, 84), 2, 1
    PAINT (92, 128), 2, 1: PAINT (36, 156), 12, 1
    PAINT (36, 168), 1, 1: PAINT (84, 178), 14, 1
    PAINT (88, 118), 12, 1: PAINT (144, 86), 12, 1
    LOCATE 25, 1: PRINT "Press a key to save the screen..... ";
    R$ = INPUT$(1)
    VGASave Title$, screenmode%
    CLS
    LOCATE 25, 1: PRINT "Press a key to Restore the screen... ";
    R$ = INPUT$(1)
    VGALoad Title$, screenmode%
END

DEFSNG A-Z
'   Load graphics screen from up to 4 seperate image files.
'
'   Title$      = Filename of image file(s) (excluding extension)
'                 Maximum of 8 characters
'
'   ScreenMode% = Current SCREEN mode (7, 8, 9, 10, 11, 12 or 13)
'                 (must be the same as when image was saved)
'
SUB VGALoad (Title$, screenmode%)
    IF LEN(Title$) > 8 THEN Title$ = LEFT$(Title$, 8)
    IF screenmode% > 6 THEN
       IF screenmode% = 13 THEN
          BLOAD Title$ + ".GRA"
       ELSE
          FOR I% = 0 TO 3
              OUT &H3C4, 2          ' Enable video port
              OUT &H3C5, 2 ^ I%     ' Select currently addressable bit plane
              BLOAD Title$ + ".BP" + CHR$(49 + I%)
              IF I% = 1 AND screenmode& = 10 THEN EXIT FOR
          NEXT I%
       END IF
    END IF
END SUB

'   Save current graphics screen in up to 4 seperate image files
'
'   Title$      = Filename for images (excluding extension)
'                 Maximum of 8 characters
'
'   ScreenMode% = Current SCREEN mode (7, 8, 9, 10, 11, 12 or 13)
'
SUB VGASave (Title$, screenmode%)
    IF LEN(Title$) > 8 THEN Title$ = LEFT$(Title$, 8)
    SELECT CASE screenmode%         ' Calculate video buffer sizes
        CASE 7
             Bytes& = 8000
        CASE 8
             Bytes& = 16000
        CASE 9, 10
             Bytes& = 28000
        CASE 11, 12
             Bytes& = 38400
        CASE 13
             Bytes& = 64000
        CASE ELSE
    END SELECT
    IF Bytes& THEN
       DEF SEG = &HA000             ' Video buffer segment
       IF screenmode& = 13 THEN
          BSAVE Title$ + ".GRA", 0, Bytes&
       ELSE
          FOR I% = 0 TO 3
              OUT &H3CE, 4          ' Enable video port
              OUT &H3CF, I%         ' Select bit plane
              BSAVE Title$ + ".BP" + CHR$(49 + I%), 0, Bytes&
              IF I% = 1 AND screenmode& = 10 THEN EXIT FOR
          NEXT I%
       END IF
       DEF SEG
    END IF
END SUB

