'Collectin of subs for reading disks/drives
TYPE DataTransferArea
    Reserved1   AS STRING * 21
    Attribute   AS STRING * 1
    FileTime    AS INTEGER
    FileDate    AS INTEGER
    FileSize    AS LONG
    FileName    AS STRING * 13
END TYPE
TYPE DirectoryRecord
    FileName    AS STRING * 13
    FileSize    AS LONG
    FileDate    AS INTEGER
    FileTime    AS INTEGER
    FileAttb    AS INTEGER
END TYPE
DECLARE SUB ParsePathname (InSpec$, Drive$, Path$, Entry$)
DECLARE SUB ChDrive (DriveSpec$)
DECLARE FUNCTION CurDir$ ()
DECLARE FUNCTION QualifyName$ (InSpec$)
DECLARE SUB TreeWalk (InSpec$, ActionKey%)
DECLARE SUB TreeWalkHelper (PathSpec$, EntrySpec$, ActionKey%, Level%)
DECLARE SUB ProcessDirectoryEntry (PathSpec$, EntrySpec$, DirEnt AS
-DirectoryRecord, Level%)
DECLARE FUNCTION FindFirst% (Attr%, FileName$, DEntry AS DirectoryRecord,
- theDTA AS DataTransferArea)
DECLARE FUNCTION FindNext% (DEntry AS DirectoryRecord, theDTA AS DataTransferArea)
DECLARE SUB PrintDirEntry (DR AS DirectoryRecord, FindStatus%)
DECLARE SUB SetDTA (theDTA AS DataTransferArea)
DECLARE SUB TransferDTA2DIR (DEntry AS DirectoryRecord, theDTA AS DataTransferArea)
CONST TopDown = 1, BottomsUp = 2
CONST FALSE = 0, TRUE = NOT FALSE
DEFINT A-Z

' $INCLUDE: 'qb.BI'
DIM SHARED InRegsX AS RegTypeX
DIM SHARED OutRegsX AS RegTypeX

INPUT "Enter a path spec: ", Spec$
Action% = 0
DO WHILE Action% = 0
  PRINT "Enter T for top-down traversal, or"
  INPUT "enter B for bottoms-up traversal:", Action$
  Action% = INSTR("TB", UCASE$(Action$))
LOOP
TreeWalk Spec$, Action%   ' Walk the directory tree.
END

DEFSNG A-Z
SUB ChDrive (DriveSpec$)
' ChDrive -     Changes the currently logged drive to that specified
'               by the first character of the DriveSpec$ argument.

DIM Regs AS RegType

Regs.ax = &HE00
Regs.dx = ASC(DriveSpec$) - &H41
INTERRUPT &H21, Regs, Regs

END SUB

FUNCTION CurDir$
' CurDir$ -     Returns a string containing the current working
'               drive and directory.

DIM Regs AS RegTypeX
DIM cwdTmp1 AS STRING * 64
DIM cwDrv AS INTEGER

Regs.ax = &H1900             ' get current disk
INTERRUPTX &H21, Regs, Regs

cwDrv = Regs.ax AND &HFF

LSET cwdTmp1 = ""

Regs.ax = &H4700             ' get current working direcory
Regs.dx = 0                  ' specify current drive
Regs.ds = VARSEG(cwdTmp1)
Regs.si = VARPTR(cwdTmp1)
INTERRUPTX &H21, Regs, Regs

' Construct the final current directory string.
cwdTmp2$ = CHR$(cwDrv + &H41) + ":\"
CurDir$ = cwdTmp2$ + MID$(cwdTmp1, 1, INSTR(cwdTmp1, CHR$(0)) - 1)

END FUNCTION

DEFINT A-Z
FUNCTION FindFirst (Attr, FileName$, DEntry AS DirectoryRecord, theDTA AS DataTransferArea)
InRegsX.ax = &H4E00
InRegsX.cx = Attr

 Spec$ = FileName$ + CHR$(0) ' Create an ASCIIZ version of string
 InRegsX.ds = VARSEG(Spec$)  ' Load DS:DX with
 InRegsX.dx = SADD(Spec$)    ' address of Spec$
 INTERRUPTX &H21, InRegsX, OutRegsX

' The next line sets an error as default condition

FindFirst = OutRegsX.ax      ' assume an error
IF (OutRegsX.flags AND 1) = 0 THEN
  TransferDTA2DIR DEntry, theDTA
  FindFirst = 0              ' Clear the assumed error condition
END IF
END FUNCTION

FUNCTION FindNext (DEntry AS DirectoryRecord, theDTA AS DataTransferArea)
theDTA.FileName = SPACE$(13)
InRegsX.ax = &H4F00
INTERRUPTX &H21, InRegsX, OutRegsX
FindNext = OutRegsX.ax
IF (OutRegsX.flags AND 1) = 0 THEN
  TransferDTA2DIR DEntry, theDTA
  FindNext = 0
END IF
END FUNCTION

DEFSNG A-Z
SUB ParsePathname (InSpec$, Drive$, Path$, Entry$)

