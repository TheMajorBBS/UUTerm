DECLARE FUNCTION AddDate$ (DateString$, NumberOfDays%)
DECLARE FUNCTION CDOW$ (DateString$)
DECLARE FUNCTION Cmonth$ (DateString$)
DECLARE FUNCTION Day% (DateString$)
DECLARE FUNCTION DiffBetweenDates! (DateString1$, DateString2$)
DECLARE FUNCTION DOW% (DateString$)
DECLARE FUNCTION IsLeap% (DateString$)
DECLARE FUNCTION JulianDate! (DateString$)
DECLARE FUNCTION JulianToDate$ (Julian!)
DECLARE FUNCTION Month% (DateString$)
DECLARE FUNCTION SubtractDate$ (DateString$, NumberOfDays%)

'Anything to do with Date manipulation is here.

'this figure what day of the week a date falls on
wDay$ = CDOW$("04-29-1993")
PRINT wDay$


DEFINT A-Z
FUNCTION AddDate$ (DateString$, NumberOfDays%)
' Function: Allows you to add a specified number of days to a date passed
'           and returns the new date in the form MM-DD-YYYY.  As written,
'           the number of days must be passed as an integer, so you can't
'           add more than 32,767 days.  Date must be passed as a string
'           in the format MM-DD-YYYY.
' Uses:     JulianDate
'           JulianToDate
'
   AddDate$ = JulianToDate$(JulianDate!(DateString$) + NumberOfDays%)
END FUNCTION

FUNCTION CDOW$ (DateString$)
'
' Function: CDOW
' Language: QuickBASIC 4.5
' Author:   Vincent D. O'Connor
' Function: Returns the name of the day of the week that the passed date
'           falls on.  Date must be passed as a string in the format
'           MM-DD-YYYY.
' Uses:     DOW
'
   DayStr$ = "Sunday   Monday   Tuesday  WednesdayThursday Friday   Saturday "
   CDOW$ = RTRIM$(MID$(DayStr$, 9 * (DOW%(DateString$) - 1) + 1, 9))
END FUNCTION

FUNCTION Cmonth$ (DateString$)
'
' Function: Cmonth
' Language: QuickBASIC 4.5
' Author:   Vincent D. O'Connor
' Function: Returns the name of the month of the passed date.
'           Date must be passed as a string in the format MM-DD-YYYY.
' Uses:     Month
'
   MonthStr$ = "December January  February March    April    May      "
   MonthStr$ = MonthStr$ + "June     July     August   September"
   MonthStr$ = MonthStr$ + "October  November "
   Cmonth$ = RTRIM$(MID$(MonthStr$, 9 * Month%(DateString$) + 1, 9))
END FUNCTION

FUNCTION Day% (DateString$)
' Function: Returns the number of the day of the month of the passed date.
'           Date must be passed as a string in the format MM-DD-YYYY.
'
   Day% = VAL(MID$(DateString$, 4, 2))
END FUNCTION

FUNCTION DiffBetweenDates! (DateString1$, DateString2$)
'
' Function: DiffBetweenDates
' Language: QuickBASIC 4.5
' Author:   Vincent D. O'Connor
' Function: Returns the number of days difference between two dates.
'           Both dates must be passed as a string in the format MM-DD-YYYY.
' Uses:     JulianDate
'
   Temp! = JulianDate!(DateString1$) - JulianDate!(DateString2$)
   DiffBetweenDates! = ABS(Temp!)
END FUNCTION

FUNCTION DOW% (DateString$)
'
' Function: DOW
' Language: QuickBASIC 4.5
' Author:   Vincent D. O'Connor
' Function: Returns a number that represents the day of the week that the
'           passed date falls on.  Sunday is day 1, and Saturday is day 7.
'           Date must be passed as a string in the format MM-DD-YYYY.
' Uses:     JulianDate
'
   Temp1! = JulianDate!(DateString$) + 2
   Temp2! = INT((JulianDate!(DateString$) + 2) / 7) * 7
   DOW% = INT(Temp1! - Temp2!) + 1
END FUNCTION

FUNCTION IsLeap% (DateString$)
'
' Function: IsLeap
' Language: QuickBASIC 4.5
' Author:   Vincent D. O'Connor
' Function: Returns TRUE if the year of the passed date is a leap year.
'           Date must be passed as a string in the format MM-DD-YYYY.
'
   Year! = VAL(RIGHT$(DateString$, 4))
   IsLeap% = (Year! MOD 4 = 0 AND Year! MOD 100 <> 0) OR (Year! MOD 400 = 0)
END FUNCTION

FUNCTION JulianDate! (DateString$)
'
' Function: JulianDate
' Language: QuickBASIC 4.5
' Author:   Vincent D. O'Connor
' Function: Returns the Julian date of the passed date.  The Julian date
'           is the number of days since January 1, 4713 BC.  This routine
'           is designed to handle only dates from January 1, 1 AD.
'           Date must be passed as a string in the format MM-DD-YYYY.
'
   Mnth! = VAL(LEFT$(DateString$, 2))
   Day1! = VAL(MID$(DateString$, 4, 2))
   Year! = VAL(RIGHT$(DateString$, 4))
   Temp1! = Year! + (Mnth! - 2.85) / 12
   Temp2! = INT(367 * Temp1!) - INT(Temp1!) - .75 * INT(Temp1!) + Day1!
   Temp3! = INT(Temp2!) - .75 * 2
   JulianDate! = INT(Temp3!) + 1721115
END FUNCTION

FUNCTION JulianToDate$ (Julian!)
'
' Function: JulianToDate
' Language: QuickBASIC 4.5
' Author:   Vincent D. O'Connor
' Function: Converts a Julian date to a date string in the form
'           MM-DD-YYYY. This routine is designed to handle only Julian
'           dates from January 1, 1 AD.
'
   Temp1! = (Julian! - 1721119) + 2
   Temp2! = INT((Temp1! - .2) / 365.25)
   Temp3! = Temp1! - INT(365.25 * Temp2!)
   Temp4! = INT((Temp3! - .5) / 30.6)
   D! = INT(Temp3! - 30.6 * Temp4! + .5)
   Y! = INT(Temp2! + ABS(Temp4! > 9))
   M! = INT(Temp4! + 3 - (ABS(Temp4! > 9) * 12))
   Day1$ = RIGHT$("00" + LTRIM$(STR$(D!)), 2)
   Mnth$ = RIGHT$("00" + LTRIM$(STR$(M!)), 2)
   Year1$ = RIGHT$("0000" + LTRIM$(STR$(Y!)), 4)
   JulianToDate$ = Mnth$ + "-" + Day1$ + "-" + Year1$
END FUNCTION

FUNCTION Month% (DateString$)
'
' Function: Month
' Language: QuickBASIC 4.5
' Author:   Vincent D. O'Connor
' Function: Returns the number of the day of the month of the passed date.
'           Date must be passed as a string in the format MM-DD-YYYY.
'
   Month% = VAL(LEFT$(DateString$, 2))
END FUNCTION

FUNCTION SubtractDate$ (DateString$, NumberOfDays%)
'
' Function: SubtractDate
' Language: QuickBASIC 4.5
' Author:   Vincent D. O'Connor
' Function: Allows you to subtract a specified number of days from a date
'           passed and returns the new date in the form MM-DD-YYYY.  As
'           written, the number of days must be passed as an integer, so
'           you can't subtract more than 32,767 days.  Date must be passed
'           as a string in the format MM-DD-YYYY.
'
' Uses:     JulianDate
'           JulianToDate
   SubtractDate$ = JulianToDate$(JulianDate!(DateString$) - NumberOfDays%)
END FUNCTION

