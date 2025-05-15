DECLARE SUB BlinkSwitch (Toggle%)
DECLARE SUB PokePrint (Row%, Col%, Text$, Fore%, Back%)
'Write to video memory/make intense BG
'   $DYNAMIC
'  $INCLUDE: 'QB.BI'
   
    DIM SHARED InRegs AS RegType, OutRegs AS RegType
    CLS
    PokePrint 10, 10, "This is NORMAL background", 1, 6
    BlinkSwitch 0
    PokePrint 15, 10, "This is INTENSE background ", 1, 14
    R$ = INPUT$(1)
    BlinkSwitch 1
    CLS
END

'   Toggle blinking or intense backgrounds.
'
SUB BlinkSwitch (Toggle%) STATIC
    Toggle% = Toggle% AND 1             ' Only 0 or 1 allowed
    InRegs.ax = &H1003                  ' Function 16/3
    InRegs.bx = Toggle%                 ' Toggle blink/intensity
    INTERRUPT &H10, InRegs, OutRegs     ' Call video BIOS
END SUB

'   Write a string of text directly to video memory.
'
SUB PokePrint (Row%, Col%, Text$, Fore%, Back%) STATIC
    DEF SEG = &H40
    IF PEEK(&H49) = 7 THEN
       VideoSegment& = &HB000
    ELSE
       VideoSegment& = &HB800
    END IF
    DEF SEG = VideoSegment&
    Offset% = (((Row% - 1) * 80) + (Col% - 1)) * 2
    Colour% = (Back% * 16) + Fore%
    FOR I% = 1 TO LEN(Text$)
	Char% = ASC(MID$(Text$, I%, 1))
	POKE Offset% + ((I% - 1) * 2), Char%
	POKE Offset% + ((I% - 1) * 2) + 1, Colour%
    NEXT I%
    DEF SEG
END SUB

