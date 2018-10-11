// Unit test of KUnitFile class

runoncepath("kunit/class/KUnitFile").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function KUnitFileTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitFileTest").
       
    local public is KUnitTest("KUnitFileTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().

    set protected#setUp to KUnitFileTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitFileTest_tearDown@:bind(private, parentProtected).
    
    set public#testCtor to KUnitFileTest_testCtor@:bind(public, private).
    set public#testGetPathString to KUnitFileTest_testGetPathString@:bind(public, private).
    set public#testGetPathStringWoVol to KUnitFileTest_testGetPathStringWoVol@:bind(public, private).
    set public#testIsExists to KUnitFileTest_testIsExists@:bind(public, private).
    set public#testIsDir to KUnitFileTest_testIsDir@:bind(public, private).
    set public#testIsFile to KUnitFileTest_testIsFile@:bind(public, private).
    set public#testGetVolumeKOS to KUnitFileTest_testGetVolumeKOS@:bind(public, private).
    set public#testToString to KUnitFileTest_testToString@:bind(public, private).
    set public#testEquals to KUnitFileTest_testEquals@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    
    return public.
}

function KUnitFileTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    return true.
}

function KUnitFileTest_tearDown {
    declare local parameter private, parentProtected.
    
    parentProtected#tearDown().
}

function KUnitFileTest_testCtor {
    declare local parameter public, private.
    
    local object is KUnitFile(path("kunit/test/fixture/file0_1.txt")).

    local expected is path("kunit/test/fixture/file0_1.txt").
    local actual is object#getPath().
    if not public#assertEquals(expected, actual) return.
}

function KUnitFileTest_testGetPathString {
    declare local parameter public, private.

    local object is KUnitFile(path("kunit/test/fixture/file0_1.txt")).
    
    local curVol is volume().
    local expected is curVol:name + ":/kunit/test/fixture/file0_1.txt".
    local actual is object#getPathString().
    if not public#assertEquals(expected, actual) return.
}

function KUnitFileTest_testGetPathStringWoVol {
    declare local parameter public, private.

    local object is KUnitFile(path("kunit/test/fixture/file0_1.txt")).

    local expected is "/kunit/test/fixture/file0_1.txt".
    local actual is object#getPathStringWoVol().
    if not public#assertEquals(expected, actual) return.
}

function KUnitFileTest_testIsExists {
    declare local parameter public, private.

    local object is KUnitFile(path("kunit/test/fixture/file0_1.txt")).
    if not public#assertTrue(object#isExists(), "File should exists") return.
    
    local object is KUnitFile(path("kunit/test/fixture/non-existent-file.txt")).
    if not public#assertFalse(object#isExists(), "File shouldn't exists") return.
}

function KUnitFileTest_testIsDir {
    declare local parameter public, private.

    local object is KUnitFile(path("kunit/test/fixture/subdir1")).
    local actual is object#isDir().
    local msg is "The path should be identified as directory".
    if not public#assertTrue(actual, msg) return.
    
    local object is KUnitFile(path("kunit/test/fixture/file0_1.txt")).
    local actual is object#isDir().
    local msg is "File shouldn't be identified as directory".
    if not public#assertFalse(actual, msg) return.
    
    local object is KUnitFile(path("kunit/test/fixture/non-existent-dir")).
    local actual is object#isDir().
    local msg is "Non-existent path shouldn't be identified as directory".
    if not public#assertFalse(actual, msg) return.
}

function KUnitFileTest_testIsFile {
    declare local parameter public, private.
    
    local object is KUnitFile(path("kunit/test/fixture/subdir1")).
    local actual is object#isFile().
    local msg is "Directory shouldn't be identified as file".
    if not public#assertFalse(actual, msg) return.
    
    local object is KUnitFile(path("kunit/test/fixture/file0_1.txt")).
    local actual is object#isFile().
    local msg is "This path should be identified as file".
    if not public#assertTrue(actual, msg) return.

    local object is KUnitFile(path("kunit/test/fixture/non-existent-file.txt")).
    local actual is object#isFile().
    local msg is "Non-existent path shouldn't be identified as file".
    if not public#assertFalse(actual, msg) return.
}

function KUnitFileTest_testGetVolumeKOS {
    declare local parameter public, private.
    
    local object is KUnitFile(path("kunit/test/fixture/subdir1")).
    local expected is volume().
    local actual is object#getVolumeKOS().
    if not public#assertEquals(expected, actual, "Unexpected volume") return.
}

function KUnitFileTest_testToString {
    declare local parameter public, private.
    
    // Given
    local object is KUnitFile(path("kunit/test/fixture/subdir1")).

    // When
    local actual is object#toString().
        
    // Then
    local curVol is volume().
    local expected is "KUnitFile[" + curVol:name + ":/kunit/test/fixture/subdir1" + "]".
    if not public#assertEquals(expected, actual) return.
}

function KUnitFileTest_testEquals {
    declare local parameter public, private.
    
    local object is KUnitFile(path("kunit/test/fixture/subdir1")).
    local actual is object#equals(object).
    local msg is "Object should be equal to itself".
    if not public#assertTrue(actual, msg) return.
    
    local other is KUnitObject().
    local actual is object#equals(other).
    local msg is "Objects of different classes should not be equal".
    if not public#assertFalse(actual, msg) return.
    
    local other is KUnitFile(path("kunit/test/fixture/subdir1")).
    local actual is object#equals(other).
    local msg is "Objects with equivalent paths should be equal".
    if not public#assertTrue(actual, msg) return.
    
    local other is KUnitFile(path("kunit/test/fixture/subdir2")).
    local actual is object#equals(other).
    local msg is "Objects with different paths should not be equal".
    if not public#assertFalse(actual, msg) return.
}
