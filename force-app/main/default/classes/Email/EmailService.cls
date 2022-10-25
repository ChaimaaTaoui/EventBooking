public with sharing class EmailService {

    public void sendEmail(String email, String subject, String body) {

        Messaging.SingleEmailMessage sEmail = new Messaging.SingleEmailMessage();
        String[] sendingTo = new List<String>{ email };
        sEmail.setToAddresses(sendingTo);
        sEmail.setSubject(subject);
        sEmail.setPlainTextBody(body);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(
          new List<Messaging.SingleEmailMessage>{ sEmail }
        );
    
        if (results[0].success) {
          System.debug('The email was sent successfully.');
        } else {
          Log.error('Unexpected error: ' + results[0].errors[0].message);
        }
      }
}
