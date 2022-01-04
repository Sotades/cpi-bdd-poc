import spock.lang.Specification


class Test_Specification extends Specification {
    def "Basic Functionality Test"() {
        given:
        def aString = 'Fred'

        expect:
        aString == 'Fred'
    }
}