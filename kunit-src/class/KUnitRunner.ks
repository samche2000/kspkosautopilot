// Test runner

runoncepath("kunit/class/KUnitFileUtils").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitEventBuilder").

function KUnitRunner {
    declare local parameter
        reporter is KUnitReporter(),
        filePattern is "test\.ksm?$",
        fileUtils is KUnitFileUtils(),
        className is list(),
        protected is lexicon().
    className:add("KUnitRunner").
    
    local public is KUnitObject(className, protected).
    local private is lexicon().
    
    set private#tempFilePath to path("kunit/tmp/kunit-last-run.ks").
    set private#reporter to reporter.
    set private#filePattern to filePattern.
    set private#fileUtils to fileUtils.
    
    set protected#prepareRunfile to KUnitRunner_prepareRunfile@:bind(public, protected, private).
    set protected#appendToRunfile to KUnitRunner_appendToRunfile@:bind(public, protected, private).
    set protected#startRunfile to KUnitRunner_startRunfile@:bind(public, protected, private).
    set protected#cleanupRunfile to KUnitRunner_cleanupRunfile@:bind(public, protected, private).
    
    set public#getTestNameByFile to KUnitRunner_getTestNameByFile@:bind(public, protected, private).
    set public#suite to KUnitRunner_suite@:bind(public, protected, private).
    set public#single to KUnitRunner_single@:bind(public, protected, private).
        
    return public.
}

function KUnitRunner_suite {
    declare local parameter public, protected, private,
        suiteDir,               // KUnitFile instance
        testNamePattern is "",
        testCasePattern is "".
    if not suiteDir#isDir() { // fail-fast
        return.
    }
    local reporter is private#reporter.
    local fileUtils is private#fileUtils.
    
    protected#prepareRunfile().
    local testFileFilter is fileUtils#createFilterByFileWithNamePattern(private#filePattern).
    for file in fileUtils#listFiles(suiteDir, testFileFilter, true) {
        local testName is public#getTestNameByFile(file).
        if testNamePattern:length = 0 or testName:matchespattern(testNamePattern) {
            protected#appendToRunfile(file).
        }
    }
    protected#startRunfile(testCasePattern).
    protected#cleanupRunfile().
}

function KUnitRunner_single {
    declare local parameter public, protected, private,
        testFile,               // KUnitFile instance
        testCasePattern is "".
    if not testFile#isFile() { // fail-fast
        return.
    }
    local reporter is private#reporter.
    local fileUtils is private#fileUtils.
    
    protected#prepareRunfile().
    protected#appendToRunfile(testFile).
    protected#startRunfile(testCasePattern).
    protected#cleanupRunfile().
}

function KUnitRunner_prepareRunfile {
    declare local parameter public, protected, private.
    
    local tempFilePath is private#tempFilePath.
    if exists(tempFilePath) {
        deletepath(tempFilePath).
    }
    log "parameter reporter, testCasePattern." to tempFilePath.    
}

function KUnitRunner_appendToRunfile {
    declare local parameter public, protected, private,
        testFile.           // KUnitFile instance
        
    local testName is public#getTestNameByFile(testFile). 
    local tempFilePath is private#tempFilePath.
    log "local test is " + testName + "(reporter)." to tempFilePath.
    log "test#run(testCasePattern)." to tempFilePath.
    
    runoncepath(testFile#getPath()).
}

function KUnitRunner_startRunfile {
    declare local parameter public, protected, private,
        testCasePattern.
    local tempFilePath is private#tempFilePath.
    local reporter is private#reporter.
    runpath(tempFilePath, reporter, testCasePattern).
}

function KUnitRunner_cleanupRunfile {
    declare local parameter public, protected, private.    
}

function KUnitRunner_getTestNameByFile {
    declare local parameter public, protected, private,
        testFile.   // KUnitFile instance

    local testPath is testFile#getPath().
    local testName is testPath:name.
    local dotIndex is testName:findlast(".").
    if dotIndex > 0 {
        set testName to testName:substring(0, dotIndex).
    }
    return testName.
}
