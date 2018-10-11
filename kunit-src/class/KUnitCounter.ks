// The counter class to help summarize test results 

runoncepath("kunit/class/KUnitObject").

function KUnitCounter {
    declare local parameter
        className is list(),
        protected is lexicon().
    className:add("KUnitCounter").

    local public is KUnitObject(className, protected).
    local private is lexicon().    

    set private#total to 0.
    set private#failure to 0.
    
    set public#addFailure to KUnitCounter_addFailure@:bind(public, private).
    set public#addSuccess to KUnitCounter_addSuccess@:bind(public, private).
    set public#getTotalCount to KUnitCounter_getTotalCount@:bind(public, private).
    set public#getSuccessCount to KUnitCounter_getSuccessCount@:bind(public, private).
    set public#getFailureCount to KUnitCounter_getFailureCount@:bind(public, private).

    set public#toString to KUnitCounter_toString@:bind(public).
    set public#equals to KUnitCounter_equals@:bind(public).

    return public.
}

function KUnitCounter_addFailure {
    declare local parameter public, private.
    
    set private#total to private#total + 1.
    set private#failure to private#failure + 1.
}

function KUnitCounter_addSuccess {
    declare local parameter public, private.
    
    set private#total to private#total + 1.
}

function KUnitCounter_getTotalCount {
    declare local parameter public, private.
    
    return private#total.
}

function KUnitCounter_getSuccessCount {
    declare local parameter public, private.
    
    return private#total - private#failure.
}

function KUnitCounter_getFailureCount {
    declare local parameter public, private.
    
    return private#failure.
}

function KUnitCounter_toString {
    declare local parameter public.
    
    return "[total=" + public#getTotalCount() +
        " success=" + public#getSuccessCount() +
        " failure=" + public#getFailureCount() +
        "]".  
}

function KUnitCounter_equals {
    declare local parameter public, other.
    
    if public = other {
        return true.
    }
    if not public#isSameClassWith(other) {
        return false.
    }
    if public#getTotalCount() = other#getTotalCount() and
        public#getFailureCount() = other#getFailureCount()
    {
        return true.
    }
    return false.
}
