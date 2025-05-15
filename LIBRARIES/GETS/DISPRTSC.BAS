DECLARE SUB DisablePrintScreen (sw%)
'disable/enable the PrintScreen key
'sw = 1 disables   sw = 0 enables

DisablePrintScreen sw%

SUB DisablePrintScreen (sw%)
   'sw% = 1 then disable     sw% = 0 then enable
   DEF SEG = 0
   POKE &H500, sw%
   DEF SEG
END SUB

