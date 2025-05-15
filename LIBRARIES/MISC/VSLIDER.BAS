'draw vertical Slide bar
'*** Slider position in bar (0=top, 1=bottom)
 hor% = 8: ver% = 6: h% = 14: s = 0
 CLS
 
 IF s < 0 THEN s = 0
 IF s > 1 THEN s = 1
 SliderPos% = (h% - 3) * s + 1

 COLOR 15, 1: LOCATE ver%, hor%: PRINT ""
 FOR i% = 1 TO h% - 2
   LOCATE ver% + i%, hor%
   IF i% = SliderPos% THEN
    COLOR 14, 6: PRINT "";
   ELSE
    COLOR 15, 1: PRINT "²";
   END IF
 NEXT i%
 COLOR 15, 1: LOCATE ver% + h% - 1, hor%: PRINT ""
END

