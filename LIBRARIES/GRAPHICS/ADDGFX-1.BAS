'Save and append a graphic to an .EXE file
'TYPE DATAFILE >>FILE.EXE

    SCREEN 12
    COLOR 1                       ' Select Blue for the color.
    DIM Box%(1 TO 1792)           ' Dimension an array big enough
                                  ' for the GET statement.
    LOCATE 2, 2                   ' Locate the "Hello" text.
    PRINT "Hello";
    LINE (1, 15)-(55, 30), , B    ' Draw a box.
    GET (1, 1)-(55, 30), Box%     ' Get the box.

    OPEN "DATAFILE" FOR BINARY AS #1
    FOR I% = 1 TO 1792
        PUT #1, , Box%(I%)        ' Save image to disk.
    NEXT I%
    CLOSE #1
    END

