import spock.lang.Specification
import spock.lang.Unroll


class File_Specification extends Specification {

    def "Listing files in a directory"() {
        given: "a set of test files"

        when: "I list the files"
        def testFiles = new File("tests").listFiles()

        then: "Some files should be present in the list"
        testFiles.size()

    }
    @Unroll
    def "Test for each file in a directory"() {
        given: "a set of test files"
        def inputBody
        def outputBody
        def inString
        def outString

        when: "I read the input and output files"
        inputBody = new File("tests/$inFile")
        outputBody = new File("tests/output/$outFile")
        inString = inputBody.text
        outString = outputBody.text

        then: "expect them to be the same"
        inputBody.text == outputBody.text
        1 == 1


        where:
        inFile                  | outFile
        "INVOIC_CU Test1.xml"   | "INVOIC_CU Test2.xml"
        "INVOIC_CU Test2.xml"   | "INVOIC_CU Test1.xml"


    }
}