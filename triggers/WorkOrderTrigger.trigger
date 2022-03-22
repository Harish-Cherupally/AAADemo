trigger WorkOrderTrigger on WorkOrder (before insert, before update) {
    if(trigger.isBefore){
        if(trigger.isUpdate){
            WorkOrderTriggerHandler.restrictChangeAssignedDealer(trigger.newMap, trigger.oldMap);
        }
    } 
}