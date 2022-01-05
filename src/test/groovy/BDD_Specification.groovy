import groovy.transform.SourceURI
import spock.lang.Shared
import spock.lang.Specification


class BDD_Specification extends Specification {

    def "Name"() {

        given: "a set of test files"
        def testFiles2 = new File("tests").listFiles()
        def body
        def baseUrl = new URL('https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/http_test')
        URLConnection connection = baseUrl.openConnection()

        testFiles2.size().times {

            when: "test file is sent to CPI for transform"
            body = testFiles2[it].text
            connection.with {
                doOutput = true
                requestMethod = 'POST'

            }

            then:
            1 == 1

        }

    }
}