'unlimited string space in QB.45
'Supertxt 1 QuickBASIC 4.5 String Utility
'by Tim Gerchmez /12648 S.E. 81st Pl./Renton, WA 98056
'Released to the Public Domain 10/2/93.

'Treats a double-precision array as a random file, allowing
'up to 524,272 bytes of string data to be kept in memory at
'once on the far heap.  A substitute for lack of far strings
'in the QB4.5 environment.

DECLARE SUB storestring (strng$, recnum%, reclen%)
DECLARE SUB recallstring (strng$, recnum%, reclen%)
DECLARE FUNCTION maxrecs% (reclen%)

COMMON SHARED buffer1#(), buffer2#()

'$DYNAMIC : 'This line is ESSENTIAL!!
DIM SHARED buffer1#(1 TO 32767)  'Buffers for text data
DIM SHARED buffer2#(1 TO 32767)  'Will be stored in far memory
                                 'if /AH and $DYNAMIC are used.

FUNCTION maxrecs% (reclen%)
maxrecs = ((32767& * 8&) / reclen%) * 2
END FUNCTION

SUB recallstring (strng$, recnum%, reclen%)
'Use in conjunction with storestring to store string
'data on the far heap.  See storestring for further
'information.
maximumrecords% = maxrecs(reclen%)
recshalf% = INT(maximumrecords% / 2)
IF recnum% > maximumrecords% THEN recnum% = 0: EXIT SUB
IF recnum% > recshalf% THEN
  biu% = 2: number% = recnum% - recshalf%
ELSE
  biu% = 1: number% = recnum%
END IF
x& = INT(reclen% / 8)
count& = (x& * (number% - 1&)) + 1&
IF biu% = 1 THEN
  segment& = VARSEG(buffer1#(count&))
  pointer& = VARPTR(buffer1#(count&))
ELSE
  segment& = VARSEG(buffer2#(count&))
  pointer& = VARPTR(buffer2#(count&))
END IF
IF pointer& <> ABS(pointer&) THEN pointer& = 65536 + pointer&
' Normalize
WHILE pointer& + reclen% > 65535
  pointer& = pointer& - 16&: segment& = segment& + 1&
WEND
strng$ = ""
DEF SEG = segment&
FOR t% = 1 TO reclen%
  q$ = CHR$(PEEK(pointer& + (t% - 1)))
  IF q$ = CHR$(0) THEN EXIT SUB
  strng$ = strng$ + q$
NEXT t%
END SUB

SUB storestring (strng$, recnum%, reclen%)
'Stores a reclen%-character string in buffer1#() and buffer2#().
'Use /AH when loading QB and $DYNAMIC... DIM SHARED buffer1#(1 TO 32767)
'and buffer2#(1 to 32767) ... will not run in QB4.5 environment, must be
'compiled (uses too much memory).
'Total Max Bytes Available = 524,272 (262,136 * 2)
'Note: reclen% should be the same for each record and should be
'divisible by 8.

maximumrecords% = maxrecs(reclen%)
recshalf% = INT(maximumrecords% / 2)

        IF recnum% > recshalf% THEN
                biu% = 2: number% = recnum% - recshalf%
        ELSE
                biu% = 1: number% = recnum%
        END IF

        x& = INT(reclen% / 8)
        count& = (x& * (number% - 1&)) + 1&

        IF biu% = 1 THEN
                segment& = VARSEG(buffer1#(count&))
                pointer& = VARPTR(buffer1#(count&))
        ELSE
                segment& = VARSEG(buffer2#(count&))
                pointer& = VARPTR(buffer2#(count&))
        END IF

        IF pointer& <> ABS(pointer&) THEN pointer& = 65536 + pointer&

        ' Normalize
        WHILE pointer& + reclen% > 65535
                pointer& = pointer& - 16&: segment& = segment& + 1&
        WEND

        IF LEN(strng$) > reclen% THEN strng$ = LEFT$(strng$, reclen%)
        IF LEN(strng$) < reclen% THEN strng$ = strng$ + CHR$(0)
        ln% = LEN(strng$)
        DEF SEG = segment&

        FOR t% = 1 TO ln%
                POKE pointer& + (t% - 1&), ASC(MID$(strng$, t%, 1&))
        NEXT t%

END SUB
        IF recnum% > maximumrecords% THEN recnum% = 0: EXIT SUB

