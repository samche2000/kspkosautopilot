// ****************************************************************************
// ***                                                                      ***
// *** MISSION :                                                            ***
// ***                                                                      ***
// *** DESCRIPTION :                                                        ***
// ***                                                                      ***
// ****************************************************************************
//
// ****************************************************************************
// ***                                                                      ***
// *** mission                                                              ***
// ***   + steps                                                            ***
// ***     + step                                                           ***
// ***       + id                                                           ***
// ***       + name                                                         ***
// ***       + maneuver                                                     ***
// ***         + type                                                       ***
// ***         + constants                                                  ***
// ***           + body                                                     ***
// ***           + targetAltitude                                           ***
// ***                                                                      ***
// ***                                                                      ***
// ***                                                                      ***
// ***                                                                      ***
// ***                                                                      ***
// ***                                                                      ***
// ***                                                                      ***
// ****************************************************************************


set mission to list().
    set steps to list().
        set step to lexicon().
            step:ADD("id", 1).
            step:ADD("name", "launch").
            set maneuver to lexicon().
                maneuver:ADD("type", "launch").
                maneuver:ADD("initialStatus", "On launch").
                maneuver:ADD("finalStatus", "Orbit Kerbin at 80 km").
                set constants to lexicon().
                    constants:ADD("body", "kerbin").
                    constants:ADD("targetAltitude", 80000).
                maneuver:ADD("constants", constants).
            step:ADD("maneuver", maneuver).
        mission:ADD(step).
    mission:ADD(steps).
