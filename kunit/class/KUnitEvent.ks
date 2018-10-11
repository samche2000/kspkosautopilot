// Class to represent test event

runoncepath("kunit/class/KUnitObject").

// Constructor.
function KUnitEvent {
	declare local parameter
	   type,               // String identifier of the event type (for example
	                       // "fail", "ok", etc...)
	   msg is "",          // Text message to describe the event (optional)
	   testName is "",     // Test name (optional) 
	   testCaseName is "", // Test case name (optional) 
	   className is list(),
	   protected is lexicon().
	className:add("KUnitEvent").

	local public is KUnitObject(className, protected).
	local private is lexicon().
	
	set private#type to type.
	set private#message to msg.
	set private#testName to testName.
	set private#testCaseName to testCaseName.

	// class methods
	set public#getType to KUnitEvent_getType@:bind(public, private).
	set public#getMessage to KUnitEvent_getMessage@:bind(public, private).
	set public#getTestName to KUnitEvent_getTestName@:bind(public, private).
	set public#getTestCaseName to KUnitEvent_getTestCaseName@:bind(public, private).
	set public#toString to KUnitEvent_toString@:bind(public, private).
	set public#equals to KUnitEvent_equals@:bind(public, private).

	return public.
}

function KUnitEvent_toString {
	declare local parameter public, private.
	local r is "".
	if private#testName <> "" {
		set r to private#testName.
		if private#testCaseName <> "" {
			set r to r + "#" + private#testCaseName.
		}
		set r to r + " ".
	}
	set r to r + private#type.
	if private#message <> "" {
		set r to r + ": " + private#message.
	}
	return r.
}

function KUnitEvent_equals {
    declare local parameter public, private, other.
    if public = other {
        return true.
    }
    if not public#isSameClassWith(other) {
        return false.
    }
    if private#type = other#getType() and
        private#message = other#getMessage() and
        private#testName = other#getTestName() and
        private#testCaseName = other#getTestCaseName()
    {
        return true.
    }
    return false.
}

function KUnitEvent_getType {
    declare local parameter public, private.
    return private#type. 
}

function KUnitEvent_getMessage {
    declare local parameter public, private.
    return private#message.
}

function KUnitEvent_getTestName {
    declare local parameter public, private.
    return private#testName.
}

function KUnitEvent_getTestCaseName {
    declare local parameter public, private.
    return private#testCaseName.
}
