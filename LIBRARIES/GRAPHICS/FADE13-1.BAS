'fade screen in VGA mode 13
'The following program makes the fade.obj file. To make a .QLB use:
'link /q fade,fade,,bqlb45.lib
'(assuming bqlb45.lib is in the current directory)
'To make a .LIB so you can compile it, enter LIB at the DOS prompt and
'type:
'fade.lib  at the library prompt
'Y         at the "Make new library?" prompt
'+fade.obj at the operations prompt
'<Enter>   at the listing prompt

DEFINT A-Z
RESTORE
OPEN "fade.obj" FOR BINARY AS #1
S$ = "": Check = &HFFFF: CheckSum = 0
FOR A = 1 TO 345
    READ A$
    A$ = "&H" + A$: V = VAL(A$): S$ = S$ + CHR$(V)
    Check = Check XOR V: CheckSum = (CheckSum + V) AND &HFF
NEXT

IF Check <> &HFF3F OR CheckSum <> 0 THEN
    PRINT "UNcool! This copy has been trashed!"
    END
ELSE
    PRINT "Success!"
    PRINT "R.G."
    PUT #1, , S$
END IF
CLOSE


DATA 80,A,0,8,66,61,64,65,2E,41,53,4D,CF,88,1F,0,0,0,54,75,72,62,6F,20
DATA 41,73,73,65,6D,62,6C,65,72,20,20,56,65,72,73,69,6F,6E,20,32,2E,30
DATA B9,88,10,0,40,E9,E0,4E,B2,18,8,66,61,64,65,2E,41,53,4D,A0,88,3,0,40
DATA E9,4C,96,2,0,0,68,88,3,0,40,A1,94,96,C,0,5,5F,54,45,58,54,4,43,4F
DATA 44,45,96,98,7,0,48,89,0,2,3,1,8A,96,C,0,5,5F,44,41,54,41,4,44,41,54
DATA 41,C2,98,7,0,48,0,3,4,5,1,C,96,8,0,6,44,47,52,4F,55,50,8B,9A,4,0,6
DATA FF,2,5B,90,11,0,0,1,A,46,41,44,45,53,43,52,45,45,4E,0,0,0,84,88,4
DATA 0,40,A2,1,91,A0,8D,0,1,0,0,55,8B,EC,1E,6,B8,0,0,8E,D8,8E,C0,8B,76
DATA A,8B,4E,8,2B,CE,41,BA,C7,3,BF,0,0,90,8B,C6,EE,42,EE,42,EC,AA,EC,AA
DATA EC,AA,4A,4A,46,E2,EF,BB,40,0,8B,7E,A,BE,0,0,8B,4E,6,90,B2,DA,B4,8
DATA EC,22,C4,74,FB,90,EC,22,C4,75,FB,E2,EF,B2,C7,8B,4E,8,2B,CF,41,90,8B
DATA C7,EE,42,EE,42,AC,F6,E3,D1,E0,D1,E0,8A,C4,EE,AC,F6,E3,D1,E0,D1,E0
DATA 8A,C4,EE,AC,F6,E3,D1,E0,D1,E0,8A,C4,EE,4A,4A,47,E2,D7,4B,83,FB,FF
DATA 75,AD,7,1F,5D,CA,6,0,E7,9C,F,0,C8,6,55,1,C4,19,14,1,2,C4,34,14,1,2
DATA 2E,8A,2,0,0,74

'That's all! Run this program first: it will make a small .obj file in
'the current directory. Then follow the directions above to make a .QLB
'file.

'After you make the .QLB file, load QB like this:

'QB /lfade.qlb

'Then load in the first program(usefade.bas) and see if it works
'correctly(I'll kill myself if it doesn't :-)

