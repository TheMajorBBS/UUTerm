'Quick sort routine

SUB QSort (Array$(), First%, Last%)
 '*****  Quick-Sort
 '*** sorts(ascending) the fields in Array$(), from field First% thru Field Last%
 IF First% >= Last% THEN EXIT SUB

 DIM Lft%(10), Rght%(10)

 Temp% = 1
 Lft%(1) = First%
 Rght%(1) = Last%

 DO
   Start% = Lft%(Temp%)
   Ende% = Rght%(Temp%)
   Temp% = Temp% - 1

   DO           '** (WHILE Start% < Ende%)
    IndexLft% = Start%
    IndexRght% = Ende%
    x$ = UCASE$(Array$((Start% + Ende%) \ 2))

    DO
     WHILE UCASE$(Array$(IndexLft%)) < x$: IndexLft% = IndexLft% + 1: WEND
     WHILE x$ < UCASE$(Array$(IndexRght%)): IndexRght% = IndexRght% - 1: WEND
  
     IF IndexLft% > IndexRght% THEN EXIT DO
  
     SWAP Array$(IndexLft%), Array$(IndexRght%)   '*** switch elements
     IndexLft% = IndexLft% + 1
     IndexRght% = IndexRght% - 1
    LOOP
 
    IF IndexRght% - Start% >= Ende% - IndexLft% THEN
      IF Start% < IndexRght% THEN
        Temp% = Temp% + 1
        Lft%(Temp%) = Start%
        Rght%(Temp%) = IndexRght%
      END IF
      Start% = IndexLft%
    ELSE
      IF IndexLft% < Ende% THEN
        Temp% = Temp% + 1
        Lft%(Temp%) = IndexLft%
        Rght%(Temp%) = Ende%
      END IF
       Ende% = IndexRght%
    END IF

   LOOP WHILE Start% < Ende%

 LOOP WHILE Temp%

END SUB

