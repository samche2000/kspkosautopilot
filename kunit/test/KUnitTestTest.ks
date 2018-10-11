// Unit test of KUnitTest class

runoncepath("kunit/class/KUnitPrinter").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitEvent").
runoncepath("kunit/class/KUnitEventBuilder").

function KUnitTestTest {
    declare local parameter
        reporter is KUnitReporter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitTestTest").

	local public is KUnitTest("KUnitTestTest", reporter, className, protected).
	local private is lexicon().
	local parentProtected is protected:copy().
	
	set private#eventBuilder to -1.
	set private#printerMock to -1.
	set private#reporterMock to -1.
	set private#testObject to -1.
	
	set protected#setUp to KUnitTestTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitTestTest_tearDown@:bind(private, parentProtected).

    set public#testGetTestName to KUnitTestTest_testGetTestName@:bind(public, private).
    set public#testShuffleTestCases to KUnitTestTest_testShuffleTestCases@:bind(public, private).
    set public#testAddCase to KUnitTestTest_testAddCase@:bind(public, private).
    set public#testAddCase_FailedIfCaseExists to KUnitTestTest_testAddCase_FailedIfCaseExists@:bind(public, private).
    set public#testAddCase_FailedIfRunning to KUnitTestTest_testAddCase_FailedIfRunning@:bind(public, private).
    set public#testAddCasesByNamePattern to KUnitTesttest_testAddCasesByNamePattern@:bind(public, private).
    set public#testClose to KUnitTestTest_testClose@:bind(public, private).
    set public#testRun to KUnitTestTest_testRun@:bind(public, private).
    set public#testRun_FilterByNamePattern to KUnitTestTest_testRun_FilterByNamePattern@:bind(public, private).
    set public#testRun_ShouldSkipAllTestCases_IfSetUpTestFailed to KUnitTestTest_testRun_ShouldSkipAllTestCases_IfSetUpTestFailed@:bind(public, private).
    set public#testRun_ShouldSkipTestCase_IfSetUpFailed to KUnitTestTest_testRun_ShouldSkipTestCase_IfSetUpFailed@:bind(public, private).
    set public#testRun_TestOfNotificationSequence to KUnitTestTest_testRun_TestOfNotificationSequence@:bind(public, private).
    set public#testFail to KUnitTestTest_testFail@:bind(public, private).
    set public#testAssertThat to KUnitTestTest_testAssertThat@:bind(public, private).
    set public#testAssertTrue to KUnitTestTest_testAssertTrue@:bind(public, private).
    set public#testAssertFalse to KUnitTestTest_testAssertFalse@:bind(public, private).
    set public#testAssetEquals to KUnitTestTest_testAssertEquals@:bind(public, private).
    set public#testAssetListEquals to KUnitTestTest_testAssertListEquals@:bind(public, private).
    set public#testAssertObjectEquals to KUnitTestTest_testAssertObjectEquals@:bind(public, private).
    set public#testAssertObjectListEquals to KUnitTestTest_testAssertObjectListEquals@:bind(public, private).
    set public#testAssertObjectListEquals_DefaultMsg to KUnitTestTest_testAssertObjectListEquals_DefaultMsg@:bind(public, private).
    public#addCasesByNamePattern("^test").
    
	return public.
}

function KUnitTestTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    local printerMock is KUnitPrinter().
    set printerMock#print to { declare local parameter x. }.
    set private#printerMock to printerMock.
    local report is KUnitTestSuiteReport().
    set private#reporterMock to KUnitReporter(report, printerMock).
    set private#testObject to KUnitTest("MyTest", private#reporterMock).
    set private#eventBuilder to KUnitEventBuilder().
    
    return true.
}

function KUnitTestTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    private#reporterMock:clear().
    private#printerMock:clear().
    
    parentProtected#tearDown().
}

function KUnitTestTest_testGetTestName {
    declare local parameter public, private.
    
    local test is KUnitTest("MyTest").
    
    if not public#assertEquals("MyTest", test#getTestName()) return.
}

