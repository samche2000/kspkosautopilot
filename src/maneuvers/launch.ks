RUNONCEPATH("libs/create_node_at_altitude").
RUNONCEPATH("libs/exec_node").
RUNONCEPATH("libs/draw_menu").
RUNONCEPATH("maneuvers/gravity_turn").
RUNONCEPATH("missions/001").

function launch {
	PARAMETER maneuver.

	SET thr TO 1.0.
	LOCK THROTTLE TO thr.
	RCS OFF.
	SAS OFF.

	DRAW_MENU().

	SET SEP_SOLID TO 25.

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

	WHEN MAXTHRUST = 0 THEN {
	    STAGE.
	    WAIT 3.
	    PRESERVE.
	}.

	STAGE.
	WAIT 1.5.

	STAGE.
	WAIT 1.
}
