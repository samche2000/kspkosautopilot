@lazyglobal off.

// Status: confirmed
// Not yet done.
//
// The Case: Printing lexicon with complex content causes KSP crash.
//
// Example:
// 
// local expected is KUnitEvent("failure", "Test failure message"). 
// print "EXPECTED: " + expected#toString(). // <-- works
// print "EXPECTED: " + expected. 			 // <-- causes crash
//