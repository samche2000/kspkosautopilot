// Unit test of KUnitFileUtils class

runoncepath("kunit/class/KUnitFileUtils").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function KUnitFileUtilsTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitFileUtilsTest").
       
    local public is KUnitTest("KUnitFileUtilsTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set protected#setUp to KUnitFileUtilsTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitFileUtilsTest_tearDown@:bind(private, parentProtected).
    
    set private#testObject to -1.
    
    set public#testCtor to KUnitFileUtilsTest_testCtor@:bind(public, private).
    set public#testCreateFilterByDir to KUnitFileUtilsTest_testCreateFilterByDir@:bind(public, private).
    set public#testCreateFilterByFileWithNamePattern to KUnitFileUtilsTest_testCreateFilterByFileWithNamePattern@:bind(public, private).
    set public#testListFiles_Flat to KUnitFileUtilsTest_testListFiles_Flat@:bind(public, private).
    set public#testListFiles_Recursive to KUnitFileUtilsTest_testListFiles_Recursive@:bind(public, private).
    
    public#addCasesByNamePattern("^test").    
    return public.
}

function KUnitFileUtilsTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    set private#testObject to KUnitFileUtils().
    
    return true.
}

function KUnitFileUtilsTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    
    parentProtected#tearDown().
}

function KUnitFileUtilsTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    local actual is object#getClassName().
    local expected is "KUnitFileUtils".
    if not public#assertEquals(expected, actual) return.
}

function KUnitFileUtilsTest_testCreateFilterByDir {
    declare local parameter public, private.
    
    local object is private#testObject.
    local filter is object#createFilterByDir().
        
    local file is KUnitFile(path("kunit/test/fixture/subdir1/file1_1.txt")).
    local actual is filter(file).
    if not public#assertFalse(actual) return.
    
    local file is KUnitFile(path("kunit/test/fixture/subdir1")).
    local actual is filter(file).
    if not public#assertTrue(actual) return.
    
    local file is KUnitFile(path("kunit/test/fixture")).
    local actual is filter(file).
    if not public#assertTrue(actual) return.
    
    local file is KUnitFile(path("kunit/test/fixture/subdir2/file2_1.txt")).
    local actual is filter(file).
    if not public#assertFalse(actual) return.
}

function KUnitFileUtilsTest_testCreateFilterByFileWithNamePattern {
    declare local parameter public, private.
    
    local object is private#testObject.
    local filter is object#createFilterByFileWithNamePattern("file\d_1\.txt$").
    
    local file is KUnitFile(path("kunit/test/fixture/subdir1/file1_1.txt")).
    local actual is filter(file).
    if not public#assertTrue(actual) return.
    
    local file is KUnitFile(path("kunit/test/fixture/subdir1")).
    local actual is filter(file).
    if not public#assertFalse(actual) return.
    
    local file is KUnitFile(path("kunit/test/fixture/subdir1/file1_2.txt")).
    local actual is filter(file).
    if not public#assertFalse(actual) return.
    
    local file is KUnitFile(path("kunit/test/fixture/non-existent-file1_1.txt")).
    local actual is filter(file).
    if not public#assertFalse(actual) return.
}

function KUnitFileUtilsTest_testListFiles_Flat {
    declare local parameter public, private.
    
    local object is private#testObject.

    local filter is object#createFilterByDir().
    local dir is KUnitFile(path("kunit/test/fixture")).
    local actual is object#listFiles(dir, filter).
    
    local expected is list().
    expected:add(KUnitFile(path("kunit/test/fixture/subdir1"))).
    expected:add(KUnitFile(path("kunit/test/fixture/subdir2"))).
    if not public#assertObjectListEquals(expected, actual) return.
 }

function KUnitFileUtilsTest_testListFiles_Recursive {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    local filter is object#createFilterByFileWithNamePattern("file\d_(1|3)\.txt$").
    local dir is KUnitFile(path("kunit/test/fixture")).
    local actual is object#listFiles(dir, filter, true).
 
    local expected is list().
    expected:add(KUnitFile(path("kunit/test/fixture/subdir1/file1_1.txt"))).
    expected:add(KUnitFile(path("kunit/test/fixture/subdir2/file2_1.txt"))).
    expected:add(KUnitFile(path("kunit/test/fixture/file0_1.txt"))).
    expected:add(KUnitFile(path("kunit/test/fixture/file0_3.txt"))).
    if not public#assertObjectListEquals(expected, actual) return.
}
