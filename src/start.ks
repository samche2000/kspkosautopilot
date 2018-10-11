CLEARSCREEN.

LOG "altitude;pression" TO "1:/mylog.csv".
UNTIL SHIP:ALTITUDE > 70000 {
    SET line TO ROUND(SHIP:ALTITUDE,2) + ";" + ROUND(SHIP:SENSORS:PRES,2).
    PRINT(line).
    LOG line TO "1:/mylog.csv".
    WAIT 1.
}
