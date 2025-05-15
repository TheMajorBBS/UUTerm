DECLARE SUB GetCursorPos (row%, col%)
   'Get the real cursor position from BIOS
   'Input   : none
   'Return  : Column number in Col%, Row number in Row%

GetCursorPos row%, col%

SUB GetCursorPos (row%, col%)
   DEF SEG = 0
   col% = PEEK(&H450) + 1
   row% = PEEK(&H451) + 1
   DEF SEG
END SUB

