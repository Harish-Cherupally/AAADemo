global class A3SH_StagesCalloutBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.stateful {
    
    public final String Query;
    public final String Entity;
    public final String Field;
    public final String Value;
    Public Static List<String> successfulIds = new List<String>();
    Public Static List<String> errorIds = new List<String>();
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query = 'SELECT Id, AccountId, CustomerNumber__c, Email, CustomerType__c '+
            'FROM Contact '+
            'Where AccountId != NULL AND CreatedDate = today AND Stages__c = FALSE '+
            'AND Id NOT IN (Select ContactId FROM Asset WHERE type__c = \'Customer Systems\') '+
            'AND Id IN (Select ContactId FROM WorkOrder WHERE Opportunity__c <> \'\' AND Opportunity__r.Installation_Type__c <> \'Self Install\' AND WorkOrderNumber <> \'\')';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){ 
        A3SH_StagesService.invokeService(scope);
        
        if(A3SH_StagesService.successfulIds != null && !successfulIds.contains(A3SH_StagesService.successfulIds)){
            successfulIds.add(A3SH_StagesService.successfulIds);
        }else if(A3SH_StagesService.errorIds != null && !errorIds.contains(A3SH_StagesService.errorIds)){
          errorIds.add(A3SH_StagesService.errorIds); 
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
         A3SH_AlarmCalloutBatchClass stg = new A3SH_AlarmCalloutBatchClass(); 
         database.executebatch(stg , 1);
        
    }
    
}