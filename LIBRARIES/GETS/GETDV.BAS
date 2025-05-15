'Detect Desqview Multi-Tasker & return version number

     DECLARE FUNCTION DVVers! ()
     
     DEFINT A-Z
     
     TYPE RegType
        AX AS INTEGER
        Bx AS INTEGER
        CX AS INTEGER
        DX AS INTEGER
        BP AS INTEGER
        SI AS INTEGER
        DI AS INTEGER
        FLAGS AS INTEGER
        DS AS INTEGER
        ES AS INTEGER
     END TYPE
     
     DIM SHARED InRegs AS RegType, OutRegs AS RegType
     
     CLS
     DV! = DVVers!
     IF DV! = 0 THEN
        PRINT "DESQview is currently NOT running."
     ELSE
        PRINT USING "You are running under DESQview version #.##"; DV!
     END IF
     
     END

     FUNCTION DVVers!
     
        InRegs.CX = &H4445   ' An invalid date... (= "DESQ")
        InRegs.DX = &H5351
        InRegs.AX = &H2B01      ' DOS Set Date function
        CALL interrupt(&H21, InRegs, OutRegs)
        IF (OutRegs.AX AND 255) = 255 THEN
           DV.Vers = 0
        ELSE
           DV.Vers! = ((OutRegs.Bx AND &HFF00) / 256) + (OutRegs.Bx AND 255) / 100
        END IF
        DVVers! = DV.Vers!
     
     END FUNCTION

