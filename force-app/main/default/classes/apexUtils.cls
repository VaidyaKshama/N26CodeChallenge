global inherited sharing class apexUtils {
/**
   * @description  return API url string
   **/
  global static String obtainUrlSuffix(String classUrlMapping) {
    String cBaseUrl = (classUrlMapping);
    String fullUrl = System.RestContext.request.requestURI.removeEnd('/');
    return fullUrl.toLowerCase().substringAfterLast(cBaseUrl.toLowerCase());
  }

}
