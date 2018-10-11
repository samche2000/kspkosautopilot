// Test of KUnitTestReport class

runoncepath("kunit/class/KUnitTestSuiteReport").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitEventBuilder").

function KUnitTestSuiteReportTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitSuiteTestReportTest").
       
    local public is KUnitTest("KUnitTestSuiteReportTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#testObject to -1.
    set private#eventBuilder to -1.
    set private#testReport1 to -1.
    set private#testReport2 to -1.
    set private#testReport3 to -1.
    set private#testReports to -1.
    set private#fillUpReportsWithTestData to KUnitTestSuiteReportTest_fillUpReportsWithTestData@:bind(public, private).
    
    set protected#setUp to KUnitTestSuiteReportTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitTestSuiteReportTest_tearDown@:bind(private, parentProtected).
    
    set public#testCtor to KUnitTestSuiteReportTest_testCtor@:bind(public, private).
    set public#testGetTotalAssertionCount to KUnitTestSuiteReportTest_testGetTotalAssertionCount@:bind(public, private).
    set public#testGetSuccessAssertionCount to KUnitTestSuiteReportTest_testGetSuccessAssertionCount@:bind(public, private).
    set public#testGetFailureAssertionCount to KUnitTestSuiteReportTest_testGetFailureAssertionCount@:bind(public, private).
    set public#testGetTotalTestCaseCount to KUnitTestSuiteReportTest_testGetTotalTestCaseCount@:bind(public, private).
    set public#testGetSucceededTestCaseCount to KUnitTestSuiteReportTest_testGetSucceededTestCaseCount@:bind(public, private).
    set public#testGetFailedTestCaseCount to KUnitTestSuiteReportTest_testGetFailedTestCaseCount@:bind(public, private).
    set public#testGetTotalTestCount to KUnitTestSuiteReportTest_testGetTotalTestCount@:bind(public, private).
    set public#testGetSucceededTestCount to KUnitTestSuiteReportTest_testGetSucceededTestCount@:bind(public, private).
    set public#testGetFailedTestCount to KUnitTestSuiteReportTest_testGetFailedTestCount@:bind(public, private).
    set public#testIsFailed to KUnitTestSuiteReportTest_testIsFailed@:bind(public, private).
    set public#testHasErrors to KUnitTestSuiteReportTest_testHasErrors@:bind(public, private).
    set public#testGetErrorCount to KUnitTestSuiteReportTest_testGetErrorCount@:bind(public, private).
    set public#testGetFailures to KUnitTestSuiteReportTest_testGetFailures@:bind(public, private).
    set public#testGetErrors to KUnitTestSuiteReportTest_testGetErrors@:bind(public, private).
    set public#testAggregateEvent_OldTest to KUnitTestSuiteReportTest_testAggregateEvent_OldTest@:bind(public, private).
    set public#testAggregateEvent_NewTest to KUnitTestSuiteReportTest_testAggregateEvent_NewTest@:bind(public, private).
    set public#testAggregateEvent_SuiteWideEvent to KUnitTestSuiteReportTest_testAggregateEvent_SuiteWideEvent@:bind(public, private).

    public#addCasesByNamePattern("^test").
    return public.
}

function KUnitTestSuiteReportTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    local eventBuilder is KUnitEventBuilder().
    set private#eventBuilder to eventBuilder.
    set private#testReport1 to KUnitTestReport("FooTest").
    set private#testReport2 to KUnitTestReport("BarTest").
    set private#testReport3 to KUnitTestReport("ZooTest").
    set private#testReports to lexicon().
    set private#testObject to KUnitTestSuiteReport(private#testReports).
    
    return true.
}

function KUnitTestSuiteReportTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testReport3:clear().
    private#testReport2:clear().
    private#testReport1:clear().
    private#eventBuilder:clear().
    private#testObject:clear().
    
    parentProtected#tearDown().
}

