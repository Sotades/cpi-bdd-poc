import spock.lang.Specification
import spock.lang.Unroll


class HTTPConnectionHandler_Specification extends Specification {

    @Unroll
    def "Successful call into backend"() {
        given: "I set up the FileHandler"
        FileHandler fileHandler = new FileHandler(pathAndFileName)
        def fileContents = fileHandler.readFileContents()
        def urlAddress = 'https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/http_test_test'
        def user = 'sb-18fab321-4609-47c4-9718-ae9b2bce3726!b3328|it-rt-cpit100!b259'
        def password = 'c9316225-46fb-4692-bf94-6f8f4c5a2494$83F8QIJp3JT5-sp-L_J-banOvlHugLdrcnBXNw5mRGI='

        FileHandler mappedFileHandler = new FileHandler(mappedFile)
        def mappedFileContents = mappedFileHandler.readFileContents()

        HTTPConnectionHandler ch = new HTTPConnectionHandler(urlAddress, user, password)
        ch.setRequestBody(fileHandler.readFileContents())

        when: "I call the connection handler to fetch the response"
        def response = ch.getResponse()

        then: "I expect a successful call"
        response != null

        and: "response matches mapped file"
        response == mappedFileContents


        where: "test files are"
        pathAndFileName             || mappedFile
        'tests/INVOIC_CU Test1.xml' || 'tests/responses/INVOIC_CU Test1 Response.xml'
        'tests/INVOIC_CU Test2.xml' || 'tests/responses/INVOIC_CU Test2 Response.xml'

    }
}