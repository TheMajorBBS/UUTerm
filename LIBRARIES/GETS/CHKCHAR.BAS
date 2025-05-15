'find contents of screen at given location
'MaxCol% is the number of columns (usually 80)
'Row% is the row (usually 1-25)
'and Column% is the column (usually 1-80).

   maxcol% = 80
   row% = 1
   column% = 1
   CLS
   PRINT "*"
   DEF SEG = &HB800
   char = PEEK(((row% - 1) * maxcol% + column% - 1) * 2)
   attr = PEEK(((row% - 1) * maxcol% + column% - 1) * 2 + 1)
   DEF SEG

PRINT char, attr

