// File utilities

runoncepath("kunit/class/KUnitFile").

function KUnitFileUtils {
        declare local parameter
        className is list(),
        protected is lexicon().
    className:add("KUnitFileUtils").

    local public is KUnitObject(className, protected).

    set public#createFilterByDir to KUnitFileUtils_createFilterByDir@.
    set public#createFilterByFileWithNamePattern to KUnitFileUtils_createFilterByFileWithNamePattern@.
    set public#listFiles to KUnitFileUtils_listFiles@.

    return public.
}

function KUnitFileUtils_createFilterByDir {
    return {
        declare local parameter file.
        if file#isDir() {
            return true.
        }
        return false.
    }.
}

function KUnitFileUtils_createFilterByFileWithNamePattern {
    declare local parameter namePattern.
    return {
        declare local parameter file.
        if not file#isFile() {
            return false.
        }
        local pathString is file#getPathString().
        if not pathString:matchespattern(namePattern) {
            return false.
        }
        return true.
    }.
}

// List files and directories from specified directory.
// Return: KOS list of KUnitFile objects
function KUnitFileUtils_listFiles {
    declare local parameter
        dir,                    // KUnitFile with directory to scan.
        filter is {             // Function for file filtering. Should get
                                // KUnitFile instance as argument and return
                                // true if this file should be included
                                // to result set.
            declare local parameter f.
            return true.
        },
        recursive is false,     // Boolean flag to enable recursive
                                // scan of sub directories.
        result is list().       // Pass the list to append found files
    
    if not dir#isDir() {
        return result.
    }
        
    if recursive {
        local dirFilter is KUnitFileUtils_createFilterByDir().
        for subDir in KUnitFileUtils_listFiles(dir, dirFilter, false) {
            KUnitFileUtils_listFiles(subDir, filter, true, result).
        }
    }

    if dir#isDir() {    
        local vol is dir#getVolumeKOS().
        local dirVI is vol:open(dir#getPathStringWoVol()).
        local dirPath is dir#getPath().
        for vi in dirVI {
            local file is KUnitFile(dirPath:combine(vi:name)).
            if filter(file) {
                result:add(file).
            }
        }
    }
    
    return result.
}
