// This is example how to write KOS OOP KUnit-way.
// It's a UnitTest class but that does not matter.
// Nevertheless, it's not example of OOP basics.
// You need some OOP knowledge to understand all terms here.

// Include classes this class will use
runoncepath("kunit/class/KUnitTest").
runoncepath("kunit/class/KUnitReporter").

// Constructor function produces class instances. You can call it as you wish
// but the best practice is to call it same as class name.
function MyClassTest {
    declare local parameter
        // Those are constructor arguments of MyClassTest class.
        // You can declare any set of constructor arguments in you classes.
        // But the last two are important for OOP.
        
        // Base class KUnitTest requires test reporter.
        // We can get reporter instance outside or produce new if
        // it wasn't passed to the constructor.
        reporter is KUnitReporter(),
        
        // Those arguments are typical part of OOP KUnit-way.
        // Other class may want inherit this class.
        // Such subclass will have it's own class name which should be
        // passed through class hierarchy using className list.
		// But if it isn't derived then we make new list of className
		// because we need this for itself.
        className is list(), 
        
        // This is storage of protected interface members. Because
        // protected members should not be accessible outside hierarchy
        // this works like request for protected interface. As you see
        // that request may came from derived class. In this case,
        // derived class will obtain protected interface with all
        // protected elements of all classes which provide protected members.
		// If this is not case of inheritance or there was not request for
		// protected interface then we create new storage to use it for itself.
        protected is lexicon().
        
    // Don't forget to register class name or it will look like a base class
    className:add("MyTest"). 
    
    // This line is quite important. This line produces accessible
    // interfaces of base class. Those are public and protected. Public
    // is "must have" but protected is optional. We need protected
    // interface of parent class here because we want override some
    // protected methods. To understand what there happen exactly just
    // have a look on KUnitTest constructor arguments:
    // The first one just a name of test. It can be any string you
    // wish. The second one is reporter to make base class properly
    // working. Actually it isn't needed because KUnitTest can create
    // reporter if isn't passed. But if you want to run tests with
    // KUnit runners you have require and pass reporter down through
    // class hierarchy. Passing className isn't so important for this
    // class as for derived class and this class consumers. The last
    // argument is also needed for derived classes and in case if we
    // want to use protected interface of base class. We want to use
    // protected therefore we "ask" base class to provide its protected
    // members for us.
    local public is KUnitTest("MyTestName", reporter, className, protected).
    
    // Make storage of private members.
    // Private members are our own members which is inaccessible for
    // all outside of this class. The good approach is to keep all
    // members private and open only those what are really needed to
    // be opened.
    local private is lexicon().
    
    // If you want just call protected members of base class you do not
    // care. But if you want to override and then call base implementation
    // of protected method you have to keep original references.
    // Make shallow copy of protected interface to use it later.
    local parentProtected is protected:copy().
    
    // Declare your class public methods.
    // This code requires some explanations. Each method registration
    // (independently of which interface it's linked to: public, protected or
    // private) is making a delegate with binding "interfaces" to this call.
    // Obtained reference is saved to appropriate interface. Literally it makes
    // a lexicon pair with method name as key and delegate as value.
    // Binding required (for this separate method) "interfaces" makes
    // this call free of passing class arguments between calling the
    // members. Calling it outside looks like calling of an object
    // member. But when it comes to method implementation it obtains
    // all needed for work. Those methods registered to work with public
    // and private interfaces. Those variables should be declared first
    // in method definition. Be careful keeping declaration and definition
    // in consistent state to each other. Otherwise you may face problems with
    // error localisation during refactorings or similar things.
    // Look into MyClassTest_testMyCase definition (method body) to ensure that
    // binding variables and declaring arguments in function body are made in a
    // right way.
    set public#testMyCase1 to MyClassTest_testMyCase1@:bind(public, private).
    set public#testMyCase2 to MyClassTest_testMyCase2@:bind(public, private).
    
    public#addCasesByNamePattern("^test").
    
    // Don't forget to return public interface
    return public.
}

function MyClassTest_testMyCase1 {
    declare local parameter public, private.

    local expected is "foo".
    local actual is "bar".    
    if not public#assertEquals(expected, actual) return.
}

function MyClassTest_testMyCase2 {
    declare local parameter public, private.

}
