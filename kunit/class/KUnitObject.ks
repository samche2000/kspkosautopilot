// Prototype of ANY object class

function KUnitObject {
    declare local parameter
        className is list(),
        protected is lexicon().
    className:add("KUnitObject").
        
    local public is lexicon().
    local private is lexicon().
    
    set private#className to className.
    set private#refID to KUnitObject_NEXT_REF_ID().
    
    set public#getClassName to KUnitObject_getClassName@:bind(private).
    set public#getRefID to KUnitObject_getRefID@:bind(private).
    set public#isSameClassWith to KUnitObject_isSameClassWith@:bind(public, protected, private).
    set public#isA to KUnitObject_isA@:bind(public, protected, private).
    set public#isClass to KUnitObject_isClass@:bind(public).
    set public#toString to KUnitObject_toString@:bind(public).
    set public#equals to KUnitObject_equals@:bind(public).
    
    return public.
}

// Public methods.

// Get top-level class name.
// Return: object class name
function KUnitObject_getClassName {
    declare local parameter private.
    return private#className[0].
}


function KUnitObject_getRefID {
    declare local parameter private.
    return private#refID.
}


// Public.
// Test that the argument is object of same class as this.
// Return: false if argument is not an object or belongs to other class
function KUnitObject_isSameClassWith {
    declare local parameter public, protected, private,
        other.  // Value to test. It must be at least lexicon or
                // runtime error will occur.
        
    if not KUnitObject_isObject(other) {
        return false.
    }
    if other#getClassName() = public#getClassName() {
        return true.
    }
    return false.
}


// Public.
function KUnitObject_isA {
    declare local parameter public, protected, private,
        className.
    for x in private#className {
        if x = className {
            return true.
        }
    }    
    return false.
}


function KUnitObject_toString {
    declare local parameter public.
    return public#getClassName() + "@" + public#getRefID().
}


// Public.
// Test that argument is equal to this object.
// Return: true if objects are equal. 
function KUnitObject_equals {
    declare local parameter public,
        other.          // Value to test. It must be at least
                        // lexicon or runtime error will occur.
    if other = public {
        return true.
    }
    if not public#isSameClassWith(other) {
        return false.
    }
    if other#getRefID() = public#getRefID() {
        return true.
    } else {
        return false.
    }
}


// Static.
// Test that the argument is object.
// Return: true if value is object of KUnitObject subclass
function KUnitObject_isObject {
    declare local parameter
        object.         // Value to test. It must be at least
                        // lexicon or runtime error will occur.
    if object:haskey("getClassName") and object:haskey("getRefID") {
        return true.
    }
    return false.
}


// Static or public.
// Test that the argument is an object of specified class.
// Return: true if value is object and belongs to the specified class
function KUnitObject_isClass {
    declare local parameter
        object,         // Value to test. It must be at least lexicon
                        // or runtime error will occur.
        className.      // Name of class that object should belong
    if not KUnitObject_isObject(object) {
        return false.
    }
    if object#getClassName() = className {
        return true.
    }
    return false.
}

global KUnitObject_g67asdjqjvwdhvasd89jnbavsdvvtyvasdjebzebkebdoamnjnsdhhb is 0.

// Static.
// Service method.
function KUnitObject_NEXT_REF_ID {
    local x is KUnitObject_g67asdjqjvwdhvasd89jnbavsdvvtyvasdjebzebkebdoamnjnsdhhb.
    set x to x + 1.
    set KUnitObject_g67asdjqjvwdhvasd89jnbavsdvvtyvasdjebzebkebdoamnjnsdhhb to x.
    return x.
}

// Static.
// Service method.
function KUnitObject_LAST_REF_ID {
    return KUnitObject_g67asdjqjvwdhvasd89jnbavsdvvtyvasdjebzebkebdoamnjnsdhhb.
}
