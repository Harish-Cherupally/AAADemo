public class SA_ReUpdateScheduleStart_Batch implements Database.Batchable<SObject>, Schedulable,Database.AllowsCallouts {
    public void execute(SchedulableContext sc){
        SA_ReUpdateScheduleStart_Batch runBatch = new SA_ReUpdateScheduleStart_Batch();
        Database.executeBatch(runBatch, 50);
    }
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator([SELECT Id,Self_Scheduled__c,Original_Schedule_Start__c,SchedStartTime
                                         FROM ServiceAppointment
                                         WHERE Original_Schedule_Start__c != null
                                         and Status = 'Scheduled']);
                                                                                    
    }
    
    public void execute(Database.BatchableContext BC, List<ServiceAppointment> serviceAppRecs){
        for(ServiceAppointment tempSA :serviceAppRecs){
            //DateTime dt = tempSA.SchedStartTime;
            tempSA.SchedStartTime = tempSA.Original_Schedule_Start__c;//dt.addMinutes(-1);
            tempSA.Original_Schedule_Start__c = null;
        }
        
        update serviceAppRecs;
    }
    
    public void finish(Database.BatchableContext BC){}
}