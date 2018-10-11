// Unit test of KUnitPrinter class

runoncepath("kunit/class/KUnitPrinter").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function KUnitPrinterTest {
    declare local parameter
       reporter is KUnitReporter(),
       className is list(),
       protected is lexicon().
    className:add("KUnitPrinterTest").
       
    local public is KUnitTest("KUnitPrinterTest", reporter, className, protected).
    local private is lexicon().
    local parentProtected is protected:copy().
    
    set private#testObject to -1.
    
    set protected#setUp to KUnitPrinterTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitPrinterTest_tearDown@:bind(private, parentProtected).
    
    set public#testCtor to KUnitPrinterTest_testCtor@:bind(public, private).
    set public#testPrint to KUnitPrinterTest_testPrint@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    
    return public.
}

function KUnitPrinterTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }

    set private#testObject to KUnitPrinter().
    
    return true.
}

function KUnitPrinterTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    set private#testObject to -1.
    
    parentProtected#tearDown().
}

function KUnitPrinterTest_testCtor {
    declare local parameter public, private.
    
    local object is private#testObject.
    public#assertEquals("KUnitPrinter", object#getClassName()).
}

function KUnitPrinterTest_testPrint {
    declare local parameter public, private.

    // We cannot mock up the print function of kOS.
    // This method just a stub for the case.
    // Some time later if we get possibility to override
    // printing in kOS it will be implemented.
    // Now just let's print some text to make this test "manual".
    
    local object is private#testObject.
    object#print("If you see this then everything is ok with KUnitPrinter").
}
