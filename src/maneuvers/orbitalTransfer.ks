RUNONCEPATH("libs/exec_node").

function OrbitalTransfer {
    PARAMETER maneuver.

    LOCAL TARGET_AP TO maneuver["constants"]["targetAltitude"].
    LOCAL nd TO CREATE_NODE_AT_ALTITUDE(TARGET_AP).
    SET nd TO NEXTNODE.

    EXEC_NODE(nd).

    IF (ADDONS:AVAILABLE("KAC")) {
        IF (nd:ETA - (5 * 60) > 0) {
        SET kacAlarm TO addAlarm("Raw", nd:ETA - (5 * 60), "Orbital Transfer", "Circularisation de l'orbite").
        SET kacAlarm:ACTION TO "KillWarp".
        }
    }
}
