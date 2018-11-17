// https://floobits.com/hvacengi/ksp-kos/browse/boot_duna.ks

CLEARSCREEN.

RUNONCEPATH("src/libs/maths").
RUNONCEPATH("src/libs/orbit").
RUNONCEPATH("src/libs/lambertSolver").
RUNONCEPATH("src/maneuvers/planInterplanetary").
RUNONCEPATH("src/maneuvers/transferInterplanetary").

set origin to Kerbin.
set destination to Duna.
start(origin, destination).

function start {
    PARAMETER origin.
    PARAMETER destination.

    SET message to "Depart pour Duna".
    SET note to "Preparer les moteurs pour un bon burn".

    //planInterplanetary(origin, destination, message, note).

    transferInterplanetary(origin, destination).

    //set vd_r0 to vecdraw(body:position, r0, red, "r0", 1, true).
    //set vd_rNormal to vecdraw(body:position, rNormal, green, "normal", 1, true).
    //set vd_rinfinity to vecdraw(body:position, rinfinity, yellow, "r infinity", 1, true).
    //set vd_asymptote to vecdraw(body:position + rinfinity, transferDv * 10^5, green, "asymptote", 1, true).
    //set vd_rburn to vecdraw(body:position, rburn, purple, "r burn", 1, true).
    //set vd_burnV0 to vecdraw(burnPos, burnV0 * 10 ^ 4, yellow, "burnV0", 1, true).
    //set vd_burnV1 to vecdraw(burnPos, burnV1 * 10 ^ 4, purple, "burnV1", 1, true).
}
