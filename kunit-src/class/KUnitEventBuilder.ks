// Builder of a test event

runoncepath("kunit/class/KUnitObject").
runoncepath("kunit/class/KUnitEvent").

function KUnitEventBuilder {
    declare local parameter
        testName is "",
        testCaseName is "",
        className is list(),
        protected is lexicon().
    className:add("KUnitEventBuilder").

    local public is KUnitObject(className, protected).
    local private is lexicon().
    
    set private#testName to testName.
    set private#testCaseName to testCaseName.
    
    set public#setTestName to KUnitEventBuilder_setTestName@:bind(public, private).
    set public#setTestCaseName to KUnitEventBuilder_setTestCaseName@:bind(public, private).
    set public#buildFailure to KUnitEventBuilder_buildFailure@:bind(public, private).
    set public#buildSuccess to KUnitEventBuilder_buildSuccess@:bind(public, private).
    set public#buildError to KUnitEventBuilder_buildError@:bind(public, private).
    set public#buildExpectationFailure to KUnitEventBuilder_buildExpectationFailure@:bind(public, private).
    set public#buildTestStart to KUnitEventBuilder_buildTestStart@:bind(public, private).
    set public#buildTestEnd to KUnitEventBuilder_buildTestEnd@:bind(public, private).
    set public#buildTestCaseStart to KUnitEventBuilder_buildTestCaseStart@:bind(public, private).
    set public#buildTestCaseEnd to KUnitEventBuilder_buildTestCaseEnd@:bind(public, private).
    
    return public. 
}

function KUnitEventBuilder_setTestName {
    declare local parameter public, private, testName.
    set private#testName to testName.
}

function KUnitEventBuilder_setTestCaseName {
    declare local parameter public, private, testCaseName.
    set private#testCaseName to testCaseName.
}

function KUnitEventBuilder_buildFailure {
    declare local parameter public, private,
        msg,
        clarification is "",
        type is "failure".      // Some cases we need to override the type
    if msg:length > 0 and clarification:length > 0 {
        set msg to msg + ". " + clarification.
    }
    return KUnitEvent(type, msg, private#testName, private#testCaseName).
}

function KUnitEventBuilder_buildSuccess {
    declare local parameter public, private.
    return KUnitEvent("success", "", private#testName, private#testCaseName).
}

function KUnitEventBuilder_buildError {
    declare local parameter public, private, msg.
    return KUnitEvent("error", msg, private#testName, private#testCaseName). 
}

function KUnitEventBuilder_buildExpectationFailure {
    declare local parameter public, private, msg, clarification, expected, actual.
    set clarification to clarification
        + ": expected: <[" + expected + "]> but was <[" + actual + "]>".
    return public#buildFailure(msg, clarification).
}

function KUnitEventBuilder_buildTestStart {
    declare local parameter public, private.
    return KUnitEvent("testStart", "", private#testName, private#testCaseName).
}

function KUnitEventBuilder_buildTestEnd {
    declare local parameter public, private.
    return KUnitEvent("testEnd", "", private#testName, private#testCaseName).
}

function KUnitEventBuilder_buildTestCaseStart {
    declare local parameter public, private.
    return KUnitEvent("testCaseStart", "", private#testName, private#testCaseName).
}

function KUnitEventBuilder_buildTestCaseEnd {
    declare local parameter public, private.
    return KUnitEvent("testCaseEnd", "", private#testName, private#testCaseName).
}
