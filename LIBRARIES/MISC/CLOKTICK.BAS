DECLARE FUNCTION ClockTicks& ()
'Replacement for QB's TIMER

'***********************************************************************
'* FUNCTION ClockTicks&
'*
'* PURPOSE
'*    Returns the number of clock ticks since midnight.
'***********************************************************************
FUNCTION ClockTicks& STATIC
   DEF SEG = &H40
   ClockTicks& = PEEK(&H6C) + PEEK(&H6D) * 256& + PEEK(&H6E) * 65536
   DEF SEG
END FUNCTION

