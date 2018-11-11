CLEARSCREEN.

RUNONCEPATH("libs/create_node_at_altitude").
RUNONCEPATH("libs/exec_node").
RUNONCEPATH("libs/gravity_turn").

//LOG "altitude;pression" TO "1:/mylog.csv".

//UNTIL SHIP:ALTITUDE > 70000 {
    // Tester presence SENSORS:PRES
    //SET line TO ROUND(SHIP:ALTITUDE,2) + ";" + ROUND(SHIP:SENSORS:PRES,2).
    //PRINT(line).
    //LOG line TO "1:/mylog.csv".
    //WAIT 1.
//}

// Orbital wishlist
SET TARGET_AP TO 80000.
SET TARGET_PE TO 80000.

// Gravity turn params
SET SPEED_MIN TO 100.
SET SPEED_STEP TO 50.
SET PITCH_MAX TO 90.
SET PITCH_MIN TO 10.
SET PITCH_STEP TO 5.

// Max fuel not to count as a separator
SET SEP_SOLID TO 25.

// Identify SRB's and count any fuel in the separators
SET SOLID_EMPTY TO 1.

LIST ENGINES IN ENGLIST.
FOR ENG IN ENGLIST {
	IF ENG:ALLOWSHUTDOWN = FALSE {
		FOR RES IN ENG:RESOURCES {
			IF RES:AMOUNT < SEP_SOLID {
				SET SOLID_EMPTY TO SOLID_EMPTY + RES:AMOUNT.
			}.
		}.
	}.
}.

CLEARSCREEN.
SET V0 TO GetVoice(0).

//PRINT "Counting down".
//FROM {local countdown is 10.} UNTIL countdown = 0 STEP {SET countdown to countdown - 1.} DO {
//    PRINT "  ... " + countdown + " " AT (0,1).
//	V0:PLAY( NOTE( 440, 0.25) ).
//    WAIT 1.
//}.

//V0:PLAY( NOTE( 880, 1) ).
PRINT "Blast off !!".

// Open the throttle, but save the mono
SET thr TO 1.0.
LOCK THROTTLE TO thr.
RCS OFF.
SAS ON.

STAGE.
WAIT 1.5.

PRINT "Lift off !!".
STAGE.
WAIT 1.

WHEN MAXTHRUST = 0 THEN {
    PRINT "Staging".
    STAGE.
    WAIT 3.
    PRESERVE.
}.

GRAVITY_TURN(TARGET_AP)

LOCAL nd IS CREATE_NODE_AT_ALTITUDE(TARGET_AP).

EXEC_NODE(nd).

// IF OK
REMOVE nd.


// Because we can
PRINT "Deploying panels...".
BAYS ON.
WAIT 3.
PANELS ON.

// This sets the user's throttle setting to zero to prevent the throttle
// from returning to the position it was at before the script was run.
SAS OFF.
RCS OFF.
UNLOCK throttle.
SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
