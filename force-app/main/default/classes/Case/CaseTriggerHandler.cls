public with sharing class CaseTriggerHandler extends TriggerHandler {
  public override void beforeInsert() {
    Set<Id> accountsIds = new Set<Id>();
    for (Case caseInsertRequest : (List<Case>) Trigger.new) {
      accountsIds.add(requests.AccountId);
    }
    Map<String, Account> accounts = DataFetcher.getAccountsByIds(accountsIds);
    for (Case caseInsertRequest : (List<Case>) Trigger.new) {
      if (caseInsertRequest == null || caseInsertRequest.AccountId == null) {
        caseInsertRequest.addError(
          'Please make sure to attach an account when creating a case'
        );
        Log.error('Null Case or no Account attached');
        return;
      }
      CaseTriggerHelper.insertingNewCase(caseInsertRequest, accounts);
    }
  }

  public override void afterUpdate() {
    for (Case newCase : [
      SELECT AccountId, Status
      FROM Case
      WHERE id IN :Trigger.new
    ]) {
      CaseTriggerHelper.updatingCase(newCase);
    }
  }
}
