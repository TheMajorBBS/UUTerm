DECLARE SUB TINYFONT (HOR%, VER%, line$, CLR%)
DECLARE SUB SmallPrint (spx%, spy%, sp$, spcolor%)
DECLARE SUB BigPrint (bpx!, bpy!, bp$, bpcolor!)
DECLARE SUB SevenSegment (Number%, xPix%, yPix%, CLR%)
DEFINT A-Z
'4 different fonts: LCD numbers, Large Letters, Small letters, Letter shadows

SCREEN 9

CLS
BigPrint 25, 25, "ABCDEFGHIJKLMNOPQRSTUVWXYZ ", 3
BigPrint 25, 40, "1234567890 . , /", 3

SmallPrint 25, 60, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 15
SmallPrint 25, 70, "1234567890 . , /@-<>", 15

TINYFONT 25, 85, "ABCDEFGHIJKLMNOPQRSTUVWXYZ", 15
TINYFONT 25, 95, "1234567890 . , : ; ' !-+=", 15

HOR = 10: VER = 140                      'lcd numbers
NumStr$ = "1234567890"
FOR i = 1 TO LEN(NumStr$)
  n$ = MID$(NumStr$, i, 1)
  IF n$ <> " " THEN
    n = VAL(n$)
    SevenSegment n, HOR + i * 30 - 15, VER + 15, 14
  END IF
NEXT
END

DEFSNG A-Z
SUB BigPrint (bpx, bpy, bp$, bpcolor) STATIC
'
  DRAW "BM" + STR$(bpx) + "," + STR$(bpy)'  Move to Starting Location
  DRAW "C" + LTRIM$(STR$(bpcolor))'         Establish the Color
