  DECLARE SUB Check (Tmp$, Baud%)
  DEFINT A-Z

  'checks for baud rate
  'returns baud rate in baud%

  CLS
  LOCATE 1, 1, 1, 1, 9
  OPEN "COM2:2400,N,8,1,rb32000" FOR RANDOM AS #1 LEN = 256
  PRINT #1, "AT E1 L3 S11=50 &D2 &C1 X3"

   DO
       Keyinput$ = INKEY$
       IF Keyinput$ = CHR$(27) THEN EXIT DO
    IF Keyinput$ <> "" THEN
       PRINT #1, Keyinput$;
    END IF
    IF NOT EOF(1) THEN
       modeminput$ = INPUT$(LOC(1), #1)
       Tmp$ = Tmp$ + modeminput$
       Check Tmp$, Baud
       IF Baud THEN EXIT DO
       PRINT modeminput$;
    END IF
   LOOP

   PRINT : PRINT "Connect Made At"; Baud; "baud."

   CLOSE 1
   END

   SUB Check (Tmp$, Baud)

    IF INSTR(Tmp$, "CONNECT 300") > 0 THEN
       Baud = 300: EXIT SUB
    ELSEIF INSTR(Tmp$, "CONNECT 1200") > 0 THEN
       Baud = 1200: EXIT SUB
    ELSEIF INSTR(Tmp$, "CONNECT 2400") > 0 THEN
       Baud = 2400: EXIT SUB
    ELSEIF INSTR(Tmp$, "CONNECT 9600") > 0 THEN
       Baud = 9600: EXIT SUB
    END IF

   END SUB

