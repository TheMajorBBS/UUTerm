
'Get the colour attributes of a character
'            Note : only works in SCREEN 0
'Input   : Row% = row where character is at
'          Col% = column where the character is at
'Return  : Fore% = the foreground colour
'          Back% = the background colour
  

SUB GetCharColor (Row%, Col%, Fore%, Back%)
   A = SCREEN(Row%, Col%, 1)
   Back% = A \ 16
   Fore% = A - Back% * 16
END SUB

