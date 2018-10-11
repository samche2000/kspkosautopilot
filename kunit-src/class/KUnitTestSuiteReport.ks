// Class to keep result of test suite execution

runoncepath("kunit/class/KUnitTestReport").

function KUnitTestSuiteReport {
    declare local parameter
        testReports is lexicon(), // Storage of test reports
        className is list(),
        protected is lexicon().
    className:add("KUnitTestSuiteReport").

    local public is KUnitObject(className, protected).
    local private is lexicon().
    
    set private#testReports to testReports.
    set private#errorCount to 0.
    set private#errors to list().
    
    set public#getTotalAssertionCount to KUnitTestSuiteReport_getTotalAssertionCount@:bind(public, private).
    set public#getSuccessAssertionCount to KUnitTestSuiteReport_getSuccessAssertionCount@:bind(public, private).
    set public#getFailureAssertionCount to KUnitTestSuiteReport_getFailureAssertionCount@:bind(public, private).
    set public#getTotalTestCaseCount to KUnitTestSuiteReport_getTotalTestCaseCount@:bind(public, private).
    set public#getSucceededTestCaseCount to KUnitTestSuiteReport_getSucceededTestCaseCount@:bind(public, private).
    set public#getFailedTestCaseCount to KUnitTestSuiteReport_getFailedTestCaseCount@:bind(public, private).
    set public#getTotalTestCount to KUnitTestSuiteReport_getTotalTestCount@:bind(public, private).
    set public#getSucceededTestCount to KUnitTestSuiteReport_getSucceededTestCount@:bind(public, private).
    set public#getFailedTestCount to KUnitTestSuiteReport_getFailedTestCount@:bind(public, private).
    set public#isFailed to KUnitTestSuiteReport_isFailed@:bind(public, private).
    set public#hasErrors to KUnitTestSuiteReport_hasErrors@:bind(public, private).
    set public#getErrorCount to KUnitTestSuiteReport_getErrorCount@:bind(public, private).
    set public#getFailures to KUnitTestSuiteReport_getFailures@:bind(public, private).
    set public#getErrors to KUnitTestSuiteReport_getErrors@:bind(public, private).
    set public#aggregateEvent to KUnitTestSuiteReport_aggregateEvent@:bind(public, private).
    
    return public.    
}

function KUnitTestSuiteReport_getTotalAssertionCount {
    declare local parameter public, private.
    local result is 0.
    for test in private#testReports:values() {
        set result to result + test#getTotalAssertionCount().
    }
    return result.
}

function KUnitTestSuiteReport_getSuccessAssertionCount {
    declare local parameter public, private.
    local result is 0.
    for test in private#testReports:values() {
        set result to result + test#getSuccessAssertionCount().
    }
    return result.
}

function KUnitTestSuiteReport_getFailureAssertionCount {
    declare local parameter public, private.
    local result is 0.
    for test in private#testReports:values() {
        set result to result + test#getFailureAssertionCount().
    }
    return result.
}

function KUnitTestSuiteReport_getTotalTestCaseCount {
    declare local parameter public, private.
    local result is 0.
    for test in private#testReports:values() {
        set result to result + test#getTotalTestCaseCount().
    }    
    return result.
}

function KUnitTestSuiteReport_getSucceededTestCaseCount {
    declare local parameter public, private.
    local result is 0.
    for test in private#testReports:values() {
        set result to result + test#getSucceededTestCaseCount().
    }    
    return result.
}

function KUnitTestSuiteReport_getFailedTestCaseCount {
    declare local parameter public, private.
    local result is 0.
    for test in private#testReports:values() {
        set result to result + test#getFailedTestCaseCount().
    }    
    return result.
}

function KUnitTestSuiteReport_getTotalTestCount {
    declare local parameter public, private.
    return private#testReports:length.
}

function KUnitTestSuiteReport_getSucceededTestCount {
    declare local parameter public, private.
    local result is 0.
    for test in private#testReports:values() {
        if not test#isFailed() { 
            set result to result + 1.
        }
    }     
    return result.
}

function KUnitTestSuiteReport_getFailedTestCount {
    declare local parameter public, private.
    local result is 0.
    for test in private#testReports:values() {
        if test#isFailed() { 
            set result to result + 1.
        }
    }     
    return result.
}

function KUnitTestSuiteReport_isFailed {
    declare local parameter public, private.
    if public#hasErrors() {
        return true.
    }
    local result is false.
    for test in private#testReports:values() {
        if test#isFailed() { 
            set result to true.
        }
    }         
    return result.
}

function KUnitTestSuiteReport_hasErrors {
    declare local parameter public, private.
    if public#getErrorCount() > 0 {
        return true.
    }
    local result is false.
    for test in private#testReports:values() {
        if test#hasErrors() { 
            set result to true.
        }
    }         
    return result.
}

function KUnitTestSuiteReport_getErrorCount {
    declare local parameter public, private.
    local result is 0.
    for test in private#testReports:values() {
        local x is test#getErrorCount().
        set result to result + x.
    }
    return result + private#errorCount.
}

function KUnitTestSuiteReport_getFailures {
    declare local parameter public, private.
    local result is list().
    for test in private#testReports:values() {
        for x in test#getFailures() {
            result:add(x).
        }
    }
    return result.
}

function KUnitTestSuiteReport_getErrors {
    declare local parameter public, private.
    local result is list().
    for test in private#testReports:values() {
        for x in test#getErrors() {
            result:add(x).
        }
    }
    for x in private#errors {
        result:add(x).
    }
    return result.
}

function KUnitTestSuiteReport_aggregateEvent {
    declare local parameter public, private, event.
    local testName is event#getTestName().
    if testName:length > 0 {
        local testReports is private#testReports.
        local testReport is -1.
        if testReports:haskey(testName) {
            set testReport to testReports[testName].
        } else {
            set testReport to KUnitTestReport(event#getTestName()).
            set testReports[testName] to testReport.
        }
        testReport#aggregateEvent(event).
    } else if event#getType() = "error" {
        set private#errorCount to private#errorCount + 1.
        private#errors:add(event).
    }
}
