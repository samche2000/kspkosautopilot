# KUnit - Unit Testing framework for kerboscript

<b>Note: This project is not part of [KOS project](https://github.com/KSP-KOS/KOS). Please don't ask to do something with KOS.</b>

KUnit provides possibility to write repeatable tests for kerboscript -
[KOS programming language](https://github.com/KSP-KOS/KOS). KUnit is an
instance of the xUnit architecture for unit testing frameworks.

KUnit shouldn't force to write any tests but should help write any test you want for any code you want in case when you feel that it should be tested. There is a way how to implement, organize and run your tests. And this is KUnit. If you found this tool nice and helpful this means KUnit works well.

KUnit also demonstrates how to use object-oriented approach in KOS
programs to achieve well-looking design, maximum code reusability and
exceptional software quality.


## Professor Kobert informs you of possible risks

* Higher level - you can use object#member calling signature in your programs
but keep in mind that availability of such approach may be terminated by kOS
maintainers. In case if it is terminated you will be forced to rewrite all your
classes for official supported syntax with object["member"] calling signature. 
Possible, KUnit maintainers will provide a tool for automatical refactoring
but no promises.

* Lower level - you can use object["member"] calling signature in your
programs. This should work while kOS supports binding code with variables.
That is official KOS feature with low risk to disapper.

* Lowest level - you can use ancient procedural approach which is officially
supported by KOS. In this case you'll never face with problems around
object-oriented programming on KOS.

* Zero level - you can use any other language to write your programs for
[KSP](https://www.kerbalspaceprogram.com/en/).
In this case you'll never face with problems programming on KOS.

## Get started

To get started just run KUnit unit tests. Let's assume that you placed KUnit to Archive volume. Open KOS terminal and run:

```
switch to 0.
runpath("kunit/suite", "kunit/test").
```
It may take few seconds to scan for test files then testing process begin.
Finally if you see something like that
```
== GREENLINE =============================
                  total |success | failed
     assertions:    371 |    371 |      0
     test cases:    114 |    114 |      0
          tests:     14 |     14 |      0
         errors:      0
========================== KUnit v0.0.2 ==
```
then you definitely can use all features and approaches KUnit suggests. GREENLINE is a key. This means all tests passed without failures and errors. 

Want to see how failures will look? Just run example test cases
```
runpath("kunit/suite", "kunit/examples").
```
After passing the tests you will see something like that
```
MyTestName#testmycase1 testCaseEnd
MyTestName#testmycase2 testCaseStart
MyTestName#testmycase2 testCaseEnd
MyTestName testEnd
== REDLINE ===============================
                  total |success | failed
     assertions:     12 |      2 |     10
     test cases:      6 |      1 |      5
          tests:      3 |      0 |      3
         errors:      1
========================== KUnit v0.0.2 ==
FAILURES:
FailuresDemoTest#teststringsarentequal assertion[0]failure: Value equality expectation. Values are not equal: expected: <[foo]> but was <[bar]>
FailuresDemoTest#testwhatifdonotcheckassertionresult assertion[0]failure: You will see. element #0 mismatch: expected: <[foo]> but was <[bar]>
FailuresDemoTest#testwhatifdonotcheckassertionresult assertion[1]failure: more output
FailuresDemoTest#testwhatifdonotcheckassertionresult assertion[2]failure: until test ended. Failed: expected: <[KUnitObject@41]> but was <[KUnitObject@42]>
FailuresDemoTest#testhowtoidentifyfailurelocation assertion[2]failure: Have a look on assertion[X] information.
FailuresDemoTest#testhowtoidentifyfailurelocation assertion[3]failure: You can identify assertion by its index
FailuresDemoTest#testhowtoidentifyfailurelocation assertion[4]failure: which is shown in [] brackets.
FailuresDemoTest#testhowtoidentifyfailurelocation assertion[5]failure: Then find assertion in the test case and fix the problem
FailuresDemoTest#testhowtoidentifyfailurelocation assertion[6]failure: That's easy
MyTestName#testmycase1 assertion[0]failure: Value equality expectation. Values are not equal: expected: <[foo]> but was <[bar]>
ERRORS:
ErrorsDemoTest#testerrorsarentfailures error: Test case setup failed
```
Have you noticed there is REDLINE? REDLINE means there are problems with the passed tests or code under test.

<b>Note: REDLINE or GREENLINE is the most significant report you should track while doing TDD.</b>

Do not worry that there is the REDLINE here. Those tests especially written to demonstrate how KUnit will handle failures and errors. Let's get deeper what we see in case of failures. I will cut the output to make it a bit  nicer. Consider that output is eqivalent to the last one

```
MyTestName#testmycase1 testCaseEnd
MyTestName#testmycase2 testCaseStart                
MyTestName#testmycase2 testCaseEnd
MyTestName testEnd                               <-- here and above is the test execution log section
== REDLINE ===============================    
                  total |success | failed
     assertions:     12 |      2 |     10
     test cases:      6 |      1 |      5        <-- here is summary report of the test run
          tests:      3 |      0 |      3
         errors:      1
========================== KUnit v0.0.2 ==

FAILURES:                                        <-- here and below is assertion failures report
FailuresDemoTest#teststringsarentequal assert...
FailuresDemoTest#testwhatifdonotcheckassertio...
FailuresDemoTest#testwhatifdonotcheckassertio...
FailuresDemoTest#testwhatifdonotcheckassertio...
FailuresDemoTest#testhowtoidentifyfailureloca...
FailuresDemoTest#testhowtoidentifyfailureloca...
FailuresDemoTest#testhowtoidentifyfailureloca...
FailuresDemoTest#testhowtoidentifyfailureloca...
FailuresDemoTest#testhowtoidentifyfailureloca...
MyTestName#testmycase1 assertion[0]failure: V...
ERRORS:                                          <-- here and below is test error report
ErrorsDemoTest#testerrorsarentfailures error:...
```
Let's figure out why we need each section. Each section is quite important as the order they are followed by

* Test execution log may look redundant but this section is important because it is realtime execution log. It prints information at time when it was obtained from the test. There is difference with other sections which is formed AFTER all tests. In case if you got critical failure and you test run is broken you will see WHERE the problem appeared. What test what test case and possible what assertion. Taking this information into account you can easily locate the code where exactly to work to beat this issue. That is definitely useful.

* Summary Report is the overview of test run situation. It isn't located at bottom because when you got failures you prefer to know more details instead of summary. This report may be formed after all wanted tests run. Therefore you will not see this and all following sections if you get something what may called "language error". Don't worry, this is normal in TDD. The main goal is to keep your code clear of errors in production. By the way, when you got GREENLINE looking at the summary report you can proud of work you done. That's quite nice.

* Assertion failures report lists all registered failures. Test execution log may contain so many lines to make investigation process quite hard. Actually we do not need anything else instead of information about failures and errors. Therefore there is assertion failures report. Keep in mind that all assertions inside a single test case have its own index. Index means in what order this statement follows in the body of the test case. KOS does not provide any information about what line of code caused a problem. Therefore KUnit suggests assertion indexation to make issue localization easier. So you can find appropriate assertion even if it does not provide detailed message. Assertion failures report is the section you will use most time while doing TDD. 

* And the last one - is the error reporting section. Errors are not assertion failures. Failures are related to code under test. But errors are related to test code itself. Most time you will not see this section. But sometimes your test may include more interaction with test environment. And in case if there are problems with test environment there will be test errors. For example you test is to create files but volume size limit is reached. This will cause problems but your code under test is actually fine. There will be a test error, not your code failure. To separate such situations from test cases, there are errors. This section is the last one because most cases you do not need to fix your code in case of error. Errors may cause assertion failures. And to get the GREENLINE, you have to fix errors first. Because of this, the error reporting section should be at most visible position.

Hope this paragraph was clear enough to make you excited of KUnit possibilities. If so, let's go ahead.

## How to run tests

There is two meaning of runner term: the first one is the program to run your test and the second one is the class which implements how tests will run. This paragraph is about program to run your tests.

If you have a look on contents of kunit directory you will see two strange files: single.ks and suite.ks. They are test runners. The first one is to run single test and the second is for big test suites. They are do not have a lot differencies but one important: the test execution speed (telling more precise is the scanning for tests). Let's look at how to use these programs.

Running suite is useful when you going to make a commit of your project. Running suite allows you run all existing tests. And the good practive is run all tests before commiting to be sure nothing is broken. If you run kunit/suite without an arguments you will see something like that
```
runpath("kunit/suite").
Welcome to KUnit v0.0.2 test suite runner
Usage:
  runpath(kunit/suite, <SUITE_DIRECTORY>, [NAME_PATTERN], [CASE_PATTERN]).

NOTE: Use double quotes when needed.
      KOS does not support escape sequences to show exact commands.

Usage examples

Show this help:
  runpath(kunit/suite).

Run all KUnit tests:
  runpath(kunit/suite, kunit/test).

Run KUnitObjectTest only:
  runpath(kunit/suite, kunit/test, KUnitObject).
  runpath(kunit/suite, kunit/test, KUnitObjectTest).

Run testToString case of KUnitObjectTest only:
  runpath(kunit/suite, kunit/test, KUnitObject, testToString).

Run testToString and testEquals of KUnitObjectTest:
  runpath(kunit/suite, kunit/test, KUnitObject, test(ToString|Equals).
```
This is a help page you will see any time while run without arguments or run with wrong arguments. In additional if there is wrong argument you will see something like that at head
```
runpath("kunit/suite", "very-bad-suite-directory").
ERROR: Suite path you entered is not directory or not exists: very-bad-suite-directory
ERROR: Check the path and try again
Welcome to KUnit v0.0.2 test suite runner
...
```
Keep an eye on such errors because it's generally often case when you mistaken while switching before suites. So the suite path is just a path to directory contain set of unit tests which are written KUnit-way. Correct examples of path to suite in KUnit package are kunit/examples and kunit/tests. You can use ANY paths relative or absolute. Both should work. Suite path is mandatory argument if you want to get it work.

The last two arguments NAME_PATTERN and CASE_PATTERN are regular expression patterns to select tests or test cases to run.
Don't worry if you do not understand regular expressions. It will work if you will use it in simple inclusion patterns without any special characters. For example this command will run only test which name is KUnitObjectTest:
```
runpath("kunit/suite", "kunit/test", "KUnitObjectTest").
```
This one will run only one test case called testEquals of KUnitObjectTest
```
runpath("kunit/suite", "kunit/test", "KUnitObjectTest", "testEquals").
```
You see this quite enough for most cases. When you get ready you could easily choose test cases in more precise manner
```
runpath("kunit/suite", "kunit/test", "KUnit(Object|Reporter)Test").
runpath("kunit/suite", "kunit/test", "KUnitObjectTest", "test(Equals|ToString)").
runpath("kunit/suite", "kunit/test", "KUnit(Report).*?Test").
```
And so on. 

Let's have a look on single test runner
```
runpath("kunit/single").
Welcome to KUnit v0.0.2 single test runner
Usage:
  runpath(kunit/single, <TEST_PATH>, [CASE_PATTERN]).

NOTE: Use double quotes when needed.
      KOS does not support escape sequences to show exact commands.

Usage examples

Show this help:
  runpath(kunit/single).

Run all cases of KUnitObjectTest:
  runpath(kunit/single, kunit/test/KUnitObjectTest).

Run testToString case of KUnitObjectTest:
  runpath(kunit/single, kunit/test/KUnitObjectTest, testToString).

Run testToString and testEquals of KUnitObjectTest:
  runpath(kunit/single, kunit/test/KUnitObjectTest, test(ToString|Equals).

```
This runner is quite similar to suite runner. The difference is second argument is a path to test file. There is no test filtering pattern but still test case pattern. It works similar to suite runner. As noticed above, the single test runner works a bit faster because it does not need to scan directories for test files. You should use single runner while working with tests separately of each other.

## How to write Unit Tests

To get started writing tests have a look on files in kunit/examples. Those classes are
written especially simplified. Some useful (I hope) comments are provided.

Also, KUnit is covered by self-tests. Those tests have lot examples of basics and tricks how to test your code. Study it and you could do TDD as pro. All KUnit self-tests are located in kunit/test subdirectory of project root. 

I hope here will be more useful examples soon.

## Known issues

### KOS bugs

The most critical issue is that KOS have a very unpleasant bug which appeared
often when you coding TDD + OOP. In such case you run your test often and you
have lot calls on stack. In case if you mistaked in variable name sometimes KOS
cannot handle stack and that leads to KSP chash. The problem is that situation
cannot be easily reproduced in automated test. When we try then we get an
expected KOS behavior. But we will keep trying. Project crash_cases directory
contains description of issues. They are definitely bugs and do not related to
object-oriented programming or unit testing only. They may appear any time you
work kerboscript. KUnit developers informed KOS maintainers about that case and
hope this kind of bugs will be fixed soon.

### Don't make protected class attributes

Combination of inheritance and calling parent may lead to a mess with
references. Making a shallow copy of parent protected interface means you will
get two independent copies of attributes if they are primitive types. Better to
keep all properties private and use protected mutator/accessor to provide an
access to them for derived classes.

### Where object#member does not work

In some cases referencing with # does not work
```
print "PRINT ME: " + ("" + private#numTests). 
```
Use official syntax instead of code above
```
print "PRINT ME: " + ("" + private["numTests"]).
```

## What would be nice to get better OOP on top of KOS

* Having three lexicons for those scopes: public, protected and private is most
significant problem while programming OOP on KOS. It causes lot problems with
method declaration and definition. There should be an adequate analogue for
visibility specificators.

* TDA (tell, don't ask) principle does not work well without possibility to
force call stack. Exceptions support would be nice and useful feature. Also TDA
means we do not want to negotiate interfaces. We want to tell of interfaces.
Type checking is very desirable feature in weak typed language. Something like
PHP type hinting would be great addition to provide strong contract declaration.
