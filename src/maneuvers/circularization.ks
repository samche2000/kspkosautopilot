RUNONCEPATH("exec_node").

function circularization {
    PARAMETER maneuver.

    LOCAL nd IS CREATE_NODE_AT_ALTITUDE(TARGET_AP).

    SET nd TO NEXTNODE.

    EXEC_NODE(nd).

    REMOVE nd.

    PRINT "Deploying panels...".
    BAYS ON.
    WAIT 3.
    PANELS ON.

    SAS OFF.
    RCS OFF.
    UNLOCK THROTTLE.
    UNLOCK STEERING.
    SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
}
