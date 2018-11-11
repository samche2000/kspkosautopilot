@LAZYGLOBAL OFF.

CLEARSCREEN.
SWITCH TO ARCHIVE.

PRINT "=======================".
PRINT "Debut de la compilation".
PRINT "=======================".
PRINT " ".

// Inserer ici les tests unitaires

// Si ok, on continue

//
// On gere les programmes tiers
//
//DELETEPATH("0:/kunit").
//CREATEDIR("0:/kunit").
//CREATEDIR("0:/kunit/class").

//CD("0:/kunit-src/class").

//LIST FILES IN srcFiles.
//LIST FILES IN srcFiles.
//FOR ksfile IN srcFiles {
//    PRINT "Compilation du fichier : " + ksfile.
//    COMPILE "ARCHIVE:/kunit-src/class/" + ksfile TO "ARCHIVE:/kunit/class/" + ksfile + "m".
//}

//
// On gere les programmes metiers
//

DELETEPATH("0:/bin").
CREATEDIR("0:/bin").

CD("0:/src").

LIST FILES IN srcFiles.
FOR ksfile IN srcFiles {
    PRINT "Compilation du fichier : " + ksfile.
    COMPILE "ARCHIVE:/src/" + ksfile TO "ARCHIVE:/bin/" + ksfile + "m".
}

CD("0:/tools").

PRINT " ".
PRINT "=====================".
PRINT "Fin de la compilation".
PRINT "=====================".
PRINT " ".
