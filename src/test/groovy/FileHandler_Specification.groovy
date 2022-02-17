import spock.lang.Specification
import spock.lang.Unroll

class FileHandler_Specification extends Specification {

    @Unroll
    def "FileHandler reads contents of file"() {
        given: "a FileHandler instance"
        FileHandler fileHandler = new FileHandler(pathAndFileName)
        def contents

        when: "I read the contents of the file"
        contents = fileHandler.readFileContents()

        then: "I expect the contents to be non-null"
        contents != null

        where: "test files are"
        pathAndFileName   || _
        'tests/INVOIC_CU Test1.xml' || _
        'tests/INVOIC_CU Test2.xml' || _

    }
}