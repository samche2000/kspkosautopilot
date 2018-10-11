// Test of KUnitTestCaseReport class

runoncepath("kunit/class/KUnitTestCaseReport").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitEventBuilder").

function KUnitTestCaseReportTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitTestCaseReportTest").
       
    local public is KUnitTest("KUnitTestCaseReportTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#testObject to -1.
    set private#eventBuilder to -1.
    
    set protected#setUp to KUnitTestCaseReportTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitTestCaseReportTest_tearDown@:bind(private, parentProtected).

    set public#testCtor to KUnitTestCaseReportTest_testCtor@:bind(public, private).
    set public#testAggregateEvent to KUnitTestCaseReportTest_testAggregateEvent@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    return public.
}

function KUnitTestCaseReportTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    set private#testObject to KUnitTestCaseReport("FooTest", "testCase1").
    local eventBuilder is KUnitEventBuilder().
    eventBuilder#setTestName("FooTest").
    eventBuilder#setTestCaseName("testCase1").
    set private#eventBuilder to eventBuilder.
    
    return true.
}

function KUnitTestCaseReportTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    private#eventBuilder:clear().
    
    parentProtected#tearDown().
}

function KUnitTestCaseReportTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    if not public#assertEquals("KUnitTestCaseReport", object#getClassName()) return.
    if not public#assertEquals("FooTest", object#getTestName()) return.
    if not public#assertEquals("testCase1", object#getTestCaseName()) return.
    if not public#assertEquals(0, object#getAssertionCount()) return.
    if not public#assertEquals(0, object#getSuccessCount()) return.
    if not public#assertEquals(0, object#getFailureCount()) return.
    if not public#assertEquals(0, object#getErrorCount()) return.
    if not public#assertFalse(object#hasErrors()) return.
    if not public#assertFalse(object#isFailed()) return.
    local expectedFailures is list().
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return.
}

function KUnitTestCaseReportTest_testAggregateEvent {
    declare local parameter public, private.
    
    local object is private#testObject.
    local builder is private#eventBuilder.
    local expectedFailures is list().
    local expectedErrors is list().
    
    local event is builder#buildSuccess().
    object#aggregateEvent(event).
    
    if not public#assertEquals(1, object#getAssertionCount()) return.
    if not public#assertEquals(1, object#getSuccessCount()) return.
    if not public#assertEquals(0, object#getFailureCount()) return.
    if not public#assertEquals(0, object#getErrorCount()) return.
    if not public#assertFalse(object#hasErrors()) return.
    if not public#assertFalse(object#isFailed()) return.
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return. 
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
    
    local event is builder#buildFailure("foobar error").
    object#aggregateEvent(event).
    
    if not public#assertEquals(2, object#getAssertionCount()) return.
    if not public#assertEquals(1, object#getSuccessCount()) return.
    if not public#assertEquals(1, object#getFailureCount()) return.
    if not public#assertEquals(0, object#getErrorCount()) return.
    if not public#assertFalse(object#hasErrors()) return.
    if not public#assertTrue(object#isFailed()) return.
    expectedFailures:add(builder#buildFailure("foobar error", "", "assertion[1]failure")).
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return. 
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
    
    local event is builder#buildSuccess().
    object#aggregateEvent(event).
    
    if not public#assertEquals(3, object#getAssertionCount()) return.
    if not public#assertEquals(2, object#getSuccessCount()) return.
    if not public#assertEquals(1, object#getFailureCount()) return.
    if not public#assertEquals(0, object#getErrorCount()) return.
    if not public#assertFalse(object#hasErrors()) return.
    if not public#assertTrue(object#isFailed()) return.
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return.
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
    
    local event is builder#buildFailure("zulu24 error").
    object#aggregateEvent(event).

    if not public#assertEquals(4, object#getAssertionCount()) return.
    if not public#assertEquals(2, object#getSuccessCount()) return.
    if not public#assertEquals(2, object#getFailureCount()) return.
    if not public#assertEquals(0, object#getErrorCount()) return.
    if not public#assertFalse(object#hasErrors()) return.
    if not public#assertTrue(object#isFailed()) return.
    expectedFailures:add(builder#buildFailure("zulu24 error", "", "assertion[3]failure")).
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return.
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
    
    local event is builder#buildError("My error message").
    object#aggregateEvent(event).

    if not public#assertEquals(4, object#getAssertionCount()) return.
    if not public#assertEquals(2, object#getSuccessCount()) return.
    if not public#assertEquals(2, object#getFailureCount()) return.
    if not public#assertEquals(1, object#getErrorCount()) return.
    if not public#assertTrue(object#hasErrors()) return.
    if not public#assertTrue(object#isFailed()) return.
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return.
    expectedErrors:add(builder#buildError("My error message")).
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
}


