@LAZYGLOBAL OFF.

CLEARSCREEN.
SWITCH TO ARCHIVE.

PRINT "=======================".
PRINT "Debut de la compilation".
PRINT "=======================".
PRINT " ".

// Supprimer le dossier bin et le recréer

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
