import groovy.xml.XmlSlurper
import spock.lang.Specification
import spock.lang.Unroll


class CPI_Transform_Specification extends Specification {

    @Unroll
    def "Testing CPI Transform"() {

        given: "I set up the FileHandler and HTTPConnectionHandler"
        FileHandler fileHandler = new FileHandler(pathAndFileName)
        def fileContents = fileHandler.readFileContents()
        def urlAddress = 'https://mg-dev-integration.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/http_test'
        def user = 'sb-2929bbcc-e1b4-41ef-8bb7-1e72f4d1f413!b2561|it-rt-mg-dev-integration!b259'
        def password = '9a4075bd-5f35-4a67-8b95-7cf606603384$li0n2-TSS2gkuipwCn01hftOMKQFtUrKQJyW4iyTI4c='

        HTTPConnectionHandler ch = new HTTPConnectionHandler(urlAddress, user, password)
        ch.setRequestBody(fileHandler.readFileContents())

        when: "I call the connection handler to fetch the response"
        def response = ch.getResponse()
        def responseXml = new XmlSlurper().parseText(response)

        then: "I expect the following fields to match the expected results"
        responseXml.IDOC.E1EDK01.CURCY == curcy
        responseXml.IDOC.E1EDK01.HWAER == hwaer
        responseXml.IDOC.E1EDK01.NTGEW == ntgew
        responseXml.IDOC.E1EDK01.GEWEI == gewei

        where: "test files and expected results are"
        pathAndFileName             || curcy | hwaer | ntgew    | gewei
        'tests/INVOIC_CU Test1.xml' || 'SEK' | 'SEK' | 153.120  | 'KGM'
        'tests/INVOIC_CU Test2.xml' || 'GBP' | 'GBP' | 221.937  | 'LTR'
        'tests/INVOIC_CU Test3.xml' || 'USD' | 'USD' | 451.216  | 'EA'

    }
}