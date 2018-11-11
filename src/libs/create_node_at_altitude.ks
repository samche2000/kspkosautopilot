function CREATE_NODE_AT_ALTITUDE {
    PARAMETER mAlt.

    LOCAL mu IS BODY:MU.
    LOCAL br IS BODY:RADIUS.

    // present orbit properties
    LOCAL vom IS VELOCITY:ORBIT:MAG.                     // actual velocity
    LOCAL r IS br + ALTITUDE.                            // actual distance to body
    LOCAL ra IS br + APOAPSIS.                           // radius at burn apsis
    LOCAL v1 IS sqrt(vom^2 + 2 * mu * (1 / ra - 1 / r)). // velocity at burn apsis
    LOCAL sma1 IS (PERIAPSIS + 2 * br + APOAPSIS) / 2.   // semi major axis present orbit

    // future orbit properties
    LOCAL r2 IS br + APOAPSIS.                      // distance after burn at apoapsis
    LOCAL sma2 IS ((mAlt) + 2 * br + APOAPSIS) / 2. // semi major axis target orbit
    LOCAL v2 IS sqrt(vom^2 + (mu * (2 / r2 - 2 / r + 1 / sma1 - 1 / sma2))).

    // create node
    LOCAL deltav IS v2 - v1.
    LOCAL nd IS node(TIME:SECONDS + ETA:APOAPSIS, 0, 0, deltav).
    ADD nd.
    RETURN nd.
}
