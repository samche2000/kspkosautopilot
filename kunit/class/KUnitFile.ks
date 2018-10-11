// Wrapper around kOS files
// There is some kind of mess around kOS files.
// This class is to solve them in a nice manner.

runoncepath("kunit/class/KUnitObject").

function KUnitFile {
    declare local parameter
        kosPath,
        className is list(),
        protected is lexicon().
    className:add("KUnitFile").
    
    // This check will make this class fail-fast.
    // It will cause KOS error when string passed as argument.
    // It MUST be a KOS path and we have to inform of error asap.
    local x is kosPath:segments. // Argument must be a KOS path

    local public is KUnitObject(className, protected).
    local private is lexicon().

    set private#kosPath to kosPath.
    
    set public#getPath to KUnitFile_getPath@:bind(public, protected, private).
    set public#getPathString to KUnitFile_getPathString@:bind(public, protected, private).
    set public#getPathStringWoVol to KUnitFile_getPathStringWoVol@:bind(public, protected, private).
    set public#isExists to KUnitFile_isExists@:bind(public, protected, private).
    set public#isDir to KUnitFile_isDir@:bind(public, protected, private).
    set public#isFile to KUnitFile_isFile@:bind(public, protected, private).
    set public#getVolumeKOS to KUnitFile_getVolumeKOS@:bind(public, protected, private).
    set public#toString to KUnitFile_toString@:bind(public, protected, private).
    set public#equals to KUnitFile_equals@:bind(public, protected, private).

    return public.
}

// Get KOS path object associated with the file.
// Return: KOS path
function KUnitFile_getPath {
    declare local parameter public, protected, private.
    return private#kosPath.
}

// Get string of file absolute path.
// Return: string of path
function KUnitFile_getPathString {
    declare local parameter public, protected, private.
    local kp is private#kosPath.
    return ("" + kp).
}

// Get string of file absolute path without volume.
// Return: string of path
function KUnitFile_getPathStringWoVol {
    declare local parameter public, protected, private.
    local kp is private#kosPath.
    local vol is kp:volume().
    local volName is vol:name.
    local toCut is volName + ":".
    local toCutLen is toCut:length.
    local pathString is ("" + kp).
    local pathString is pathString:remove(0, toCutLen).
    return pathString.
}

// Check that path is exists.
// Return: true if exists, false otherwise
function KUnitFile_isExists {
    declare local parameter public, protected, private.
    return exists(private#kosPath).
}

function KUnitFile_isDir {
    declare local parameter public, protected, private.
    local e is public#isExists().
    if not e {
        return false.
    }
    local kp is private#kosPath.
    local pathStringWoVol is public#getPathStringWoVol().
    local vol is kp:volume().
    local volItem is vol:open(pathStringWoVol).
    if volItem:isfile {
        return false.
    }
    return true.
}

function KUnitFile_isFile {
    declare local parameter public, protected, private.
    local e is public#isExists().
    if not e {
        return false.
    }
    local e is public#isDir().
    if e {
        return false.
    }
    return true.
}

function KUnitFile_getVolumeKOS {
    declare local parameter public, protected, private.
    local kp is private#kosPath.
    return kp:volume.
}

function KUnitFile_toString {
    declare local parameter public, protected, private.
    local x is public#getPathString().
    return "KUnitFile[" + x + "]".
}

function KUnitFile_equals {
    declare local parameter public, protected, private,
        other.
        
    if public = other {
        return true.
    }
    if not public#isSameClassWith(other) {
        return false.
    }
    local kosPath1 is public#getPath().
    local kosPath2 is other#getPath().
    if kosPath1 <> kosPath2 {
        return false.
    }
    return true.
}
