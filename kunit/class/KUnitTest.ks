// Base class of unit test

runoncepath("kunit/class/KUnitObject").
runoncepath("kunit/class/KUnitEventBuilder").

// Constructor.
// Return: Unit test instance.
function KUnitTest {
	declare local parameter
        testName,           // Name of test.
        reporter is KUnitReporter(),// Instance of test result reporter.
                                    // Reporter will receive all results
                                    // including self-test failures  of unit
                                    // test. Reporter must be a sub class of
                                    // KUnitReporter class.
        className is list(),
        protected is lexicon().
    className:add("KUnitTest").

	local public is KUnitObject(className, protected).
	local private is lexicon().

    set private#reporter to reporter.
    set private#testName to testName.
	set private#shuffleTestCases to true.
    set private#eventBuilder to KUnitEventBuilder().
    set private#isRunning to false.

	// Map: case name -> test function. Also it is used to check that test
	// case with such name isn't added yet.
	set private#testCases to lexicon().

	// We must ensure all test may run in order as they were registered. Yes,
	// this is a "smell" of tests. And to avoid any issues with it there is
	// shuffleCases option. This list still keeps possibility to run test
	// cases in predictable order if needed.       
	set private#testCasesList to list().

    // Protected methods.
    
	// See method description for details.
	// Those are just prototypes to avoid checking before call.
	set protected#setUpTest to KUnitTest_setUpTest@.
	set protected#tearDownTest to KUnitTest_tearDownTest@.
	set protected#setUp to KUnitTest_setUp@.
	set protected#tearDown to KUnitTest_tearDown@.

    // Public methods:

    set public#getTestName to KUnitTest_getTestName@:bind(public, private).
    set public#shuffleTestCases to KUnitTest_shuffleTestCases@:bind(public, private).
	set public#addCase to KUnitTest_addCase@:bind(public, private).
	set public#addCasesByNamePattern to KUnitTest_addCasesByNamePattern@:bind(public, private).
	set public#close to KUnitTest_close@:bind(public, private).
	set public#run to KUnitTest_run@:bind(public, protected, private).
	set public#fail to KUnitTest_fail@:bind(public, private).
	set public#assertThat to KUnitTest_assertThat@:bind(public, private).
	set public#assertTrue to KUnitTest_assertTrue@:bind(public, private).
	set public#assertFalse to KUnitTest_assertFalse@:bind(public, private).
	set public#assertEquals to KUnitTest_assertEquals@:bind(public, private).
	set public#assertListEquals to KUnitTest_assertListEquals@:bind(public, private).
	set public#assertObjectEquals to KUnitTest_assertObjectEquals@:bind(public, private).
	set public#assertObjectListEquals to KUnitTest_assertObjectListEquals@:bind(public, private).
	
	// Private methods:
	set private#reportError to KUnitTest_reportError@:bind(public, private).
	
	return public.
}


// Override this method to do something before all test cases executed.
// Return: should return true if ok, false on error
function KUnitTest_setUpTest {

    return true.
}


// Override this method to do cleanup after all test cases executed.
function KUnitTest_tearDownTest {

}


// Override this method to do something before each test case executed.
// Return: should return true if ok, false on error
function KUnitTest_setUp {

    return true.
}


// Override this method to do cleanup after each test case executed.
function KUnitTest_tearDown {

}


// Get test name.
function KUnitTest_getTestName {
    declare local parameter public, private.
    return private#testName.
}


// Shuffle test cases before start unit test.
// This helps detect bad tests when test cases depend on each other.
// Param1: true to enable shuffling, false - to disable
function KUnitTest_shuffleTestCases {
    declare local parameter public, private, shuffle.
    set private#shuffleTestCases to shuffle.
}


// Register test case.
// Param1: test case name
// Param2: test case function
function KUnitTest_addCase {
	declare local parameter public, private, testCaseName, testCaseFunction.
	if private#isRunning {
        return private#reportError("Unable to register new cases while running").
	}
	if private#testCases:haskey(testCaseName) {
	   return private#reportError("Test case already registered: " + testCaseName).
	}
	set private#testCases[testCaseName] to testCaseFunction.
	private#testCasesList:add(testCaseName).
}


function KUnitTest_addCasesByNamePattern {
    declare local parameter public, private, namePattern.
    for methodName in public:keys {
        if methodName:matchespattern(namePattern) {
            public#addCase(methodName, public[methodName]).
        }
    }
}


function KUnitTest_close {
    declare local parameter public, private.
    set private#testCases to lexicon().
    set private#testCasesList to list().
}


