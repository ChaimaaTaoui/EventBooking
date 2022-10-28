public with sharing class ExternalSystemService {
  @future(callout=true)
  public static void createReservationForAttendee(Case caseRequest) {
    for (Account company : [
      SELECT id, (SELECT id, name, email FROM Contacts)
      FROM Account
      WHERE id = :caseRequest.AccountId
    ]) {
      for (Contact attendee : company.contacts) {
        Http http = new Http();

        HttpRequest request = ExternalSystemHelper.createReservationRequest(
          ConstantUtils.WEB_SERVICE_URL,
          attendee
        );
        HttpResponse response = http.send(request);

        if (response.getStatusCode() != 201) {
          Log.error(
            'The status code returned was not expected: ' +
            response.getStatusCode() +
            ' ' +
            response.getStatus()
          );
        } else {
          notifyAttendeeByEmail(attendee);
        }
      }
    }
  }

  private static void notifyAttendeeByEmail(Contact attendee) {
    String email = attendee.email;
    String subject = 'RSVP confirmation';
    String body =
      'Hi ' +
      attendee.name +
      ',\n You have successfully RVSPd at BHotels. Enjoy your stay!\n';

    EmailService emailService = new EmailService();
    emailService.sendEmail(email, subject, body);
  }
}
