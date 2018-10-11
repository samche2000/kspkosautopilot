// Class to keep result of a single test case execution

runoncepath("kunit/class/KUnitCounter").

function KUnitTestCaseReport {
    declare local parameter
        testName,
        testCaseName,
        className is list(),
        protected is lexicon().
    className:add("KUnitTestCaseReport").

    local public is KUnitObject(className, protected).
    local private is lexicon().
    
    set private#testName to testName.
    set private#testCaseName to testCaseName.
    set private#counter to KUnitCounter().
    set private#errorCounter to 0.
    set private#failures to list().
    set private#errors to list().

    set public#getTestName to KUnitTestCaseReport_getTestName@:bind(public, private).
    set public#getTestCaseName to KUnitTestCaseReport_getTestCaseName@:bind(public, private).
    set public#getAssertionCount to KUnitTestCaseReport_getAssertionCount@:bind(public, private).
    set public#getSuccessCount to KUnitTestCaseReport_getSuccessCount@:bind(public, private).
    set public#getFailureCount to KUnitTestCaseReport_getFailureCount@:bind(public, private).
    set public#getFailures to KUnitTestCaseReport_getFailures@:bind(public, private).
    set public#aggregateEvent to KUnitTestCaseReport_aggregateEvent@:bind(public, private).
    set public#isFailed to KUnitTestCaseReport_isFailed@:bind(public, private).
    set public#hasErrors to KUnitTestCaseReport_hasErrors@:bind(public, private).
    set public#getErrorCount to KUnitTestCaseReport_getErrorCount@:bind(public, private).
    set public#getErrors to KUnitTestCaseReport_getErrors@:bind(public, private).

    return public.
}

function KUnitTestCaseReport_getTestName {
    declare local parameter public, private.
    return private#testName.    
}

function KUnitTestCaseReport_getTestCaseName {
    declare local parameter public, private.
    return private#testCaseName.
}

function KUnitTestCaseReport_getAssertionCount {
    declare local parameter public, private.
    return private#counter#getTotalCount().
}

function KUnitTestCaseReport_getSuccessCount {
    declare local parameter public, private.
    return private#counter#getSuccessCount().
}

function KUnitTestCaseReport_getFailureCount {
    declare local parameter public, private.
    return private#counter#getFailureCount().
}

function KUnitTestCaseReport_getFailures {
    declare local parameter public, private.
    return private#failures.
}

function KUnitTestCaseReport_aggregateEvent {
    declare local parameter public, private, event.

    local counter is private#counter.
    local type is event#getType().
    if type = "success" {
        counter#addSuccess().
    } else if type = "failure" {
        local assertionIndex is counter#getTotalCount().
        local newEvent is KUnitEvent(
            "assertion" + "[" + assertionIndex + "]" + type,
            event#getMessage(), event#getTestName(), event#getTestCaseName()).
        private#failures:add(newEvent).
        counter#addFailure().
    } else if type = "error" {
        set private#errorCounter to private#errorCounter + 1.
        private#errors:add(event).
    }
}

function KUnitTestCaseReport_isFailed {
    declare local parameter public, private.
    return public#getFailureCount() > 0 or public#getErrorCount() > 0.
}

function KUnitTestCaseReport_hasErrors {
    declare local parameter public, private.
    return public#getErrorCount() > 0.    
}

function KUnitTestCaseReport_getErrorCount {
    declare local parameter public, private.
    return private#errorCounter.
}

function KUnitTestCaseReport_getErrors {
    declare local parameter public, private.
    return private#errors.    
}
