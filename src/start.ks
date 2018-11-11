RUNONCEPATH("libs/draw_menu").
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
                    RUN "maneuvers/launch".
                }.
            }.
        }.
        DRAW_MENU().
    }.
}.

TERMINAL:INPUT:clear().
CLEARSCREEN.
