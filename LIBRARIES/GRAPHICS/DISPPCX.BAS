DEFINT A-Z
DECLARE SUB PCXLOAD (File$)
'display a .PCX

SCREEN 11
CLS
PCXLOAD "fish.PCX"
WHILE INKEY$ = "": WEND

SUB PCXLOAD (File$) STATIC
  OPEN File$ FOR INPUT AS #1 LEN = 16384
  SEEK #1, 129
  DEF SEG = &HA000
  FOR ScrLin = 0 TO 479
    Addr& = 80& * ScrLin
    LinStrt& = Addr&: LinEnd& = Addr& + 80
    Plane = 1
    OUT &H3C4, 2: OUT &H3C5, Plane
    DO WHILE Plane <= 8
      Byte = ASC(INPUT$(1, 1))
      IF EOF(1) THEN EXIT FOR
      IF (Byte AND 192) <> 192 THEN
        POKE Addr&, Byte
        Addr& = Addr& + 1
        IF Addr& >= LinEnd& THEN
          Addr& = LinStrt&
          Plane = Plane * 2
          OUT &H3C4, 2: OUT &H3C5, Plane
        END IF
      ELSE
        Byte = Byte AND 63
        Byte2 = ASC(INPUT$(1, 1))
        IF EOF(1) THEN EXIT FOR
        FOR Expand = 1 TO Byte
          POKE Addr&, Byte2
          Addr& = Addr& + 1
          IF Addr& >= LinEnd& THEN
            Addr& = LinStrt&
            Plane = Plane * 2
            OUT &H3C4, 2: OUT &H3C5, Plane
          END IF
        NEXT
      END IF
    LOOP
  NEXT
  OUT &H3C4, 2: OUT &H3C5, &HF
  DEF SEG
  CLOSE #1
END SUB

