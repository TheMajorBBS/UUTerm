' Loads mode 9 (EGA) and mode 12 (VGA) .PCX
' files using only QB statements

DEFINT A-Z

CONST Red = 1, Green = 2, Blue = 3

TYPE PcxHeader
 Manufacturer AS STRING * 1
 version AS STRING * 1
 Encoding AS STRING * 1
 BitsPerPixel AS STRING * 1
 Xmin AS INTEGER
 Ymin AS INTEGER
 Xmax AS INTEGER
 Ymax AS INTEGER
 HDpi AS INTEGER
 Vdpi AS INTEGER
 Colormap AS STRING * 48
 Reserved AS STRING * 1
 NPlanes AS STRING * 1
 BytesPerLine AS INTEGER
 PaletteInfo AS INTEGER
 HScreenSize AS INTEGER
 VScreenSize AS INTEGER
 Filler AS STRING * 54
END TYPE

DIM a AS PcxHeader
DIM PaletteColors(15) AS LONG
DIM PCXByte AS STRING * 1

SCREEN 0: CLS
INPUT "Enter the name of the PCX file you want to load: ", PCXInFile$
OPEN PCXInFile$ FOR BINARY AS #1

' Retrieve Header information into PCX Header

GET 1, , a
XSize = a.Xmax + a.Xmin + 1
ysize = a.Ymax - a.Ymin + 1

' Determine image type and load palette
IF ysize = 350 THEN smode% = 9 ELSE smode% = 12
pcxversion% = ASC(a.version)

SELECT CASE pcxversion%
  CASE 0, 2, 5
    SELECT CASE ysize
      CASE 350
        FOR Entry% = 0 TO 15
          EntryIDX% = Entry% * 3
          R& = ASC(MID$(a.Colormap, EntryIDX% + Red)) \ 64
          G& = ASC(MID$(a.Colormap, EntryIDX% + Green)) \ 64
          B& = ASC(MID$(a.Colormap, EntryIDX% + Blue)) \ 64
          R& = ((R& AND 1) * 32) OR ((R& AND 2) / 2 * 4)
          G& = ((G& AND 1) * 16) OR ((G& AND 2) / 2 * 2)
          B& = ((B& AND 1) * 8) OR ((B& AND 2) / 2 * 1)
          PaletteColors(Entry%) = R& OR G& OR B&
        NEXT Entry%
      CASE 480
        FOR Entry% = 0 TO 15
          EntryIDX% = Entry% * 3
          R& = ASC(MID$(a.Colormap, EntryIDX% + Red)) \ 4
          G& = ASC(MID$(a.Colormap, EntryIDX% + Green)) \ 4
          B& = ASC(MID$(a.Colormap, EntryIDX% + Blue)) \ 4
          PaletteColors(Entry%) = 65536 * B& + 256& * G& + R&
        NEXT Entry%
      CASE ELSE
        PRINT "Invalid PCX resolution:"
        PRINT "  "; XSize; " X "; ysize
    END SELECT
  CASE 3
END SELECT

SCREEN smode%, , 0
IF pcxversion% <> 3 THEN PALETTE USING PaletteColors(0)

' File pointer is positioned after the header information
' Set Segment to base address for EGA/VGA

DEF SEG = &HA000
TotalBytesPerLine = a.BytesPerLine * ASC(a.NPlanes)
DIM DBytes(TotalBytesPerLine) AS INTEGER
CurByte = 0

FOR I& = 0 TO ysize - 1

DO
 ' read all four bit planes
 GET #1, , PCXByte
 ByteValue% = ASC(PCXByte)
  IF (ByteValue% AND &HC0) = &HC0 THEN
   NumDecode% = ASC(PCXByte)
   NumDecode% = NumDecode% AND &H3F
   GET #1, , PCXByte: ByteChar% = ASC(PCXByte)
   FOR NBytes = 1 TO NumDecode%
    DBytes(CurByte) = ByteChar%
    CurByte = CurByte + 1
   NEXT NBytes
  ELSE
   DBytes(CurByte) = ByteValue%
   CurByte = CurByte + 1
  END IF

LOOP UNTIL CurByte >= TotalBytesPerLine

 ' Slam each bit plane out there by scan line

  ScanLine& = a.BytesPerLine * I&

    FOR Plane = 1 TO 4
     BitPlane = 2 ^ (Plane - 1)
     'Specify Write Plane Mask register
     OUT &H3C4, 2
     'set Write Plane Mask register
     OUT &H3C5, BitPlane
     FOR Char2Zap = 0 TO a.BytesPerLine - 1
      zap = (Plane - 1) * a.BytesPerLine + Char2Zap
      IF zap > 239 THEN EXIT FOR
      POKE ScanLine& + Char2Zap, DBytes(zap)
     NEXT Char2Zap
    NEXT Plane

 CurByte = 0

NEXT I&

' Reset Write Plane Mask Register

OUT &H3C4, 2: OUT &H3C5, &HF: DEF SEG : CLOSE #1

END

