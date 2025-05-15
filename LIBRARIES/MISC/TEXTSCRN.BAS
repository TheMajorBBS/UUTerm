DEFINT A-Z
'How to save and restore a text screen
DECLARE SUB GetScrn (TR%, BR%, LC%, RC%, scrn%())
DECLARE SUB PokePrint (Row%, Col%, Attr%, Text$)
DECLARE SUB PutScrn (TR%, BR%, LC%, RC%, scrn%())
DECLARE FUNCTION IsClrMon% ()
DIM scrn%(4000)

SCREEN 0

  FOR x = 1 TO 23
    PokePrint x, 5, -1, "Will boyettfgkjhtyuigjhkfjlhgsjfkdhg8trurgjlkjgfdgsf"
  NEXT
  GetScrn 1, 23, 1, 80, scrn%()
CLS
PutScrn 1, 23, 1, 80, scrn%()
SLEEP

'***********************************************************************
'* SUB GetScrn
'*
'* PURPOSE
'*    Saves a specified portion of the screen into an array from which
'*    it can later be restored with SUB PutScrn.
'***********************************************************************
SUB GetScrn (TR%, BR%, LC%, RC%, scrn%()) STATIC
   DEF SEG = &HB000 - IsClrMon * &H800

   Element% = LBOUND(scrn%)
   UL% = (TR% - 1) * 160 + LC% * 2 - 2
   LL% = (BR% - 1) * 160 + LC% * 2 - 2

   FOR x% = UL% TO LL% STEP 160
      FOR Y% = x% TO x% + (BR% - 1) * 160 + RC% * 2 - 2 - LL% + 1 STEP 2
         scrn%(Element%) = PEEK(Y%)
         scrn%(Element% + 1) = PEEK(Y% + 1)
         Element% = Element% + 2
      NEXT Y%
   NEXT x%

   DEF SEG
END SUB

'***********************************************************************
'* FUNCTION IsClrMon%
'*
'* PURPOSE
'*    Returns TRUE if there is a color monitor active.
'***********************************************************************
FUNCTION IsClrMon% STATIC
   'If 0000:0463 = B4, monitor is monochrome
   DEF SEG = 0
   IsClrMon% = PEEK(&H463) <> &HB4
   DEF SEG
END FUNCTION

'***********************************************************************
'* SUB PokePrint
'*
'* PURPOSE
'*    Prints Text$ by writing directly to video memory.  Set Attr% < 0
'*    if you wish to print with the existing color, else set Attr% to
'*    the corresponding color value.
'***********************************************************************
SUB PokePrint (Row%, Col%, Attr%, Text$) STATIC
   DEF SEG = &HB000 - IsClrMon * &H800
   J% = 0

   FOR I% = Col% TO Col% + LEN(Text$) - 1
      J% = J% + 1
      POKE (((Row% - 1) * 160) + (I% * 2) - 2), ASC(MID$(Text$, J%, 1))
      IF Attr% > -1 THEN
         POKE (((Row% - 1) * 160) + (I% * 2) - 1), Attr%
      END IF
   NEXT I%

   DEF SEG
END SUB

'***********************************************************************
'* SUB PutScrn
'*
'* PURPOSE
'*    Restores a screen area previously saved with SUB GetScrn.
'***********************************************************************
SUB PutScrn (TR%, BR%, LC%, RC%, scrn%()) STATIC
   DEF SEG = &HB000 - IsClrMon * &H800

   Element% = LBOUND(scrn%)
   UL% = (TR% - 1) * 160 + LC% * 2 - 2
   LL% = (BR% - 1) * 160 + LC% * 2 - 2

   FOR x% = UL% TO LL% STEP 160
      FOR Y% = x% TO x% + (BR% - 1) * 160 + RC% * 2 - 2 - LL% + 1 STEP 2
         POKE Y%, scrn%(Element%)
         POKE Y% + 1, scrn%(Element% + 1)
         Element% = Element% + 2
      NEXT Y%
   NEXT x%

   DEF SEG
END SUB

