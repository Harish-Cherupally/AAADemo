trigger quoteTrigger on SBQQ__Quote__c (after update) {
    
    if(Trigger.isAfter){
        if(Trigger.isUpdate){        
            QuoteTriggerHandler.onAfterUpdate(Trigger.new,Trigger.oldMap);
            
            QuoteTriggerHandler.updateOppFieldsForPrimaryQuote(Trigger.new,Trigger.oldMap);
            
            //QuoteTriggerHandler.autoSendDocuSign(Trigger.new,Trigger.oldMap);
        }
    }
}