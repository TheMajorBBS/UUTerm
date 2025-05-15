FUNCTION pcrCarrierDetect% (Com%)

   'Purpose : Detects carrier.
   'Input   : 1 - 4 for Com ports ... assumes changed irqs if > 2
   'Return  : -1 if carrier detected, 0 if not CD, 2 if out of range

   pcrCarrierDetect% = 0
   IF Com% = 1 THEN Addr = &H3FE
   IF Com% = 2 THEN Addr = &H2FE
   IF Com% = 3 THEN Addr = &H3EE
   IF Com% = 4 THEN Addr = &H2EE
   IF Addr = 0 THEN pcrCarrierDetect% = 2: EXIT DEF
   IF (INP(Addr) AND 128) THEN pcrCarrierDetect% = -1
END FUNCTION

