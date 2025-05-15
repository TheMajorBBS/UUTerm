'converts Binary to Decimal and vice versa
DECLARE FUNCTION BinDec& (Binary$)
DECLARE FUNCTION DecBin$ (Decimal&)

' Converts a string of binary digits to their decimal equivalent.
'
FUNCTION BinDec& (Binary$)
    Decimal& = 0: Power% = 0
    FOR I% = LEN(Binary$) TO 1 STEP -1
        Digit% = ASC(MID$(Binary$, I%, 1)) - 48
        IF Digit% < 0 OR Digit% > 1 THEN Decimal& = 0: EXIT FOR
        Decimal& = Decimal& + Digit% * 2 ^ (Power%)
        Power% = Power% + 1
    NEXT I%
    BinDec& = Decimal&
END FUNCTION

' Converts a decimal number to an equivalent string of binary digits.
'
FUNCTION DecBin$ (Decimal&)
    Bin$ = "": H$ = HEX$(Decimal&)
    FOR I% = 1 TO LEN(H$)
        Digit% = INSTR("0123456789ABCDEF", MID$(H$, I%, 1)) - 1
        IF Digit% < 0 THEN Bin$ = "": EXIT FOR
        J% = 8: K% = 4
        DO
           Bin$ = Bin$ + RIGHT$(STR$((Digit% \ J%) MOD 2), 1)
           J% = J% - (J% \ 2): K% = K% - 1
           IF K% = 0 THEN EXIT DO
        LOOP WHILE J%
    NEXT I%
    DecBin$ = Bin$
END FUNCTION

