@lazyglobal off.

// Status: investigate
// Not yet done.
// Still unable to reproduce test case automatically.

// The Case: Looks like that MANY (but not all) errors inside mix of
// closure+delegate+storing code references to lexicon causes KSP crash.
// With high prob it depends on stack depth.
//
// Example1:
//
//function KUnitObject_equals {
//    declare local parameter public, protected, private, other.
//    if other = public {
//        return true.
//    }
//    if not public#isSameClassWith(other) {
//        return false.
//    }
//    //if object#getRefID() = public#getRefID() {
//    if object["getRefID"]() = public["getRefID"]() {
//       ^^^^^ IT MUST BE other
//       Calling this causes KSP crash.
//       But reproduce it from a clear leaf is hard.
//       Possible the current stack state is matters.
//       That does not matter what reference syntax is used: o#x or o["x"]
//       Both lead to crash.
//
//        return true.
//    } else {
//        return false.
//    }
//}
//
//
// Example2:
//function KUnitObject_isSameClassWith {
//    declare local parameter public, protected, private,
//        other.  // Value to test. It must be at least lexicon or
//                // runtime error will occur.
//        
//    if not KUnitObject_isObject(other) {
//        return false.
//    }
//    if object#getClassName() = public#getClassName() {
//       ^^^^^^ IT MUST BE other
//        return true.
//    }
//    return false.
//}
//
// Example3:
//
// method declaration:
// 
//      set public#equals to KUnitObject_equals@:bind(public).
//
// method definition:
//
//function KUnitObject_equals {
//    declare local parameter public, protected, private, other.
//
//
// Example4: inside a test case
//
//  local expectedObject is KUnitObject().
//  local actualObject is KUnitObject().
//  local r is public#assertObjectEquals(expectedObject, acualObject, "Test message").
//                                                       ^^^^^ causes crash
//
// Example 5:
//
//  local actualObject is expectedObject.
//  local r is object#assertObjectEquals(expectedObject, actualbject, "Test message").
//                                                       ^^^ same here
//
// Example 6: (possible related to test_case3):
//
//     local msg is "Test message. Failed: expected: <[" +
//        expectedObject#toString() + "]> but was <[" + actualObject#toString + "]>".
//                                                                          ^^^
// Example 7:
//
//    } else if actualList:lenth <> expectedList:length {
//        set result to builder#buildExpectationFailure(msg,
//            "Number of elements", expected:length, actual:length).
//                                  ^^^^ must be expectedList, causes crash
//        set ret to false.
//    }
//
// Example 8:
//
// } else if actualList:lenth <> expectedList:length {
//                      ^^^^^ causes chash
//
// Example 9:
//
//    local expected is "KUnit v0.0.2".
//    local actual is KUnit_getVersionString().
//    if not public#assertEquals(expected, actua) return.
//                                             ^^ crash
//
// Example 10: (calling with wrong signature)
//
// When method defined
// function KUnitTestCaseReport_aggregateEvent {
//    declare local parameter public, private.
// }
//
// So calling causes crash
// object["aggregateEvent"](event).
// because aggregateEvent hasn't declared third argument
//
//