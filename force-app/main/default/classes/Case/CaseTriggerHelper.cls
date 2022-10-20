public  class CaseTriggerHelper {
    public static void insertingNewCase(Case newCase) {
        Account account =  [SELECT ID, (select id from contacts) FROM Account where id = :newCase.AccountId LIMIT 1];

       Integer accountSize= account.Contacts.size();

        if(accountSize ==0){
            newCase.addError('You cannot create a request for accounts without contacts');
        }else {
            switch on newCase.Origin {
                when 'Web' {
                    if(accountSize >= 2 ){
                        newCase.addError('Web request are only allowed to have one attendee');
                    }
                }
                when 'Phone'{
                    if(accountSize >= 4 ){
                        newCase.addError('Phone request are only allowed to have three attendee');
                    }
                }
            }    
                        
        }
    }
    public static void updatingCase(Case newCase){
        
        Case updateCase = [
          SELECT AccountId, Status
          FROM Case
          WHERE id = :newCase.ID
        ];
        if (updateCase.Status == 'Closed') {
          ExternalSystemService.rsvpAttendee(updateCase.Id);
        }
      }
}
