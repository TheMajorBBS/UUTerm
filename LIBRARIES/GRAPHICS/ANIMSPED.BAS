'calculates computer speed for animation
'returns length of a delay between screens

DEFINT A-Z
SUB setspeed (speed)

x! = TIMER
FOR i = 0 TO 499
  y! = SIN(i)
  y! = y! ^ 2
  y! = y! + i
  y! = y! - i
NEXT
y! = TIMER - x!

SELECT CASE y!
  CASE 0 TO 1      '66-486
    speed = 3200
  CASE 1 TO 2.5
    speed = 1600   '33-486
  CASE 2.5 TO 5
    speed = 800    '33-386
  CASE 5 TO 10    '16-386
    speed = 400
  CASE IS > 10    '12-286
    speed = 1
END SELECT

END SUB

