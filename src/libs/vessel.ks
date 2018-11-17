function currentTWR {
    SET TotalThrust TO 0.
    LIST ENGINES IN engList.
    FOR eng IN engList {
        IF eng:IGNITION SET totalThrust TO totalThrust + eng:THRUST.
    }.
    SET Poids TO MASS *  (BODY:mu / (ship:body:position:mag * ship:body:position:mag)).

    RETURN TotalThrust / poids.
}
