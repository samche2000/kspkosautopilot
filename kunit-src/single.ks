// KUnit single test runner
@lazyglobal off.

parameter testPath is "", testCasePattern is "".

runoncepath("kunit/class/KUnit").
runoncepath("kunit/class/KUnitFile").
runoncepath("kunit/class/KUnitReporter").
runoncepath("kunit/class/KUnitRunner").
runoncepath("kunit/class/KUnitReportPrinter").

main().
function main {
    local testFile is KUnitFile(path(testPath)).
    if not testPath or not testFile#isFile() {
        if testPath and not testFile#isFile() {
            print "ERROR: Test file you entered is not exists: " + testPath.
            print "ERROR: Check the path and try again".
        }
        local spath is "kunit/single".
        print "Welcome to " + KUnit_getVersionString() + " single test runner".
        print "Usage: ".
        print "  runpath(" + spath + ", <TEST_PATH>, [CASE_PATTERN]).".
        print " ".
        print "NOTE: Use double quotes when needed.".
        print "      KOS does not support escape sequences to show exact commands.".
        print " ".
        print "Usage examples".
        print " ".
        print "Show this help: ".
        print "  runpath(" + spath + ").".
        print " ".
        print "Run all cases of KUnitObjectTest: ".
        print "  runpath(" + spath + ", kunit/test/KUnitObjectTest).".
        print " ".
        print "Run testToString case of KUnitObjectTest: ".
        print "  runpath(" + spath + ", kunit/test/KUnitObjectTest, testToString).".
        print " ".
        print "Run testToString and testEquals of KUnitObjectTest: ".
        print "  runpath(" + spath + ", kunit/test/KUnitObjectTest, test(ToString|Equals).".
        print " ".
        
        return.
    }
    local reporter is KUnitReporter().
    local runner is KUnitRunner(reporter).
    runner#single(testFile, testCasePattern).
    local report is reporter#getReport().
    local reportPrinter is KUnitReportPrinter().
    reportPrinter#printSummary(report).
    reportPrinter#printFailuresAndErrors(report).
}
