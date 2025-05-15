'loads graphic that is appended to an .EXE  
   
    TYPE EXEHEADER
       exSignature AS INTEGER
       exExtraBytes AS INTEGER   ' Number of bytes in last page.
       exPages AS INTEGER        ' Number of whole and part pages.
       exRelocItems AS INTEGER
       exHeaderSize AS INTEGER
       exMinAlloc AS INTEGER
       exMaxAlloc AS INTEGER
       exInitSS AS INTEGER
       exInitSP AS INTEGER
       exCheckSum AS INTEGER
       exInitIP AS INTEGER
       exInitCS AS INTEGER
       exRelocTable AS INTEGER
       exOverlay AS INTEGER
    END TYPE

    DIM exeheadblock AS EXEHEADER
    OPEN "TEST.EXE" FOR BINARY AS #1
    GET #1, , exeheadblock    ' This puts the executable header in
                              ' to the structure exeheadblock.
    CLS
    SCREEN 12
    DIM Box%(1 TO 1792)
    IF exeheadblock.exPages MOD 512 <> 0 THEN
      Size = exeheadblock.exPages * 512& - (512& - exeheadblock.exExtraBytes)
    ELSE  ' If no partial pages then execute the ELSE statement.
        Size = exeheadblock.exPages * 512&
    END IF

    GET #1, Size + 1, Box%(1) ' Read each element of the array.
    FOR I% = 2 TO 1792
       GET #1, , Box%(I%)
    NEXT I%
    CLOSE #1

    PUT (100, 100), Box%      ' Put the graphics image to the screen.
    SLEEP
    END

