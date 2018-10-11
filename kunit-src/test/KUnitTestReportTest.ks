// Test of KUnitTestReport class

runoncepath("kunit/class/KUnitTestReport").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitEventBuilder").

function KUnitTestReportTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitTestReportTest").
       
    local public is KUnitTest("KUnitTestReportTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#testObject to -1.
    set private#eventBuilder to -1.
    set private#testCaseReport1 to -1.
    set private#testCaseReport2 to -1.
    set private#testCaseReport3 to -1.
    set private#testCaseReports to -1.
    set private#fillUpReportsWithTestData to KUnitTestReportTest_fillUpReportsWithTestData@:bind(public, private).
    
    set protected#setUp to KUnitTestReportTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitTestReportTest_tearDown@:bind(private, parentProtected).

    set public#testCtor to KUnitTestReportTest_testCtor@:bind(public, private).
    set public#testGetTotalAssertionCount to KUnitTestReportTest_testGetTotalAssertionCount@:bind(public, private).
    set public#testGetSuccessAssertionCount to KUnitTestReportTest_testGetSuccessAssertionCount@:bind(public, private).
    set public#testGetFailureAssertionCount to KUnitTestReportTest_testGetFailureAssertionCount@:bind(public, private).
    set public#testGetTotalTestCaseCount to KUnitTestReportTest_testGetTotalTestCaseCount@:bind(public, private).
    set public#testGetSucceededTestCaseCount to KUnitTestReportTest_testGetSucceededTestCaseCount@:bind(public, private).
    set public#testGetFailedTestCaseCount to KUnitTestReportTest_testGetFailedTestCaseCount@:bind(public, private).
    set public#testIsFailed to KUnitTestReportTest_testIsFailed@:bind(public, private).
    set public#testHasErrors to KUnitTestReportTest_testHasErrors@:bind(public, private).
    set public#testGetErrorCount to KUnitTestReportTest_testGetErrorCount@:bind(public, private).
    set public#testGetFailures to KUnitTestReportTest_testGetFailures@:bind(public, private).
    set public#testGetErrors to KUnitTestReportTest_testGetErrors@:bind(public, private).
    set public#testAggregateEvent_NewTestCase to KUnitTestReportTest_testAggregateEvent_NewTestCase@:bind(public, private).
    set public#testAggregateEvent_OldTestCase to KUnitTestReportTest_testAggregateEvent_OldTestCase@:bind(public, private).
    set public#testAggregateEvent_TestWideEvent to KUnitTestReportTest_testAggregateEvent_TestWideEvent@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    return public.
}

function KUnitTestReportTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    local eventBuilder is KUnitEventBuilder().
    eventBuilder#setTestName("FooTest").
    set private#eventBuilder to eventBuilder.
    set private#testCaseReport1 to KUnitTestCaseReport("FooTest", "testCase1").
    set private#testCaseReport2 to KUnitTestCaseReport("FooTest", "testCase2").
    set private#testCaseReport3 to KUnitTestCaseReport("FooTest", "testCase3").
    local testCaseReports is lexicon().
    set private#testCaseReports to testCaseReports.
    set private#testObject to KUnitTestReport("FooTest", testCaseReports).
    
    return true.
}

function KUnitTestReportTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testCaseReport3:clear().
    private#testCaseReport2:clear().
    private#testCaseReport1:clear().
    private#eventBuilder:clear().
    private#testObject:clear().
    
    parentProtected#tearDown().
}

function KUnitTestReportTest_fillUpReportsWithTestData {
    declare local parameter public, private.

    local testCaseReports is private#testCaseReports.
    set testCaseReports["testCase1"] to private#testCaseReport1.
    set testCaseReports["testCase2"] to private#testCaseReport2.
    set testCaseReports["testCase3"] to private#testCaseReport3.
    
    local eventBuilder is private#eventBuilder.
    
    eventBuilder#setTestCaseName("testCase1").
    private#testCaseReport1#aggregateEvent(eventBuilder#buildSuccess()).
    eventBuilder#setTestCaseName("testCase2").
    private#testCaseReport2#aggregateEvent(eventBuilder#buildSuccess()).
    private#testCaseReport2#aggregateEvent(eventBuilder#buildFailure("foo error")).
    eventBuilder#setTestCaseName("testCase3").
    private#testCaseReport3#aggregateEvent(eventBuilder#buildError("foobar error")).
    private#testCaseReport3#aggregateEvent(eventBuilder#buildSuccess()).
    private#testCaseReport3#aggregateEvent(eventBuilder#buildFailure("hello")).
    
}

function KUnitTestReportTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    if not public#assertEquals("KUnitTestReport", object#getClassName()) return.
    if not public#assertEquals("FooTest", object#getTestName()) return.
    if not public#assertEquals(0, object#getTotalAssertionCount()) return.
    if not public#assertEquals(0, object#getSuccessAssertionCount()) return.
    if not public#assertEquals(0, object#getFailureAssertionCount()) return.
    if not public#assertEquals(0, object#getTotalTestCaseCount()) return.
    if not public#assertEquals(0, object#getSucceededTestCaseCount()) return.
    if not public#assertEquals(0, object#getFailedTestCaseCount()) return.
    if not public#assertEquals(0, object#getErrorCount()) return.
    if not public#assertFalse(object#isFailed()) return.
    if not public#assertFalse(object#hasErrors()) return.
    local expectedFailures is list().
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return.
    local expectedErrors is list().
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
}

function KUnitTestReportTest_testGetTotalAssertionCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.
    
    if not public#assertEquals(5, object#getTotalAssertionCount()) return.
}

