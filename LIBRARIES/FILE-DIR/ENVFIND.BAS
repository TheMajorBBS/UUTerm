'Find the master DOS environment strings

'Assumptions: 1) you know what an environment variable is.
'             2) you know what CALL INTERRUPT does.
'             3) you have some idea about how programs are loaded
'                into memory (from MAPMEM or QMAP or PCTOOLS, etc)
'
'DOS gives a copy of the parent environment to any program you run.
'If any changes are made to this environment, they are discarded
'upon exit from your program.  The only way to ensure permanent
'change to the environment strings is to find the parent DOS
'environment block and to make your changes there.  In order to do
'this, you will need to know EXACTLY how and where the parent
'environment is stored.  This procedure is not for the weak of
'heart, as mistakes can send your system reeling; however - it can
'be of great use to those who are comfortable with mucking about at
'system level.  It is highly recommended that you refer to your DOS
'programmer's reference (QUE's and the Waite Group's cover this
'stuff) and do plenty of snooping with utilities like PC Mag's
'RAMVIEW or DEBUG before attempting anything you're not sure of.
'
'The DOS environment consists of a series of null-terminated
'strings, all terminated by a further null.  The length of the
'parent environment space defaults to 160 bytes, but is
'configurable via the SHELL=COMMAND.COM /P /E:nnnn statement in
'your CONFIG.SYS file to any size from 16 bytes to 32k bytes.  DOS
'will round your chosen number to the next highest multiple of 16.
'
'When DOS passes a copy of the environment to a program, it only
'passes the active portion.  You may have found it sometimes
'necessary to define a "place-holder" variable to ensure you won't
'run out of space.
'
'For your program to find its copy of the environment, it needs to
'look at offset 2Ch of its Program Segment Prefix, where it will
'find the environment copy's segment address (2 bytes in lo-hi fmt).
'
'If you look at the environment block in memory, you will see a
'series of null-terminated strings, ending in a further null.  The
'block is paragraph-aligned (starts at offset 0 of the segment) and
'its length can be determined by its Memory Control Block, a
'16-byte structure immediately preceding it.  The memory control
'block's structure is as follows:
'
'offset  type  function
'
' 0      char  end of chain flag ("Z"=end;"M"=no)
' 1-2    word  seg of owner's PSP (lo-hi)
' 3-4    word  block size in paragraphs (lo-hi)
' 5-15   ----  unused until DOS 4.0 (name of owner)
'
'You can deduce that if you follow the pointer from an environment
'block to it's owner's PSP, and offset 2C of that PSP points back
'to you, you have verified that this is indeed an environment
'block.
'
'Now, the hard part comes when trying to find the parent DOS
'environment block.  That's the one owned by Command.COM, and will
'be the first environment block loaded in memory.  The method for
'this relies on an undocumented (well, by Microsoft, anyway) DOS
'interrupt - "INT 21h function 52h - get the DOS list of lists".
'When this interrupt returns, a pointer to the first DOS Memory
'Control Block can be found at the address specified by ES:BX-2.
'This interrupt is good for other things, but they are beyond the
'scope of this tutorial.
'
'If you take the following steps, you can find the first DOS
'environment block:
'
'find first MCB
'do
'  find next MCB
'loop until my owner's PSP env ptr points back to me
'print found!
'end
'
'Now that you're there, you can find the maximum length of the
'block from its MCB.  Any changes to the environment must not
'exceed this limit, or you're asking for lockups or worse.
'Furthermore, there are some caveats when editing the master:
'
'1) make sure you keep to the proper format, uppercase the
'   variable's name and terminate with nulls.  Be careful not to
'   extend into the next variable when adding to a variable.
'
'2) if you have multiple copies of COMMAND.COM running, this is
'   only the grandaddy parent of them all, not necessarily the
'   parent of the moment.  Changes here won't affect resident
'   programs that are still referring to their personal copies.
'====================================================================
'
'
' EnvFind.BAS - a QB program to find the master DOS environment strings
'
' (C) 1990 by Brent Ashley - (416)846-0541 evgs
'
' no restrictions on use, just gimme credit.
'
DEFINT A-Z
' $INCLUDE: 'QB.BI'
DECLARE FUNCTION Hex4$ (Number&)
DECLARE FUNCTION StringPeek$ (Offset&, Length&)
DECLARE FUNCTION WordPeek& (Offset&)
DIM InRegs AS RegTypeX, OutRegs AS RegTypeX

' Find First Memory Control Block
InRegs.ax = &H5200
CALL INTERRUPTX(&H21, InRegs, OutRegs)
DEF SEG = OutRegs.es
MCBSeg& = WordPeek(OutRegs.bx - 2)

' Check MCB chain for first Env block
Found = 0
DO
	DEF SEG = MCBSeg&
	BlkLen& = WordPeek(3)
	Owner& = WordPeek(1)
	' Check owner's PSP to see if Env pointer points here.
	DEF SEG = Owner&
	EnvPtr& = WordPeek(&H2C)
	IF MCBSeg& = EnvPtr& - 1 THEN
	 Found = 1
	ELSE
	 MCBSeg& = MCBSeg& + BlkLen& + 1
	END IF
LOOP WHILE Found = 0
DEF SEG = MCBSeg& + 1

' spit out some specs
Environment$ = StringPeek(0, BlkLen& * 16)
EnvUsed& = INSTR(Environment$, CHR$(0) + CHR$(0))
PRINT
PRINT "Master Environment found at address :  "; Hex4(MCBSeg& + 1);
":0000"
PRINT "Maximum Environment space allocated : "; BlkLen& * 16; "bytes"
PRINT "Environment space currently in use  : "; EnvUsed&; "bytes"
PRINT
PRINT "Master Environment block (unformatted):"
PRINT LEFT$(Environment$, EnvUsed&)
END

DEFSNG A-Z
FUNCTION Hex4$ (Number&)
	Hex4$ = RIGHT$("000" + HEX$(Number&), 4)
END FUNCTION

FUNCTION StringPeek$ (Offset&, Length&)
	STATIC Posn&, Temp$
	Temp$ = ""
	FOR Posn& = Offset& TO Offset& + Length& - 1
	 Temp$ = Temp$ + CHR$(PEEK(Posn&))
	NEXT Posn&
	StringPeek$ = Temp$
END FUNCTION

FUNCTION WordPeek& (Offset&)
	WordPeek& = 256& * PEEK(Offset& + 1) + PEEK(Offset&)
END FUNCTION

