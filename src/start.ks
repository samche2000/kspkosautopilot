RUNONCEPATH("libs/draw_menu").
RUNONCEPATH("maneuvers/launch").
RUNONCEPATH("maneuvers/gravity_turn").
RUNONCEPATH("maneuvers/circularization").
RUNONCEPATH("maneuvers/planInterplanetary").
RUNONCEPATH("maneuvers/transferInterplanetary").
RUNONCEPATH("missions/001").

DRAW_MENU().
SET done TO FALSE.
TERMINAL:INPUT:clear().
UNTIL done {
    SET ch TO TERMINAL:INPUT:getchar().
    IF (TERMINAL:INPUT:HASCHAR = FALSE) {
        IF (ch = "0") {
            SET done TO TRUE.
        }.
        FOR step IN mission {
            IF step:TYPENAME = "lexicon" {
                IF step["id"] = ch {
                    launch(step["maneuvers"][0]).
                    gravity_turn(step["maneuvers"][1]).
                    circularization(step["maneuvers"][2]).
                }.
            }.
        }.
        DRAW_MENU().
    }.
}.

TERMINAL:INPUT:clear().
CLEARSCREEN.
