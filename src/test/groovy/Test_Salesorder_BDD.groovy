import groovy.xml.XmlSlurper

FileHandler fileHandler = new FileHandler('C:\\Users\\AnthonyBateman\\IdeaProjects\\cpi-bdd-poc\\tests\\SalesOrderExample1.json')
def fileContents = fileHandler.readFileContents()

def urlAddress = 'https://cpit100.it-cpi005-rt.cfapps.eu20.hana.ondemand.com/http/Global_SalesOrder_to_S4_HTTP_Receiver/BDD_Test/to_be'

def user = 'sb-18fab321-4609-47c4-9718-ae9b2bce3726!b3328|it-rt-cpit100!b259'
def password = 'c9316225-46fb-4692-bf94-6f8f4c5a2494$83F8QIJp3JT5-sp-L_J-banOvlHugLdrcnBXNw5mRGI='

HTTPConnectionHandler ch = new HTTPConnectionHandler(urlAddress, user, password)
ch.setRequestBody(fileContents)

def response = ch.getResponse()
def responseXml = new XmlSlurper().parseText(response)

def stop = 'here'

