function EXEC_NODE {
    PARAMETER nd.

    // S'assurer que les moteurs sont demarres

    SET thr TO 0.
    SET np TO nd:deltav.
    SET max_acc TO ship:maxthrust/ship:mass.
    SET burn_duration TO nd:deltav:mag/max_acc.

    LOCK steering TO np.
    LOCK throttle to thr.
    SAS OFF.
    RCS ON.

    UNTIL nd:eta <= (burn_duration/2 + 60) {
        SET np TO nd:deltav.
    }.

    UNTIL vang(np, ship:facing:vector) < 0.25 {
        SET np TO nd:deltav.
    }.

    UNTIL nd:eta <= (burn_duration/2) {
        SET np TO nd:deltav.
    }.

    SET done TO False.
    SET dv0 TO nd:deltav.
    UNTIL done
    {
        SET np TO nd:deltav.
        SET max_acc TO ship:maxthrust/ship:mass.

        SET thr TO min(nd:deltav:mag/max_acc, 1).

        IF vdot(dv0, nd:deltav) < 0
        {
            PRINT "End burn, remain dv " + ROUND(nd:deltav:mag, 1) + "m/s, vdot: " + ROUND(vdot(dv0, nd:deltav),1).
            SET thr TO 0.
            BREAK.
        }

        IF nd:deltav:mag < 0.1
        {
            PRINT "Finalizing burn, remain dv " + ROUND(nd:deltav:mag, 1) + "m/s, vdot: " + ROUND(vdot(dv0, nd:deltav),1).
            WAIT UNTIL vdot(dv0, nd:deltav) < 0.5.

            SET thr TO 0.
            PRINT "End burn, remain dv " + ROUND(nd:deltav:mag, 1) + "m/s, vdot: " + ROUND(vdot(dv0, nd:deltav),1).
            SET done TO True.
        }
    }
    WAIT 1.
    UNLOCK steering.

    SET thr TO 0.
}