function KUnitTestSuiteReportTest_fillUpReportsWithTestData {
    declare local parameter public, private.

    local testReports is private#testReports.
    set testReports["FooTest"] to private#testReport1.
    set testReports["BarTest"] to private#testReport2.
    set testReports["ZooTest"] to private#testReport3.
    
    local eventBuilder is private#eventBuilder.

    eventBuilder#setTestName("FooTest").    
    eventBuilder#setTestCaseName("testCase1").
    private#testReport1#aggregateEvent(eventBuilder#buildSuccess()).
    eventBuilder#setTestName("BarTest").
    eventBuilder#setTestCaseName("testCase1").
    private#testReport2#aggregateEvent(eventBuilder#buildSuccess()).
    private#testReport2#aggregateEvent(eventBuilder#buildFailure("foo error")).
    eventBuilder#setTestName("ZooTest").
    eventBuilder#setTestCaseName("testCase1").
    private#testReport3#aggregateEvent(eventBuilder#buildError("foobar error")).
    private#testReport3#aggregateEvent(eventBuilder#buildSuccess()).
    eventBuilder#setTestCaseName("testCase2").
    private#testReport3#aggregateEvent(eventBuilder#buildFailure("hello")).
    
}

function KUnitTestSuiteReportTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    if not public#assertEquals("KUnitTestSuiteReport", object#getClassName()) return.
    if not public#assertEquals(0, object#getTotalAssertionCount()) return.
    if not public#assertEquals(0, object#getSuccessAssertionCount()) return.
    if not public#assertEquals(0, object#getFailureAssertionCount()) return.
    if not public#assertEquals(0, object#getTotalTestCaseCount()) return.
    if not public#assertEquals(0, object#getSucceededTestCaseCount()) return.
    if not public#assertEquals(0, object#getFailedTestCaseCount()) return.
    if not public#assertEquals(0, object#getTotalTestCount()) return.
    if not public#assertEquals(0, object#getSucceededTestCount()) return.
    if not public#assertEquals(0, object#getFailedTestCount()) return.
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

function KUnitTestSuiteReportTest_testGetTotalAssertionCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(5, object#getTotalAssertionCount()) return.
}

function KUnitTestSuiteReportTest_testGetSuccessAssertionCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(3, object#getSuccessAssertionCount()) return.
}

function KUnitTestSuiteReportTest_testGetFailureAssertionCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(2, object#getFailureAssertionCount()) return.
}

function KUnitTestSuiteReportTest_testGetTotalTestCaseCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(4, object#getTotalTestCaseCount()) return.
}

function KUnitTestSuiteReportTest_testGetSucceededTestCaseCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(1, object#getSucceededTestCaseCount()) return.
}

function KUnitTestSuiteReportTest_testGetFailedTestCaseCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(3, object#getFailedTestCaseCount()) return.
}

function KUnitTestSuiteReportTest_testGetTotalTestCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(3, object#getTotalTestCount()) return.
}

function KUnitTestSuiteReportTest_testGetSucceededTestCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(1, object#getSucceededTestCount()) return.
}

function KUnitTestSuiteReportTest_testGetFailedTestCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(2, object#getFailedTestCount()) return.
}

