import groovy.xml.XmlSlurper
import spock.lang.Specification
import spock.lang.Unroll


class CPI_To_Be_Transform_Specification extends Specification {

    @Unroll
    def "Testing to-be CPI SalesOrder Transform"() {

        given: "I set up the FileHandler and HTTPConnectionHandler"
        FileHandler fileHandler = new FileHandler(pathAndFileName)
        def fileContents = fileHandler.readFileContents()
        //def urlAddress = 'https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/Global_SalesOrder_to_S4_HTTP_Receiver/BDD_Test/as_is'
        def urlAddress = 'https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/Global_SalesOrder_to_S4_HTTP_Receiver/BDD_Test/to_be'
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
        //responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.REQ_DATE_H == req_date_h
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.REF_1 == ref_1
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.NAME == name
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.PMNTTRMS == pmttrms
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.PURCH_NO_C == purch_no_c
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.PURCH_NO_S == purch_no_s
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDHD1.CURR_ISO == curr_iso

        and: "I expect the header texts to match the following expecter results"
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDTEXT.find{ it.TEXT_ID == 'Z002' && it.ITM_NUMBER == '000000'}.TEXT_LINE == z002_text_row

        and: "I expect the first item to match the following expected results"
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDITM[0].ITM_NUMBER == itm_number_1
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDITM[0].MATERIAL == material_1
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDITM[0].TARGET_QU== target_quantity_1
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDITM[0].ITEM_CATEG == itm_categ_1
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDITM[0].PRC_GROUP1 == prc_grp_1
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDITM[0].PRC_GROUP3 == prc_grp_3
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPSDITM[0].E1BPSDITM1.ORDERID == order_id_1

        and: "I expect the following partner information"
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'AG'}.PARTN_NUMB == partner_customer_number
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'AG'}.NAME == partner_customer_name
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'AG'}.NAME_2 == partner_customer_name_2
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'AG'}.NAME_3 == partner_customer_name_3
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'AG'}.NAME_4 == partner_customer_name_4
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'AG'}.STREET == partner_customer_street
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'AG'}.COUNTRY == partner_customer_country
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'AG'}.POSTL_CODE == partner_customer_postal_code
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'AG'}.CITY == partner_customer_city

        and: "I expect the Parter Interface fields to be like this"
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'ZI'}.PARTN_NUMB == partner_interface_number

        and: "I expect the Parter Sales Person fields to be like this"
        responseXml.IDOC.Z1ZALMA_SALESORDERCREATEFRO.E1BPPARNR.find{ it.PARTN_ROLE == 'VE'}.PARTN_NUMB == partner_sales_person_number



        where: "test files and expected results are"
        pathAndFileName                 || doc_type |sales_org  |distr_chan  |division  |req_date_h |ref_1  |name|pmttrms|purch_no_s|bill_date |purch_no_c|curr_iso|z002_text_row
        'tests/SalesOrderExample1.json' || 'ZED'    | ''        | ''         | ''       | '20220224'|'18969'|''  |'1'     |'71233'  |'20220224'|'71232'   |'EUR'   |'Onnistunutta remonttia!'
        _____
        itm_number_1|material_1|target_quantity_1|itm_categ_1|prc_grp_1|prc_grp_3|order_id_1|partner_customer_number|partner_customer_name|partner_customer_name_2|partner_customer_name_3|partner_customer_name_4|partner_customer_street|partner_customer_country|partner_customer_postal_code|partner_customer_city|partner_interface_number|partner_sales_person_number
        '000010'    |'1000'    |'1'              | 'ZTDC'    |'TBD'    |'TBD'    |'E9Q3X7'  |'10016734'             |'Fred Astaire'       |'Fred Kruger'          |'Fred Flintstone'     |'Fred the Shred'        |'10 Downing Street'    |'United Kingdom'        |'SW1A 2AA'                  |'London'             |'ZI_EVENT'              |"VIRVEK"





    }


}