IF LEN(InSpec$) > 0 THEN
  OldSpec$ = InSpec$    ' make a copy for possible later use
  OldDrive$ = ""
  InSpec$ = QualifyName$(InSpec$) ' qualify the name (DOS 3.X > only)
  ' Let's see if the network redirector messed with the name
  IF LEFT$(InSpec$, 2) = "\\" THEN
    ' Yup. This filename is on a network. We'll need to remove
    ' the \\SERVER_NAME\VOLUME_NAME prefix, then stick a drive
    ' letter back on the front of the name.
    InSpec$ = MID$(InSpec$, INSTR(MID$(InSpec$, 3), "\") + 2)
    InSpec$ = MID$(InSpec$, INSTR(MID$(InSpec$, 2), "\") + 1)
    IF MID$(OldSpec$, 2, 1) = ":" THEN ' Did user specify a drive letter?
      OldDrive$ = LEFT$(OldSpec$, 2)   ' yes, use the drive they specified
    ELSE          ' nope, use current drive
      ' won't be right if file found in APPEND path
      OldDrive$ = LEFT$(CurDir$, 2)
    END IF
  END IF
  ' More initializations for the name parsing routine
  Entry$ = "": InLen% = LEN(InSpec$): ParseState% = 0: CHPos% = InLen%
  DO WHILE CHPos%
    SELECT CASE ParseState%
      CASE 0
	  ' Whatever was entered after the last "\" is an entry name
	  IF INSTR(":\", MID$(InSpec$, CHPos%, 1)) = 0 THEN
	    Entry$ = MID$(InSpec$, CHPos%, 1) + Entry$
	    CHPos% = CHPos% - 1
	  ELSE
	    ' We don't want to include the "\" in the next component
	    ' we're going to parse, UNLESS the next component is
	    ' going to be the root directory specification.
	    IF MID$(InSpec$, CHPos%, 1) = "\" THEN
	      IF CHPos% > 1 THEN
		IF MID$(InSpec$, CHPos% - 1, 1) <> ":" THEN
		  CHPos% = CHPos% - 1
		END IF
	      END IF
	    END IF
	    ParseState% = ParseState% + 1           ' next state
	  END IF
      CASE 1
	  ' Here, we build the path that leads the to entry name.
	  IF INSTR(":", MID$(InSpec$, CHPos%, 1)) = 0 THEN
	    Path$ = MID$(InSpec$, CHPos%, 1) + Path$
	    CHPos% = CHPos% - 1
	  ELSE
	    ParseState% = ParseState% + 1
	  END IF
      CASE 2
	  ' Here, we build the drive specfication also
	  ' (also, because the drive spec is part of the drive spec).
	  Drive$ = MID$(InSpec$, CHPos%, 1) + Drive$
	  Path$ = MID$(InSpec$, CHPos%, 1) + Path$
	  CHPos% = CHPos% - 1
    END SELECT
  LOOP
  IF LEN(Drive$) = 0 THEN Drive$ = OldDrive$
END IF
END SUB

SUB ProcessDirectoryEntry (PathSpec$, EntrySpec$, DirEnt AS DirectoryRecord, Level%)
' ProcessDirectoryEntry - Perform whatever action you want
'                         with the contents of "DirEnt".
' Convert ASCIIZ string to normal string
TrimmedEntry$ = MID$(DirEnt.FileName, 1, INSTR(DirEnt.FileName, CHR$(0)) - 1)
IF RIGHT$(TrimmedEntry$, 4) = RIGHT$(EntrySpec$, 4) THEN
  PRINT "Level "; Level%; " "; PathSpec$; TrimmedEntry$
END IF
END SUB

FUNCTION QualifyName$ (InSpec$)
' QualifyName$() - This function takes an incomplete file spec
'                  and returns a fully-qualified pathname.
'                  If the name cannot be qualified, the
'                  original input string is returned instead.
DIM Regs AS RegType
DIM InPath AS STRING * 128
DIM OutPath AS STRING * 128

LSET InPath = ""
LSET OutPath = ""
InPath = InSpec$ + CHR$(0)  ' make an ASCIIZ version of input spec
Regs.ax = &H6000            ' invoke the TRUENAME DOS function
Regs.si = VARPTR(InPath)
Regs.di = VARPTR(OutPath)
INTERRUPT &H21, Regs, Regs
' Check to see if the operation succeded.
IF Regs.flags AND 1 THEN
  ' Carry set... there was a problem with the name. Just
  ' return the original specification.
  QualifyName$ = InSpec$
ELSE
  QualifyName$ = MID$(OutPath, 1, INSTR(OutPath, CHR$(0)) - 1)
END IF
END FUNCTION

DEFINT A-Z
SUB SetDTA (theDTA AS DataTransferArea)
InRegsX.ax = &H1A00
InRegsX.ds = VARSEG(theDTA)
InRegsX.dx = VARPTR(theDTA)   'Use for records
INTERRUPTX &H21, InRegsX, OutRegsX
END SUB

SUB TransferDTA2DIR (DEntry AS DirectoryRecord, theDTA AS DataTransferArea)
DEntry.FileName = theDTA.FileName
DEntry.FileSize = theDTA.FileSize
DEntry.FileDate = theDTA.FileDate
DEntry.FileTime = theDTA.FileTime
DEntry.FileAttb = ASC(theDTA.Attribute)
END SUB

DEFSNG A-Z
SUB TreeWalk (Spec$, ActionKey%)
' TreeWalk - Iterate all the files in the tree
'            starting with the path Spec$

WhereIWasWhenIStarted$ = CurDir$    ' Save current directory

' Qualify and parse the user's input specification

ParsePathname Spec$, JustDrive$, JustPath$, JustSpec$  ' parse input spec
ChDrive JustDrive$                    ' Change to specified drive
WhereDriveWasWhenItStarted$ = CurDir$ ' save cwd on specified drive
CHDIR JustPath$                       ' enter the starting directory

' Since we pass the "\" separator into the real tree walking code,
' we need to make sure we're not starting with the root directory.
' If we are, the path spec already ends with a "\".
FirstSep$ = ""
IF RIGHT$(JustPath$, 1) <> "\" THEN FirstSep$ = "\"

' Begin the treewalk.
TreeWalkHelper JustPath$ + FirstSep$, JustSpec$, ActionKey%, 1

CHDIR WhereDriveWasWhenItStarted$     ' reset cwd on specified drive

' Parse the original working directory into drive and path,
' and return there.
ParsePathname WhereIWasWhenIStarted$, JustDrive$, JustPath$, JustSpec$
ChDrive JustDrive$: CHDIR WhereIWasWhenIStarted$
' End of TreeWalk
END SUB

SUB TreeWalkHelper (PathSpec$, EntrySpec$, ActionKey%, Level%)
' TreeWalkHelper - Subprogram to perform the essential details
'                  of a recursive directory treewalk.

DIM twDTA AS DataTransferArea
DIM DirEnt AS DirectoryRecord
DIM Stat AS INTEGER

' Set up the data transfer area for this level of TreeWalkHelper
SetDTA twDTA

' Find the first entry in the current directory that matches
' the input specification. You can modify fAttr% below to filter
' out entries you don't want to process, (such as hidden & system files),
' Attribute value     Meaning
'         &H00         Normal file
'         &H01         Read-only
'         &H02         Hidden
'         &H04         System
'         &H08         Volume label
'         &H10         Directory/subdirectory
'         &H20         Archived
fAttr% = 2 OR 4 OR &H10

Stat = FindFirst(fAttr%, "*.*", DirEnt, twDTA)
DO WHILE Stat = 0
  ' Extract the filename from the directory entry record.
  EntryName$ = MID$(DirEnt.FileName, 1, INSTR(DirEnt.FileName, CHR$(0)) - 1)
  ' If we're doing a top-down traversal, then we'll process the
  ' directory entry name here and now. Ideally, you'd use the
  ' top-down traversal to print all the names of files, count the
  ' number of files, accumulate a total size in bytes, etc.
  IF (ActionKey% AND TopDown) THEN
    ' However, if the directory entry is the one for either
    ' either the current or parent directories, ignore it. If
    ' you wre creating a TREE-oriented version of the DIR command,
    ' then you might NOT want to ignore these two special entries.
    IF EntryName$ <> "." AND EntryName$ <> ".." THEN
      ' Process a directory entry here. Or, rather, invoke
      ' the subprogram ProcessDirectoryEntry, which resides
      ' in your program's main source module.  
      ProcessDirectoryEntry PathSpec$, EntrySpec$, DirEnt, Level%
    END IF
  END IF
  ' If this directory entry is a subdirectory instead of a file,
  ' then it's time to recurse to the next level of the tree.
  IF DirEnt.FileAttb AND 16 THEN
    ' However, we'll get stuck in an infinite loop if we try
    ' to enter the current directory or the parent directory this way.
    IF EntryName$ <> "." AND EntryName$ <> ".." THEN
      CHDIR EntryName$    ' Enter the subdirectory
      TreeWalkHelper PathSpec$ + EntryName$ + "\", EntrySpec$, ActionKey%, Level% + 1
      CHDIR ".."          ' Exit from the subdirectory
    END IF
  END IF
  ' When we recursed to the next level, it's activation changed the
  ' data transfer area to a new one for it's level. Now we have to
  ' change the DTA back to our own.
  SetDTA twDTA
  ' If we're performing a bottoms-up traversal, then we process this
  ' entry after having "gone into it" (if it was a subdirectory).
  IF (ActionKey% AND BottomsUp) THEN
    IF EntryName$ <> "." AND EntryName$ <> ".." THEN
      ProcessDirectoryEntry PathSpec$, EntrySpec$, DirEnt, Level%
    END IF
  END IF
  ' Lastly, we need to see if there's another entry in this directory
  ' that requires processing.
  Stat = FindNext(DirEnt, twDTA)
LOOP
END SUB

