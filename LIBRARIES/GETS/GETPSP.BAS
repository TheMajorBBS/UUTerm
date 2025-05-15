'displays Program Segment Prefix info
' PSP.BAS by Brent Ashley
'
DECLARE FUNCTION C$ (Fore%, Back%)
DECLARE FUNCTION CurPspSegment% ()
DECLARE FUNCTION Hex2$ (Num%)
DECLARE FUNCTION Hex4$ (Num%)
DECLARE FUNCTION ProgramSpec$ (PSP AS ANY)
DECLARE SUB LoadPSPVar (PSPSeg%, PSPVar AS ANY)
DECLARE SUB MemCopy (FSeg%, FOfs%, FCnt%, TSeg%, TOfs%, TCnt%)
DECLARE SUB ShowFCB (FCB AS ANY)
DECLARE SUB ShowPSP (PSP AS ANY)

'Uncomment for compiled version and delete MemCopy SUB:
'DECLARE SUB MemCopy ALIAS "B$ASSN" (BYVAL FSeg%, BYVAL FOfs%, BYVAL FCnt%,_
'                                    BYVAL TSeg%, BYVAL TOfs%, BYVAL TCnt%)
'this is a routine internal to BCOM45.LIB - using it will
'result in a smaller program and speed up the memory copies

DEFINT A-Z
'$INCLUDE: 'qb.bi'

' user-defined types

TYPE UnopenedFCBType
	DriveNum AS STRING * 1
	FileName AS STRING * 8
	Ext AS STRING * 3
	CurBlk AS INTEGER
	RecSize AS INTEGER
END TYPE

TYPE PSPType
	Int20 AS STRING * 2
	TopOfMemory AS INTEGER
	Junk1 AS STRING * 6
	TermIP AS INTEGER
	TermCS AS INTEGER
	BreakIP AS INTEGER
	BreakCS AS INTEGER
	CritErrIP AS INTEGER
	CritErrCS AS INTEGER
	ParentPSPSeg AS INTEGER
	HandleTable AS STRING * 20
	EnvSeg AS INTEGER
	Junk3 AS STRING * 4
	HandleCnt AS INTEGER
	HdlTblOfs AS INTEGER
	HdlTblSeg AS INTEGER
	Junk4 AS STRING * 36
	FCB1 AS UnopenedFCBType
	FCB2 AS UnopenedFCBType
	Junk5 AS STRING * 4
	CmdLen AS STRING * 1
	CmdLine AS STRING * 127
END TYPE

' declare variables:

DIM SHARED Regs AS RegType, Fg, Bg, Hi
DIM PSP AS PSPType, ParentPSP AS PSPType

' set up colors
DEF SEG = 0
IF PEEK(&H449) = 7 THEN
	' monochrome
	Fg = 7: Bg = 0: Hi = 15
ELSE
	' colour
	Fg = 11: Bg = 1: Hi = 14
END IF


' fill PSP variable with current PSP data
LoadPSPVar CurPspSegment, PSP

COLOR Fg, Bg: CLS
PRINT C(Hi, Bg); "----------- Program Segment Prefix Breakdown -----------"
PRINT C(Hi, Bg); "This Program: "; C(Fg, Bg); ProgramSpec(PSP); "  ";
PRINT C(Hi, Bg); "Current PSP at: "; C(Fg, Bg); Hex4$(CurPspSegment)
ShowPSP PSP

' fill ParentPSP variable with data
LoadPSPVar PSP.ParentPSPSeg, ParentPSP
PRINT C(Hi, Bg); "Parent Program: "; C(Fg, Bg); ProgramSpec(ParentPSP)

PRINT C(Hi, Bg); "Parent Command Line: "; C(Fg, Bg); CHR$(16);
PRINT LEFT$(ParentPSP.CmdLine, ASC(ParentPSP.CmdLen)); CHR$(17)

FUNCTION C$ (Fore, Back)
	'You can change colors in the middle of a print
	'statement with this little gem! (only if you
	'use ; or , to separate the printed elements -
	'don't concatenate strings with + in a print statement
	COLOR Fore, Back
	C$ = ""
END FUNCTION

FUNCTION CurPspSegment
	' return current PSP segment address
	Regs.AX = &H6200
	Interrupt &H21, Regs, Regs
	CurPspSegment = Regs.BX
END FUNCTION

FUNCTION Hex2$ (Num)
	Hex2$ = RIGHT$("0" + HEX$(Num), 2)
END FUNCTION

FUNCTION Hex4$ (Num)
	Hex4$ = RIGHT$("000" + HEX$(Num), 4)
END FUNCTION

SUB LoadPSPVar (PSPSeg, PSPVar AS PSPType)
	' use memory block ciopy to fill PSP variable with data
	MemCopy PSPSeg, 0, 256, VARSEG(PSPVar), VARPTR(PSPVar), 256
