'display a .GIF file
'$DYNAMIC
DEFINT A-Z
DECLARE FUNCTION getbit1 ()
DECLARE FUNCTION ReadCode (CodeSize)
CONST True = -1, False = 0, redc = 0, greenc = 1, bluec = 2
DIM ByteBuffer AS STRING * 1
DIM Powers(8), Prefix(4096), Suffix(4096), Outcode(1024)
DIM MaxCodes(12), Powers2(16), pal(255) AS LONG
DIM SHARED Xstart, Xend
DIM endcounter AS LONG
DIM image%(1 TO 32200)
DIM colours(256 * 3) AS STRING * 1
counter = 0
xofs% = 0
yofs% = 0
xlen% = 320
ylen% = 200
FOR a = 1 TO 8: Powers(a) = 2 ^ (a - 1): NEXT
DATA 4,8,16,&h20,&h40,&h80,&h100,&h200,&h400,&h800,&h1000,8192
FOR a = 0 TO 11: READ MaxCodes(a): NEXT
DATA 1,3,7,15,31,63,127,255
FOR a = 1 TO 8: READ CodeMask(a): NEXT
DATA 1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384
FOR a = 0 TO 14: READ Powers2(a): NEXT
CLS
d$ = COMMAND$
INPUT "Enter gif path\name"; f$
INPUT "Enter destination and name"; e$
OPEN f$ FOR BINARY AS #1 LEN = 1
OPEN (e$ + ".DAT") FOR BINARY AS #3 LEN = 1
IF LOF(1) = 0 THEN PRINT "File not found!": CLOSE : KILL f$: END
FOR a = 1 TO 6
    GET #1, , ByteBuffer: a$ = a$ + ByteBuffer
NEXT
IF a$ <> "GIF87a" THEN
    PRINT "Warning, the "; a$; " protocol is being used in this file."
    LINE INPUT "Proceed anyway(Y/N)?"; a$
    IF UCASE$(a$) <> "Y" THEN END
END IF
GET #1, , TotalX
GET #1, , TotalY
GET #1, , ByteBuffer: a = ASC(ByteBuffer)
bitspixel = (a AND 7) + 1
GET #1, , ByteBuffer: Background = ASC(ByteBuffer)
GET #1, , ByteBuffer
IF ASC(ByteBuffer) <> 0 THEN
    PRINT "Bad file."
    END
END IF
' Retrieves and saves color palette.
FOR a = 0 TO 2 ^ bitspixel - 1
    GET #1, , ByteBuffer: red = ASC(ByteBuffer)
    GET #1, , ByteBuffer: green = ASC(ByteBuffer)
    GET #1, , ByteBuffer: blue = ASC(ByteBuffer)
    ' Here's the main change... had to save the palette to a file so that
    ' I could fix the color problem.
    colours((a * 3) + redc) = CHR$(red)
    colours((a * 3) + greenc) = CHR$(green)
    colours((a * 3) + bluec) = CHR$(blue)
    PUT #3, , colours((a * 3) + redc)
    PUT #3, , colours((a * 3) + greenc)
    PUT #3, , colours((a * 3) + bluec)
NEXT
CLOSE #3
GET #1, , ByteBuffer
IF ByteBuffer <> "," THEN
    PRINT "Bad file."
    END
END IF
GET #1, , Xstart
GET #1, , Ystart
GET #1, , Xlength
GET #1, , Ylength
Xend = Xlength + Xstart - 1: Yend = Ylength + Ystart - 1
GET #1, , ByteBuffer
a = ASC(ByteBuffer)
IF (a AND 128) = 128 THEN
    PRINT "Local colormap encountered."
    END
ELSEIF (a AND 64) = 64 THEN
    PRINT "Image is interlaced!"
    END
END IF
GET #1, , ByteBuffer
CodeSize = ASC(ByteBuffer): ClearCode = Powers2(CodeSize)
EOFCode = ClearCode + 1: FirstFree = ClearCode + 2
FreeCode = FirstFree: CodeSize = CodeSize + 1
InitCodeSize = CodeSize: Maxcode = MaxCodes(CodeSize - 2)
Bitmask = CodeMask(bitspixel)
GET #1, , ByteBuffer
BlockLength = ASC(ByteBuffer) + 1: Bitsin = 8
OutCount = 0
x = Xstart: y = Ystart
ON ERROR GOTO 0
PRINT "Translating file now.";
SCREEN 13
DO
    Code = ReadCode(CodeSize)
    IF Code <> EOFCode THEN
        IF Code = ClearCode THEN
            CodeSize = InitCodeSize
            Maxcode = MaxCodes(CodeSize - 2): FreeCode = FirstFree
            Code = ReadCode(CodeSize): CurCode = Code
            OldCode = Code: Finchar = Code AND Bitmask
            a = Finchar
            GOSUB Plot
        ELSE
            CurCode = Code: InCode = Code
            IF Code >= FreeCode THEN
                CurCode = OldCode
                Outcode(OutCount) = Finchar
                OutCount = OutCount + 1
            END IF
            IF CurCode > Bitmask THEN
                DO
                    Outcode(OutCount) = Suffix(CurCode)
                    OutCount = OutCount + 1
                    CurCode = Prefix(CurCode)
                LOOP UNTIL CurCode <= Bitmask
            END IF
            Finchar = CurCode AND Bitmask
            Outcode(OutCount) = Finchar
            OutCount = OutCount + 1
            FOR i = OutCount - 1 TO 0 STEP -1
                a = Outcode(i)
                GOSUB Plot
            NEXT
            OutCount = 0
            Prefix(FreeCode) = OldCode: Suffix(FreeCode) = Finchar
            OldCode = InCode: FreeCode = FreeCode + 1
            IF FreeCode >= Maxcode THEN
                IF CodeSize < 12 THEN
                    CodeSize = CodeSize + 1: Maxcode = Maxcode * 2
                END IF
            END IF
        END IF
    END IF
    a$ = INKEY$
LOOP UNTIL Code = EOFCode OR a$ <> ""
CLOSE #1
GET (0, 0)-(319, 199), image%(1)
DEF SEG = VARSEG(image%(1))
BSAVE e$ + ".SAV", VARPTR(image%(1)), 64200
DEF SEG
SCREEN 0
WIDTH 80, 25
PRINT "Translation complete."
END
Plot:
  PSET (x - xofs%, y - yofs%), a
  x = x + 1
  IF x > Xend THEN
    x = Xstart
    y = y + 1
  END IF
  RETURN

REM $STATIC
'This subprogram gets one bit from the data stream.
FUNCTION getbit1 STATIC
    SHARED ByteBuffer AS STRING * 1, Powers(), Bitsin, BlockLength, Num
    Bitsin = Bitsin + 1
    IF Bitsin = 9 THEN
        GET #1, , ByteBuffer
        TempChar = ASC(ByteBuffer)
        Bitsin = 1
        Num = Num + 1
        IF Num = BlockLength THEN
            BlockLength = TempChar + 1
            GET #1, , ByteBuffer
            TempChar = ASC(ByteBuffer)
            Num = 1
        END IF
    END IF
    IF (TempChar AND Powers(Bitsin)) = 0 THEN getbit1 = 0 ELSE getbit1 = 1
END FUNCTION

FUNCTION ReadCode (CodeSize)
    SHARED Powers2()
    Code = 0
    FOR Aa = 0 TO CodeSize - 1
        Code = Code + getbit1 * Powers2(Aa)
    NEXT
    ReadCode = Code
END FUNCTION

