RUNONCEPATH("libs/maths").
RUNONCEPATH("libs/orbit").
RUNONCEPATH("libs/lambertSolver").

function planInterplanetary {
    PARAMETER origin.
    PARAMETER destination.
    PARAMETER message.
    PARAMETER note.

    if defined ct ct:revertcamera.
    wait 0.1.
    set transferParameters to getMeanInterceptParameters(origin, destination).
    set transferUT to transferParameters[0].

    if (ADDONS:AVAILABLE("KAC")) {
        SET kacAlarm TO addAlarm("Raw", transferUT - origin:ROTATIONPERIOD, message, note).
        SET kacAlarm:ACTION TO "KillWarp".
    }
    return transferUT.
}
