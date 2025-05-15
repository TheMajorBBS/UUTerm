'add a delay that works past midnight
'DELAY$ is the number of seconds to wait

DEF SEG = &H40
T% = (PEEK(&H6C) + 18) AND 255: WHILE T% > PEEK(&H6C): WEND