function KUnitTestTest_testShuffleTestCases {
    declare local parameter public, private.
    
    // TODO: feature is in development
}

function KUnitTestTest_testAddCase {
    declare local parameter public, private.
    
    // Given
    local object is private#testObject.
    local called is 0.
    local fn is { set called to called + 1. }.
    object#addCase("foo", fn).
    object#addCase("bar", fn).
    
    // When
    object#run().
    
    // Then
    if not public#assertEquals(2, called) return.
}

function KUnitTestTest_testAddCase_FailedIfCaseExists {
    declare local parameter public, private.
    
    // Given
    local object is private#testObject.
    object#addCase("foo", { }).
    local captured is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfError to {
        declare local parameter arg.
        set captured to arg.
    }.
    
    // When
    object#addCase("foo", { }).
    
    // Then
    local expected is KUnitEvent("error", "Test case already registered: foo").
    if not public#assertObjectEquals(expected, captured) return.
}

function KUnitTestTest_testAddCase_FailedIfRunning {
    declare local parameter public, private.
    
    // Given
    local object is private#testObject.
    object#addCase("foo", {
        object#addCase("foo", { }). // This should be rejected
    }).
    local captured is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfError to {
        declare local parameter arg.
        set captured to arg.
    }.

    // When
    object#run().
    
    // Then    
    local expected is KUnitEvent("error", "Unable to register new cases while running", "MyTest", "foo").
    if not public#assertObjectEquals(expected, captured) return.
}

function KUnitTestTest_testAddCasesByNamePattern {
    declare local parameter public, private.
    
    // Given
    local object is private#testObject.
    local called is list().
    set object#myFoo to { called:add("myFoo"). }.
    set object#foo__ to { called:add("foo__"). }.
    set object#myBar to { called:add("myBar"). }.
    set object#bar__ to { called:add("bar__"). }.
    
    // When
    object#addCasesByNamePattern("^my").
    
    // Then
    object#run().
    local expected is list("myFoo", "myBar").
    if not public#assertListEquals(expected, called) return.
}

function KUnitTestTest_testClose {
    declare local parameter public, private.

    // Given
    local object is private#testObject.
    local called is 0.
    local fn is { set called to called + 1. }.
    object#addCase("testFoo", fn).
    object#addCase("testBar", fn).

    // When
    object#close().
    
    // Then
    object#run().
    if not public#assertEquals(0, called, "Test cases shouldn't be called") return.
}

