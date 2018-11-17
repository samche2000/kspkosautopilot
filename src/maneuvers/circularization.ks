RUNONCEPATH("libs/exec_node").

function circularization {
    PARAMETER maneuver.

    WHEN MAXTHRUST = 0 THEN {
        STAGE.
        WAIT 3.
        PRESERVE.
    }.

    SET TARGET_AP TO SHIP:APOAPSIS.

    LOCAL nd IS CREATE_NODE_AT_ALTITUDE(TARGET_AP).

    SET nd TO NEXTNODE.

    EXEC_NODE(nd).

    REMOVE nd.

    SAS OFF.
    RCS OFF.
    UNLOCK THROTTLE.
    UNLOCK STEERING.
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
}
