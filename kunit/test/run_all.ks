// Run all KUnit self-tests
@lazyglobal off.

//runoncepath("kunit/class/KUnitReporter").
//local reporter is KUnitReporter().

//runoncepath("kunit/test/KUnitObjectTest").
//local test is KUnitObjectTest(reporter).
//test#run().

//runoncepath("kunit/test/KUnitEventTest").
//local test is KUnitEventTest(reporter).
//test#run().

//runoncepath("kunit/test/KUnitEventBuilderTest").
//local test is KUnitEventBuilderTest(reporter).
//test#run().

//runoncepath("kunit/test/KUnitPrinterTest").
//local test is KUnitPrinterTest(reporter).
//test#run().

//runoncepath("kunit/test/KUnitCounterTest").
//local test is KUnitCounterTest(reporter).
//test#run().

//runoncepath("kunit/test/KUnitReporterTest").
//local test is KUnitReporterTest(reporter).
//test#run().

//runoncepath("kunit/test/KUnitTestTest").
//local test is KUnitTestTest(reporter).
//test#run().

//runoncepath("kunit/test/KUnitFileTest").
//local test is KUnitFileTest(reporter).
//test#run().

//runoncepath("kunit/test/KUnitFileUtilsTest").
//local test is KUnitFileUtilsTest(reporter).
//test#run().

//runoncepath("kunit/class/KUnitFile").
//runoncepath("kunit/class/KUnitRunner").
//local r is KUnitRunner(KUnitFile(path("kunit/test"))).
//r#run().

//runoncepath("kunit/class/KUnitRunner").
//local runner is KUnitRunner("kunit/test").
//runner#run().

//reporter#printReportSummary().
