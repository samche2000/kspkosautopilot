// Unit test of KUnitEvent class

runoncepath("kunit/class/KUnitEvent").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function KUnitEventTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitEventTest").
       
    local public is KUnitTest("KUnitEventTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#testObject to -1.
    
    set protected#setUp to KUnitEventTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitEventTest_tearDown@:bind(private, parentProtected).
    
    set public#testCtor to KUnitEventTest_testCtor@:bind(public, private).
    set public#testToString to KUnitEventTest_testToString@:bind(public, private).
    set public#testEquals to KUnitEventTest_testEquals@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    
    return public.
}

function KUnitEventTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    set private#testObject to KUnitEvent("failure", "test msg", "FooTest", "testCase1").
    
    return true.
}

function KUnitEventTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    set private#testObject to -1.
    
    parentProtected#tearDown().
}

function KUnitEventTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.

    if not public#assertEquals("KUnitEvent", object#getClassName()) return.
    if not public#assertEquals("failure", object#getType()) return.
    if not public#assertEquals("test msg", object#getMessage()) return.
    if not public#assertEquals("FooTest", object#getTestName()) return.
    if not public#assertEquals("testCase1", object#getTestCaseName()) return.
}

function KUnitEventTest_testToString {
    declare local parameter public, private.

    local object is private#testObject.

    local expected is "FooTest#testCase1 failure: test msg".
    if not public#assertEquals(expected, object#toString()) return.
    
    local other is KUnitEvent("failure", "test msg", "FooTest").
    local expected is "FooTest failure: test msg".
    if not public#assertEquals(expected, other#toString()) return.
    
    local other is KUnitEvent("failure", "test msg", "", "testCase1").
    local expected is "failure: test msg".
    if not public#assertEquals(expected, other#toString()) return.
    
    local other is KUnitEvent("failure", "", "FooTest", "testCase1").
    local expected is "FooTest#testCase1 failure".
    if not public#assertEquals(expected, other#toString()) return.
}

function KUnitEventTest_testEquals {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    local msg is "Object must be equals to itself".
    if not public#assertTrue(object#equals(object), msg) return.
    
    local other is KUnitEvent("failure", "test msg", "FooTest", "testCase1").
    local msg is "Objects must be equal if all attributes are equal".
    if not public#assertTrue(object#equals(other), msg) return.
    
    local other is KUnitEvent("success", "test msg", "FooTest", "testCase1").
    local msg is "Objects must be not equal if types are not equal".
    if not public#assertFalse(object#equals(other), msg) return.
    
    local other is KUnitEvent("failure", "another message", "FooTest", "testCase1").
    local msg is "Objects must be not equal if messages are not equal".
    if not public#assertFalse(object#equals(other), msg) return.
    
    local other is KUnitEvent("failure", "test msg", "SomeTest", "testCase1").
    local msg is "Objects must be not equal if test names are not equal".
    if not public#assertFalse(object#equals(other), msg) return.
    
    local other is KUnitEvent("failure", "test msg", "FooTest", "myTestCase").
    local msg is "Objects must be not equal if test case names are not equal".
    if not public#assertFalse(object#equals(other), msg) return.
}
