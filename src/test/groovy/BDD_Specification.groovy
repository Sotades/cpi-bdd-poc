import groovy.transform.SourceURI
import spock.lang.Shared
import spock.lang.Specification

import java.nio.file.Path
import java.nio.file.Paths


class BDD_Specification extends Specification {

    def "Name"() {

        given: "a set of test files"
        def testFiles2 = new File("tests").listFiles()
        def body

        testFiles2.size().times {

            when: "test file is sent to CPI for transform"
            body = testFiles2[it].text

            then:
            1 == 1

        }

    }
}