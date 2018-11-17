function transferInterplanetary {
    PARAMETER origin.
    PARAMETER destination.

    set transferParameters to getMeanInterceptParameters(origin, destination).
    set transferUT to transferParameters[0].

    set transferDuration to transferParameters[3].
    set buffer to ship:obt:period.

    set r0 to -body:position.
    set transferV0 to velocityat(body, transferUT):orbit.
    set transferPos to positionat(body, transferUT).
    set transferPos1 to positionat(destination, transferUT + transferDuration).
    set transferR0 to transferPos - body:body:position.
    set transferR1 to transferPos1 - body:body:position.
    set transferV1 to vxcl(transferR0, transferV0):normalized * transferParameters[1].

    set transferR1 to vxcl(ship:north:vector, transferR1).
    set transferDTa to vang(transferR0, transferR1).
    if (vdot(vcrs(transferR0, transferR1), v(0,1,0)) > 0) set transferDTa to clamp360(-transferDTa).
    set solution to LambertSolver(transferR0:mag, transferR1:mag, 0, transferDTa, transferDuration, body:body:mu).
    set f to solution[5].
    set g to solution[6].
    set gprime to solution[7].
    set transferV1 to (transferR1 - f * transferR0) * (1 / g).

    set transferDv to transferV1 - transferV0.

    set vinfinity to transferDv:mag.
    set ecc to 1 + r0:mag * vinfinity ^ 2 / body:mu.
    set sma to r0:mag / (1 - ecc).
    set angleChangePe to arcsin(1 / ecc).
    set delta to abs(sma / tan(angleChangePe)).
    set rNormal to vcrs(r0, vxcl(r0, transferDv)).
    if (vdot(rNormal, v(0,1,0)) < 0) {
        set rNormal to -rNormal.
    }
    set rinfinity to vcrs(rNormal, transferDv):normalized * delta.
    set rot to angleaxis(angleChangePe, rNormal).
    set rburn to rot * rinfinity:normalized * r0:mag	.
    set deltaTa to vang(r0, rburn).
    if vdot(vcrs(r0, rburn), v(0,1,0)) > 0 {
        set deltaTa to clamp360(-deltaTa).
    }
    set burnTa to clamp360(ship:obt:trueanomaly + deltaTa).
    set burnTime to time:seconds + getEtaTrueAnomOrbitable(burnTa, ship).
    set burnPos to positionat(ship, burnTime).
    set burnV0 to velocityat(ship, burnTime):orbit.
    set vp to sqrt(vinfinity ^ 2 + 2 * body:mu / r0:mag).
    set burnR to burnPos - body:position.

    set burnV1 to vxcl(burnR, burnV0):normalized * vp.
    set nd to getNode(burnV0, burnV1, burnR, burnTime).
    add nd.
}
