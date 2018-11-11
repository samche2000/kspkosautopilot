RUNONCEPATH("libs/create_node_at_altitude").
RUNONCEPATH("libs/exec_node").
RUNONCEPATH("maneuvers/gravity_turn").
RUNONCEPATH("missions/001").

DRAW_MENU().

// Orbital wishlist
SET TARGET_AP TO mission[0]["maneuver"]["constants"]["targetAltitude"].

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

SET thr TO 1.0.
LOCK THROTTLE TO thr.
RCS OFF.
SAS OFF.

STAGE.
WAIT 1.5.

STAGE.
WAIT 1.

WHEN MAXTHRUST = 0 THEN {
    PRINT "Staging".
    STAGE.
    WAIT 3.
    PRESERVE.
}.

GRAVITY_TURN(TARGET_AP).

LOCAL nd IS CREATE_NODE_AT_ALTITUDE(TARGET_AP).

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
