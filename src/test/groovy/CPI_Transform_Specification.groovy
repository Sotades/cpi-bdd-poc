import groovy.xml.XmlSlurper
import spock.lang.Specification
import spock.lang.Unroll


class CPI_Transform_Specification extends Specification {

    @Unroll
    def "Testing as-is CPI Transform"() {

        given: "I set up the FileHandler and HTTPConnectionHandler"
        FileHandler fileHandler = new FileHandler(pathAndFileName)
        def fileContents = fileHandler.readFileContents()
        def urlAddress = 'https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/Global_SalesOrder_to_S4_HTTP_Receiver/BDD_Test/as_is'
        def user = 'sb-18fab321-4609-47c4-9718-ae9b2bce3726!b3328|it-rt-cpit100!b259'
        def password = 'c9316225-46fb-4692-bf94-6f8f4c5a2494$83F8QIJp3JT5-sp-L_J-banOvlHugLdrcnBXNw5mRGI='

        HTTPConnectionHandler ch = new HTTPConnectionHandler(urlAddress, user, password)
        ch.setRequestBody(fileHandler.readFileContents())

        when: "I call the connection handler to fetch the response"
        def response = ch.getResponse()
        def responseXml = new XmlSlurper().parseText(response)

        then: "I expect the following header fields to match the expected results"
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.DOC_TYPE == doc_type
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.SALES_ORG == sales_org
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.DISTR_CHAN == distr_chan
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.DIVISION == division
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.REQ_DATE_H == req_date_h
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.REF_1 == ref_1
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.PMNTTRMS == pmttrms
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.PURCH_NO_S == purch_no_s
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.BILL_DATE == bill_date

        where: "test files and expected results are"
        pathAndFileName               || doc_type |sales_org  |distr_chan  |division  |req_date_h |ref_1  |pmttrms|purch_no_s|bill_date
        'tests/SalesOrder_urakka.xml' || 'ZED'    | ''        | ''         | ''       | '20220224'|'18969'|''     |'71233'   |'20220224'
    }
}