'
  FOR bpchar = 1 TO LEN(bp$)
    SELECT CASE MID$(bp$, bpchar, 1)
      CASE "A": DRAW "M+9,-12 M+9,+12 BM-3,-4 NL11 BM+3,+4 BR5"
      CASE "B": DRAW "U12 R11 F2 D2 G2 NL11 F2 D2 G2 NL11 BR8"
      CASE "C"
        DRAW "BR13 L8 H1 L1 H2 U1 H1 U2 E1 U1 E2 R1 E1 R7 F1 R1 F2 BD1 BF1 BD2 BG1 BD1 G2 L1 G1 BR10"
      CASE "D"
        DRAW "NR11 U12 R11 F1 R1 F2 D1 F1 D2 G1 D1 G2 L1 G1 BR10"
      CASE "E": DRAW "BU12 NR14 D6 NR10 D6 R14 BR5"
      CASE "F": DRAW "BU12 NR14 D6 NR10 D6 BR19"
      CASE "G"
        DRAW "BR13 L8 H1 L1 H2 U1 H1 U2 E1 U1 E2 R1 E1 R7 F1 R1 F2 BD1 BF1 BD2 NL10 ND5 G1 D1 G2 L1 G1 BR11"
      CASE "H": DRAW "U12 BD6 R14 BU6 D12 BR5"
      CASE "I": DRAW "BR2 BU12 R6 BL3 D12 BL3 R6 BR7"
      CASE "J": DRAW "BR7 L3 H1 L1 H2 U1 BR12 NU8 D1 G2 L1 G1 BR9"
      CASE "K": DRAW "NU12 BU5 NM+14,-7 BM+4,-2 M+10,+7 BR5"
      CASE "L": DRAW "NU12 R14 BR5"
      CASE "M": DRAW "U12 M+9,+12 M+9,-12 D12 BR5"
      CASE "N": DRAW "U12 M+16,+12 NU12 BR5"
      CASE "O"
        DRAW "BR11 L7 H1 L1 H2 U1 H1 U2 E1 U1 E2 R1 E1 R6 F1 R1 F2 D1 F1 D2 G1 D1 G2 L1 G1 BR9"
      CASE "P": DRAW "U12 R11 F2 D2 G2 L11 BD6 BR18"
      CASE "Q"
        DRAW "BR13 L7 H1 L1 H2 U1 H1 U2 E1 U1 E2 R1 E1 R6 F1 R1 F2 D1 F1 D2 G1 D1 G2 NH3 NF2 L1 G1 BR10"
      CASE "R": DRAW "U12 R11 F2 D2 G2 L4 NM+6,+6 L7 BD6 BR19"
      CASE "S"
          DRAW "BU3 D1 F2 R9 E2 U2 H2 L9 H2 U2 E2 R9 F2 D1 BD9 BR5"
      CASE "T": DRAW "BU12 R14 BL7 D12 BR12"
      CASE "U": DRAW "BR10 L5 H1 L1 H2 U9 BR14 D9 G2 L1 G1 BR9"
      CASE "V": DRAW "BU12 M+7,+12 M+7,-12 BD12 BR5"
      CASE "W": DRAW "BU12 M+6,+12 M+6,-12 M+6,+12 M+6,-12 BD12 BR5"
      CASE "X": DRAW "M+15,-12 BL15 M+15,+12 BR5"
      CASE "Y": DRAW "BU12 M+8,+6 NM+8,-6 D6 BR13"
      CASE "Z": DRAW "BU12 R15 M-15,12 R15 BR5"
      CASE ".": DRAW "U1 R1 D1 BR4"
      CASE ",": DRAW "U1 R1 D1 ND2 BR4"
      CASE " ": DRAW "BR16"
      CASE "/": DRAW "NE12 BR17"
      CASE "0"
        DRAW "BR10 L5 H1 L1 H2 U1 H1 U2 E1 U1 E2 R1 E1 R4 F1 R1 NM-7,+9 F2 D1 F1 D2 G1 D1 G2 L1 G1 BR10"
      CASE "1": DRAW "BR6 BU12 NM-2,+3 D12 BL3 R6 BR7"
      CASE "2": DRAW "BU10 E2 R8 F2 D2 G2 L8 G2 D4 R12 BR5"
      CASE "3": DRAW "BU10 E2 R8 F2 D2 G2 NL6 F2 D2 G2 L8 H2 BD2 BR17"
      CASE "4": DRAW "BR8 U13 M-8,+9 R13 BD4 BR5"
      CASE "5": DRAW "BU12 NR12 D6 E1 R9 F2 D3 G2 L8 NH2 BR16"
      CASE "6"
        DRAW "BM+11,-11 H1 L8 G2 D8 F2 R8 E2 U2 H2 L8 G1 BD5 BR16"
      CASE "7": DRAW "BU11 U1 R12 D2 G6 D4 BR11"
      CASE "8"
        DRAW "BU4 NE1 D2 F2 R8 E2 U2 H2 L8 H2 U2 E2 R8 F2 D2 NG1 BD8 BR6"
      CASE "9": DRAW "BU2 F2 R8 E2 U8 H2 L8 G2 D2 F2 R8 E1 BD7 BR6"
      CASE ELSE: BEEP
    END SELECT
  NEXT
'
END SUB

DEFINT A-Z
SUB SevenSegment (Number, xPix, yPix, CLR) STATIC
SELECT CASE Number
    CASE 0: Segs$ = "123567"
    CASE 1: Segs$ = "37"
    CASE 2: Segs$ = "13456"
    CASE 3: Segs$ = "13467"
    CASE 4: Segs$ = "2347"
    CASE 5: Segs$ = "12467"
    CASE 6: Segs$ = "124567"
    CASE 7: Segs$ = "137"
    CASE 8: Segs$ = "1234567"
    CASE 9: Segs$ = "12347"
