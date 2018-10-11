// Unit test of KUnitPrinterTest

runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitEventBuilder").
runoncepath("kunit/class/KUnitReportPrinter").

function KUnitReportPrinterTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitReportPrinterTest").
 
    local public is KUnitTest("KUnitReportPrinterTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().

    set private#report to -1.
    set private#printerMock to -1.
    set private#testObject to -1.
    set private#eventBuilder to -1.    

    set protected#setUp to KUnitReportPrinterTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitReportPrinterTest_tearDown@:bind(private, parentProtected).
    
    set public#testCtor to KUnitReportPrinterTest_testCtor@:bind(public, private).
    set public#testPrintSummary_Redline to KUnitReportPrinterTest_testPrintSummary_Redline@:bind(public, private).
    set public#testPrintSummary_Greenline to KUnitReportPrinterTest_testPrintSummary_Greenline@:bind(public, private).
    set public#testPrintFailuresAndErrors to KUnitReportPrinterTest_testPrintFailuresAndErrors@:bind(public, private).

    public#addCasesByNamePattern("^test").
    return public.    
}

function KUnitReportPrinterTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    set private#report to KUnitTestSuiteReport().
    set private#printerMock to KUnitPrinter().
    set private#testObject to KUnitReportPrinter(private#printerMock).
    set private#eventBuilder to KUnitEventBuilder().
    
    return true.
}

function KUnitReportPrinterTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    private#eventBuilder:clear().
    private#printerMock:clear().
    private#report:clear().
    
    parentProtected#tearDown().
}

function KUnitReportPrinterTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.
    if not public#assertTrue(object#isClass("KUnitReportPrinter")).
}

function KUnitReportPrinterTest_testPrintSummary_Redline {
    declare local parameter public, private.
    
    // GIVEN
    
    // We have to reproduce valid sequence of notifications to build correct
    // summary report. Let's assume it will be: two tests with one test case
    // each. The first test will finish with result of two successful
    // assertions.  The second test will finish with one success and one
    // failure. The third test will finish with an error. So we can predict the
    // summarty report. It should be:
    
    local vers is KUnit_getVersionString().
    local expected is list().
    expected:add("== REDLINE ===============================").
    expected:add("                  total |success | failed ").
    expected:add("     assertions:      4 |      3 |      1 ").
    expected:add("     test cases:      2 |      1 |      1 ").
    expected:add("          tests:      3 |      1 |      2 ").
    expected:add("         errors:      1                   ").
    expected:add("========================== " + vers + " ==").
    
    local builder is private#eventBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local report is private#report.
    
    // Let's add entries for summary report
    // We do not need any events except assertions and errors
    builder#setTestName("FirstTest").
    builder#setTestCaseName("testMyFirstTestCase").
    report#aggregateEvent(builder#buildSuccess()).
    report#aggregateEvent(builder#buildSuccess()).
    builder#setTestName("SecondTest").
    builder#setTestCaseName("testMySecondTestCase").
    report#aggregateEvent(builder#buildSuccess()).
    report#aggregateEvent(builder#buildFailure("Test failure")).
    builder#setTestName("ThirdTest").
    builder#setTestCaseName("").
    report#aggregateEvent(builder#buildError("Third test not started")).
    
    // So, it's time to build report. Let's capture all output from now.
    local actual is list().
    set printerMock#print to {
        declare local parameter text.
        actual:add(text).
    }.
    
    // WHEN
    object#printSummary(report).
    
    // THEN
    if not public#assertListEquals(expected, actual, "Expected output does not match") return.
}

function KUnitReportPrinterTest_testPrintSummary_Greenline {
    declare local parameter public, private.
    
    // GIVEN

    local vers is KUnit_getVersionString().
    local expected is list().
    expected:add("== GREENLINE =============================").
    expected:add("                  total |success | failed ").
    expected:add("     assertions:      4 |      4 |      0 ").
    expected:add("     test cases:      2 |      2 |      0 ").
    expected:add("          tests:      2 |      2 |      0 ").
    expected:add("         errors:      0                   ").
    expected:add("========================== " + vers + " ==").

    local builder is private#eventBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local report is private#report.
    
    builder#setTestName("FirstTest").
    builder#setTestCaseName("testMyFirstTestCase").
    report#aggregateEvent(builder#buildSuccess()).
    report#aggregateEvent(builder#buildSuccess()).

    builder#setTestName("SecondTest").
    builder#setTestCaseName("testMySecondTestCase").
    report#aggregateEvent(builder#buildSuccess()).
    report#aggregateEvent(builder#buildSuccess()).

    local actual is list().
    set printerMock#print to {
        declare local parameter text.
        actual:add(text).
    }.
    
    // WHEN
    object#printSummary(report).
    
    // THEN
    if not public#assertListEquals(expected, actual, "Expected output does not match") return.
}

function KUnitReportPrinterTest_testPrintFailuresAndErrors {
    declare local parameter public, private.
    
    // GIVEN
    local builder is private#eventBuilder.
    local object is private#testObject.
    local printerMock is private#printerMock.
    local report is private#report.
    
    builder#setTestName("FirstTest").
    builder#setTestCaseName("testMyFirstTestCase").
    report#aggregateEvent(builder#buildSuccess()).
    report#aggregateEvent(builder#buildFailure("first failure")).
    report#aggregateEvent(builder#buildFailure("second failure")).
    builder#setTestName("SecondTest").
    builder#setTestCaseName("testMySecondTestCase").
    report#aggregateEvent(builder#buildSuccess()).
    report#aggregateEvent(builder#buildFailure("Test failure")).
    builder#setTestName("ThirdTest").
    builder#setTestCaseName("").
    report#aggregateEvent(builder#buildError("Third test not started")).
    
    local actual is list().
    set printerMock#print to {
        declare local parameter text.
        actual:add(text).
    }.
    
    // WHEN
    object#printFailuresAndErrors(report).

    // THEN
    local expected is list().
    expected:add("FAILURES: ").
    expected:add("FirstTest#testMyFirstTestCase assertion[1]failure: first failure").
    expected:add("FirstTest#testMyFirstTestCase assertion[2]failure: second failure").
    expected:add("SecondTest#testMySecondTestCase assertion[1]failure: Test failure").
    expected:add("ERRORS: ").
    expected:add("ThirdTest error: Third test not started").
    if not public#assertListEquals(expected, actual) return.
}
