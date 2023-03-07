global with sharing class apexResponse {

  @AuraEnabled
  global object status { get; set; }
  @AuraEnabled
  global object entity { get; set; }
  @AuraEnabled
  global object data { get; set; }

  /**
   * @description  return status with 200 and data
   **/
  global static ApexResponse ok(object data) {
    return new ApexResponse().setStatus(200).setDataAsStringfy(data);
  }

  /**
   * @description  return status with 200
   **/
  global static ApexResponse ok() {
    return new ApexResponse().setStatus(200);
  }

  /**
   * @description return status with 400 and data
   **/
  global static ApexResponse fail(object data) {
    return new ApexResponse().setStatus(400).setData(data);
  }

  /**
   * @description return status with 400 and exception details
   **/
  global static ApexResponse fail(Exception ex) {
    return new ApexResponse().setStatus(400).setData(ex);
  }

  /**
   * @description return status with 400
   **/
  global static ApexResponse fail() {
    return new ApexResponse().setStatus(400);
  }

  /**
   * @description return status with 500 with error
   **/
  global static ApexResponse exception(object error) {
    return new ApexResponse().setStatus(500).setData(error);
  }

  /**
   * @description  return status with 500 and exception details
   **/
  global static ApexResponse exception(Exception ex) {
    return new ApexResponse().setStatus(500).setData(ex);
  }

  /**
   * @description set status code
   **/
  global ApexResponse setStatus(object status) {
    if (RestContext.request != null) {
      RestContext.response.statusCode = (Integer) status;
    } else {
      this.status = status;
    }
    return this;
  }

  /**
   * @description set data on exception
   **/
  public ApexResponse setData(Exception ex) {
    String exceptionTrace =
      'Message: ' +
      ex.getMessage() +
      ' ; Line Number: ' +
      ex.getLineNumber() +
      ' ; Type: ' +
      ex.getTypeName() +
      ' ; Stack Trace: ' +
      ex.getStackTraceString();

    if (RestContext.request != null) {
      RestContext.response.responseBody = blob.valueOf(exceptionTrace);
    } else {
      this.data = ex.getMessage();
      this.entity = exceptionTrace;
    }
    return this;
  }

  /**
   * @description Set data value as Object
   **/
  public ApexResponse setData(Object data) {
    if (RestContext.request != null) {
      if (data instanceof String) {
        RestContext.response.responseBody = blob.valueOf((String) data);
      } else {
        RestContext.response.responseBody = blob.valueOf(JSON.serialize(data));
      }
    } else {
      this.data = data;
    }
    return this;
  }

  /**
   * @description Set data value as Stringfy
   **/
  public ApexResponse setDataAsStringfy(Object data) {
    if (RestContext.request != null) {
      if (data instanceof String) {
        RestContext.response.responseBody = blob.valueOf((String) data);
      } else {
        RestContext.response.responseBody = blob.valueOf(JSON.serialize(data));
      }
    } else {
      this.data = JSON.serialize(data);
    }
    return this;
  }
}
