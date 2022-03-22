//This Scheduler Batch class will retrieve the records(for which Docusign to be generated) and will generate and send 
//the Docusign
public class AutoSendDocuSignEnvelope_Batch implements Database.Batchable<sObject>, Schedulable,Database.AllowsCallouts {
    private String query {get; set;}
    
    public AutoSendDocuSignEnvelope_Batch(){}
    
    public AutoSendDocuSignEnvelope_Batch(String query){
        this.query = query;
    }
    
	/* A3SHCRSF3-10         
     * Description: This Schedulable Context method will check if there are any Work Orders for which Docusign to be 
					generated or not, if yes then it will Initiate Batch with those records
     */    
    public void execute(SchedulableContext sc){
        
       /* Integer quoteCount = [SELECT Count() FROM SBQQ__Quote__c WHERE SBQQ__Status__c ='Client Accepted' AND (Is_Finance__c != true OR (Is_Finance__c = true AND Credit_Score_Status__c = 'Approved'))];
        
        if(quoteCount > 0){
        	AutoSendDocuSignEnvelope_Batch quoteBatch = new AutoSendDocuSignEnvelope_Batch('SELECT Id FROM SBQQ__Quote__c WHERE SBQQ__Status__c =\'Client Accepted\' AND (Is_Finance__c != true OR (Is_Finance__c = true AND Credit_Score_Status__c = \'Approved\'))');
        	Database.executeBatch(quoteBatch, 1);    
        }*/
        
        //Checking if there are any Work Orders for which Docusign to be generated.
        Integer workOrder = [SELECT Count() FROM WorkOrder WHERE Status = 'Esign To Be Generated'];
        
        if(workOrder > 0){
            //If WO records exist, then Initiate Batch
        	AutoSendDocuSignEnvelope_Batch workOrderBatch = new AutoSendDocuSignEnvelope_Batch('SELECT Id FROM WorkOrder WHERE Status = \'Esign To Be Generated\'');
        	Database.executeBatch(workOrderBatch, 1);
        }
    }
    
    /* A3SHCRSF3-10         
     * Description: This Start will query the data which is consturcted in the above schedular execute method.
     */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(this.query);
    }
    
    /* A3SHCRSF3-10         
     * Description: The execute method will generate and sends Docusign
     */
    public void execute(Database.BatchableContext bc, List<SObject> sObjectRecs){
        //retrieving Object Information based on ObjectId
		String sObjectName = GlobalUtil.getSObjectName(new List<Id>{sObjectRecs[0].Id});   
                
        if(sObjectName == 'SBQQ__Quote__c'){
            //Map<Id,SBQQ__Quote__c> quoteData = new Map<Id,SBQQ__Quote__c>((List<SBQQ__Quote__c>)sObjectRecs);
        	//AutoSendDocuSignEnvelope.sendDocuSignEnvelope(new List<Id>(quoteData.keySet()));    
        }
        else if(sObjectName == 'WorkOrder'){
            Map<Id,WorkOrder> woData = new Map<Id,WorkOrder>((List<WorkOrder>)sObjectRecs);
            //This method will generate and Sends Docusign
        	AutoSendDocuSignEnvelope.sendDocuSignEnvelope(new List<Id>(woData.keySet()));            
        }
    }

    public void finish(Database.BatchableContext bc){}
}