function KUnitTestSuiteReportTest_testIsFailed {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertTrue(object#isFailed()) return.
    
    private#testReports:remove("BarTest").
    private#testReports:remove("ZooTest").
    
    if not public#assertFalse(object#isFailed()) return.
}


function KUnitTestSuiteReportTest_testHasErrors {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertTrue(object#hasErrors()) return.
    
    private#testReports:remove("ZooTest").
    
    if not public#assertFalse(object#hasErrors()) return.
}

function KUnitTestSuiteReportTest_testGetErrorCount {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.

    if not public#assertEquals(1, object#getErrorCount()) return.
    
    private#testReports:remove("ZooTest").
    
    if not public#assertEquals(0, object#getErrorCount()) return.
}

function KUnitTestSuiteReportTest_testGetFailures {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.
    local eventBuilder is private#eventBuilder.
    
    local expectedFailures is list().
    eventBuilder#setTestName("BarTest").
    eventBuilder#setTestCaseName("testCase1").
    expectedFailures:add(eventBuilder#buildFailure("foo error", "", "assertion[1]failure")).
    eventBuilder#setTestName("ZooTest").
    eventBuilder#setTestCaseName("testCase2").
    expectedFailures:add(eventBuilder#buildFailure("hello", "", "assertion[0]failure")).
    
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures).
}

function KUnitTestSuiteReportTest_testGetErrors {
    declare local parameter public, private.
    private#fillUpReportsWithTestData().
    
    local object is private#testObject.
    local eventBuilder is private#eventBuilder.
    local expectedErrors is list().
    eventBuilder#setTestName("ZooTest").
    eventBuilder#setTestCaseName("testCase1").
    expectedErrors:add(eventBuilder#buildError("foobar error")).
    
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
}

function KUnitTestSuiteReportTest_testAggregateEvent_OldTest {
    declare local parameter public, private.
    
    local object is private#testObject.
    local eventBuilder is private#eventBuilder.
    eventBuilder#setTestName("FooTest").
    eventBuilder#setTestCaseName("testCase1").
    set private#testReports["FooTest"] to private#testReport1.
    local capture is -1.
    set private#testReport1#aggregateEvent to {
        declare local parameter event.
        set capture to event.
    }.
    
    local expected is eventBuilder#buildSuccess().
    object#aggregateEvent(expected).
    
    if not public#assertObjectEquals(expected, capture) return.
}

function KUnitTestSuiteReportTest_testAggregateEvent_NewTest {
    declare local parameter public, private.
    
    local object is private#testObject.
    local eventBuilder is private#eventBuilder.
    eventBuilder#setTestName("FooTest").
    eventBuilder#setTestCaseName("testCase1").

    local expected is eventBuilder#buildSuccess().
    object#aggregateEvent(expected).
    
    if not public#assertTrue(private#testReports:haskey("FooTest")) return.
    
    if not public#assertEquals(1, object#getTotalAssertionCount()) return.
    if not public#assertEquals(1, object#getSuccessAssertionCount()) return.
    if not public#assertEquals(0, object#getFailureAssertionCount()) return.
    if not public#assertEquals(1, object#getTotalTestCaseCount()) return.
    if not public#assertEquals(1, object#getSucceededTestCaseCount()) return.
    if not public#assertEquals(0, object#getFailedTestCaseCount()) return.
    if not public#assertEquals(1, object#getTotalTestCount()) return.
    if not public#assertEquals(1, object#getSucceededTestCount()) return.
    if not public#assertEquals(0, object#getFailedTestCount()) return.
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

function KUnitTestSuiteReportTest_testAggregateEvent_SuiteWideEvent {
    declare local parameter public, private.
    
    // A suite-wide event means that event does not belong to concrete test.
    // Such events shouldn't be passed to test reports.
    // If they are errors, they should be accumulated in error counter of suite
    // report. Otherwise they should be ignored.
    
    local object is private#testObject.
    local eventBuilder is private#eventBuilder.
    eventBuilder#setTestName("").
    eventBuilder#setTestCaseName("").

    local expected is eventBuilder#buildError("foobar error").
    object#aggregateEvent(expected).
    
    // New test reports shouldn't be added
    if not public#assertEquals(0, private#testReports:length) return.
    
    if not public#assertEquals(0, object#getTotalAssertionCount()) return.
    if not public#assertEquals(0, object#getSuccessAssertionCount()) return.
    if not public#assertEquals(0, object#getFailureAssertionCount()) return.
    if not public#assertEquals(0, object#getTotalTestCaseCount()) return.
    if not public#assertEquals(0, object#getSucceededTestCaseCount()) return.
    if not public#assertEquals(0, object#getFailedTestCaseCount()) return.
    if not public#assertEquals(0, object#getTotalTestCount()) return.
    if not public#assertEquals(0, object#getSucceededTestCount()) return.
    if not public#assertEquals(0, object#getFailedTestCount()) return.
    if not public#assertEquals(1, object#getErrorCount()) return.
    if not public#assertTrue(object#isFailed()) return.
    if not public#assertTrue(object#hasErrors()) return.
    local expectedFailures is list().
    local actualFailures is object#getFailures().
    if not public#assertObjectListEquals(expectedFailures, actualFailures) return.
    local expectedErrors is list().
    expectedErrors:add(eventBuilder#buildError("foobar error")).
    local actualErrors is object#getErrors().
    if not public#assertObjectListEquals(expectedErrors, actualErrors) return.
}
