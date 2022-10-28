public with sharing class ExternalSystemHelper {
  public static HttpRequest createReservationRequest(
    String url,
    Contact attendee
  ) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(url);
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');

    request.setBody('{"name":"' + attendee.name + '-' + attendee.email + '}');

    return request;
  }
}
