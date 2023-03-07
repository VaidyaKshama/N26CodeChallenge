/* Service API has get method and based on the service name respective method is called for further processig
*/

@RestResource(UrlMapping='/nps/*')
global virtual with sharing class dataService {
    private static dataService serviceInstance = new dataService();
    private static String classUrlMapping = '/nps/';
 /**
   * @description  Common method for Post Http calls
   **/
  @HttpGet
  global static void doGet() {
    try {
        serviceInstance.resolveDoGet();
    } catch (Exception ex) {
      apexResponse.fail(ex);
    } 
  }

 
  /**
   * @description Process the Rest URI and redirect into different provider for process
   **/
  global virtual void resolveDoGet() {
    String suffixRestUrl = apexUtils.obtainUrlSuffix(classUrlMapping);
    String precedingUri = suffixRestUrl.substringBefore('/');
    switch on precedingUri {
      //RestContext.request.requestURI :/nps/sendContactData/
      when 'sendContactData' {
        this.sendContactData();
      }
    }
  }


  /**
   * @description Fetch contact data using uuid
   **/
  global virtual void sendContactData() {
    RestRequest restReq = RestContext.request;
    String uuid = restReq.params.get('uuid');
    buildContactWrapper wrapper = new buildContactWrapper();
    List<dataDTO.contactData> contactResponse = wrapper.sendContactData((List<String>)json.deserialize(uuid, List<String>.class));
    RestResponse response = RestContext.response;
    response.responseBody = Blob.valueOf(JSON.serialize(contactResponse));
    response.statusCode = 200;
    response.addHeader('Content-Type', 'application/json');
  }
}
