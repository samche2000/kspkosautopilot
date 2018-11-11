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
// ***         + initialStatus                                              ***
// ***         + finalStatus                                                ***
// ***         + constants                                                  ***
// ***           + body                                                     ***
// ***           + targetAltitude                                           ***
// ***                                                                      ***
// ****************************************************************************


set mission to list().
    set steps to list().
        set step to lexicon().
            step:ADD("id", 1).
            step:ADD("name", "Launch").
            set maneuvers to list().
                set maneuver to lexicon().
                    maneuver:ADD("name", "launch").
                    maneuver:ADD("initialStatus", "On launch").
                    maneuver:ADD("finalStatus", "Orbit Kerbin at 80 km").
                maneuvers:ADD(maneuver).
                set maneuver to lexicon().
                    maneuver:ADD("name", "gravity turn").
                    maneuver:ADD("initialStatus", "launch").
                    maneuver:ADD("finalStatus", "Apoapsis 80 km").
                    set constants to lexicon().
                        constants:ADD("body", "kerbin").
                        constants:ADD("targetAltitude", 80000).
                    maneuver:ADD("constants", constants).
                maneuvers:ADD(maneuver).
                set maneuver to lexicon().
                    maneuver:ADD("name", "circularization").
                    maneuver:ADD("initialStatus", "Apoapsis 80 km").
                    maneuver:ADD("finalStatus", "Orbit Kerbin at 80 km").
                maneuvers:ADD(maneuver).
            step:ADD("maneuvers", maneuvers).
        mission:ADD(step).
    mission:ADD(steps).
// End mission
