// Unit test of KUnitCounter class

runoncepath("kunit/class/KUnitCounter").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function KUnitCounterTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitCounterTest").
       
    local public is KUnitTest("KUnitCounterTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#testObject to -1.
    
    set protected#setUp to KUnitCounterTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitCounterTest_tearDown@:bind(private, parentProtected).
    
    set public#testCtor to KUnitCounterTest_testCtor@:bind(public, private).
    set public#testAddFailure to KUnitCounterTest_testAddFailure@:bind(public, private).
    set public#testAddSuccess to KUnitCounterTest_testAddSuccess@:bind(public, private).
    set public#testToString to KUnitCounterTest_testToString@:bind(public, private).
    set public#testEquals to KUnitCounterTest_testEquals@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    
    return public.
}

function KUnitCounterTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    set private#testObject to KUnitCounter().
    
    return true.
}

function KUnitCounterTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    
    parentProtected#tearDown().
}

function KUnitCounterTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.

    if not public#assertEquals("KUnitCounter", object#getClassName()) return.
    local msg is "Total count should be zero".
    if not public#assertEquals(0, object#getTotalCount(), msg) return.
    local msg is "Success count should be zero".
    if not public#assertEquals(0, object#getSuccessCount(), msg) return.
    local msg is "Failure count should be zero".
    if not public#assertEquals(0, object#getFailureCount(), msg) return.
}

function KUnitCounterTest_testAddFailure {
    declare local parameter public, private.

    local object is private#testObject.
    
    object#addFailure().
    
    local msg is "Total count should be 1".
    if not public#assertEquals(1, object#getTotalCount(), msg) return.
    local msg is "Failure count should be 1".
    if not public#assertEquals(1, object#getFailureCount(), msg) return.
    local msg is "Success count should be 0".
    if not public#assertEquals(0, object#getSuccessCount(), msg) return.
    
    object#addFailure().

    local msg is "Total count should be 2".
    if not public#assertEquals(2, object#getTotalCount(), msg) return.
    local msg is "Failure count should be 2".
    if not public#assertEquals(2, object#getFailureCount(), msg) return.
    local msg is "Success count should be 0".
    if not public#assertEquals(0, object#getSuccessCount(), msg) return.
}

function KUnitCounterTest_testAddSuccess {
    declare local parameter public, private.

    local object is private#testObject.

    object#addSuccess().
    
    local msg is "Total count should be 1".
    if not public#assertEquals(1, object#getTotalCount(), msg) return.
    local msg is "Failure count should be 0".
    if not public#assertEquals(0, object#getFailureCount(), msg) return.
    local msg is "Success count should be 1".
    if not public#assertEquals(1, object#getSuccessCount(), msg) return.

    object#addSuccess().
    
    local msg is "Total count should be 2".
    if not public#assertEquals(2, object#getTotalCount(), msg) return.
    local msg is "Failure count should be 0".
    if not public#assertEquals(0, object#getFailureCount(), msg) return.
    local msg is "Success count should be 2".
    if not public#assertEquals(2, object#getSuccessCount(), msg) return.
}

function KUnitCounterTest_testToString {
    declare local parameter public, private.

    local object is private#testObject.
    
    object#addFailure().
    object#addSuccess().
    object#addSuccess().
    
    local expected is "[total=3 success=2 failure=1]".
    local actual is object#toString().
    if not public#assertEquals(expected, actual) return.
}

function KUnitCounterTest_testEquals {
    declare local parameter public, private.
    
    local object is private#testObject.
    object#addFailure().
    object#addFailure().
    object#addSuccess().
    
    local msg is "Object should equals to itself".
    if not public#assertTrue(object#equals(object), msg) return.
    
    local other is KUnitCounter().
    other#addFailure().
    other#addFailure().
    other#addSuccess().
    local msg is "Objects should be equal if all attributes are equal".
    if not public#assertTrue(object#equals(other), msg) return.
    
    object#addFailure().
    local msg is "Objects should not be equal if total count is not equal".
    if not public#assertFalse(object#equals(other), msg) return.
    
    other#addSuccess().
    local msg is "Objects should not be equals if failure count is not equals".
    if not public#assertFalse(object#equals(other), msg) return.
}
