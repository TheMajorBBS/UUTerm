'Animation routine for movement
INPUT "Do you want sound"; a$: a$ = UCASE$(a$): IF a$ = "Y" THEN yes = 1
SCREEN 9, 0: CLS : KEY OFF
DIM C(32, 2), H(7, 2)
P = 0: Q = 0: F = 0
FOR I = 0 TO 32: C(I, 0) = SIN(I * .195) * 20
C(I, 1) = COS(I * .195) * 20: NEXT I
H(0, 0) = 140: H(0, 1) = 90
CX = INT(RND * 7) + 4: CY = INT(RND * 7) + 4

WHILE INKEY$ = ""

Draw1:
    LINE (H(P, 0) + C(Q, 0), H(P, 1) + C(Q, 1))-(H(P, 0) - C(Q, 0), H(P, 1) - C(Q, 1)), INT(RND * 6) + 9
    H(P, 2) = Q: Q = (Q + 1) MOD 33
    Z = P: P = (P + 1) MOD 8: IF P = 0 THEN F = -1
    IF NOT F THEN GOTO Draw2:
    LINE (H(P, 0) + C(H(P, 2), 0), H(P, 1) + C(H(P, 2), 1))-(H(P, 0) - C(H(P, 2), 0), H(P, 1) - C(H(P, 2), 1)), 0
    FOR lp = 1 TO 150: NEXT
Draw2:
    H(P, 0) = H(Z, 0) + CX: H(P, 1) = H(Z, 1) + CY
    IF H(P, 0) > 20 AND H(P, 0) < 650 THEN GOTO Draw3
    IF yes = 1 THEN SOUND 1000, .1
    H(P, 0) = H(Z, 0) - CX: CX = -SGN(CX) * (INT(RND * 6) + 9)
    FOR lp = 1 TO 150: NEXT
Draw3:
    IF H(P, 1) > 20 AND H(P, 1) < 325 THEN GOTO Draw1
    H(P, 1) = H(Z, 1) - CY: CY = -SGN(CY) * (INT(RND * 6) + 9)
    IF yes = 1 THEN SOUND 1000, .1
    FOR lp = 1 TO 150: NEXT
WEND