END SELECT
FOR i = 1 TO LEN(Segs$)
  SELECT CASE MID$(Segs$, i, 1)
    CASE "1"
      LINE (xPix + 2, yPix)-(xPix + 18, yPix), CLR
      LINE (xPix + 3, yPix + 1)-(xPix + 17, yPix + 1), CLR
      LINE (xPix + 4, yPix + 2)-(xPix + 16, yPix + 2), CLR
    CASE "2"
        LINE (xPix, yPix + 2)-(xPix, yPix + 18), CLR
        LINE (xPix + 1, yPix + 3)-(xPix + 1, yPix + 17), CLR
        LINE (xPix + 2, yPix + 4)-(xPix + 2, yPix + 16), CLR
    CASE "3"
        LINE (xPix + 20, yPix + 2)-(xPix + 20, yPix + 18), CLR
        LINE (xPix + 19, yPix + 3)-(xPix + 19, yPix + 17), CLR
        LINE (xPix + 18, yPix + 4)-(xPix + 18, yPix + 16), CLR
    CASE "4"
        LINE (xPix + 2, yPix + 19)-(xPix + 18, yPix + 19), CLR
        LINE (xPix + 1, yPix + 20)-(xPix + 19, yPix + 20), CLR
        LINE (xPix + 2, yPix + 21)-(xPix + 18, yPix + 21), CLR
    CASE "5"
        LINE (xPix, yPix + 22)-(xPix, yPix + 38), CLR
        LINE (xPix + 1, yPix + 23)-(xPix + 1, yPix + 37), CLR
        LINE (xPix + 2, yPix + 24)-(xPix + 2, yPix + 36), CLR
    CASE "6"
        LINE (xPix + 2, yPix + 40)-(xPix + 18, yPix + 40), CLR
        LINE (xPix + 3, yPix + 39)-(xPix + 17, yPix + 39), CLR
        LINE (xPix + 4, yPix + 38)-(xPix + 16, yPix + 38), CLR
    CASE "7"
        LINE (xPix + 20, yPix + 22)-(xPix + 20, yPix + 38), CLR
        LINE (xPix + 19, yPix + 23)-(xPix + 19, yPix + 37), CLR
        LINE (xPix + 18, yPix + 24)-(xPix + 18, yPix + 36), CLR
  END SELECT
NEXT
END SUB

SUB SmallPrint (spx, spy, sp$, spcolor) STATIC
'
  CIRCLE (spx, spy), 1000'                  Used As a Dummy To Set x-y
  DRAW "C" + LTRIM$(STR$(spcolor))'         Establish the Color
