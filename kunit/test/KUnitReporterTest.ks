// Unit test of KUnitReporter class
// Also this is a good example how to deal with mocks and captures to
// test class behavior. Next KUnit versions will include a special class
// for capturing arguments.

runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitEventBuilder").

function KUnitReporterTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitReporterTest").
 
    local public is KUnitTest("KUnitReporterTest", reporter, className, protected).
    
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#report to -1.
    set private#printerMock to -1.
    set private#testObject to -1.
    set private#eventBuilder to -1.
    
    set protected#setUp to KUnitReporterTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitReporterTest_tearDown@:bind(private, parentProtected).
 
    set public#testCtor to KUnitReporterTest_testCtor@:bind(public, private).
    set public#testNotifyOfTestStart to KUnitReporterTest_testNotifyOfTestStart@:bind(public, private).
    set public#testNotifyOfTestCaseStart to KUnitReporterTest_testNotifyOfTestCaseStart@:bind(public, private).
    set public#testNotifyOfAssertionResult to KUnitReporterTest_testNotifyOfAssertionResult@:bind(public, private).
    set public#testNotifyOfTestCaseEnd to KUnitReportertest_testNotifyOfTestCaseEnd@:bind(public, private).
    set public#testNotifyOfTestEnd to KUnitReporterTest_testNotifyOfTestEnd@:bind(public, private).
    set public#testNotifyOfError to KUnitReporterTest_testNotifyOfError@:bind(public, private).
    
    public#addCasesByNamePattern("^test").

    return public.
}

function KUnitReporterTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    set private#report to KUnitTestSuiteReport().
    set private#printerMock to KUnitPrinter().
    set private#testObject to KUnitReporter(private#report, private#printerMock).
    set private#eventBuilder to KUnitEventBuilder("TestName", "testCase").
    
    return true.
}

function KUnitReporterTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    private#eventBuilder:clear().
    private#printerMock:clear().
    
    parentProtected#tearDown().
}

function KUnitReporterTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.
    if not public#assertEquals("KUnitReporter", object#getClassName()).
    
    local report is object#getReport().
    if not public#assertTrue(report#isClass("KUnitTestSuiteReport")) return.
}

function KUnitReporterTest_testNotifyOfTestStart {
    declare local parameter public, private.

    local builder is private#eventBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    builder#setTestCaseName("").
    local res is builder#buildTestStart().
    
    local capture2 is -1.
    local report is private#report.
    set report#aggregateEvent to {
        declare local parameter event.
        set capture2 to event.
    }.
     
    object#notifyOfTestStart(res).
    
    if not public#assertEquals("TestName testStart", captured) return.
    if not public#assertObjectEquals(res, capture2) return.
}

function KUnitReporterTest_testNotifyOfTestCaseStart {
    declare local parameter public, private.
    
    local builder is private#eventBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    local res is builder#buildTestCaseStart().
    
    local capture2 is -1.
    local report is private#report.
    set report#aggregateEvent to {
        declare local parameter event.
        set capture2 to event.
    }.
    
    object#notifyOfTestCaseStart(res).
    
    if not public#assertEquals("TestName#testCase testCaseStart", captured) return.
    if not public#assertObjectEquals(res, capture2) return.
}

function KUnitReporterTest_testNotifyOfAssertionResult {
    declare local parameter public, private.
    
    local builder is private#eventBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    local res is builder#buildSuccess().
    
    local capture2 is -1.
    local report is private#report.
    set report#aggregateEvent to {
        declare local parameter event.
        set capture2 to event.
    }.
    
    object#notifyOfAssertionResult(res).
    
    if not public#assertEquals("TestName#testCase success", captured) return.
    if not public#assertObjectEquals(res, capture2) return.
}

function KUnitReporterTest_testNotifyOfTestCaseEnd {
    declare local parameter public, private.
    
    local builder is private#eventBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    local res is builder#buildTestCaseEnd().

    local capture2 is -1.
    local report is private#report.
    set report#aggregateEvent to {
        declare local parameter event.
        set capture2 to event.
    }.

    object#notifyOfTestCaseEnd(res).
    
    if not public#assertEquals("TestName#testCase testCaseEnd", captured) return.
    if not public#assertObjectEquals(res, capture2) return.
}

function KUnitReporterTest_testNotifyOfTestEnd {
    declare local parameter public, private.
    
    local builder is private#eventBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    builder#setTestCaseName("").
    local res is builder#buildTestEnd().

    local capture2 is -1.
    local report is private#report.
    set report#aggregateEvent to {
        declare local parameter event.
        set capture2 to event.
    }.
    
    object#notifyOfTestEnd(res).
    
    if not public#assertEquals("TestName testEnd", captured) return.
    if not public#assertObjectEquals(res, capture2) return.
}

function KUnitReporterTest_testNotifyOfError {
    declare local parameter public, private.

    local builder is private#eventBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local captured is -1.
    set printerMock#print to {
        declare local parameter text.
        set captured to text.
    }.
    local res is builder#buildError("Some error text").
    
    local capture2 is -1.
    local report is private#report.
    set report#aggregateEvent to {
        declare local parameter event.
        set capture2 to event.
    }.
    
    object#notifyOfError(res).
    
    if not public#assertEquals("TestName#testCase error: Some error text", captured) return.
    if not public#assertObjectEquals(res, capture2) return.
}