function KUnitTestTest_testRun {
	declare local parameter public, private.

	// Given
	local className is list("MyTest").
	local protected is lexicon().
	local service is KUnitTest("MyTest", private#reporterMock, className, protected).
	local actual is list().
	service#shuffleTestCases(false).
	set protected#setUpTest to { actual:add("setUpTest"). return true. }.
	set protected#tearDownTest to { actual:add("tearDownTest"). }.
	set protected#setUp to { actual:add("setUp"). return true. }.
	set protected#tearDown to { actual:add("tearDown"). }.
	set service#testCase1 to { actual:add("testCase1"). }.
	set service#testCase2 to { actual:add("testCase2"). }.
	service#addCase("testCase1", service#testCase1).
	service#addCase("testCase2", service#testCase2).

	// When
	service#run().

	// Then
	local expected is list().
	expected:add("setUpTest").
	expected:add("setUp").
	expected:add("testCase1").
	expected:add("tearDown").
	expected:add("setUp").
	expected:add("testCase2").
	expected:add("tearDown").
	expected:add("tearDownTest").
	if not public#assertListEquals(expected, actual, "Unexpected call sequence") return.
}

function KUnitTestTest_testRun_FilterByNamePattern {
    declare local parameter public, private.

    // Given
    local className is list("MyTest").
    local protected is lexicon().
    local service is KUnitTest("MyTest", private#reporterMock, className, protected).
    local actual is list().
    service#shuffleTestCases(false).
    set service#testCase1 to { actual:add("case1"). }.
    set service#testCase2 to { actual:add("case2"). }.
    set service#testCase3 to { actual:add("case3"). }.
    set service#testCase4 to { actual:add("case4"). }.
    service#addCase("includeCase1", service#testCase1).
    service#addCase("excludeCase2", service#testCase2).
    service#addCase("includeCase3", service#testCase3).
    service#addCase("excludeCase4", service#testCase4).

    service#run("^include").
    
    local expected is list("case1", "case3").
    if not public#assertListEquals(expected, actual, "Unexpected call sequence") return.
}

function KUnitTestTest_testRun_ShouldSkipAllTestCases_IfSetUpTestFailed {
    declare local parameter public, private.
    
    // Given
    local className is list("MyTest").
    local protected is lexicon().
    local service is KUnitTest("MyTest", private#reporterMock, className, protected).
    local actual is list().
    service#shuffleTestCases(false).
    set protected#setUpTest to { actual:add("setUpTest"). return false. }.
    set protected#tearDownTest to { actual:add("tearDownTest"). }.
    set protected#setUp to { actual:add("setUp"). return true. }.
    set protected#tearDown to { actual:add("tearDown"). }.
    set service#testCase1 to { actual:add("testCase1"). }.
    set service#testCase2 to { actual:add("testCase2"). }.
    service#addCase("testCase1", service#testCase1).
    service#addCase("testCase2", service#testCase2).

    // When
    service#run().
    
    // Then
    local expected is list("setUpTest", "tearDownTest").
    if not public#assertListEquals(expected, actual, "Unexpected call sequence") return.
}

function KUnitTestTest_testRun_ShouldSkipTestCase_IfSetUpFailed {
    declare local parameter public, private.
    
    // Given
    local className is list("MyTest").
    local protected is lexicon().
    local service is KUnitTest("MyTest", private#reporterMock, className, protected).
    local actual is list().
    service#shuffleTestCases(false).
    set protected#setUpTest to { actual:add("setUpTest"). return true. }.
    set protected#tearDownTest to { actual:add("tearDownTest"). }.
    local setUpNumber is 0.
    set protected#setUp to {
        actual:add("setUp").
        set setUpNumber to setUpNumber + 1.
        if setUpNumber = 1 {
            return true.
        } else {
            return false.
        }
    }.
    set protected#tearDown to { actual:add("tearDown"). }.
    set service#testCase1 to { actual:add("testCase1"). }.
    set service#testCase2 to { actual:add("testCase2"). }.
    service#addCase("testCase1", service#testCase1).
    service#addCase("testCase2", service#testCase2).

    // When
    service#run().
    
    // Then
    local expected is list().
    expected:add("setUpTest").
    expected:add("setUp").
    expected:add("testCase1").
    expected:add("tearDown").
    expected:add("setUp").
    expected:add("tearDown").
    expected:add("tearDownTest").
    if not public#assertListEquals(expected, actual, "Unexpected call sequence") return.
}

function KUnitTestTest_testRun_TestOfNotificationSequence {
    declare local parameter public, private.
    
    // Given
    local reporterMock is private#reporterMock.
    local actual is list().
    local fn is {
        declare local parameter x.
        actual:add(x).
    }.
    set reporterMock#notifyOfTestStart to fn.
    set reporterMock#notifyOfTestCaseStart to fn.
    set reporterMock#notifyOfAssertionResult to fn.
    set reporterMock#notifyOfTestCaseEnd to fn.
    set reporterMock#notifyOfTestEnd to fn.
    local object is private#testObject.
    set object#testCase1 to {
        object#assertTrue(false, "good message").
    }.
    object#addCase("testCase1", object#testCase1).
    
    // When
    object#run().
    
    // Then
    local builder is private#eventBuilder.
    local expected is list().
    builder#setTestName("MyTest").
    expected:add(builder#buildTestStart()).
    builder#setTestCaseName("testCase1").
    expected:add(builder#buildTestCaseStart()).
    expected:add(builder#buildFailure("good message")).
    expected:add(builder#buildTestCaseEnd()).
    builder#setTestCaseName("").
    expected:add(builder#buildTestEnd()).
    local msg is "Unexpected notification sequence".
    if not public#assertObjectListEquals(expected, actual, msg) return.
}

function KUnitTestTest_testFail {
    declare local parameter public, private.
    
    // Given
    local capture is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfAssertionResult to {
        declare local parameter x.
        set capture to x.
    }.
    local object is private#testObject.
    
    // When
    local r is object#fail("Test failure message").

    // Then
    if not public#assertFalse(r, "Expected result is false") return.
    local expected is KUnitEvent("failure", "Test failure message").
    if not public#assertObjectEquals(expected, capture) return.
    
    // The case without message text
    
    local r is object#fail().
    
    if not public#assertFalse(r, "Expected result is false [2]") return.
    local expected is KUnitEvent("failure").
    if not public#assertObjectEquals(expected, capture) return.
}

function KUnitTestTest_testAssertThat {
    declare local parameter public, private.
    
    local capture is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfAssertionResult to {
        declare local parameter x.
        set capture to x.
    }.
    local object is private#testObject.

    local r is object#assertThat({ return false. }, "Failure message").

    if not public#assertFalse(r, "Expected result is false") return.
    local expected is KUnitEvent("failure", "Failure message").
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertThat({ return true. }, "Failure message").
    
    if not public#assertTrue(r, "Expected result is true") return.
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertThat({ return false. }).
    
    if not public#assertFalse(r, "Expected result is false [2]") return.
    local expected is KUnitEvent("failure", "Conditional requirement is not met").
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertThat({ return true. }).
    
    if not public#assertTrue(r, "Expected result is true [2]") return.
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
}

function KUnitTestTest_testAssertTrue {
    declare local parameter public, private.
    
    local capture is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfAssertionResult to {
        declare local parameter x.
        set capture to x.
    }.
    local object is private#testObject.
    
    local r is object#assertTrue(false, "Failure message").
    
    if not public#assertFalse(r, "Expected result is false") return.
    local expected is KUnitEvent("failure", "Failure message").
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertTrue(true, "Failure message").
    
    if not public#assertTrue(r, "Expected result is true") return.
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertTrue(false).
    
    if not public#assertFalse(r, "Expected result is false [2]") return.
    local expected is KUnitEvent("failure", "Expected true").
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertTrue(true).
    
    if not public#assertTrue(r, "Expected result is true [2]") return.
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
}

function KUnitTestTest_testAssertFalse {
    declare local parameter public, private.

    local capture is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfAssertionResult to {
        declare local parameter x.
        set capture to x.
    }.
    local object is private#testObject.

    local r is object#assertFalse(true, "Error message").
    
    if not public#assertFalse(r, "Expected result is false") return.
    local expected is KUnitEvent("failure", "Error message").
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertFalse(false, "Error message").
    
    if not public#assertTrue(r, "Expected result is true") return.
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertFalse(true).
    
    if not public#assertFalse(r, "Expected result is false [2]") return.
    local expected is KUnitEvent("failure", "Expected false").
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertFalse(false).
    
    if not public#assertTrue(r, "Expected result is true [2]") return.
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
}

function KUnitTestTest_testAssertEquals {
    declare local parameter public, private.
    
    local capture is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfAssertionResult to {
        declare local parameter x.
        set capture to x.
    }.
    local object is private#testObject.

    local r is object#assertEquals("foo", "bar", "Value is different").
    
    if not public#assertFalse(r, "Expected result is false") return.
    local msg is "Value is different. Values are not equal: expected: <[foo]> but was <[bar]>".
    local expected is KUnitEvent("failure", msg).
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertEquals("foo", "foo", "Value is different").
    
    if not public#assertTrue(r, "Expected result is true") return.
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertEquals("foo", "bar").
    
    if not public#assertFalse(r, "Expected result is false [2]") return.
    local msg is "Value equality expectation. Values are not equal: expected: <[foo]> but was <[bar]>".
    local expected is KUnitEvent("failure", msg).
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertEquals("foo", "foo").
    
    if not public#assertTrue(r, "Expected result is true [2]") return.
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
}

function KUnitTestTest_testAssertListEquals {
    declare local parameter public, private.
    
    local capture is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfAssertionResult to {
        declare local parameter x.
        set capture to x.
    }.
    local object is private#testObject.
    
    local expectedList is list("one", "two", "three").
    local actualList is list("one", "two").
    local r is object#assertListEquals(expectedList, actualList, "List is different").
    
    if not public#assertFalse(r, "Expected that list should not be equal") return.
    local msg is "List is different. Number of elements: expected: <[3]> but was <[2]>".
    local expected is KUnitEvent("failure", msg).
    if not public#assertObjectEquals(expected, capture) return.
    
    local actualList is list("one", "two", "more").
    local r is object#assertListEquals(expectedList, actualList, "List is different").
    
    if not public#assertFalse(r, "Two lists with different values should not be equal") return.
    local msg is "List is different. element #2 mismatch: expected: <[three]> but was <[more]>".
    local expected is KUnitEvent("failure", msg).
    if not public#assertObjectEquals(expected, capture) return.
    
    local actualList is list("one", "two", "three").
    local r is object#assertListEquals(expectedList, actualList, "List is different").
    
    if not public#assertTrue(r, "When all elements are equal then lists should be equal").
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
    
    // without specified message
    
    local actualList is list("one", "two").
    local r is object#assertListEquals(expectedList, actualList).
    
    if not public#assertFalse(r, "Expected that list should not be equal [2]") return.
    local msg is "List equality expectation. Number of elements: expected: <[3]> but was <[2]>".
    local expected is KUnitEvent("failure", msg).
    if not public#assertObjectEquals(expected, capture) return.
    
    local actualList is list("one", "two", "more").
    local r is object#assertListEquals(expectedList, actualList).
    
    if not public#assertFalse(r, "Two lists with different values should not be equal [2]") return.
    local msg is "List equality expectation. element #2 mismatch: expected: <[three]> but was <[more]>".
    local expected is KUnitEvent("failure", msg).
    if not public#assertObjectEquals(expected, capture) return.
    
    local actualList is list("one", "two", "three").
    local r is object#assertListEquals(expectedList, actualList).
    
    if not public#assertTrue(r, "When all elements are equal then lists should be equal [2]").
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
}

function KUnitTestTest_testAssertObjectEquals {
    declare local parameter public, private.
    
    local capture is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfAssertionResult to {
        declare local parameter x.
        set capture to x.
    }.
    local object is private#testObject.
    
    local expectedObject is KUnitObject().
    local actualObject is KUnitObject().
    local r is object#assertObjectEquals(expectedObject, actualObject, "Test message").
    
    if not public#assertFalse(r, "Different instances shouldn't be equal") return.
    local msg is "Test message. Failed: expected: <[" +
        expectedObject#toString() + "]> but was <[" + actualObject#toString() + "]>".
    local expected is KUnitEvent("failure", msg).
    if not public#assertObjectEquals(expected, capture) return.
    
    local actualObject is expectedObject.
    local r is object#assertObjectEquals(expectedObject, actualObject, "Test message").
    
    if not public#assertTrue(r, "Same instances should be equal") return.
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.

    // Without a special message
    
    local actualObject is KUnitObject().
    local r is object#assertObjectEquals(expectedObject, actualObject).
    if not public#assertFalse(r, "Different instances shouldn't be equal [2]") return.
    local msg is "Object equality expectation. Failed: expected: <[" +
        expectedObject#toString() + "]> but was <[" + actualObject#toString() + "]>".
    local expected is KUnitEvent("failure", msg).
    if not public#assertObjectEquals(expected, capture) return.
    
    local actualObject is expectedObject.
    local r is object#assertObjectEquals(expectedObject, actualObject).
    
    if not public#assertTrue(r, "Same instances should be equal [2]") return.
    local expected is KUnitEvent("success").
    if not public#assertObjectEquals(expected, capture) return.
}

function KUnitTestTest_testAssertObjectListEquals {
    declare local parameter public, private.
    
    local capture is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfAssertionResult to {
        declare local parameter x.
        set capture to x.
    }.
    local object is private#testObject.
    local builder is private#eventBuilder.
    
    // KUnitEvent itself is a good candidate to test object list comparison.
    // We will use its instance to test object list equality assert.
    // We will not fill it in all possible combinations of attributes
    // to keep the test is easy to understand. Because we know that KUnitEvent
    // is well tested and works properly.  

    local expectedList is list().
    expectedList:add(KUnitEvent("foo")).
    expectedList:add(KUnitEvent("bar")).
    
    local actualList is list().
    actualList:add(KUnitEvent("foo")).

    local r is object#assertObjectListEquals(expectedList, expectedList, "Test msg").
    local msg is "Object list instance should be equal to itself".
    if not public#assertTrue(r, msg) return.
    
    local expected is builder#buildSuccess().
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertObjectListEquals(expectedList, actualList, "Test msg").
    local msg is "Object lists with different number of elements shouldn't be equal".
    if not public#assertFalse(r, msg) return.
    
    local msg is "Test msg. Number of elements: expected: <[2]> but was <[1]>".
    local expected is builder#buildFailure(msg).
    if not public#assertObjectEquals(expected, capture) return.

    actualList:add(KUnitEvent("buz")).
    local r is object#assertObjectListEquals(expectedList, actualList, "Test msg").
    local msg is "Object lists which contains different objects should not be equal".
    if not public#assertFalse(r, msg) return.
    
    local msg is "Test msg. element #1 mismatch: expected: <[bar]> but was <[buz]>".
    local expected is builder#buildFailure(msg).
    if not public#assertObjectEquals(expected, capture) return.

    set actualList[1] to KUnitEvent("bar").
    local r is object#assertObjectListEquals(expectedList, actualList, "Test msg").
    local msg is "Object lists with similar elements should be equal".
    if not public#assertTrue(r, msg) return.
    
    local expected is builder#buildSuccess().
    if not public#assertObjectEquals(expected, capture) return.
}

function KUnitTestTest_testAssertObjectListEquals_DefaultMsg {
    declare local parameter public, private.
    
    local capture is -1.
    local reporterMock is private#reporterMock.
    set reporterMock#notifyOfAssertionResult to {
        declare local parameter x.
        set capture to x.
    }.
    local object is private#testObject.
    local builder is private#eventBuilder.

    local expectedList is list().
    expectedList:add(KUnitEvent("foo")).
    expectedList:add(KUnitEvent("bar")).
    
    local actualList is list().
    actualList:add(KUnitEvent("foo")).

    local r is object#assertObjectListEquals(expectedList, expectedList).
    local msg is "Object list instance should be equal to itself".
    if not public#assertTrue(r, msg) return.
    
    local expected is builder#buildSuccess().
    if not public#assertObjectEquals(expected, capture) return.
    
    local r is object#assertObjectListEquals(expectedList, actualList).
    local msg is "Object lists with different number of elements shouldn't be equal".
    if not public#assertFalse(r, msg) return.
    
    local msg is "Object list equality expectation. Number of elements: expected: <[2]> but was <[1]>".
    local expected is builder#buildFailure(msg).
    if not public#assertObjectEquals(expected, capture) return.

    actualList:add(KUnitEvent("buz")).
    local r is object#assertObjectListEquals(expectedList, actualList).
    local msg is "Object lists which contains different objects should not be equal".
    if not public#assertFalse(r, msg) return.
    
    local msg is "Object list equality expectation. element #1 mismatch: expected: <[bar]> but was <[buz]>".
    local expected is builder#buildFailure(msg).
    if not public#assertObjectEquals(expected, capture) return.

    set actualList[1] to KUnitEvent("bar").
    local r is object#assertObjectListEquals(expectedList, actualList).
    local msg is "Object lists with similar elements should be equal".
    if not public#assertTrue(r, msg) return.
    
    local expected is builder#buildSuccess().
    if not public#assertObjectEquals(expected, capture) return.
}