'
  FOR spchar = 1 TO LEN(sp$)
    SELECT CASE MID$(sp$, spchar, 1)
      CASE "A": DRAW "U3 E3 F3 D1 NL5 D2 BR3"
      CASE "B": DRAW "U6 R5 F1 D1 G1 NL4 F1 D1 G1 NL5 BR4"
      CASE "C": DRAW "BM+6,-5 H1 L3 G2 D2 F2 R3 E1 BD1 BR3"
      CASE "D": DRAW "U6 R4 F2 D2 G2 NL4 BR5"
      CASE "E": DRAW "BU6 NR6 D3 NR5 D3 R6 BR3"
      CASE "F": DRAW "BU6 NR6 D3 NR5 D3 BR9"
      CASE "G": DRAW "BM+6,-5 H1 L3 G2 D2 F2 R3 E1 U2 L1 BD3 BR4"
      CASE "H": DRAW "U6 BD3 R6 BU3 D6 BR3"
      CASE "I": DRAW "BR1 NU6 BR4"
      CASE "J": DRAW "BU2 F2 R2 E2 U4 BD6 BR3"
      CASE "K": DRAW "U6 BD3 R3 NE3 F3 BR3"
      CASE "L": DRAW "NU6 R6 BR3"
      CASE "M": DRAW "U6 F4 E4 D6 BR3"
      CASE "N": DRAW "U6 F6 U6 BD6 BR3"
      CASE "O": DRAW "BU2 U2 E2 R3 F2 D2 G2 L3 H2 BD2 BR10"
      CASE "P": DRAW "U6 R5 F1 D1 G1 L4 BD3 BR8"
      CASE "Q": DRAW "BU2 U2 E2 R3 F2 D2 G1 NH1 NF1 G1 L3 H2 BD2 BR10"
      CASE "R": DRAW "U6 R5 F1 D1 G1 L2 NF3 L2 BD3 BR8"
      CASE "S": DRAW "BU1 F1 R4 E1 U1 H1 L4 H1 U 1 E1 R4 F1 BD5 BR3"
      CASE "T": DRAW "BU6 R6 BL3 D6 BR6"
      CASE "U": DRAW "BU1 NU5 F1 R4 E1 U5 BD6 BR3"
      CASE "V": DRAW "BU6 D3 F3 E3 U3 BD6 BR3"
      CASE "W": DRAW "NU6 E3 F3 U6 BD6 BR3"
      CASE "X": DRAW "NE6 BU6 F6 BR3"
      CASE "Y": DRAW "BE3 NH3 NE3 D3 BR6"
      CASE "Z": DRAW "BU6 R6 G6 R6 BR3"
      CASE ".": DRAW "U1 R1 D1 BR3"
      CASE ",": DRAW "U1 R1 D1 ND1 BR3"
      CASE " ": DRAW "BR9"
      CASE "-": DRAW "BU3 R6 BD3 BR3" '"U6 BD3 R6 BU3 D6 BR3"
      CASE "@": DRAW "BU6 NR2 BR1 D3 BR3 U3 BD1 R2 BU1 D3 BD3 BR3"
      CASE "/": DRAW "NE6 BR9"
      CASE ">": DRAW "BR6 BU3 NH3 NG3 BD3 BR5"
      CASE "<": DRAW "BR1 BU3 NE3 NF3 BD3 BR8"
      CASE "0": DRAW "BU2 U2 E2 R3 F1 NG4 F1 D2 G2 L3 H2 BD2 BR10"
      CASE "1": DRAW "BR2 BU6 NG1 D6 NL2 R2 BR3"
      CASE "2": DRAW "BU5 E1 R4 F1 D1 G1 L4 G1 D2 R6 BR3"
      CASE "3": DRAW "BU5 E1 R4 F1 D1 G1 NL3 F1 D1 G1 L4 H1 BD1 BR9"
      CASE "4": DRAW "BR4 U6 G4 R6 BD2 BR3"
      CASE "5": DRAW "BU6 NR6 D2 R5 F1 D2 G1 L4 NH1 BR8"
      CASE "6": DRAW "BE6 BL1 L3 G2 D3 F1 R4 E1 U1 H1 L4 G1 BD2 BR9"
      CASE "7": DRAW "BU5 U1 R6 D1 G3 D2 BR6"
      CASE "8"
        DRAW "BU1 NF1 U1 E1 H1 U1 E1 R4 F1 D1 G1 NL3 F1 D1 G1 NL3 BR4"
      CASE "9": DRAW "BR1 R3 E2 U3 H1 L4 G1 D1 F1 R4 BD3 BR4"
      CASE ELSE: BEEP
    END SELECT
  NEXT
'
END SUB

SUB TINYFONT (HOR, VER, line$, CLR)

DRAW "BM" + STR$(HOR) + "," + STR$(VER) + " C" + STR$(CLR)

