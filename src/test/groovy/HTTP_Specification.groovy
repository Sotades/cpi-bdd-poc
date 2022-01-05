import spock.lang.Specification


class HTTP_Specification extends Specification {

    def "Make an HTTP GET with Authorisation"() {

        given:
        String username = 'sb-18fab321-4609-47c4-9718-ae9b2bce3726!b3328|it-rt-cpit100!b259'
        String password = 'c9316225-46fb-4692-bf94-6f8f4c5a2494$83F8QIJp3JT5-sp-L_J-banOvlHugLdrcnBXNw5mRGI='

        String userpass = username + ":" + password;

        URL url = new URL('https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/http_test')
        URLConnection uc = url.openConnection();

        String basicAuth = "Basic " + new String(Base64.getEncoder().encode(userpass.getBytes()));

        uc.setRequestProperty ("Authorization", basicAuth);

        InputStream inputStream = uc.getInputStream()

        String fred = 'Fred'

        expect:
        fred == 'Fred'


    }
}