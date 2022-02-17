import groovy.xml.XmlSlurper
import spock.lang.Specification
import spock.lang.Unroll


class HTTPConnectionHandler_Specification extends Specification {

    @Unroll
    def "Successful call into backend"() {

        given: "I set up the FileHandler and HTTPConnectionHandler"
        FileHandler fileHandler = new FileHandler(pathAndFileName)
        def fileContents = fileHandler.readFileContents()
        def urlAddress = 'https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/http_test_test'
        def user = 'sb-18fab321-4609-47c4-9718-ae9b2bce3726!b3328|it-rt-cpit100!b259'
        def password = 'c9316225-46fb-4692-bf94-6f8f4c5a2494$83F8QIJp3JT5-sp-L_J-banOvlHugLdrcnBXNw5mRGI='

        HTTPConnectionHandler ch = new HTTPConnectionHandler(urlAddress, user, password)
        ch.setRequestBody(fileHandler.readFileContents())

        when: "I call the connection handler to fetch the response"
        def response = ch.getResponse()
        def responseXml = new XmlSlurper().parseText(response)

        then: "I expect the following fields to match the expected results"
        responseXml.IDOC.E1EDK01.CURCY == curcy
        responseXml.IDOC.E1EDK01.HWAER == hwaer
        responseXml.IDOC.E1EDK01.NTGEW == ntgew

        where: "test files and expected results are"
        pathAndFileName             || curcy | hwaer | ntgew
        'tests/INVOIC_CU Test1.xml' || 'SEK' | 'SEK' | 153.120
        'tests/INVOIC_CU Test2.xml' || 'GBP' | 'GBP' | 221.937

    }
}