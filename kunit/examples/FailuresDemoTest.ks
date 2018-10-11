// This is example of Unit Test which produces failures.
// Run it to see how KUnit output will handle test failures.

runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function FailuresDemoTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(), 
        protected is lexicon().
    className:add("FailuresDemoTest"). 
    
    local public is KUnitTest("FailuresDemoTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set public#testStringsArentEqual to FailuresDemoTest_testStringsArentEqual@:bind(public, private).
    set public#testWhatIfDoNotCheckAssertionResult to FailuresDemoTest_testWhatIfDoNotCheckAssertionResult@:bind(public, private).
    set public#testHowToIdentifyFailureLocation to FailuresDemoTest_testHowToIdentifyFailureLocation@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    return public.
}

function FailuresDemoTest_testStringsArentEqual {
    declare local parameter public, private.

    local expected is "foo".
    local actual is "bar".    
    if not public#assertEquals(expected, actual) return.
    
    public#fail("Will never reach this line").
}

function FailuresDemoTest_testWhatIfDoNotCheckAssertionResult {
    declare local parameter public, private.

    local expected is list("foo").
    local actual is list("bar").
    public#assertListEquals(expected, actual, "You will see").
    public#assertFalse(true, "more output").
    public#assertObjectEquals(KUnitObject(), KUnitObject(), "until test ended").
}

function FailuresDemoTest_testHowToIdentifyFailureLocation {
    declare local parameter public, private.

    local expected is list(KUnitObject()).
    local actual is list(expected[0]).
    if not public#assertObjectListEquals(expected, actual, "Those lists should be equal") return.
    
    if not public#assertTrue(true, "This should not fail") return.
    
    public#assertTrue(false, "Have a look on assertion[X] information.").
    public#assertTrue(false, "You can identify assertion by its index").
    public#assertTrue(false, "which is shown in [] brackets.").
    public#assertTrue(false, "Then find assertion in the test case and fix the problem").
    public#fail("That's easy").
}
