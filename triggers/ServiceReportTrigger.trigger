trigger ServiceReportTrigger on ServiceReport (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        ServiceReportTriggerHandler.afterInsert(Trigger.new);
    }
}