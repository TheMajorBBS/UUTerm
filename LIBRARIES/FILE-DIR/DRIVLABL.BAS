' Gets and/or Sets the disk volume label
'
'Note that, while the ReadLabel routine will find the volume label from
'whichever subdirectory you happen to be in, the MakeLabel routine only
'works from the root directory of the drive you're relabelling.
'
'   Author:     Christy Gemmell
'
'   $DYNAMIC
'   $INCLUDE: 'QB.BI'                       ' Use QBX.BI for PDS

    DECLARE SUB MakeLabel (Drive$, Label$)
    DECLARE SUB ReadLabel (Drive$, Label$)

    CONST FALSE = 0, TRUE = NOT FALSE

    TYPE XFCBType
	XFlag AS STRING * 1                 ' Extended FCB signature
	Rsrv1 AS STRING * 5                 ' Reserved (do not use)
	Attr  AS STRING * 1                 ' File attribute
	Drive AS STRING * 1                 ' Drive number
	FName AS STRING * 11                ' Filename
	Rsrv2 AS STRING * 5                 ' Reserved (do not use)
	NName AS STRING * 11                ' Replacement name
	Rsrv3 AS STRING * 9                 ' Reserved (do not use)
    END TYPE

    DIM SHARED FCB AS XFCBType              ' File Control Block
    DIM SHARED InRegs AS RegTypeX           ' Register structures
    DIM SHARED OutRegs AS RegTypeX          '   for interrupt calls

    DIM SHARED DTA AS STRING * 64           ' Disk Transfer Area

    LSET FCB.XFlag = CHR$(255)              ' Flag as Extended FCB
    LSET FCB.Rsrv1 = STRING$(5, 0)          ' Fill with nulls
   
    CLS
    Drive$ = "A:": Label$ = ""
    ReadLabel Drive$, Label$
    LOCATE 10, 1: PRINT "Current Label = "; Label$
    Label$ = "DidItWork"
    MakeLabel Drive$, Label$
    LOCATE 12, 1: PRINT "New Label     = "; Label$
END

'   Creates or changes the volume label of the drive specified
'
SUB MakeLabel (Drive$, Label$) STATIC
    NewLabel$ = Label$                      ' Preserve new label
    ReadLabel Drive$, Label$                ' Search for current label
    IF Label$ = "" THEN                     ' If no label found
       LSET FCB.FName = NewLabel$           '    Set new label
       InRegs.ds = VARSEG(FCB)              '    Segment and offset of
       InRegs.dx = VARPTR(FCB)              '      our File Control Block
       InRegs.ax = &H1600                   '    Create file
       INTERRUPTX &H21, InRegs, OutRegs     '    Call DOS
       InRegs.ax = &H1000                   '    Close file
       INTERRUPTX &H21, InRegs, OutRegs     '    Call DOS
    ELSE                                    ' Otherwise
       LSET FCB.FName = Label$              '    Set current label
       LSET FCB.NName = NewLabel$           '    Set replacement label
       InRegs.ds = VARSEG(FCB)              '    Segment and offset of
       InRegs.dx = VARPTR(FCB)              '      our File Control Block
       InRegs.ax = &H1700                   '    Rename file
       INTERRUPTX &H21, InRegs, OutRegs     '    Call DOS
    END IF
    Label$ = ""                             ' Check to see
    ReadLabel Drive$, Label$                '    if it worked
END SUB

'   Reads the volume label of the drive specified.
'
SUB ReadLabel (Drive$, Label$) STATIC
    InRegs.ax = &H2F00                      ' Get current DTA
    INTERRUPTX &H21, InRegs, OutRegs        ' Call DOS
    DTASeg% = OutRegs.es                    ' Store DTA segment
    DTAOff% = OutRegs.bx                    ' Store DTA offset
    InRegs.ds = VARSEG(DTA)                 ' Replace with
    InRegs.dx = VARPTR(DTA)                 '    our own temporary
    InRegs.ax = &H1A00                      '    Disk Transfer Area
    INTERRUPTX &H21, InRegs, OutRegs        ' Call DOS
    IF Drive$ = "" THEN                     ' If no drive
       Disk% = 0                            '    letter is supplied
    ELSE                                    '    use current drive
       Disk% = ASC(UCASE$(Drive$)) - 64     '    otherwise convert
    END IF                                  '    letter to numeral
    LSET FCB.Drive = CHR$(Disk%)            ' Drive to search
    LSET FCB.Attr = CHR$(8)                 ' Specify Volume label
    LSET FCB.FName = "???????????"          ' Use wildcards for search
    InRegs.ds = VARSEG(FCB)                 ' Segment and offset of
    InRegs.dx = VARPTR(FCB)                 '    our File Control Block
    InRegs.ax = &H1100                      ' Find first match
    INTERRUPTX &H21, InRegs, OutRegs        ' Call DOS
    IF OutRegs.ax MOD 256 = &HFF THEN       ' If a label wasn't found
       Label$ = ""                          '    return a null string
    ELSE                                    '    otherwise
       Label$ = MID$(DTA, 9, 11)            '    extract it from
    END IF                                  '    our DTA
    InRegs.ds = DTASeg%                     ' Restore
    InRegs.dx = DTAOff%                     '    original
    InRegs.ax = &H1A00                      '    Disk Transfer Area
    INTERRUPTX &H21, InRegs, OutRegs        ' Call DOS
END SUB

