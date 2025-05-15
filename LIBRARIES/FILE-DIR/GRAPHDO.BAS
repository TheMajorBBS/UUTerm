'display percentage done and graph of a file read/wrtitten/processed
 SCREEN 12
 Filename$ = "d:\uuterm\uuterm.doc"
 GraphCol = 500  '*** 100-600 in increments of 100
                 'smaller number is needed for small files.
 Screencol = 640
 Spos = ((Screencol - GraphCol) \ 2) - 1
 LINE (Spos, 9)-(GraphCol + Spos, 41), 7, B
 LINE (Spos + 1, 10)-(GraphCol + Spos - 1, 40), 1, BF
 LOCATE 5, 34: PRINT "Percent Done"
 OPEN Filename$ FOR INPUT AS 1
 Tot = LOF(1)
 B = Tot \ (GraphCol - 2)
 WHILE NOT EOF(1)
  LINE INPUT #1, a$'*** can be INPUT# or LINE INPUT#
'call A Routine Here, to Do What Ever You Want To Do With The Data.
   B$ = B$ + a$
   c = LEN(B$) - B
   IF c > 0 THEN
     D = D + 1
     GOSUB PERCENT
     LINE (Spos + D, 20)-(Spos + D, 30), 12
     B$ = MID$(B$, LEN(B$) - c, LEN(B$))
   END IF
 WEND
 IF LEN(B$) > 0 THEN
   FOR X = 1 TO GraphCol - D
     LINE (Spos + D, 20)-(Spos + D, 30), 12
     D = D + 1
     GOSUB PERCENT
   NEXT
 END IF
 LOCATE 6, 38: PRINT Pd
 CLOSE
 LOCATE 25, 32: PRINT "Press any key...";
 X$ = INPUT$(1)
 SCREEN 0
 CLOSE
 END
PERCENT:
 Done = GraphCol \ 100
 P = P + 1
 IF P = Done THEN
   LOCATE 6, 39: PRINT Pd
   Pd = Pd + 1
   P = 0
 END IF
 RETURN

