DEFINT A-Z
'displays full directory info on files
DECLARE SUB SortDir (SNumberOfFiles AS INTEGER)
DECLARE FUNCTION ReadDir& (RDIR$, RFTYPE$)
DECLARE FUNCTION FreeSpace& (FCurrentDrive AS INTEGER)
DECLARE FUNCTION GetCurrentDrive% ()
DECLARE FUNCTION GetNumberOfDrives% ()
DECLARE FUNCTION GetVolumeName$ (VDir$)
DECLARE FUNCTION GetFile% ()
TYPE RegTypeX
        AX AS INTEGER
        BX AS INTEGER
        CX AS INTEGER
        DX AS INTEGER
        BP AS INTEGER
        SI AS INTEGER
        DI AS INTEGER
        FLAGS AS INTEGER
        DS AS INTEGER
        ES AS INTEGER
END TYPE
TYPE DTA
        RES AS STRING * 21
        ATT AS STRING * 1
        Time AS INTEGER
        Date AS INTEGER
        Size AS LONG
        FName AS STRING * 98
END TYPE
TYPE TDTA
        Time AS STRING * 8
        Date AS STRING * 10
        Size AS LONG
        FName AS STRING * 12
        D AS INTEGER
        R AS INTEGER
        A AS INTEGER
        S AS INTEGER
        H AS INTEGER
END TYPE
COMMON SHARED TDInfo() AS TDTA
COMMON SHARED Dinfo AS DTA
COMMON SHARED Dregs AS RegTypeX
COMMON SHARED NumberOfFIles AS INTEGER
CONST MaxFiles = 250  '***Maximum entries in a directory***
CONST True = -1
CONST FALSE = NOT True
DIM TDInfo(1 TO MaxFiles) AS TDTA

FormatDir$ = "\      \ \ \  ##########  \  \  \        \  \      \\\"

CLS
DirPath$ = "D:\"  '***Change to directory to list***
NumberOfFIles = ReadDir(DirPath$, "*.*") '***Load directory into TDInfo array***
SortDir (NumberOfFIles)                  '***Sort directory***

'***Display directory on screen***
CLS
CurrentDrive = ASC(LEFT$(UCASE$(DirPath$) + CHR$(0), 1)) - 64
IF CurrentDrive < 1 OR CurrentDrive > GetNumberOfDrives% THEN
   CurrentDrive = GetCurrentDrive%
END IF
PRINT USING "Volume in Drive \\is \          \"; CHR$(CurrentDrive + 64); GetVolumeName$(DirPath$)'add to above line
PRINT "Directory of "; DirPath$
PRINT

FOR I = 1 TO NumberOfFIles
     IF TDInfo(I).D = True THEN  '***Directory entry***
        PRINT USING "\      \ <DIR>"; TDInfo(I).FName
     ELSE
        Rash$ = "...."              '***Set attributes***
        IF TDInfo(I).R = True THEN
           MID$(Rash$, 1, 1) = "R"
        END IF
        IF TDInfo(I).A = True THEN
           MID$(Rash$, 2, 1) = "A"
        END IF
        IF TDInfo(I).S = True THEN
           MID$(Rash$, 3, 1) = "S"
        END IF
        IF TDInfo(I).H = True THEN
           MID$(Rash$, 4, 1) = "H"
        END IF
        Period = INSTR(TDInfo(I).FName, ".")
        IF Period <> 0 THEN
           FileName$ = LEFT$(TDInfo(I).FName, Period - 1)
           FileExt$ = MID$(TDInfo(I).FName, Period + 1, LEN(TDInfo(I).FName))
        ELSE
           FileName$ = TDInfo(I).FName
           FileExt$ = ""
        END IF
        '***Convert from 24 hour format to 12 hour format***
        Hour = VAL(MID$(TDInfo(I).Time, 1, 2))
        IF Hour > 12 THEN
           Hour = Hour - 12
           AP$ = "pm"
        ELSE
           AP$ = "am"
        END IF
        MID$(TDInfo(I).Time, 1, 2) = RIGHT$("0" + LTRIM$(STR$(Hour)), 2)
        PRINT USING FormatDir$; FileName$; FileExt$; TDInfo(I).Size; Rash$; TDInfo(I).Date; TDInfo(I).Time; AP$ 'add to above line
     END IF
NEXT I
PRINT USING "       #### File(s)  ###,###,### bytes free"; NumberOfFIles; FreeSpace(CurrentDrive) 'add to above line