// Execute registered test cases. 
function KUnitTest_run {
	declare local parameter public, protected, private,
	   includeNamePattern is "". // test case selection pattern (optional)
	   
    local reporter is private#reporter.
    local eventBuilder is private#eventBuilder.

	// TODO: add shuffle of test cases
	
    eventBuilder#setTestName(private#testName).
    eventBuilder#setTestCaseName("").
    if not protected#setUpTest() {
        private#reportError("Test setup failed").
        protected#tearDownTest().
        return.
    }
    
    local result is eventBuilder#buildTestStart().
    reporter#notifyOfTestStart(result).

    set private#isRunning to true.    
    for testCaseName in private#testCasesList {
        eventBuilder#setTestCaseName(testCaseName).
        if includeNamePattern:length > 0 and
            not testCaseName:matchespattern(includeNamePattern)
        {
            // skip this test case
        
        } else if not protected#setUp() {
            private#reportError("Test case setup failed").
            protected#tearDown().
        } else {
            set result to eventBuilder#buildTestCaseStart().
            reporter#notifyOfTestCaseStart(result).
            local testCaseFunction is private#testCases[testCaseName].
            testCaseFunction().
            protected#tearDown().
            set result to eventBuilder#buildTestCaseEnd().
            reporter#notifyOfTestCaseEnd(result).
        }        
    }
    set private#isRunning to false.
        
    eventBuilder#setTestCaseName("").
    protected#tearDownTest().
    set result to eventBuilder#buildTestEnd().
    reporter#notifyOfTestEnd(result).
    eventBuilder#setTestName("").
}


function KUnitTest_fail {
    declare local parameter public, private, msg is "".
    local reporter is private#reporter.
    local builder is private#eventBuilder.
    local result is builder#buildFailure(msg).
    reporter#notifyOfAssertionResult(result).
    return false.
}

function KUnitTest_assertThat {
	declare local parameter public, private, assertFunction, msg is "Conditional requirement is not met".
    local reporter is private#reporter.
    local builder is private#eventBuilder.
    local result is builder#buildSuccess().
    local ret is assertFunction().
	if not ret {
        set result to builder#buildFailure(msg).
	}
	reporter#notifyOfAssertionResult(result).
    return ret.
}


function KUnitTest_assertTrue {
	declare local parameter public, private, actual, msg is "Expected true".
	return public#assertThat({ return actual = true. }, msg).
}

function KUnitTest_assertFalse {
    declare local parameter public, private, actual, msg is "Expected false".
    return public#assertThat({ return actual = false. }, msg).
}

function KUnitTest_assertEquals {
    declare local parameter public, private, expected, actual, msg is "Value equality expectation".
    local reporter is private#reporter.
    local builder is private#eventBuilder.
    local result is builder#buildSuccess().
    local ret is true.
    if actual = expected {
        set ret to true.
    } else {
        set result to builder#buildExpectationFailure(msg, "Values are not equal", expected, actual).
        set ret to false.
    }
    reporter#notifyOfAssertionResult(result).
    return ret.
}

function KUnitTest_assertListEquals {
    declare local parameter public, private, expected, actual, msg is "List equality expectation".
    local reporter is private#reporter.
    local builder is private#eventBuilder.
    local result is builder#buildSuccess().
    local ret is true.
    if actual = expected {
        set ret to true.
    } else if actual:length <> expected:length {
        set result to builder#buildExpectationFailure(msg,
            "Number of elements", expected:length, actual:length).
        set ret to false.
    } else {
        local break is false.
        from { local i is 0. }
            until i >= expected:length or break = true
            step { set i to i + 1. }
            do
        {
            if actual[i] <> expected[i] {
                set result to builder#buildExpectationFailure(msg,
                    "element #" + i + " mismatch", expected[i], actual[i]).
                set ret to false.
                set break to true.
            }
        }
    }
    reporter#notifyOfAssertionResult(result).
    return ret.
}

function KUnitTest_assertObjectEquals {
    declare local parameter public, private,
        expectedObject,
        actualObject,
        msg is "Object equality expectation".
    local reporter is private#reporter.
    local builder is private#eventBuilder.
    local result is builder#buildSuccess().
    local ret is true.
    if not actualObject#equals(expectedObject) {
        set ret to false.
        set result to builder#buildExpectationFailure(msg,
            "Failed", expectedObject#toString(), actualObject#toString()).
    }
    reporter#notifyOfAssertionResult(result).
    return ret.
}

function KUnitTest_assertObjectListEquals {
    declare local parameter public, private,
        expectedList,
        actualList,
        msg is "Object list equality expectation".
    local reporter is private#reporter.
    local builder is private#eventBuilder.
    local result is builder#buildSuccess().
    local ret is true.
    if actualList = expectedList {
        set ret to true.
    } else if actualList:length <> expectedList:length {
        set result to builder#buildExpectationFailure(msg,
            "Number of elements", expectedList:length, actualList:length).
        set ret to false.
    } else {
        local break is false.
        from { local i is 0. }
            until i >= expectedList:length or break = true
            step { set i to i + 1. }
            do
        {
            local actualObject is actualList[i].
            local expectedObject is expectedList[i].
            if not actualObject#equals(expectedObject) {
                set result to builder#buildExpectationFailure(msg,
                    "element #" + i + " mismatch",
                    expectedObject#toString(),
                    actualObject#toString()).
                set ret to false.
                set break to true.
            }
        }
    }
    reporter#notifyOfAssertionResult(result).
    return ret.
}

// Private methods.

// Private.
// Errors are not test failures!
// Error mean something is going wrong with test process.
// For example - bad implementation of the unit test which causes error.
function KUnitTest_reportError {
	declare local parameter public, private, msg.
	local reporter is private#reporter.
	local builder is private#eventBuilder.
	local result is builder#buildError(msg).
	reporter#notifyOfError(result).
}
