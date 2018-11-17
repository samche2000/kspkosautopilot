RUNONCEPATH("libs/exec_node").

function burnToApoapsis {
    PARAMETER maneuver.

    SET TARGET_AP TO maneuver["constants"]["targetAltitude"].
    SET nd TO CREATE_NODE_AT_ALTITUDE(TARGET_AP).
    SET nd TO NEXTNODE.

    EXEC_NODE(nd).

    REMOVE nd.

    SAS OFF.
    RCS OFF.
    UNLOCK THROTTLE.
    UNLOCK STEERING.
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
}
