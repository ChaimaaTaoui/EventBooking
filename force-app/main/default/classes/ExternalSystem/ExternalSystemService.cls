public class with sharing ExternalSystemService {
 
// add the @future for callout
@future(callout=true)
    public static void createReservationForAttendee(Id caseRequestId){
        //get the case
        Case reservationRequestCase = [SELECT Id, AccountId FROM Case WHERE Id = :caseRequestId LIMIT 1];
        //get account and related contacts , no need for two loops
           for(Account company: [SELECT id, (SELECT id, name, email FROM Contacts)
           FROM Account
           WHERE id = :reservationRequestCase.AccountId
         ]) {
                for(Contact attendee : company.contacts) {
                    Http http = new Http();
                    //create the request
                    HttpRequest request = ExternalSystemHelper.createReservationRequest(ConstantUtils.WEB_SERVICE_URL,attendee);
                    HttpResponse response = http.send(request);
                    // Parse the JSON responsse
                    if (response.getStatusCode() != 201) {
                        Log.error('The status code returned was not expected: ' +
                            response.getStatusCode() + ' ' + response.getStatus());
                     
                    } else {
                       // Everything went as expected.
            
                       notifyAttendeeByEmail(attendee);
                    }
                }
            
        }
    } 

    private static void notifyAttendeeByEmail(Contact attendee){
      //create email parts
        String email = attendee.email;
        String subject = 'RSVP confirmation';
        String body =
          'Hi ' +
          attendee.name +
          ',\n You have successfully RVSPd at BHotels. Enjoy your stay!\n';

        EmailService emailService = new EmailService();
        emailService.sendEmail(email,subject,body);

    } 


}
