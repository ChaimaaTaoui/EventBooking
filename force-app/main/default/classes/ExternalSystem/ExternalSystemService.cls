public  class ExternalSystemService {
 
// add the @future for callout
@Future(callout=true)
    public static void rsvpAttendee(Id caseRequestId){
        //get the case
        Case reservationRequestCase = [SELECT Id, AccountId FROM Case WHERE Id = :caseRequestId LIMIT 1];
        //get account and related contacts , no need for two loops
           for(Account company: [SELECT id, (SELECT id, name, email FROM Contacts)
           FROM Account
           WHERE id = :reservationRequestCase.AccountId
         ]) {
                for(Contact attendee : company.contacts){
                    Http http = new Http();
                    HttpRequest request = ExternalSystemHelper.createReservationRequest(ConstantUtils.WEB_SERVICE_URL,attendee);
                    HttpResponse response = http.send(request);
                    // Parse the JSON responsse
                    if (response.getStatusCode() != 201) {
                        System.debug('The status code returned was not expected: ' +
                            response.getStatusCode() + ' ' + response.getStatus());
                      Log.error('Failed to RSVP');
                    } else {
                       // Everything went as expected.
                       Log.error('Successfull RSVP');
                       notifyAttendeeByEmail(attendee);
                    }
                }
            
        }
    } 

    private static void notifyAttendeeByEmail(Contact attendee){
      
        String email = attendee.email;
        String subject = 'RSVP confirmation';
        String body =
          'Hi ' +
          attendee.name +
          ',\n You have successfully RVSPd at BHotels. Enjoy your stay!\n';
        EmailService emailService = new EmailService();

    } 


}