FUNCTION FreeSpace& (FCurrentDrive AS INTEGER)
     '*** Return free disk space of drive as pointed to by FCurrentDrive ***
     '*** Where 0 = default, 1=A, 2=B, 3=C etc. ***

     Dregs.AX = &H3600
     Dregs.DX = FCurrentDrive
     CALL InterruptX(&H21, Dregs, Dregs)   '***Get bytes free***
     FreeSpace& = CLNG(Dregs.AX) * Dregs.BX * Dregs.CX

END FUNCTION

FUNCTION GetCurrentDrive%
    '*** Returns default drive number ***

    Dregs.AX = &H1900
    CALL InterruptX(&H21, Dregs, Dregs)
    GetCurrentDrive% = (Dregs.AX AND 255) + 1 '***A=1, B=2. C=3 etc.***

END FUNCTION

FUNCTION GetNumberOfDrives
   '***Returns number of drives or LASTDRIVE whichever is greater***

   CurrentDrive = GetCurrentDrive% '*** Save current logged drive ***
   Dregs.AX = &HE00
   Dregs.DX = 0                    '*** Set to drive A (all pc's should have) ***
   CALL InterruptX(&H21, Dregs, Dregs)
   GetNumberOfDrives = (Dregs.AX AND 15)
   Dregs.AX = &HE00
   Dregs.DX = CurrentDrive - 1     '*** Restore drive to default ***
   CALL InterruptX(&H21, Dregs, Dregs)

END FUNCTION

FUNCTION GetVolumeName$ (VDir$)
'***Returns volume name of disk referenced by VDir$)

DIM FileSpec AS STRING * 60
FileSpec = VDir$ + "*.*" + CHR$(0)

Dregs.DS = VARSEG(Dinfo)            '*** Set Pointers to temporary storage array ***
Dregs.DX = VARPTR(Dinfo)
Dregs.AX = &H1A00                   '*** Interrupt $21, Function $1A ***
CALL InterruptX(&H21, Dregs, Dregs) '*** Set disk xfer address ***
Dregs.AX = &H4E00                   '*** Find First entry ***
Dregs.CX = 8                        '*** Only Volume Name returned ***
VSEG% = VARSEG(FileSpec)            '*** Set pointers to FileSpec ***
VPTR% = VARPTR(FileSpec)

DoneFlag = FALSE
DO
   Dregs.DS = VSEG%
   Dregs.DX = VPTR%
   CALL InterruptX(&H21, Dregs, Dregs)  '***1st time AX=$4E (find 1st entry) ***
   IF (Dregs.FLAGS AND 1) = FALSE THEN  '***Entry is found***
       IF (ASC(Dinfo.ATT) AND 8) = 8 THEN
          VolumeName$ = Dinfo.FName
          Period = INSTR(Dinfo.FName, ".")
          IF Period <> 0 THEN
             VolumeName$ = LEFT$(Dinfo.FName, Period - 1) + MID$(Dinfo.FName, Period + 1, LEN(Dinfo.FName))
          ELSE
             VolumeName$ = Dinfo.FName
          END IF
          GetVolumeName$ = LEFT$(VolumeName$, INSTR(VolumeName$, CHR$(0)) - 1)
          DoneFlag = True               '***If found then quit looking ***
       END IF
       Dregs.AX = &H4F00  '***Read next entry***
   ELSE
       DoneFlag = True    '***No more entries***
   END IF
LOOP UNTIL DoneFlag = True

END FUNCTION

DEFSNG A-Z
FUNCTION ReadDir& (RDIR$, RFTYPE$)
'** READS DIRECTORY INTO TD.Info() ARRAY ***
'*** Returns the number of files found ***
'*** RDIR$=directory path..must end with \  or left blank for current***
'*** RFTYPE$=parameters such as *.* ***

DIM FileSpec AS STRING * 60
FileSpec = RDIR$ + RFTYPE$ + CHR$(0)
FI = 0
Dregs.DS = VARSEG(Dinfo)  '*** Set Pointers to temporary storage array ***
Dregs.DX = VARPTR(Dinfo)
Dregs.AX = &H1A00         '*** Interrupt $21, Function $1A ***
CALL InterruptX(&H21, Dregs, Dregs)  '***Set disk xfer address ***
Dregs.AX = &H4E00                    '*** Find First entry ***
Dregs.CX = 55         '*** Set to 0 to not include directories ***
VSEG% = VARSEG(FileSpec) '*** Set pointers to FileSpec ***
VPTR% = VARPTR(FileSpec)

