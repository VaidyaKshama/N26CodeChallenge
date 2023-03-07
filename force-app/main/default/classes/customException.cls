global with sharing class customException extends Exception {
   /**
   * @description  throws execption with passed message
   **/
  public CustomException(Exception ex, String message) {
    system.debug('error : ' + ex.getStackTraceString());
    throw new CustomException(ex.getMessage());
  }
}
