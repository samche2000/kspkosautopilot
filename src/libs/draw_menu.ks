function DRAW_MENU {
    SET TERMINAL:WIDTH TO 120.
    SET TERMINAL:HEIGHT TO 40.
    SET TERMINAL:CHARHEIGHT TO 22.
    CLEARSCREEN.

    PRINT "========================================================================================================================" AT (0,2).
    PRINT "========================================================================================================================" AT (0,9).
    PRINT "========================================================================================================================" AT (0,38).

    LOCAL x TO 0.
    LOCAL y TO 3.
    FOR step IN mission {
        IF step:TYPENAME = "lexicon" {
            PRINT step["id"] + " : " + step["name"] AT (x,y).
        }.
        SET y TO y + 1.
        IF (y > 7) {
            SET x TO 60.
            SET y TO 3.
        }.
    }.
    PRINT "0 : Exit Program" AT (60,8).
}.