DoneFlag = FALSE
DO
  Dregs.DS = VSEG%
  Dregs.DX = VPTR%
  CALL InterruptX(&H21, Dregs, Dregs)  '***1st time AX=$4E (find 1st entry) ***
  IF (Dregs.FLAGS AND 1) = FALSE THEN  '***Entry is found***
    FI = FI + 1
    '***Get filename***
    F$ = Dinfo.FName
    TDInfo(FI).FName = LEFT$(F$, INSTR(F$, CHR$(0)) - 1)
    TDInfo(FI).Date = "  -  -    "
    TDInfo(FI).Time = "  :  :  "
    '***Assemble date***
MID$(TDInfo(FI).Date, 1, 2) = RIGHT$("0" + LTRIM$(STR$((Dinfo.Date AND 480) \ 32)), 2)'add to above line
MID$(TDInfo(FI).Date, 4, 2) = RIGHT$("0" + LTRIM$(STR$((Dinfo.Date AND 31))), 2)  'add to above line
MID$(TDInfo(FI).Date, 7, 4) = LTRIM$(STR$((Dinfo.Date AND 65024) \ 512 + 1980))  'add to above line
    '***Assemble Time***
MID$(TDInfo(FI).Time, 1, 2) = RIGHT$("0" + LTRIM$(STR$((Dinfo.Time AND 63488) \ 2048)), 2) 'add to above
MID$(TDInfo(FI).Time, 4, 2) = RIGHT$("0" + LTRIM$(STR$((Dinfo.Time AND 2016) \ 32)), 2)  'add to above
MID$(TDInfo(FI).Time, 7, 2) = RIGHT$("0" + LTRIM$(STR$((Dinfo.Time AND 31))), 2)  'add to above
    '***Get filesize***'
    TDInfo(FI).Size = Dinfo.Size
    '***Set attributes***
    TDInfo(FI).D = (ASC(Dinfo.ATT) AND 16) = 16
    TDInfo(FI).R = (ASC(Dinfo.ATT) AND 1) = 1
    TDInfo(FI).A = (ASC(Dinfo.ATT) AND 32) = 32
    TDInfo(FI).S = (ASC(Dinfo.ATT) AND 4) = 4
    TDInfo(FI).H = (ASC(Dinfo.ATT) AND 2) = 2
    IF TDInfo(FI).S = True OR TDInfo(FI).H = True THEN
    '***Make System or Hidden files lower case***
      TDInfo(FI).FName = LCASE$(TDInfo(FI).FName)
      'FI = FI - 1 '***Remove REM to not display System/Hidden files***
    END IF
    Dregs.AX = &H4F00  '***Read next entry***
  ELSE
    DoneFlag = True    '***No more entries***
END IF
LOOP UNTIL DoneFlag = True
ReadDir = FI  '***Return number of entries found***
END FUNCTION

SUB SortDir (SNumberOfFiles AS INTEGER)
'***SORT DIRECTORY BY FILENAME (SHELL SORT)***
'***Sorts in ascending order***
'***Set number of passes required to sort array***
IF SNumberOfFiles = 0 THEN
  TPASS = 0
ELSE
  TPASS = INT(LOG(SNumberOfFiles) / LOG(2))
END IF

MidPoint = SNumberOfFiles
'***SORT DIRECTORY***
FOR L = 1 TO TPASS
  MidPoint = MidPoint \ 2
  FOR I = MidPoint TO SNumberOfFiles - 1
    FOR J = (I - MidPoint + 1) TO 1 STEP -MidPoint
      IF (UCASE$(TDInfo(J).FName) > UCASE$(TDInfo(J + MidPoint).FName)) THEN
        '***Put directories at top of listing***
        IF TDInfo(J).D = True AND TDInfo(J + MidPoint).D = FALSE THEN
          EXIT FOR
        ELSE
          SWAP TDInfo(J), TDInfo(J + MidPoint)
        END IF
      ELSE
        IF TDInfo(J).D = FALSE AND TDInfo(J + MidPoint).D = True THEN
          SWAP TDInfo(J), TDInfo(J + MidPoint)
        ELSE
          EXIT FOR
        END IF
      END IF
NEXT J, I, L
END SUB

