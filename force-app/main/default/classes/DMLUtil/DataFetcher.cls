public with sharing class DataFetcher {
  public static Map<String, Account> getAccountsByIds(List<Id> accountsIds) {
    Map<String, Account> accountsMap = new Map<String, Account>();

    for (Account account : [
      SELECT Id, (SELECT Id, Name, Email FROM Contacts)
      FROM Account
      WHERE Id IN :accountsIds
    ]) {
      accountsMap.put(account.Id, account);
    }

    return accountsMap;
  }
}
