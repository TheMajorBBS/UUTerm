DECLARE FUNCTION CreditTest% (CCNum AS STRING)
'checks if a credit card is valid

FUNCTION CreditTest% (CCNum AS STRING)

' Function returns the type of card if the card is valid, otherwise
' it returns a "-1" for invalid numbers.
' Valid types:
'       3 = American Express
'       4 = VISA
'       5 = Mastercard
'       6 = Discover, I think.
'       Other numbers would be the FIRST DIGIT on the card in question!
'       Let me know if you know others!!!!

DIM X AS INTEGER, Y AS INTEGER, XCard AS INTEGER

BadLen = 0
card$ = CCNum
Cstr$ = ""

'Remove Spaces and invalid characters from the input line (CCNum)
FOR X = 1 TO LEN(card$)
  Test$ = MID$(card$, X, 1)
  IF (Test$ >= "0") AND (Test$ <= "9") THEN Cstr$ = Cstr$ + Test$
NEXT X
card$ = Cstr$
XCard% = 0

'Set up to test the number depending on number of characters.
IF (LEN(card$) / 2) = (LEN(card$) \ 2) THEN
  'Test for 16 Character numbers
  IF LEN(card$) <> 16 THEN
    BadLen = -1
  ELSE
    FOR X = (LEN(card$) - 1) TO 1 STEP -1
      Test$ = MID$(card$, X, 1)
      IF (X / 2) <> (X \ 2) THEN
        Y = (VAL(Test$) * 2)
      ELSE
        Y = VAL(Test$)
      END IF
      IF Y >= 10 THEN Y = ((Y - 10) + 1)
      XCard = XCard + Y
    NEXT
  END IF
ELSE
  'Test for 13 character numbers
  IF LEN(card$) <> 13 THEN
    BadLen = -1
  ELSE
    FOR X = (LEN(card$) - 1) TO 1 STEP -1
      Test$ = MID$(card$, X, 1)
      IF (X / 2) <> (X \ 2) THEN
        Y = VAL(Test$)
      ELSE
        Y = (VAL(Test$) * 2)
      END IF
      IF Y >= 10 THEN Y = ((Y - 10) + 1)
      XCard = XCard + Y
    NEXT
  END IF
END IF

'Test the resulting calculations for validity (MOD 10 Calculation)
X = (10 - (XCard MOD 10))
IF X = 10 THEN X = 0
Test$ = RIGHT$(card$, 1)

'Compare to LAST DIGIT in number, if equal, then it's valid.
'Set XCard to the card type for valid numbers, -1 for bad numbers.
IF X = VAL(Test$) THEN
  XCard = VAL(LEFT$(card$, 1))
ELSE
  XCard = -1
END IF

'Return the card type for valid numbers, -1 for bad numbers.
IF BadLen = -1 THEN
  CreditTest% = -1
ELSE
  CreditTest% = XCard
END IF

END FUNCTION

