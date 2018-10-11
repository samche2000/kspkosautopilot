// Wrapper around kOS output stream
// We need this to make mockups on this interface to test other classes

runoncepath("kunit/class/KUnitObject").

function KUnitPrinter {
    declare local parameter
        className is list(),
        protected is lexicon().
    className:add("KUnitPrinter").

    local public is KUnitObject(className, protected).
    local private is lexicon().    

    set public#print to KUnitPrinter_print@.

    return public.
}

function KUnitPrinter_print {
    declare local parameter text.
    print text.
}
