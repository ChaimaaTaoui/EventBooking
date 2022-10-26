public abstract class TestDataFactory {
    //easily mock data for testing purposes
    // TODO : ask/look it up 
    public static Account createCompanywithContacts(Integer nbrAttendees){
        Account company = new Account(Name = 'Salesforce'); 
        insert company;

        List<Contact> attendees = new List<Contact>();
        for(Integer i=0; i<nbrAttendees; i++){
            Contact newAttendee = new Contact(LastName = 'Contact ' + i, AccountId = company.ID);
            contacts.add(newAttendee);
        }   
        insert attendees;
        return company;
    }
