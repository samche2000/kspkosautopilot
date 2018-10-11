// Class for report visualization

runoncepath("kunit/class/KUnit").
runoncepath("kunit/class/KUnitPrinter").
runoncepath("kunit/class/KUnitTestSuiteReport").

function KUnitReportPrinter {
    declare local parameter
        printer is KUnitPrinter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitReportPrinter").

    local public is KUnitObject(className, protected).
    local private is lexicon().

    set private#printer to printer.

    set public#printSummary to KUnitReportPrinter_printSummary@:bind(public, private).
    set public#printFailuresAndErrors to KUnitReportPrinter_printFailuresAndErrors@:bind(public, private).

    return public.
}

function KUnitReportPrinter_printSummary {
    declare local parameter public, private,
        report.     // KUnitTestSuiteReport instance
    local printer is private#printer.

    if report#isFailed() {
        printer#print("== REDLINE ===============================").
    } else {
        printer#print("== GREENLINE =============================").
    }
    
    local width is 6.
    local ff is {
        declare local parameter value.
        return ("" + value):padleft(width).
    }.
    
    printer#print("                  total |success | failed ").
    
    local tc is ff(report#getTotalAssertionCount()).
    local sc is ff(report#getSuccessAssertionCount()).
    local fc is ff(report#getFailureAssertionCount()).
    printer#print("     assertions: "+tc+" | "+sc+" | "+fc+" ").
    
    local tc is ff(report#getTotalTestCaseCount()).
    local sc is ff(report#getSucceededTestCaseCount()).
    local fc is ff(report#getFailedTestCaseCount()).
    printer#print("     test cases: "+tc+" | "+sc+" | "+fc+" ").
    
    local tc is ff(report#getTotalTestCount()).
    local sc is ff(report#getSucceededTestCount()).
    local fc is ff(report#getFailedTestCount()).
    printer#print("          tests: "+tc+" | "+sc+" | "+fc+" ").
    
    local tc is ff(report#getErrorCount()).
    printer#print("         errors: "+tc+"                   ").
    local vers is KUnit_getVersionString().
    printer#print("========================== " + vers + " ==").
}

function KUnitReportPrinter_printFailuresAndErrors {
    declare local parameter public, private,
        report.     // KUnitTestSuiteReport instance
    local printer is private#printer.
    
    if report#getFailureAssertionCount() > 0 {
        printer#print("FAILURES: ").
        for x in report#getFailures() {
            printer#print(x#toString()).
        }
    }
    if report#hasErrors() {
        printer#print("ERRORS: ").
        for x in report#getErrors() {
            printer#print(x#toString()).
        }
    }
}

