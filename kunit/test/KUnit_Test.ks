// Test of KUnit class

runoncepath("kunit/class/KUnit").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

// We already have KUnitTest class as basis of Test class.
// Let's call this class in a bit different way to not mix them
function KUnit_Test {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnit_Test").
       
    local public is KUnitTest("KUnit_Test", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set public#testGetVersion to KUnit_Test_testGetVersion@:bind(public, private).
    set public#testGetVersionString to KUnit_Test_testGetVersionString@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    return public.
}

function KUnit_Test_testGetVersion {
    declare local parameter public, private.
    
    local expected is "0.0.2".
    local actual is KUnit_getVersion().
    if not public#assertEquals(expected, actual) return.
}

function KUnit_Test_testGetVersionString {
    declare local parameter public, private.

    local expected is "KUnit v0.0.2".
    local actual is KUnit_getVersionString().
    if not public#assertEquals(expected, actual) return.
}
