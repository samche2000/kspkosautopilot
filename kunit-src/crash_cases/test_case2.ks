@lazyglobal off.

// Status: investigate (possible related to test_case3)
// Not yet done.
//
// The Case: Accessing lexicon created in closure scope and stored to variable
// outside of closure scope causes KSP crash while accessing that stored value
// outside of closure scope. Looks like that the tracking of references is not
// correct in this case.
//
// Example:
// 
//  local actual is list().
//    local fn is {
//        declare local parameter x.
//        actual:add(x). // <-- storing lexicon to list
//    }.
//    set reporterMock#notifyOfTestStart to fn.
//
//    // ...
//    // initiate working fn
//
//    print actual. // <-- will cause KSP crash
//
// -----------------------------------------------------------------------------
// At same time storing primitive values will not cause KSP crash
// For example this code works well:
//
//  local actual is list().
//    local fn is {
//        declare local parameter x.
//        actual:add(x#toString()). // <-- storing primitive to list
//    }.
//    set reporterMock#notifyOfTestStart to fn.
//
//    // ...
//    // initiate working fn
//
//    print actual. // <-- will work OK
// 
// Example2: Same thing with variable instead of list
//
//