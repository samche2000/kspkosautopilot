function gravity_turn {
    PARAMETER maneuver.

    WHEN MAXTHRUST = 0 THEN {
	    STAGE.
	    WAIT 3.
	    PRESERVE.
	}.

    LOCAL TARGET_AP TO maneuver["constants"]["targetAltitude"].

    LOCAL thr TO 1.0.
    LOCK THROTTLE TO thr.

    SET HEAD TO HEADING(90,90).
    LOCK STEERING TO HEAD.

    RCS OFF.
    SAS OFF.

    UNTIL SHIP:APOAPSIS > TARGET_AP {

        LOCAL Pitch TO 90 - (SHIP:APOAPSIS / TARGET_AP * 90).
        SET HEAD TO HEADING(90,Pitch).

        LOCAL twr TO currenttwr().

        LOCAL Speed TO SHIP:VELOCITY:SURFACE:MAG.

        IF SHIP:ALTITUDE < 500 {
            WAIT 1.
        } ELSE IF SHIP:ALTITUDE < 15000 {
            IF SHIP:AIRSPEED > 500 {
                SET thr TO thr - 0.01.
            } ELSE {
                IF twr > 1.8 AND THROTTLE > 0.1 {
                    SET thr TO thr - 0.01.
                }
                IF twr < 1.4 AND THROTTLE < 1 {
                    SET thr TO thr + 0.01.
                }
            }
        } ELSE IF SHIP:ALTITUDE < 25000 {
            IF SHIP:AIRSPEED > 700 {
                SET thr TO thr - 0.01.
            } ELSE {
                IF twr > 2.2 AND THROTTLE > 0.1 {
                    SET thr TO thr - 0.01.
                }
                IF twr < 1.6 AND THROTTLE < 1 {
                    SET thr TO thr + 0.01.
                }
            }
        } ELSE IF SHIP:ALTITUDE < 35000 {
            IF SHIP:AIRSPEED > 1000 {
                SET thr TO thr - 0.01.
            } ELSE {
                IF twr > 2.8 AND THROTTLE > 0.1 {
                    SET thr TO thr - 0.01.
                }
                IF twr < 2 AND THROTTLE < 1 {
                    SET thr TO thr + 0.01.
                }
            }
        } ELSE IF SHIP:ALTITUDE < 45000 {
            IF SHIP:AIRSPEED > 1200 {
                SET thr TO thr - 0.01.
            } ELSE {
                IF twr > 2.8 AND THROTTLE > 0.1 {
                    SET thr TO thr - 0.01.
                }
                IF twr < 2 AND THROTTLE < 1 {
                    SET thr TO thr + 0.01.
                }
            }
        } ELSE IF SHIP:ALTITUDE > 45000 {
            SET thr TO 1.
        }
    }

    SET thr TO 0.
    SAS OFF.
    RCS OFF.
}
