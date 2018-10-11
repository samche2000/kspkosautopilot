// Class to gather and process test results.

runoncepath("kunit/class/KUnitPrinter").
runoncepath("kunit/class/KUnitTestSuiteReport").

// Constructor.
function KUnitReporter {
    declare local parameter
        report is KUnitTestSuiteReport(),
        printer is KUnitPrinter(),
        className is list(),
        protected is lexicon().
    className:add("KUnitReporter").
    
    local public is KUnitObject(className, protected).
    
	local private is lexicon().

    set private#report to report.	
	set private#printer to printer.

	// class methods
	set public#notifyOfTestStart to KUnitReporter_notifyOfEvent@:bind(public, private).
	set public#notifyOfTestCaseStart to KUnitReporter_notifyOfEvent@:bind(public, private).
	set public#notifyOfAssertionResult to KUnitReporter_notifyOfEvent@:bind(public, private).
	set public#notifyOfTestCaseEnd to KUnitReporter_notifyOfEvent@:bind(public, private).
	set public#notifyOfTestEnd to KUnitReporter_notifyOfEvent@:bind(public, private).
	set public#notifyOfError to KUnitReporter_notifyOfEvent@:bind(public, private).
	set public#getReport to KUnitReporter_getReport@:bind(public, private).

    set private#printResult to KUnitReporter_printResult@:bind(public, private).	

	return public.
}

function KUnitReporter_getReport {
    declare local parameter public, private.
    return private#report.
}

function KUnitReporter_notifyOfEvent {
	declare local parameter public, private, result.
	private#report#aggregateEvent(result).
	private#printResult(result).
}

function KUnitReporter_printResult {
	declare local parameter public, private, result.
	local printer is private#printer.
	printer#print(result#toString()).
}
