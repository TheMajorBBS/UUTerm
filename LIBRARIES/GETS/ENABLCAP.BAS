'Use to turn on Caps Lock before input
'SW% = 1 to turn on Capitals, anything else to turn off

SUB caps (sw%)

DEF SEG = 0
IF sw% = 1 THEN             'turns on caps lock
  POKE &H417, PEEK(&H417) OR &H40
ELSE                         'turns off caps lock
  POKE &H417, PEEK(&H417) AND &HBF
END IF
DEF SEG

END SUB

