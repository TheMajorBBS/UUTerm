DECLARE FUNCTION grid$ ()
DECLARE FUNCTION zig$ ()
DECLARE FUNCTION stripe$ ()
DECLARE FUNCTION thatch$ ()
DECLARE FUNCTION zig2$ ()
'code for a variety of patterns-Awesome!
SCREEN 9
CLS
LINE (50, 100)-(100, 300), 8, B
PAINT (51, 101), grid$, 8

LINE (150, 100)-(200, 300), 8, B
PAINT (151, 101), zig$, 8

LINE (250, 100)-(300, 300), 8, B
PAINT (251, 101), stripe$, 8

LINE (350, 100)-(400, 300), 8, B
PAINT (351, 101), thatch$, 8

LINE (450, 100)-(500, 300), 8, B
PAINT (451, 101), zig2$, 8


FUNCTION grid$

'little metal pop up buttons
  pattern$ = CHR$(255) + CHR$(255) + CHR$(255) + CHR$(0)
  pattern$ = pattern$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(124)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(68)
  pattern$ = pattern$ + CHR$(195) + CHR$(195) + CHR$(195) + CHR$(124)
  pattern$ = pattern$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(0)

grid$ = pattern$
END FUNCTION

FUNCTION stripe$
'stripes
pattern$ = CHR$(255) + CHR$(255) + CHR$(255) + CHR$(255)
pattern$ = pattern$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(255)
pattern$ = pattern$ + CHR$(255) + CHR$(127) + CHR$(127) + CHR$(127)
pattern$ = pattern$ + CHR$(239) + CHR$(175) + CHR$(191) + CHR$(175)
pattern$ = pattern$ + CHR$(247) + CHR$(215) + CHR$(223) + CHR$(215)
pattern$ = pattern$ + CHR$(251) + CHR$(235) + CHR$(239) + CHR$(235)
pattern$ = pattern$ + CHR$(253) + CHR$(245) + CHR$(247) + CHR$(245)
pattern$ = pattern$ + CHR$(254) + CHR$(254) + CHR$(255) + CHR$(254)
pattern$ = pattern$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(255)
pattern$ = pattern$ + CHR$(255) + CHR$(255) + CHR$(255) + CHR$(255)

stripe$ = pattern$
END FUNCTION

FUNCTION thatch$
'thatch pattern
pattern$ = CHR$(0) + CHR$(127) + CHR$(255) + CHR$(24)
pattern$ = pattern$ + CHR$(0) + CHR$(63) + CHR$(255) + CHR$(12)
pattern$ = pattern$ + CHR$(0) + CHR$(159) + CHR$(255) + CHR$(6)
pattern$ = pattern$ + CHR$(0) + CHR$(207) + CHR$(255) + CHR$(3)
pattern$ = pattern$ + CHR$(0) + CHR$(252) + CHR$(255) + CHR$(48)
pattern$ = pattern$ + CHR$(0) + CHR$(249) + CHR$(255) + CHR$(96)
pattern$ = pattern$ + CHR$(0) + CHR$(243) + CHR$(255) + CHR$(192)
pattern$ = pattern$ + CHR$(0) + CHR$(231) + CHR$(255) + CHR$(128)

thatch$ = pattern$
END FUNCTION

FUNCTION zig$
'metal zig-zag
pattern$ = CHR$(191) + CHR$(191) + CHR$(191) + CHR$(72)
pattern$ = pattern$ + CHR$(223) + CHR$(223) + CHR$(223) + CHR$(36)
pattern$ = pattern$ + CHR$(239) + CHR$(239) + CHR$(239) + CHR$(18)
pattern$ = pattern$ + CHR$(253) + CHR$(253) + CHR$(253) + CHR$(18)
pattern$ = pattern$ + CHR$(251) + CHR$(251) + CHR$(251) + CHR$(36)
pattern$ = pattern$ + CHR$(247) + CHR$(247) + CHR$(247) + CHR$(72)
zig$ = pattern$
END FUNCTION

FUNCTION zig2$
'zig-zag pattern
pattern$ = CHR$(224) + CHR$(111) + CHR$(127) + CHR$(239)
pattern$ = pattern$ + CHR$(112) + CHR$(183) + CHR$(191) + CHR$(247)
pattern$ = pattern$ + CHR$(56) + CHR$(219) + CHR$(223) + CHR$(251)
pattern$ = pattern$ + CHR$(56) + CHR$(219) + CHR$(223) + CHR$(251)
pattern$ = pattern$ + CHR$(112) + CHR$(183) + CHR$(191) + CHR$(247)
pattern$ = pattern$ + CHR$(224) + CHR$(111) + CHR$(127) + CHR$(239)
zig2$ = pattern$
END FUNCTION

