global class A3SH_AlarmCalloutBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {
    
    public final String Query;
    public final String Entity;
    public final String Field;
    public final String Value;
    Public Static List<String> successfulIds = new List<String>();
    Public Static List<String> errorIds = new List<String>();
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query = 'SELECT Id, AccountId, CustomerNumber__c, FirstName, LastName, Email, CustomerType__c '+
            'FROM Contact '+
            'Where AccountId != NULL AND CreatedDate = today AND Stages__c = TRUE AND Alarm__c = FALSE '+
            'AND Id IN (Select ContactId FROM Asset WHERE Type__c = \'Customer Systems\')'+
            'AND Id IN (Select ContactId FROM WorkOrder WHERE Opportunity__c <> \'\' AND Opportunity__r.Installation_Type__c <> \'Self Install\' AND WorkOrderNumber <> \'\')';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){ 
        A3SH_AlarmService.invokeService(scope);
        
        if(A3SH_AlarmService.successfulIds != null && !successfulIds.contains(A3SH_AlarmService.successfulIds)){
            successfulIds.add(A3SH_AlarmService.successfulIds);
        }else if(A3SH_AlarmService.errorIds != null && !errorIds.contains(A3SH_AlarmService.errorIds)){
          errorIds.add(A3SH_AlarmService.errorIds); 
        }
    }
    
    global void finish(Database.BatchableContext BC){  
      //  if(!Test.isRunningTest()){
           A3SH_Batch_EmailHandler.stagesSuccess();   
//        }
            
    }
    
}