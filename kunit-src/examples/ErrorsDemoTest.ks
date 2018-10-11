// This is example of Unit Test which produces errors.
// Run it to see how KUnit output will handle test errors.

runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function ErrorsDemoTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(), 
        protected is lexicon().
    className:add("ErrorsDemoTest").
    
    local public is KUnitTest("ErrorsDemoTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set protected#setUp to ErrorsDemoTest_setUp@:bind(private, parentProtected).
    
    set public#testErrorsArentFailures to ErrorsDemoTest_testErrorsArentFailures@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    return public.
}

function ErrorsDemoTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    // Errors are related to test execution, not to code under test. Error means
    // you cannot proceed with the test execution and it should be interrupted.
    // This is just one case when it may be useful. If setup of your test case
    // failed, then return false and test execution will be stopped.
    // After all you will see appropriate error line in the KUnit report.
    return false.
}

function ErrorsDemoTest_testErrorsArentFailures {
    declare local parameter public, private.
    
    if not public#assertTrue(true, "Now you know that.") return.
}
