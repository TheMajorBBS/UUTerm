DECLARE SUB SaveEGAscreen (filename$, mode!)
DECLARE SUB LoadEGAscreen (filename$)

'save/load a screen to/from disk in EGA/VGA

mode = 12
filename$ = "will"
SCREEN mode
CLS
LINE (20, 20)-(500, 300), 3, BF
LOCATE 15, 20: PRINT "hello there"

SaveEGAscreen filename$, mode
CLS
LoadEGAscreen filename$

SUB LoadEGAscreen (filename$)
 P = INSTR(filename$, ".")                'STRIP OFF EXTENSION IF
 IF P > 0 THEN                            'PRESENT
   filename$ = LEFT$(filename$, P - 1)
 END IF
 DEF SEG = &HA000                         'POINT TO VIDEO RAM
 OUT &H3C4, 2
 OUT &H3C5, 1
 BLOAD filename$ + ".PC0", 0              'LOAD BIT PLANE 0
 OUT &H3C4, 2                             '964,2
 OUT &H3C5, 2                             '965,2
 BLOAD filename$ + ".PC1", 0              'LOAD BIT PLANE 1
 OUT &H3C4, 2
 OUT &H3C5, 4
 BLOAD filename$ + ".PC2", 0              'LOAD BIT PLANE 2
 OUT &H3C4, 2
 OUT &H3C5, 8
 BLOAD filename$ + ".PC3", 0              'LOAD BIT PLANE 3
 OUT &H3C4, 2
 OUT &H3C5, &HF
 DEF SEG
END SUB

SUB SaveEGAscreen (filename$, mode)
 SELECT CASE mode
   CASE 9
     BitCount& = 28000
   CASE 12
     BitCount& = 38400
   CASE ELSE
     BEEP
     PRINT : PRINT "Wrong Mode Used When Saving"
 END SELECT
 P = INSTR(filename$, ".")                'STRIP OFF EXTENSION IF
 IF P > 0 THEN                            'PRESENT
   filename$ = LEFT$(filename$, P - 1)
 END IF
 DEF SEG = &HA000                         'POINT TO VIDEO RAM
 OUT &H3CE, 4
 OUT &H3CF, 0
 BSAVE filename$ + ".PC0", 0, BitCount&    'SAVE BIT PLANE 0
 OUT &H3CE, 4
 OUT &H3CF, 1
 BSAVE filename$ + ".PC1", 0, BitCount&    'SAVE BIT PLANE 1
 OUT &H3CE, 4
 OUT &H3CF, 2
 BSAVE filename$ + ".PC2", 0, BitCount&    'SAVE BIT PLANE 2
 OUT &H3CE, 4
 OUT &H3CF, 3
 BSAVE filename$ + ".PC3", 0, BitCount&    'SAVE BIT PLANE 3
 OUT &H3CE, 4                             'RESTORE EGA CARD
 OUT &H3CF, 0                             'REGISTERS
 DEF SEG
END SUB