function KUnitTestReportTest_testGetSuccessAssertionCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(3, object#getSuccessAssertionCount()) return.    
}

function KUnitTestReportTest_testGetFailureAssertionCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(2, object#getFailureAssertionCount()) return.    
}

function KUnitTestReportTest_testGetTotalTestCaseCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(3, object#getTotalTestCaseCount()) return.
}

function KUnitTestReportTest_testGetSucceededTestCaseCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(1, object#getSucceededTestCaseCount()) return.
}

function KUnitTestReportTest_testGetFailedTestCaseCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(2, object#getFailedTestCaseCount()) return.
}

function KUnitTestReportTest_testIsFailed {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertTrue(object#isFailed()) return.
    
    private#testCaseReports:remove("testCase2").
    private#testCaseReports:remove("testCase3").
    
    if not public#assertFalse(object#isFailed()) return.
}

function KUnitTestReportTest_testHasErrors {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertTrue(object#hasErrors()) return.

    private#testCaseReports:remove("testCase3").

    if not public#assertFalse(object#hasErrors()) return.
}

function KUnitTestReportTest_testGetErrorCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.
    
    if not public#assertEquals(1, object#getErrorCount()) return.
    
    private#testCaseReports:remove("testCase3").
    
    if not public#assertEquals(0, object#getErrorCount()) return.
}

function KUnitTestReportTest_testGetFailures {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.
    local eventBuilder is private#eventBuilder.
    
    local expectedFailures is list().
    eventBuilder#setTestCaseName("testCase2").
    expectedFailures:add(eventBuilder#buildFailure("foo error", "", "assertion[1]failure")).
    eventBuilder#setTestCaseName("testCase3").
    expectedFailures:add(eventBuilder#buildFailure("hello", "", "assertion[1]failure")).
    
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return.
    
}

function KUnitTestReportTest_testGetErrors {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.
    local eventBuilder is private#eventBuilder.

    local expectedErrors is list().
    eventBuilder#setTestCaseName("testCase3").
    expectedErrors:add(eventBuilder#buildError("foobar error")).
    
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
}

function KUnitTestReportTest_testAggregateEvent_OldTestCase {
    declare local parameter public, private.
    
    local object is private#testObject.
    local eventBuilder is private#eventBuilder.
    eventBuilder#setTestCaseName("testCase1").
    set private#testCaseReports["testCase1"] to private#testCaseReport1.
    local capture is -1.
    set private#testCaseReport1#aggregateEvent to {
        declare local parameter event.
        set capture to event.
    }.
    
    local expected is eventBuilder#buildSuccess().
    object#aggregateEvent(expected).
    
    if not public#assertObjectEquals(expected, capture) return.
}

function KUnitTestReportTest_testAggregateEvent_NewTestCase {
    declare local parameter public, private.

    // We can't test this case using mocks because we do not
    // use a factory to instantiate new test case reports.
    // Therefore only state-driven test is possible.

    local object is private#testObject.
    local eventBuilder is private#eventBuilder.
    eventBuilder#setTestCaseName("testCase1").

    local expected is eventBuilder#buildSuccess().
    object#aggregateEvent(expected).

    // Let's check the state of whole report
    // New test case report should occur in the registry
    if not public#assertTrue(private#testCaseReports:haskey("testCase1")) return.
    
    if not public#assertEquals("FooTest", object#getTestName()) return.
    if not public#assertEquals(1, object#getTotalAssertionCount()) return.
    if not public#assertEquals(1, object#getSuccessAssertionCount()) return.
    if not public#assertEquals(0, object#getFailureAssertionCount()) return.
    if not public#assertEquals(1, object#getTotalTestCaseCount()) return.
    if not public#assertEquals(1, object#getSucceededTestCaseCount()) return.
    if not public#assertEquals(0, object#getFailedTestCaseCount()) return.
    if not public#assertEquals(0, object#getErrorCount()) return.
    if not public#assertFalse(object#isFailed()) return.
    if not public#assertFalse(object#hasErrors()) return.
    local expectedFailures is list().
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return.
    local expectedErrors is list().
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
}

function KUnitTestReportTest_testAggregateEvent_TestWideEvent {
    declare local parameter public, private.
    
    // A test-wide event means that event does not belong to concrete test case.
    // Such events shouldn't be passed to test case reports.
    // If they are errors, they should be accumulated in error counter of test
    // report. Otherwise they should be ignored.
    
    local object is private#testObject.
    local eventBuilder is private#eventBuilder.
    eventBuilder#setTestCaseName("").

    local expected is eventBuilder#buildError("Test error").
    object#aggregateEvent(expected).
    
    // New test case reports shouldn't be added
    if not public#assertEquals(0, private#testCaseReports:length) return.
    
    // Let's check object state.
    // It should contain error but that error should not belong to any test case
    if not public#assertEquals("FooTest", object#getTestName()) return.
    if not public#assertEquals(0, object#getTotalAssertionCount()) return.
    if not public#assertEquals(0, object#getSuccessAssertionCount()) return.
    if not public#assertEquals(0, object#getFailureAssertionCount()) return.
    if not public#assertEquals(0, object#getTotalTestCaseCount()) return.
    if not public#assertEquals(0, object#getSucceededTestCaseCount()) return.
    if not public#assertEquals(0, object#getFailedTestCaseCount()) return.
    if not public#assertEquals(1, object#getErrorCount()) return.
    if not public#assertTrue(object#isFailed()) return.
    if not public#assertTrue(object#hasErrors()) return.
    local expectedFailures is list().
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return.
    local expectedErrors is list().
    expectedErrors:add(eventBuilder#buildError("Test error")).
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
}
