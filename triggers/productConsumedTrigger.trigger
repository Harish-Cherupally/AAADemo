trigger productConsumedTrigger on ProductConsumed (before insert) {
    
    if(Trigger.isBefore){
     ProductConsumedTriggerHandler.updateServiceTicketCheck(Trigger.new);
    }
}