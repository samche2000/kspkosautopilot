RUNONCEPATH("libs/draw_menu").
RUNONCEPATH("maneuvers/launch").
RUNONCEPATH("maneuvers/gravity_turn").
RUNONCEPATH("maneuvers/circularization").
RUNONCEPATH("maneuvers/burnToApoapsis").
RUNONCEPATH("maneuvers/transferInterplanetary").
RUNONCEPATH("missions/001").

DRAW_MENU().
SET done TO FALSE.
TERMINAL:INPUT:clear().

UNTIL done {
    IF (TERMINAL:INPUT:HASCHAR = FALSE) {
        SET ch TO TERMINAL:INPUT:getchar().
        IF (ch = "0") {
            SET done TO TRUE.
        }.
        FOR step IN mission {
            IF (step["id"] = ch:tonumber()) {
                FOR maneuver IN step["maneuvers"] {
                    PRINT maneuver["name"] AT (80,0).
                    IF (maneuver["name"] = "burnToApoapsis")  burnToApoapsis(maneuver).
                    IF (maneuver["name"] = "circularization") circularization(maneuver).
                    IF (maneuver["name"] = "gravityTurn")     gravity_turn(maneuver).
                    IF (maneuver["name"] = "launch")          launch().
                    TERMINAL:INPUT:clear().
                }.
            }.
        }.
        DRAW_MENU().
    }.
}.

TERMINAL:INPUT:clear().
CLEARSCREEN.
