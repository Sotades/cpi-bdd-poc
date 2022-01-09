import org.junit.Ignore
import spock.lang.Specification
import org.apache.commons.io.IOUtils


class HTTP_Specification extends Specification {

    @Ignore
    def "Make an HTTP GET with Authorisation"() {

        given: "Make an HTTP GET call to CPI"
        String username = 'sb-18fab321-4609-47c4-9718-ae9b2bce3726!b3328|it-rt-cpit100!b259'
        String password = 'c9316225-46fb-4692-bf94-6f8f4c5a2494$83F8QIJp3JT5-sp-L_J-banOvlHugLdrcnBXNw5mRGI='

        String userpass = username + ":" + password;

        String basicAuth = "Basic " + new String(Base64.getEncoder().encode(userpass.getBytes()));

        URL url = new URL('https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/http_test')
        URLConnection uc = url.openConnection();
        uc.requestMethod = 'GET'

        uc.setRequestProperty ("Authorization", basicAuth);



        when: "Making a String from the response"
        BufferedReader input = new BufferedReader(new InputStreamReader((uc.getInputStream())))
        StringBuilder response = new StringBuilder();
        String inputLine

        while ((inputLine = input.readLine()) != null)
            response.append(inputLine);
        input.close()

        then: "expect response not to be null"
        response != null

    }

    def "Use IOUtils"() {

        given: "Make an HTTP GET call to CPI"
        String username = 'sb-18fab321-4609-47c4-9718-ae9b2bce3726!b3328|it-rt-cpit100!b259'
        String password = 'c9316225-46fb-4692-bf94-6f8f4c5a2494$83F8QIJp3JT5-sp-L_J-banOvlHugLdrcnBXNw5mRGI='

        String userpass = username + ":" + password;

        String basicAuth = "Basic " + new String(Base64.getEncoder().encode(userpass.getBytes()));

        URL url = new URL('https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/http_test_test')
        URLConnection uc = url.openConnection();
        uc.requestMethod = 'POST'

        uc.setRequestProperty ("Authorization", basicAuth);

        when: "Making a Stream from the response using IOUtils"
        String response;

        InputStream inputStream = uc.getInputStream()
        try {
            response = IOUtils.toString(inputStream);
        } finally {
            IOUtils.closeQuietly(inputStream);
        }

        then: "expect response not to be null"
        response != null
        System.out.println(response)
    }

    def "Building an HTTP POST Request With HttpURLConnection"() {

        given: "Make an HTTP GET call to CPI"
        String username = 'sb-18fab321-4609-47c4-9718-ae9b2bce3726!b3328|it-rt-cpit100!b259'
        String password = 'c9316225-46fb-4692-bf94-6f8f4c5a2494$83F8QIJp3JT5-sp-L_J-banOvlHugLdrcnBXNw5mRGI='

        String userpass = username + ":" + password;

        String basicAuth = "Basic " + new String(Base64.getEncoder().encode(userpass.getBytes()));

        URL url = new URL('https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/http_test_test')
        HttpURLConnection con = url.openConnection();
        con.setRequestMethod("POST")
        con.setRequestProperty ("Authorization", basicAuth);
        con.setRequestProperty("Content-Type", "application/xml; utf-8");

        con.setRequestProperty("Accept", "application/xml");
        con.setDoOutput(true);

        String xmlInputString = '''<?xml version="1.0" encoding="UTF-8"?><ZINVOIC02><IDOC BEGIN="1"><EDI_DC40 SEGMENT="1"><TABNAM>EDI_DC40</TABNAM><MANDT>210</MANDT><DOCNUM>0000000000100109</DOCNUM></EDI_DC40></IDOC></ZINVOIC02>'''

        try(OutputStream os = con.getOutputStream()) {
            IOUtils.write(xmlInputString, os, "UTF-8")
        }
        when: "Making a Stream from the response using IOUtils"
        String response

        try(InputStream inputStream = con.getInputStream()) {
            response = IOUtils.toString(inputStream);
        }

        then: "expect response not to be null"
        response != null
        System.out.println(response)
    }

}