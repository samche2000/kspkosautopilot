// Unit test of KUnitObject class

runoncepath("kunit/class/KUnitObject").
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

function KUnitObjectTest {
	declare local parameter
	   reporter is KUnitReporter(),
	   className is list(),
	   protected is lexicon().
    className:add("KUnitObjectTest").
	   
	local public is KUnitTest("KUnitObjectTest", reporter, className, protected).
	local private is lexicon().
	local parentProtected is protected:copy().

    set private#testObject to -1.
    set private#testObjectProtected to -1.

    set protected#setUp to KUnitObjectTest_setUp@:bind(private, parentProtected).
    set protected#tearDown to KUnitObjectTest_tearDown@:bind(private, parentProtected).
    
    set public#testIsObject to KUnitObjectTest_testIsObject@:bind(public, private).
    set public#testGetClassName to KUnitObjectTest_testGetClassName@:bind(public, private).
    set public#testGetRefID to KUnitObjectTest_testGetRefID@:bind(public, private).
    set public#testIsSameClassWith to KUnitObjectTest_testIsSameClassWith@:bind(public, private).
    set public#testIsA to KUnitObjectTest_testIsA@:bind(public, private).
    set public#testIsClass to KUnitObjectTest_testIsClass@:bind(public, private).
    set public#testIsClass_StaticCall to KUnitObjectTest_testIsClass_StaticCall@:bind(public, private).
    set public#testToString to KUnitObjectTest_testToString@:bind(public, private).
    set public#testEquals to KUnitObjectTest_testEquals@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    
	return public.
}

function KUnitObjectTest_setUp {
    declare local parameter private, parentProtected.
    if not parentProtected#setUp() { return false. }
    
    local className is list("TopClass", "BaseClass").
    set private#testObjectProtected to lexicon().
    set private#testObject to KUnitObject(className, private#testObjectProtected).
    
    return true.
}

function KUnitObjectTest_tearDown {
    declare local parameter private, parentProtected.
    
    private#testObject:clear().
    set private#testObject to -1.
    set private#testObjectProtected to -1.
    
    parentProtected#tearDown().
}

function KUnitObjectTest_testIsObject {
    declare local parameter public, private.
    
    local object is private#testObject.
    local msg is "Valid object should be identified as object".
    if not public#assertTrue(KUnitObject_isObject(object), msg) return.
    
    local object is lexicon().
    local msg is "Lexicon shouldn't be identified as object".
    if not public#assertFalse(KUnitObject_isObject(object), msg) return.
}

function KUnitObjectTest_testGetClassName {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    if not public#assertEquals("TopClass", object#getClassName(), "Unexpected class name") return.
}

function KUnitObjectTest_testGetRefID {
    declare local parameter public, private.
 
    local object is KUnitObject().
    local actual is object#getRefID().
    local expected is KUnitObject_LAST_REF_ID().

    if not public#assertEquals(expected, actual, "Unexpected RefID") return.
}

function KUnitObjectTest_testIsSameClassWith {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    local msg is "Object should be same class with itself".
    if not public#assertTrue(object#isSameClassWith(object), msg) return.
    
    local className is list("TopClass", "BaseClass").
    local other is KUnitObject(className).
    set msg to "Object should be same class with object of same class".
    if not public#assertTrue(object#isSameClassWith(other), msg) return.

    set other to lexicon().
    set msg to "Object shouldn't be same class with a non-object".
    if not public#assertFalse(object#isSameClassWith(other), msg) return.
    
}

function KUnitObjectTest_testIsA {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    local msg is "Object should be a subclass of KUnitObject".
    if not public#assertTrue(object#isA("KUnitObject"), msg) return.
    
    local msg is "Object should be a subclass of BaseClass".
    if not public#assertTrue(object#isA("BaseClass"), msg) return.
    
    local msg is "Object should be a subclass of TopClass".
    if not public#assertTrue(object#isA("TopClass"), msg) return.
    
    local msg is "Object shouldn't be a subclass UnknownClass".
    if not public#assertFalse(object#isA("UnknownClass"), msg) return.   
}

function KUnitObjectTest_testIsClass {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    local msg is "Object class shouldn't be identified as BaseClass".
    if not public#assertFalse(object#isClass("BaseClass"), msg) return.
    
    local msg is "Object class shouldn't be identified as KUnitObject".
    if not public#assertFalse(object#isClass("KUnitObject"), msg) return.
    
    local msg is "Object class should be identified as TopClass".
    if not public#assertTrue(object#isClass("TopClass"), msg) return.
    
}

function KUnitObjectTest_testIsClass_StaticCall {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    local msg is "Object class shouldn't be identified as BaseClass".
    if not public#assertFalse(KUnitObject_isClass(object, "BaseClass"), msg) return.
    
    local msg is "Object class shouldn't be identified as KUnitObject".
    if not public#assertFalse(KUnitObject_isClass(object, "KUnitObject"), msg) return.
    
    local msg is "Object class should be identified as TopClass".
    if not public#assertTrue(KUnitObject_isClass(object, "TopClass"), msg) return.
    
}

function KUnitObjectTest_testToString {
    declare local parameter public, private.

    local object is private#testObject.
    local expected is "TopClass@" + object#getRefID().
    local actual is object#toString().
    
    if not public#assertEquals(expected, actual, "Unexpected string representation") return.
}

function KUnitObjectTest_testEquals {
    declare local parameter public, private.
    
    local object is private#testObject.
    
    local msg is "Object should be equals to itself".
    if not public#assertTrue(object#equals(object), msg) return.
    
    set msg to "Object shouldn't be equals to object of different class". 
    if not public#assertFalse(object#equals(public), msg) return.
    
    set msg to "Object shouldn't be equals to object with different RefID".
    local className is list("TopClass", "BaseClass").
    local protectedOther is lexicon().
    local other is KUnitObject(className, protectedOther).
    if not public#assertFalse(object#equals(other), msg) return.
    
    // One more case: when two objects of same class have same RefID
    // The only way to create different hash with same ref ID is make a copy of
    // original. Using lexicon:copy method gives a "shallow" copy. That mean we
    // can't build a copy of private members outside the class. In other words
    // the test cannot be formulated in current situation.
}


