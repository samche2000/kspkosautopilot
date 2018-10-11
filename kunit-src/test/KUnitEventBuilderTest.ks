// Unit test of KUnitEventBuilder class

runoncepath("kunit/class/KUnitEventBuilder").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function KUnitEventBuilderTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitEventBuilderTest").
    
    local public is KUnitTest("KUnitEventBuilderTest", reporter, className, protected).
    
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#testObject to -1.
    
    set protected#setUp to KUnitEventBuilderTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitEventBuilderTest_tearDown@:bind(private, parentProtected).
    
    set public#testCtor0 to KUnitEventBuilderTest_testCtor0@:bind(public, private).
    set public#testCtor2 to KUnitEventBuilderTest_testCtor2@:bind(public, private).
    set public#testSetTestName to KUnitEventBuilderTest_testSetTestName@:bind(public, private).
    set public#testSetTestCaseName to KUnitEventBuilderTest_testSetTestCaseName@:bind(public, private).
    set public#testBuildFailure to KUnitEventBuilderTest_testBuildFailure@:bind(public, private).
    set public#testBuildSuccess to KUnitEventBuilderTest_testBuildSuccess@:bind(public, private).
    set public#testBuildError to KUnitEventBuilderTest_testBuildError@:bind(public, private).
    set public#testBuildExpectationFailure to KUnitEventBuilderTest_testBuildExpectationFailure@:bind(public, private).
    set public#testBuildTestStart to KUnitEventBuilderTest_testBuildTestStart@:bind(public, private).
    set public#testBuildTestEnd to KUnitEventBuilderTest_testBuildTestEnd@:bind(public, private).
    set public#testBuildTestCaseStart to KUnitEventBuilderTest_testBuildTestCaseStart@:bind(public, private).
    set public#testBuildTestCaseEnd to KUnitEventBuilderTest_testBuildTestCaseEnd@:bind(public, private).
    
    public#addCasesByNamePattern("^test").

    return public.    
}

function KUnitEventBuilderTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }
    
    set private#testObject to KUnitEventBuilder().
    
    return true.
}

function KUnitEventBuilderTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    set private#testObject to -1.
    
    parentProtected#tearDown().
}

function KUnitEventBuilderTest_testCtor0 {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    if not public#assertEquals("KUnitEventBuilder", object#getClassName()) return.
    
    local expected is KUnitEvent("success").
    local actual is object#buildSuccess().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitEventBuilderTest_testCtor2 {
    declare local parameter public, private.

    local object is KUnitEventBuilder("TestName", "TestCase1").
    
    if not public#assertEquals("KUnitEventBuilder", object#getClassName()) return.
    
    local expected is KUnitEvent("success", "", "TestName", "TestCase1").
    local actual is object#buildSuccess().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitEventBuilderTest_testSetTestName {
    declare local parameter public, private.

    local object is private#testObject.
    
    object#setTestName("FooBarTest").
    local expected is KUnitEvent("success", "", "FooBarTest").
    local actual is object#buildSuccess().
    if not public#assertObjectEquals(expected, actual) return.    
}

function KUnitEventBuilderTest_testSetTestCaseName {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    object#setTestName("FooBarTest").
    object#setTestCaseName("zulu24").
    local expected is KUnitEvent("success", "", "FooBarTest", "zulu24").
    local actual is object#buildSuccess().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitEventBuilderTest_testBuildFailure {
    declare local parameter public, private.
    
    local object is private#testObject.

    object#setTestName("Zulu24").
    object#setTestCaseName("myCase").
    local expected is KUnitEvent("failure", "Message. Clarification", "Zulu24", "myCase").
    local actual is object#buildFailure("Message", "Clarification").
    if not public#assertObjectEquals(expected, actual) return.
    
    local expected is KUnitEvent("badaboom", "Message. Clarification", "Zulu24", "myCase").
    local actual is object#buildFailure("Message", "Clarification", "badaboom").
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitEventBuilderTest_testBuildSuccess {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    object#setTestName("Delta").
    object#setTestCaseName("Charlie").
    local expected is KUnitEvent("success", "", "Delta", "Charlie").
    local actual is object#buildSuccess().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitEventBuilderTest_testBuildError {
    declare local parameter public, private.
    
    local object is private#testObject.

    object#setTestName("KerbalSpace").
    object#setTestCaseName("isCool").
    local expected is KUnitEvent("error", "No errors please", "KerbalSpace", "isCool").
    local actual is object#buildError("No errors please").
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitEventBuilderTest_testBuildExpectationFailure {
    declare local parameter public, private.
    
    local object is private#testObject.

    object#setTestName("ExpectationTest").
    object#setTestCaseName("testCase100").
    local expected is KUnitEvent("failure",
        "Message. Clarification: expected: <[100]> but was <[500]>",
        "ExpectationTest", "testCase100").
    local actual is object#buildExpectationFailure("Message", "Clarification", 100, 500).
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitEventBuilderTest_testBuildTestStart {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    object#setTestName("FooTest").
    local expected is KUnitEvent("testStart", "", "FooTest").
    local actual is object#buildTestStart().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitEventBuilderTest_testBuildTestEnd {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    object#setTestName("ZuluTest").
    local expected is KUnitEvent("testEnd", "", "ZuluTest").
    local actual is object#buildTestEnd().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitEventBuilderTest_testBuildTestCaseStart {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    object#setTestName("CharlieTest").
    object#setTestCaseName("testMyFN").
    local expected is KUnitEvent("testCaseStart", "", "CharlieTest", "testMyFN").
    local actual is object#buildTestCaseStart().
    if not public#assertObjectEquals(expected, actual) return.
}

function KUnitEventBuilderTest_testBuildTestCaseEnd {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    object#setTestName("HelloTest").
    object#setTestCaseName("testZulu").
    local expected is KUnitEvent("testCaseEnd", "", "HelloTest", "testZulu").
    local actual is object#buildTestCaseEnd().
    if not public#assertObjectEquals(expected, actual) return.
}
