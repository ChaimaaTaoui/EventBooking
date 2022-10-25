 /**
  * 
  * Trigger for Case before insert and after update
  */
trigger CaseTrigger on Case (before insert, after update) {
new CaseTriggerHandler().run();
}