'shuffles and displays deck of cards

CLS : SCREEN 0
RANDOMIZE TIMER
DIM deck$(52), deck(52), suit$(52)

CLS : x = 0
PRINT "Shuffling Deck..."
hands = hands + 1
FOR x = 1 TO 52                                          'shuffle deck
 r = INT(RND * 52 + 1)
 IF deck(r) = 0 THEN deck(r) = x ELSE x = x - 1
NEXT x

FOR x = 1 TO 52                              'assign values
  temp = deck(x): swtch = 0
  IF deck(x) < 14 THEN suit$(x) = ""
  IF deck(x) > 13 AND deck(x) < 27 THEN suit$(x) = "": temp = temp - 13
  IF deck(x) > 26 AND deck(x) < 40 THEN suit$(x) = "": temp = temp - 26
  IF deck(x) > 39 THEN suit$(x) = "": temp = temp - 39
  deck(x) = temp
  IF deck(x) = 1 THEN deck$(x) = " A of " + suit$(x): swtch = 1
  IF deck(x) = 11 THEN deck$(x) = " J of " + suit$(x): swtch = 1
  IF deck(x) = 12 THEN deck$(x) = " Q of " + suit$(x): swtch = 1
  IF deck(x) = 13 THEN deck$(x) = " K of " + suit$(x): swtch = 1
  IF swtch <> 1 THEN deck$(x) = STR$(deck(x)) + " of " + suit$(x)
NEXT x
CLS
FOR x = 1 TO 5
  PRINT deck$(x)
NEXT x

