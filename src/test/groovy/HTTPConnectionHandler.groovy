import org.apache.commons.io.IOUtils

class HTTPConnectionHandler {

    HttpURLConnection con

    HTTPConnectionHandler(String urlAddress, String user, String password){

        def userpass = user + ':' + password
        def basicAuth = 'Basic ' + new String(Base64.getEncoder().encode(userpass.getBytes()))


        URL url = new URL(urlAddress)

        con = url.openConnection()
        con.setRequestMethod('POST')
        con.setRequestProperty ('Authorization', basicAuth)
        con.setRequestProperty('Content-Type', 'application/xml; utf-8')
        con.setRequestProperty('Accept', 'application/xml')
        con.setDoOutput(true)

    }

    void setRequestBody(String body){
        try(OutputStream os = con.getOutputStream()) {
            IOUtils.write(body, os, 'UTF-8')
        }
    }

    String getResponse(){
        try(InputStream inputStream = con.getInputStream()) {
            def response = IOUtils.toString(inputStream)

            return response
        }

    }
}
