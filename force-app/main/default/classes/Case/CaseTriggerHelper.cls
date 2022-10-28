public class CaseTriggerHelper {
  public static void insertingNewCase(
    Case newCase,
    Map<String, Account> mapOfAccounts
  ) {
    Account account = mapOfAccounts.get(newCase.AccountId);
    Integer accountSize = account.Contacts.size();

    if (accountSize == 0) {
      newCase.addError(
        'You cannot create a request for accounts without contacts'
      );
    } else {
      switch on newCase.Origin {
        when ConstantUtils.CASE_ORIGIN_WEB {
          if (accountSize >= 2) {
            newCase.addError(
              'Web request are only allowed to have one attendee'
            );
          }
        }
        when ConstantUtils.CASE_ORIGIN_WEB {
          if (accountSize >= 4) {
            newCase.addError(
              'Phone request are only allowed to have three attendee'
            );
          }
        }
      }
    }
  }
  public static void updatingCase(Case newCase) {
    if (newCase.Status == ConstantUtils.CASE_STATUS_CLOSED) {
      ExternalSystemService.createReservationForAttendee(newCase.Id);
    }
  }
}
