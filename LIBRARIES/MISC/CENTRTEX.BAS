DECLARE SUB disp (title$, cl%, row%)
'centers a string on the screen
'TITLE$ is the string to center
'CL is the color of the text
'ROW is the row on screen to display
DEFINT A-Z

title$ = "This is a test."
cl = 14
row = 10

disp title$, cl, row
END

SUB disp (title$, cl, row)
Y = 40 - (LEN(title$) \ 2)
COLOR cl: LOCATE row, Y: PRINT title$
END SUB