END SUB

SUB MemCopy (FSeg, FOfs, FCnt, TSeg, TOfs, TCnt)
	STATIC i, Temp$
	' copy a block of memory
	' TCnt should be same as FCnt (it's there for B$ASSN compatibility)
	' * use B$ASSN alias instead for compiled programs *
 
	' go to source segment
	DEF SEG = FSeg
	' peek temporary string
	Temp$ = SPACE$(FCnt)
	FOR i = 0 TO FCnt - 1
		MID$(Temp$, i + 1, 1) = CHR$(PEEK(FOfs + i))
	NEXT
 
	' go to destination segment
	DEF SEG = TSeg
	' poke temp string
	FOR i = 0 TO TCnt - 1
		POKE TOfs + i, ASC(MID$(Temp$, i + 1, 1))
	NEXT
	' restore BASIC seg
	DEF SEG
END SUB

FUNCTION ProgramSpec$ (PSP AS PSPType)
	STATIC i, Temp$
	' Returns full pathspec for program whose PSP is passed
 
	' look at environment block
	DEF SEG = PSP.EnvSeg
	i = 0
	' find first occurrence of 00 00
	DO WHILE PEEK(i) OR PEEK(i + 1)
		i = i + 1
	LOOP
 
	' if user program, then 01 00 follows
	IF (PEEK(i + 2) = 1) AND (PEEK(i + 3) = 0) THEN
		' jump past user program signature
		i = i + 4
		Temp$ = ""
		' build string until 00 byte
		DO WHILE PEEK(i)
			Temp$ = Temp$ + CHR$(PEEK(i))
			i = i + 1
		LOOP
		ProgramSpec$ = Temp$
	ELSE
		ProgramSpec$ = "<Command Shell>"
	END IF
END FUNCTION

SUB ShowFCB (FCB AS UnopenedFCBType)
	PRINT C(Hi, Bg); "  Drive  :"; C(Fg, Bg); ASC(FCB.DriveNum)
	PRINT C(Hi, Bg); "  Name   : "; C(Fg, Bg); FCB.FileName
	PRINT C(Hi, Bg); "  Ext    : "; C(Fg, Bg); FCB.Ext
	PRINT C(Hi, Bg); "  CurBlk :"; C(Fg, Bg); FCB.CurBlk
	PRINT C(Hi, Bg); "  RecSize:"; C(Fg, Bg); FCB.RecSize
END SUB

SUB ShowPSP (PSP AS PSPType)
	PRINT C(Hi, Bg); "Top of memory: ";
	PRINT C(Fg, Bg); Hex4$(PSP.TopOfMemory); "  "
 
	PRINT C(Hi, Bg); "Term: ";
	PRINT C(Fg, Bg); Hex4$(PSP.TermCS); ":"; Hex4$(PSP.TermIP); "  ";
	PRINT C(Hi, Bg); "Break: ";
	PRINT C(Fg, Bg); Hex4$(PSP.BreakCS); ":"; Hex4$(PSP.BreakIP); "  ";
	PRINT C(Hi, Bg); "CritErr: ";
	PRINT C(Fg, Bg); Hex4$(PSP.CritErrCS); ":"; Hex4$(PSP.CritErrIP)
 
	PRINT C(Hi, Bg); "Parent PSP Seg: "; C(Fg, Bg); Hex4$(PSP.ParentPSPSeg); "  ";
	PRINT C(Hi, Bg); "Environment Seg: "; C(Fg, Bg); Hex4$(PSP.EnvSeg)
 
	PRINT C(Hi, Bg); "Handle Table: "
		PRINT C(Fg, Bg); "  ";
	FOR i = 1 TO 20
		PRINT Hex2$(ASC(MID$(PSP.HandleTable, i, 1))); " ";
	NEXT
	PRINT
 
	PRINT C(Hi, Bg); "Handle Count:"; C(Fg, Bg); HandleCnt; "  ";
	PRINT C(Hi, Bg); "Handle Table Address: "; C(Fg, Bg);
	PRINT Hex4$(PSP.HdlTblSeg); ":"; C(Fg, Bg); Hex4$(PSP.HdlTblOfs)
 
	PRINT C(Hi, Bg); "FCB #1"
	ShowFCB PSP.FCB1
 
	PRINT C(Hi, Bg); "FCB #2"
	ShowFCB PSP.FCB2
 
	PRINT C(Hi, Bg); "Cmd Line Length:";
	PRINT C(Fg, Bg); ASC(PSP.CmdLen); "  ";
 
	PRINT C(Hi, Bg); "Command Line: "; C(Fg, Bg);
	PRINT CHR$(16); LEFT$(PSP.CmdLine, ASC(PSP.CmdLen));
	PRINT CHR$(17)
END SUB

