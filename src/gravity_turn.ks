function gravity_turn {
    PARAMETER mAlt.

    SET thr TO 1.0.
    LOCK THROTTLE TO thr.

    SET HEAD TO HEADING(90,90).
    LOCK STEERING TO HEAD.

    RCS OFF.
    SAS OFF.
    //SET SASMODE ON "STABILITYASSIST".

    UNTIL SHIP:APOAPSIS > mAlt {

        SET TotalThrust TO 0.
        SET Pitch TO 90 - (SHIP:APOAPSIS / mAlt * 90).
        SET HEAD TO (HEADING(90,Pitch)).

        LIST ENGINES IN engList.
        FOR eng IN engList {
            IF eng:IGNITION SET totalThrust TO totalThrust + eng:THRUST.
        }.

        SET Speed TO SHIP:VELOCITY:SURFACE:MAG.
        SET Poids TO MASS *  (BODY:mu / (ship:body:position:mag * ship:body:position:mag)).
        SET TWR TO TotalThrust / poids.

        IF SHIP:ALTITUDE < 500 {
            WAIT 1.
        } ELSE IF SHIP:ALTITUDE < 15000 {
            IF SHIP:AIRSPEED > 500 {
                SET thr TO thr - 0.01.
            } ELSE {
                IF TWR > 1.8 AND THROTTLE > 0.1 {
                    SET thr TO thr - 0.01.
                }
                IF TWR < 1.4 AND THROTTLE < 1 {
                    SET thr TO thr + 0.01.
                }
            }
        } ELSE IF SHIP:ALTITUDE < 25000 {
            IF SHIP:AIRSPEED > 700 {
                SET thr TO thr - 0.01.
            } ELSE {
                IF TWR > 2.2 AND THROTTLE > 0.1 {
                    SET thr TO thr - 0.01.
                }
                IF TWR < 1.6 AND THROTTLE < 1 {
                    SET thr TO thr + 0.01.
                }
            }
        } ELSE IF SHIP:ALTITUDE < 35000 {
            IF SHIP:AIRSPEED > 1000 {
                SET thr TO thr - 0.01.
            } ELSE {
                IF TWR > 2.8 AND THROTTLE > 0.1 {
                    SET thr TO thr - 0.01.
                }
                IF TWR < 2 AND THROTTLE < 1 {
                    SET thr TO thr + 0.01.
                }
            }
        } ELSE IF SHIP:ALTITUDE < 45000 {
            IF SHIP:AIRSPEED > 1200 {
                SET thr TO thr - 0.01.
            } ELSE {
                IF TWR > 2.8 AND THROTTLE > 0.1 {
                    SET thr TO thr - 0.01.
                }
                IF TWR < 2 AND THROTTLE < 1 {
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
