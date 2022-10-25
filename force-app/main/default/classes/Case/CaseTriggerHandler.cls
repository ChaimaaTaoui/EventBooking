public with sharing class CaseTriggerHandler extends TriggerHandler {
    //overriding the before insert trigger
    public override void beforeInsert() {
        //newCaseObjects
List<Case> caseObjects= (List<Case>) Trigger.new;
Case caseInsertRequest = caseObjects[0];
// checking for NPE : null case or no account attched
if(caseInsertRequest== null || caseInsertRequest.AccountId == null) {
    //add error log
    caseInsertRequest.addError('Please make sure to attach an account when creating a case');
    Log.error('Null Case or no Account attached');
    return;
}
//call the Helper for data checkup
CaseTriggerHelper.insertingNewCase(caseInsertRequest);

}

//overriding the before update trigger
public override void beforeUpdate(){
    List<Case> caseObjects= (List<Case>) Trigger.new;
Case newCase = caseObjects[0];
    //call the Helper for data manipulation
    CaseTriggerHelper.updatingCase(newCase);
     

}
}