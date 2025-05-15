DEFINT A-Z
'Saves/loads graphic to disk using print/input

SCREEN 1
CLS
right = 95: left = 13: bottom = 80: top = 35
LINE (left, top)-(right, bottom), 14, B
BitsPerPixel% = 2: BitPlanes% = 2         'SCREEN 1!!!
Bytes% = 2 + INT(((right - left + 1) * (BitsPerPixel%) + 7) / 8) * BitPlanes% * ((bottom - top) + 1)
REDIM Image%(Bytes%)
GET (left, top)-(right, bottom), Image%
OPEN "IMAGE.DAT" FOR OUTPUT AS #1
  PRINT #1, Bytes%                       'Save # of Bytes First
  FOR loops = 0 TO Bytes%
    PRINT #1, Image%(loops)             'Save Image% Array
  NEXT loops
CLOSE

PRINT "press a key to continue:"
SLEEP
 
OPEN "IMAGE.DAT" FOR INPUT AS #1
  INPUT #1, Bytes%                       'Get # of Bytes
  REDIM Image%(Bytes%)                   'Buffer Integer Array
  FOR loops = 0 TO Bytes%
    INPUT #1, Image%(loops)             'Load Integers into Array
  NEXT loops
CLOSE
PUT (30, 30), Image%                      'ReDisplay the Image
endin! = TIMER

END

