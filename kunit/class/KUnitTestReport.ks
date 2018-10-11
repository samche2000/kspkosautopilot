// Class to keep result of a single test execution

runoncepath("kunit/class/KUnitCounter").
runoncepath("kunit/class/KUnitTestCaseReport").

function KUnitTestReport {
    declare local parameter
        testName,
        testCaseReports is lexicon(), // Storage of test case reports
        className is list(),
        protected is lexicon().
    className:add("KUnitTestReport").

    local public is KUnitObject(className, protected).
    local private is lexicon().
    
    set private#testName to testName.
    set private#testCaseReports to testCaseReports.
    set private#errorCounter to 0.  // Test-wide error counter
    set private#errors to list().   // Test-wide errors

    set public#getTestName to KUnitTestReport_getTestName@:bind(public, private).
    
    set public#getTotalAssertionCount to KUnitTestReport_getTotalAssertionCount@:bind(public, private).
    set public#getSuccessAssertionCount to KUnitTestReport_getSuccessAssertionCount@:bind(public, private).
    set public#getFailureAssertionCount to KUnitTestReport_getFailureAssertionCount@:bind(public, private).
    set public#getTotalTestCaseCount to KUnitTestReport_getTotalTestCaseCount@:bind(public, private).
    set public#getSucceededTestCaseCount to KUnitTestReport_getSucceededTestCaseCount@:bind(public, private).
    set public#getFailedTestCaseCount to KUnitTestReport_getFailedTestCaseCount@:bind(public, private).
    set public#isFailed to KUnitTestReport_isFailed@:bind(public, private).
    set public#hasErrors to KUnitTestReport_hasErrors@:bind(public, private).
    set public#getErrorCount to KUnitTestReport_getErrorCount@:bind(public, private).
    set public#getFailures to KUnitTestReport_getFailures@:bind(public, private).
    set public#getErrors to KUnitTestReport_getErrors@:bind(public, private).
    set public#aggregateEvent to KUnitTestReport_aggregateEvent@:bind(public, private).

    return public.
}

function KUnitTestReport_getTestName {
    declare local parameter public, private.
    return private#testName.    
}

function KUnitTestReport_getTotalAssertionCount {
    declare local parameter public, private.
    local result is 0.
    for caseReport in private#testCaseReports:values() {
        set result to result + caseReport#getAssertionCount().
    }
    return result.
}

function KUnitTestReport_getSuccessAssertionCount {
    declare local parameter public, private.
    local result is 0.
    for caseReport in private#testCaseReports:values() {
        set result to result + caseReport#getSuccessCount().
    }
    return result.
}

function KUnitTestReport_getFailureAssertionCount {
    declare local parameter public, private.
    local result is 0.
    for caseReport in private#testCaseReports:values() {
        set result to result + caseReport#getFailureCount().
    }
    return result.
}

function KUnitTestReport_getTotalTestCaseCount {
    declare local parameter public, private.
    return private#testCaseReports:length.
}

function KUnitTestReport_getSucceededTestCaseCount {
    declare local parameter public, private.
    local result is 0.
    for caseReport in private#testCaseReports:values() {
        if not caseReport#isFailed() {
            set result to result + 1.
        }
    }
    return result.
}

function KUnitTestReport_getFailedTestCaseCount {
    declare local parameter public, private.
    local result is 0.
    for caseReport in private#testCaseReports:values() {
        if caseReport#isFailed() {
            set result to result + 1.
        }
    }
    return result.
}

function KUnitTestReport_isFailed {
    declare local parameter public, private.
    if public#hasErrors() {
        return true.
    }
    local result is false.
    for caseReport in private#testCaseReports:values() {
        if caseReport#isFailed() {
            set result to true.
        }
    }
    return result.
}

function KUnitTestReport_hasErrors {
    declare local parameter public, private.
    if public#getErrorCount() > 0 {
        return true.
    }
    return false.
}

function KUnitTestReport_getErrorCount {
    declare local parameter public, private.
    local result is 0.
    for caseReport in private#testCaseReports:values() {
        local x is caseReport#getErrorCount().
        set result to result + x.
    }
    return result + private#errorCounter.
}

function KUnitTestReport_getFailures {
    declare local parameter public, private.
    local result is list().
    for caseReport in private#testCaseReports:values() {
        for failure in caseReport#getFailures() {
            result:add(failure).
        }
    }
    return result.
}

function KUnitTestReport_getErrors {
    declare local parameter public, private.
    local result is list().
    for caseReport in private#testCaseReports:values() {
        for error in caseReport#getErrors() {
            result:add(error).
        }
    }
    for error in private#errors {
        result:add(error).
    }
    return result.
}

function KUnitTestReport_aggregateEvent {
    declare local parameter public, private, event.
    local testCaseName is event#getTestCaseName().
    if testCaseName:length > 0 {
        local testCaseReports is private#testCaseReports.
        local testCaseReport is -1.
        if testCaseReports:haskey(testCaseName) {
            set testCaseReport to testCaseReports[testCaseName].
        } else {
            set testCaseReport to KUnitTestCaseReport(public#getTestName(), testCaseName).
            set testCaseReports[testCaseName] to testCaseReport.
        }
        testCaseReport#aggregateEvent(event).
    } else if event#getType() = "error" {
        set private#errorCounter to private#errorCounter + 1.
        private#errors:add(event).
    }
}