FOR pnt = 1 TO LEN(line$)
SELECT CASE MID$(line$, pnt, 1)
 CASE " ": DRAW "BM+7,0"
 CASE "A": DRAW "U4E2F2D2NL4D2;BM+3,0"
 CASE "B": DRAW "U6R3F1D1G1NL3F1D1G1L3;BM+7,0"
 CASE "C": DRAW "BM+1,-0;H1U4E1R2F1;BM+0,+4;G1L2;BM+6,0"
 CASE "D": DRAW "U6R3F1D4G1L3;BM+7,0"
 CASE "E": DRAW "NR4U3NR2U3R4;BM+3,+6"
 CASE "F": DRAW "U3NR2U3R4;BM+3,+6"
 CASE "G": DRAW "BM+1,-0;H1U4E1R2F1;BM+0,+2;NL1D2G1L2;BM+6,0"
 CASE "H": DRAW "U3NU3R4NU3D3;BM+3,0"
 CASE "I": DRAW "BM+1,0;R1NR1U6NL1R1;BM+4,+6"
 CASE "J": DRAW "BM+0,-1;F1R1E1U5NL1R1;BM+3,6"
 CASE "K": DRAW "U3NU3R1NE3F3;BM+3,0"
 CASE "L": DRAW "NU6R4U1;BM+3,+1"
 CASE "M": DRAW "U6F2ND1E2D6;BM+3,0"
 CASE "N": DRAW "U6F1D1F2D1F1NU6;BM+3,0"
 CASE "O": DRAW "BM+1,0;H1U4E1R2F1D4G1L2;BM+6,0"
 CASE "P": DRAW "U6R3F1D1G1L3;BM+7,3"
 CASE "Q": DRAW "BM+1,0;H1U4E1R2F1D3G1NH1NF1G1L1;BM+6,0"
 CASE "R": DRAW "U6R3F1D1G1L2NL1F3;BM+3,0"
 CASE "S": DRAW "BM+0,-1;F1R2E1U1H1L2H1U1E1R2F1;BM+3,+5"
 CASE "T": DRAW "BM+2,+0;U6NL2R2;BM+3,+6"
 CASE "U": DRAW "BM+0,-1;NU5F1R2E1U5;BM+3,6"
 CASE "V": DRAW "BM+0,-6;D2F1D1F1ND1E1U1E1U2;BM+3,+6"
 CASE "W": DRAW "NU6E2NU1F2U6;BM+3,6"
 CASE "X": DRAW "U1E4U1;BM-4,0;D1F4D1;BM+3,0"
 CASE "Y": DRAW "BM+0,-6;D2F2ND2E2U2;BM+3,6"
 CASE "Z": DRAW "NR4U1E4U1L4;BM+7,6"
 CASE "1": DRAW "BM+1,0;R1NR1U6G1;BM+6,+5"
 CASE "2": DRAW "NR4U1E1R1E2U1H1L2G1;BM+7,+5"
 CASE "3": DRAW "BM+0,-1;F1R2E1H2E2H1L3;BM+7,6"
 CASE "4": DRAW "BM+3,0;U2NR1L3U1E3D3;BM+4,3"
 CASE "5": DRAW "BM+0,-1;F1R2E1U2H1L3U2R4;BM+3,+6"
 CASE "6": DRAW "BM+4,-5;H1L2G1D4F1R2E1U1H1L3;BM+7,+3"
 CASE "7": DRAW "U1E4U1L4;BM+7,+6"
 CASE "8": DRAW "BM+1,-0;H1U1E1H1U1E1R2F1D1G1NL2F1D1G1L2;BM+6,0"
 CASE "9": DRAW "BM+0,-1;F1R2E1U4H1L2G1D1F1R2;BM+4,+3"
 CASE "0": DRAW "BM+1,0;H1U4E1R2F1D4G1L2;BM+6,0"
 CASE "/": DRAW "U1E4U1;BM+3,6"
 CASE "?": DRAW "BM+0,-5;E1R2F1D1G2;BM+0,+1;D1;BM+5,+0"
 CASE "!": DRAW "BM+2,+1;U1;BM+0,-2;U5;BM+5,7"
 CASE ".": DRAW "BM+2,0;U1;BM+5,+1"
 CASE ":": DRAW "BM+2,-1;U1;BM+0,-2;U1;BM+5,+5"
 CASE ";": DRAW "BM+1,0;E1U1;BM+0,-1;U1;BM+5,+4"
 CASE ",": DRAW "BM+2,0;NU1G1;BM+6,-1"
 CASE "'": DRAW "BM+1,-5;E2;BM+4,+7"
 CASE "-": DRAW "BM+0,-3;R4;BM+3,+3"
 CASE "+": DRAW "BM+2,-1;U2NU2NL2R2;BM+3,+3"
 CASE "=": DRAW "BM+1,-2;R3;BM-3,-2;R3;BM+4,+4"
 CASE ELSE: BEEP
END SELECT
NEXT
END SUB

